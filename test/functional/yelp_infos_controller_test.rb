require 'test_helper'

class YelpInfosControllerTest < ActionController::TestCase
  setup do
    @yelp_info = yelp_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:yelp_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create yelp_info" do
    assert_difference('YelpInfo.count') do
      post :create, yelp_info: {  }
    end

    assert_redirected_to yelp_info_path(assigns(:yelp_info))
  end

  test "should show yelp_info" do
    get :show, id: @yelp_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @yelp_info
    assert_response :success
  end

  test "should update yelp_info" do
    put :update, id: @yelp_info, yelp_info: {  }
    assert_redirected_to yelp_info_path(assigns(:yelp_info))
  end

  test "should destroy yelp_info" do
    assert_difference('YelpInfo.count', -1) do
      delete :destroy, id: @yelp_info
    end

    assert_redirected_to yelp_infos_path
  end
end
