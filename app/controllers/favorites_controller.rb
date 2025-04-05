# app/controllers/favorites_controller.rb
class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    current_user.favorites.create(book: @book)
    redirect_back fallback_location: books_path
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book: @book)
    favorite.destroy if favorite
    redirect_back fallback_location: books_path
  end
end
