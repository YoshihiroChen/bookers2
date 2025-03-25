class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      flash[:notice] = "Book was successfully created."
      redirect_to user_path(current_user)
    else
      @user = current_user
      @books = current_user.books
      flash.now[:alert] = "There was an error creating the book."
      render 'users/show'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book was successfully updated."
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = "There was an error updating the book."
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    flash[:notice] = "Book was successfully deleted."
    redirect_to user_path(current_user)
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

