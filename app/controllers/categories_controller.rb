class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Current.user.categories.order(:name)
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    @category.user = Current.user

    if @category.save
      redirect_to categories_url, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_url, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy!

    redirect_to categories_url, notice: "Category was successfully destroyed."
  end

  private

  def set_category
    @category = Current.user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :color, :icon)
  end
end
