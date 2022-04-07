class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)

    respond_to do |format|
      # HTMLとしてアクセスされた場合
      format.html
      # CSVとしてアクセスされた場合
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
    # @tasks = current_user.tasks.recent
    # @tasks = currnet_user.tasks.order(created_at: :desc)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end

  def create
    # ログインしているユーザーのTaskデータの登録
    @task = current_user.tasks.new(task_params)
    
    if params[:back].present?
      render :new
      return
    end

    if @task.save
      logger.debug "task: #{@task.attributes.inspect}"
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def import
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: "タスクを追加しました"
  end

  private
  
  def task_params
    # nameとdescriptionを抜き取る
    params.require(:task).permit(:name, :description, :image)
  end
  
  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  # def task_logger
  #   @task_logger ||= Logger.new('log/task.log', 'dialy') 
  # end
  
  # task_logger.debug 'Taskのログを出力'
end
