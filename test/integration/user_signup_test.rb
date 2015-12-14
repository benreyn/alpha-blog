require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(username: 'example', email: 'example@example.com', password: 'password')
  end
  
  test "get sigup form and create user" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {username: 'bob',
                                           email: 'bob@example.com',
                                           password: 'password'}
    end
    assert_template 'users/show'
    assert_match 'bob', response.body
  end
  
  test "invalid email results in failure" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: 'bob',
                                           email: 'bob123',
                                           password: 'password'}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "duplicate email results in failure" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: 'bob',
                                           email: 'example@example.com',
                                           password: 'password'}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
end