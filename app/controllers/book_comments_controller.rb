class BookCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def create
    @book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book = @book
    comment.save
    redirect_to book_path(@book)
  end

  def destroy
    @comment.destroy
    redirect_to book_path(@comment.book)
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

  def ensure_correct_user
    @comment = BookComment.find(params[:id])
    redirect_to book_path(@comment.book) unless @comment.user == current_user
  end
end
