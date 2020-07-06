class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # ↓hederの所logged_inアクションを使用しログインしてない人はアクセスできないのに
  # なぜここでも同じようなものをbefore_actionに設定するのか？→リンクは表示されなくてもurlに書いていけちゃうから
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  
  
  def index
    @users = User.paginate(page: params[:page],per_page: 20)
  end
  
  
  def show
  end

  def edit
  end
    
    
  def new
    if logged_in?
      flash[:info] = 'ログインしています。'
      redirect_to current_user
    end
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeフィルター
    
    # paramsハッシュからユーザーを取得します。
    
    def set_user
      @user = User.find(params[:id])
    end
    
    # ログイン済みのユーザーか確認します。
    # logged_in?(sessionHelper参照)→ログインしているか否かの判断をする
    # store_locatio[アクセスしようとしたページを記憶しとく](勤怠8章.3参照 sessionHelper参照)
    # application_controllerに記載しているからいらない
    def logged_in_user
      unless logged_in?
        strore_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    # current_user(sessionHelper参照)application_controllerに記載しているからいらない
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # システム管理権限所有者かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
      
      
end


