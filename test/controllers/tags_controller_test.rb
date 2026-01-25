require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should get index" do
    get tags_url
    assert_response :success
  end

  test "should get new" do
    get new_tag_url
    assert_response :success
  end

  test "should create tag" do
    assert_difference("Tag.count") do
      post tags_url, params: {tag: {name: "New Tag", color: "#ff0000"}}
    end

    assert_redirected_to tags_url
    assert_equal flash[:notice], "Tag was successfully created."
  end

  test "should show error on invalid tag creation" do
    post tags_url, params: {tag: {name: ""}}

    assert_response :unprocessable_content
  end

  test "should get edit" do
    @tag = tags(:tropicalrb)

    get edit_tag_url(@tag)
    assert_response :success
  end

  test "should update tag" do
    @tag = tags(:tropicalrb)

    patch tag_url(@tag), params: {tag: {name: "Updated Tag"}}
    assert_redirected_to tags_url
    assert_equal flash[:notice], "Tag was successfully updated."
  end

  test "should show error on invalid tag update" do
    @tag = tags(:tropicalrb)

    patch tag_url(@tag), params: {tag: {name: ""}}

    assert_response :unprocessable_content
  end

  test "should destroy tag" do
    @tag = tags(:tropicalrb)
    assert_difference("Tag.count", -1) do
      delete tag_url(@tag)
    end

    assert_redirected_to tags_url
    assert_equal flash[:notice], "Tag was successfully destroyed."
  end

  test "user scoping - cannot access other users tags" do
    other_user = users(:secondary)
    other_tag = other_user.tags.create!(name: "Other Tag", color: "#000000")

    get edit_tag_url(other_tag)
    assert_response :not_found
  end
end
