class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = Task.ordered

    if params[:query].present?
      @tasks = @tasks.search(params[:query])
    end

    if params[:status].present? && params[:status] != "all"
      @tasks = @tasks.where(status: params[:status])
    end

    if params[:assign_to].present? && params[:assign_to] != "all"
      if params[:assign_to] == "mine"
        @tasks = @tasks.where(assigned_to_id: current_user.id)
      elsif params[:assign_to] == "unassigned"
        @tasks = @tasks.where(assigned_to_id: nil)
      end
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("tasks_list", partial: "tasks/list", locals: { tasks: @tasks })
      end
    end
  end

  def calendar
    @tasks = Task.where(due_date: start_date..end_date)
    @start_date = start_date

    if params[:query].present?
      @tasks = @tasks.search(params[:query])
    end

    if params[:status].present? && params[:status] != "all"
      @tasks = @tasks.where(status: params[:status])
    end

    if params[:assign_to].present? && params[:assign_to] != "all"
      if params[:assign_to] == "mine"
        @tasks = @tasks.where(assigned_to_id: current_user.id)
      elsif params[:assign_to] == "unassigned"
        @tasks = @tasks.where(assigned_to_id: nil)
      end
    end

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("tasks_list", partial: "tasks/calendar", locals: { tasks: @tasks, start_date: @start_date })
      end
    end
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to tasks_path, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "Task was successfully deleted."
  end

  def generate_description
    title = params[:title].to_s.strip
    prompt = "Generate a detailed description for the following task: '#{title}'" if title.present?

    service = AiServices::OpenAiChatService.call(prompt: prompt)
    if service.success?
      render json: { description: service.data[:result] }, root: "description", adapter: :json
    else
      render json: { error: service.data[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :assigned_to_id)
  end

  def start_date
    params.fetch(:start_date, Date.current.beginning_of_month).to_date
  end

  def end_date
    params.fetch(:end_date, Date.current.end_of_month).to_date
  end
end
