class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @primary_categories = Category.where(parent_category_id: nil).order(:name)
    @categories = Category.all.order(:name)
  end

  def new
    @categories_without_parent = Category.where(parent_category_id: nil)
    @category = Category.new
  end

  def edit
    @categories_without_parent = Category.where(parent_category_id: nil).where.not(id: @category.id)
  end

  def create
    @category = Category.new(category_params)

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
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :parent_category_id)
  end
end
