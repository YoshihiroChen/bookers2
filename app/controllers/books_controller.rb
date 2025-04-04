class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
  end
  

  def show
    @book = Book.find(params[:id])
    @user = @book.user              # 投稿者
    @current_user = current_user    # 当前登录者
    @new_book = Book.new
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      flash[:notice] = "Book was successfully created."
      redirect_to book_path(@book)  # ✅ 修正跳转目标
    else
      @user = current_user
      @books = Book.all  # ✅ 注意：这里应是全部书籍，而不是 current_user.books
      flash.now[:alert] = "There was an error creating the book."
      render 'books/index'  # ✅ 注意：失败时渲染的是 books/index，而不是 users/show
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      raise "⛔️ 他人の投稿を編集しようとしています！"
      flash[:alert] = "他人の投稿は編集できません。"
      redirect_to books_path
      return
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book updated successfully."
      redirect_to book_path(@book)
    else
      flash.now[:alert] = "There was an error updating the book."
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    flash[:notice] = "Book was successfully deleted."
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    redirect_to user_path(current_user) unless @book.user == current_user
  end
end

