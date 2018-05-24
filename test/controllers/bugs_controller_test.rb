require 'test_helper'

class BugsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bug = bugs(:one)
  end

  test "should get index" do
    get bugs_url
    assert_response :success
  end

  test "should get new" do
    get new_bug_url
    assert_response :success
  end

  test "should create bug" do
    assert_difference('Bug.count') do
      post bugs_url, params: { bug: { creator_id: @bug.creator_id, deadline: @bug.deadline, developer_id: @bug.developer_id, image: @bug.image, project_id: @bug.project_id, status: @bug.status, title: @bug.title, type: @bug.type } }
    end

    assert_redirected_to bug_url(Bug.last)
  end

  test "should show bug" do
    get bug_url(@bug)
    assert_response :success
  end

  test "should get edit" do
    get edit_bug_url(@bug)
    assert_response :success
  end

  test "should update bug" do
    patch bug_url(@bug), params: { bug: { creator_id: @bug.creator_id, deadline: @bug.deadline, developer_id: @bug.developer_id, image: @bug.image, project_id: @bug.project_id, status: @bug.status, title: @bug.title, type: @bug.type } }
    assert_redirected_to bug_url(@bug)
  end

  test "should destroy bug" do
    assert_difference('Bug.count', -1) do
      delete bug_url(@bug)
    end

    assert_redirected_to bugs_url
  end
end
