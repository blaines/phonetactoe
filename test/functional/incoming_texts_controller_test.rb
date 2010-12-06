require 'test_helper'

class IncomingTextsControllerTest < ActionController::TestCase
  setup do
    @incoming_text = incoming_texts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incoming_texts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incoming_text" do
    assert_difference('IncomingText.count') do
      post :create, :incoming_text => @incoming_text.attributes
    end

    assert_redirected_to incoming_text_path(assigns(:incoming_text))
  end

  test "should show incoming_text" do
    get :show, :id => @incoming_text.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @incoming_text.to_param
    assert_response :success
  end

  test "should update incoming_text" do
    put :update, :id => @incoming_text.to_param, :incoming_text => @incoming_text.attributes
    assert_redirected_to incoming_text_path(assigns(:incoming_text))
  end

  test "should destroy incoming_text" do
    assert_difference('IncomingText.count', -1) do
      delete :destroy, :id => @incoming_text.to_param
    end

    assert_redirected_to incoming_texts_path
  end
end
