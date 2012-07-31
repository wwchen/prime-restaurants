require 'test_helper'

class YelpCategoriesControllerTest < ActionController::TestCase
  setup do
    @yelp_category = yelp_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:yelp_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create yelp_category" do
    assert_difference('YelpCategory.count') do
      post :create, yelp_category: {  }
    end

    assert_redirected_to yelp_category_path(assigns(:yelp_category))
  end

  test "should show yelp_category" do
    get :show, id: @yelp_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @yelp_category
    assert_response :success
  end

  test "should update yelp_category" do
    put :update, id: @yelp_category, yelp_category: {  }
    assert_redirected_to yelp_category_path(assigns(:yelp_category))
  end

  test "should destroy yelp_category" do
    assert_difference('YelpCategory.count', -1) do
      delete :destroy, id: @yelp_category
    end

    assert_redirected_to yelp_categories_path
  end
end
