class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def new
    @book = Book.new
  end

  def create
    @book_new = Book.new(book_params)
    @book_new.user_id = current_user.id
    if @book_new.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book_new.id)
    else
      @books = Book.all
      @user=current_user
      render :index
    end
  end

  def index
    @books = Book.all
    @book_new = Book.new
    @user=current_user
  end

  def show
    @book_new = Book.new
    @book=Book.find(params[:id])
    @book_comment=BookComment.new
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path

  end

  def edit
    # user = User.find(params[:id])
    # unless user.id == current_user.id
    #   redirect_to user_path
    # end

    @book_new = Book.find(params[:id])
  end

  def update

    @book_new = Book.find(params[:id])
    if @book_new.update(book_params)
      flash[:notice] ="You have updated book successfully."
      redirect_to book_path
    else
      @books = Book.all
      render :edit
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :image, :body)
  end

  def is_matching_login_user
    book=Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to books_path
    end
  end

end
