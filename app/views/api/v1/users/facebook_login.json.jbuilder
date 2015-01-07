json.token @user.authentication_token
json.user do
  json.partial! 'api/v1/users/info', user: @user
end
