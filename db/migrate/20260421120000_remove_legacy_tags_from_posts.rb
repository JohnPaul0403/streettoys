class RemoveLegacyTagsFromPosts < ActiveRecord::Migration[8.1]
  class MigrationPost < ApplicationRecord
    self.table_name = "posts"

    acts_as_taggable_on :tags
  end

  def up
    MigrationPost.reset_column_information

    say_with_time "Backfilling acts-as-taggable-on tags from posts.tags" do
      MigrationPost.find_each do |post|
        next if post[:tags].blank?

        post.tag_list = post[:tags]
        post.save!(validate: false)
      end
    end

    remove_column :posts, :tags, :string
  end

  def down
    add_column :posts, :tags, :string

    MigrationPost.reset_column_information

    say_with_time "Restoring posts.tags from acts-as-taggable-on tag list" do
      MigrationPost.find_each do |post|
        post.update_columns(tags: post.tag_list.join(", "))
      end
    end
  end
end
