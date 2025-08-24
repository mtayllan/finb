require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference("Category.count") do
      post categories_url, params: {category: {name: Faker::Bank.name, color: "#fff", icon: "house"}}
    end

    assert_redirected_to categories_url
    assert_equal flash[:notice], "Category was successfully created."
  end

  test "should show error on invalid category creation" do
    post categories_url, params: {category: {name: ""}}

    assert_response :unprocessable_content
  end

  test "should get edit" do
    @category = categories(:food)

    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    @category = categories(:food)

    patch category_url(@category), params: {category: {name: Faker::Bank.name, initial_balance: 50}}
    assert_redirected_to categories_url
    assert_equal flash[:notice], "Category was successfully updated."
  end

  test "should show error on invalid category update" do
    @category = categories(:food)

    patch category_url(@category), params: {category: {name: ""}}

    assert_response :unprocessable_content
  end

  test "should destroy category" do
    @category = categories(:food)
    assert_difference("Category.count", -1) do
      delete category_url(@category)
    end

    assert_redirected_to categories_url
    assert_equal flash[:notice], "Category was successfully destroyed."
  end
end
