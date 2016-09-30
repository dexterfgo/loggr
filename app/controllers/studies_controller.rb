class StudiesController < ApplicationController
  before_action :check_for_user_session
  before_action :set_study, only: [:show, :edit, :update, :destroy]

  # GET /studies
  # GET /studies.json
  def index
    @studies = Study.all
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
    @participants_in_this_study = @study.participants.paginate(:page => params[:page], :per_page => 10)
    if @participants_in_this_study.empty?
      @participants_in_this_study_header = 'There are no participants in this study. Register a participant to add them here.'
    else
      @participants_in_this_study_header = 'Participants for ' + @study.study_name + ':'
    end
  end

  # GET /studies/new
  def new
    @study = Study.new
  end

  # GET /studies/1/edit
  def edit
  end

  # POST /studies
  # POST /studies.json
  def create
    @study = Study.new(study_params)

    respond_to do |format|
      if @study.save
        format.html { redirect_to @study, notice: 'Study was successfully created.' }
        format.json { render :show, status: :created, location: @study }
      else
        format.html { render :new }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /studies/1
  # PATCH/PUT /studies/1.json
  def update
    respond_to do |format|
      if @study.update(study_params)
        format.html { redirect_to @study, notice: 'Study was successfully updated.' }
        format.json { render :show, status: :ok, location: @study }
      else
        format.html { render :edit }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studies/1
  # DELETE /studies/1.json
  def destroy
    @study.destroy
    respond_to do |format|
      format.html { redirect_to studies_url, notice: 'Study was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study
      @study = Study.find(params[:id])
    end

    def check_for_user_session
      @current_users = User.all
      if @current_users.empty?
        redirect_to user_home, notice: 'Something went wrong. Session not found. Did you log out?'
      else
        @current_user = application_current_user
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def study_params
      params.require(:study).permit(:study_name, :description)
    end
end
