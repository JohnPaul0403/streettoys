class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username
      t.string :title
      t.text :bio

      t.timestamps
    end
  end
end
