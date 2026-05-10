class LessonsController < ApplicationController
  before_action :authorize_request
  before_action :set_course, only: [:index, :create]
  before_action :set_lesson, only: [:show, :update, :destroy]
  before_action :authorize_creator!, only: [:create, :update, :destroy]

  # GET /courses/:course_id/lessons
  def index
    render json: @course.lessons
  end

  # GET /lessons/:id
  def show
    render json: @lesson
  end

  # POST /courses/:course_id/lessons
  def create
    @lesson = @course.lessons.new(lesson_params)
    if @lesson.save
      render json: @lesson, status: :created
    else
      render json: { errors: @lesson.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lessons/:id
  def update
    if @lesson.update(lesson_params)
      render json: @lesson
    else
      render json: { errors: @lesson.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /lessons/:id
  def destroy
    @lesson.destroy
    head :no_content
  end

  private

  def set_course
    @course = Course.find_by(id: params[:course_id])
    if @course.nil?
      render json: { error: 'Course not found for lessons' }, status: :unprocessable_entity
    end
  end

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def authorize_creator!
    # Se viermos do create, checamos @course. Se viermos de update/destroy, checamos @lesson.course
    course_to_check = @course || @lesson.course
    if course_to_check.creator != current_user
      render json: { error: "Ação não permitida para este utilizador" }, status: :forbidden
    end
  end

  def lesson_params
    params.require(:lesson).permit(:title, :status, :video_url)
  end
end