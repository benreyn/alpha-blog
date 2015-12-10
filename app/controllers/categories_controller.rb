class CategoriesController < ApplicationController
  
  before_action :require_admin, only: [:new, :create]
  
  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @category = Category.find(params[:id])
    @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category was created successfully"
      redirect_to categories_path
    else
      render 'new'
    end
  end
  
  private
  
    def category_params
      params.require(:category).permit(:name)
    end
end