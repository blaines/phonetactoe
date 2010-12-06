require 'test_helper'

class IncomingCallsControllerTest < ActionController::TestCase
  setup do
    @incoming_call = incoming_calls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incoming_calls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incoming_call" do
    assert_difference('IncomingCall.count') do
      post :create, :incoming_call => @incoming_call.attributes
    end

    assert_redirected_to incoming_call_path(assigns(:incoming_call))
  end

  test "should show incoming_call" do
    get :show, :id => @incoming_call.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @incoming_call.to_param
    assert_response :success
  end

  test "should update incoming_call" do
    put :update, :id => @incoming_call.to_param, :incoming_call => @incoming_call.attributes
    assert_redirected_to incoming_call_path(assigns(:incoming_call))
  end

  test "should destroy incoming_call" do
    assert_difference('IncomingCall.count', -1) do
      delete :destroy, :id => @incoming_call.to_param
    end

    assert_redirected_to incoming_calls_path
  end
end
