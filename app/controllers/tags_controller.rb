class TagsController < ApplicationController
  before_action :set_tag, only: %i[edit update destroy]

  def index
    @tags = Current.user.tags.by_last_usage
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.user = Current.user

    if @tag.save
      redirect_to tags_url, notice: "Tag was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_url, notice: "Tag was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @tag.destroy!

    redirect_to tags_url, notice: "Tag was successfully destroyed."
  end

  private

  def set_tag
    @tag = Current.user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
