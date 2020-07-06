class TasksController < ApplicationController
  before_action :set_user
  before_action :logged_in_user # ←と↓はapplication_controllerに記載
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :correct_user # sessions_helper参照このメソッドにより、他のユーザーのタスク操作を禁止できる
  
  
  
  
  
  
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
  
  def update
    @task = @user.tasks.find_by(id: params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = "タスクを更新しました"
      redirect_to user_task_url(@user)
    else
      render :edit
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
  
  
    
  
  # 管理者権限、または現在ログインしていいるユーザーを許可します。
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || @current_user.admin?
     flash[:danger] = "編集権限がありません。"
     redirect_to(root_url)
    end  
  end
  
  # 他のユーザーのタスク編集ページに飛べないようにする(show,updateも規制)
  def set_task
    unless @task = @user.tasks.find_by(id: params[:id])
      flash[:danger] = "権限がありません。"
      redirect_to user_tasks_url (current_user)
    end
  end
end
