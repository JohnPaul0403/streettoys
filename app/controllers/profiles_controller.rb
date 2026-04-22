class ProfilesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_profile, only: %i[ show ]
  before_action :set_profile_edit, only: %i[ edit update destroy ]

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.order(:username)
    @profiles = @profiles.where.not(user_id: Current.user.id) if authenticated?
  end

  # GET /profiles/1 or /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    return redirect_to edit_profile_path(Current.user.profile), notice: "Update your profile here." if Current.user.profile.present?

    @profile = Current.user.build_profile
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles or /profiles.json
  def create
    return redirect_to edit_profile_path(Current.user.profile), notice: "You already have a profile." if Current.user.profile.present?

    @profile = Current.user.build_profile(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: "Profile was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile.destroy!

    respond_to do |format|
      format.html { redirect_to profiles_path, notice: "Profile was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.includes(user: :posts).find(params.expect(:id))
    end

    def set_profile_edit
      @profile = Current.user.profile
      raise ActiveRecord::RecordNotFound unless @profile&.id == params.expect(:id).to_i
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.expect(profile: [ :username, :title, :bio, :profile_picture ])
    end
end
