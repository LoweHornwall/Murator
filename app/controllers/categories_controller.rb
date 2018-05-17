class CategoriesController < ApplicationController
  def index
    @categories = Category.all.paginate(page: params[:page])
  end

  def show
    @category = Category.find(params[:id])
    @curation_pages = @category.curation_pages.paginate(page: params[:page])
  end
end
