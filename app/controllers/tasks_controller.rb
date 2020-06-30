class TasksController < ApplicationController
  before_action :set_user
  
  # indexであるユーザーの投稿一覧を検索するのは2段構え↓
  # 1.userを特定する→set_user→ユーザを特定する
  # 2.特定したユーザのタスクを検索する→indexの中身
  # indexの@userは上記の1があるから使える
  def index
    @tasks = @user.tasks.order(created_at:"DESC")
  end
  
  def new
    @task = Task.new
  end
  
  def destroy
    @task = @user.tasks.find_by(id: params[:id])
    @task.destroy
    flash[:success] = "タスクを削除しました"
    redirect_to user_tasks_url(@user)
  end
  
  # ↓newとbuildは全く同じ機能→今回もnewでもOKだけど↓
  # 使い分け→関連付けされたモデルのオブジェクトを生成する際には、buildを使い(今回のケース)
  # それ以外でnewを用いるという使い分けがなされています
  def create
    @task = @user.tasks.build(task_params)
    if @task.save
      flash[:success] = "タスクを新規作成しました"
      redirect_to user_tasks_url(@user)
    else
      render :new
    end
  end
  
  def edit
    @task = @user.tasks.find_by(id: params[:id])
  end
  
  def show
    @task = @user.tasks.find_by(id: params[:id])
  end
  
  def set_user
    @user = User.find(params[:user_id])
  end
  
  def task_params
    params.require(:task).permit(:name, :description)
  end
end
