class UsersController < ApplicationController
  def index
    @users = User.all
    @user = current_user       # 当前登录用户
    @book = Book.new           # 投稿表单用
  end
  
  

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
  end


  def user_params
    params.require(:user).permit(:name, :introduction, :image)
  end
end
