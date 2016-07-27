API Template
==============

Template API project with simple token authentication and devise. Every request must be signed with an authentication token header (X-USER-TOKEN).

You can use params instead of headers.

1.  Clone this repo
2.  Create your .ruby-version file
3.  Create your database.yml file
4.  Run:

  ```
  bundle install
  rake db:create
  rake db:migrate
  RAILS_ENV=test rake db:migrate
  ```
5. Start your server

  ```
  rails s
  ```

For code analisys run:
```
rake code_analysis
```

You can run your tests using:
```
rspec
```


Example requests:

Create User
--------------
```
curl -X POST -H "Accept: application/json"  -H "Content-Type: application/json"\ 
http://localhost:3000/api/v1/users/ -d\
  '{ "user":
    {
      "email":"hello@hello.com",
      "password":"123456789",
      "password_confirmation":"123456789"
    }
  }'
```
Sign in User
--------------
```
curl -X POST -H "Accept: application/json"  -H "Content-Type: application/json"\
http://localhost:3000/api/v1/users/sign_in -d\
  '{ "user":
    { 
      "email":"hello@hello.com",
      "password":"123456789"
    }
  }'
```
Sign out
--------------
```
curl -X DELETE -H "X-USER-TOKEN: MTMEGgwVZxUidW2-iMjj" -H "Content-Type: application/json"\
http://localhost:3000/api/v1/users/sign_out
```
Reset password
--------------
```
curl -X POST -H "Accept: application/json"  -H "Content-Type: application/json"\
http://localhost:3000/api/v1/users/password -d\
  '{ "user":
    {
      "email":"hello@hello.com"
    }
  }'
```
```
curl -X PUT -H "Content-Type: application/json"\
http://localhost:3000/api/v1/users/password -d\
  '{ "user":
    {
      "password":"demiandemian",
      "password_confirmation":"demiandemian", "reset_password_token":"1dcce3ffa47fedf0c0fe1d3debba6686982f7e11ff46c43fbcdabd5d7eabadaa"
    }
  }'
```
Update user
--------------
```
curl -X PUT -H "X-USER-TOKEN: vxKbHC4zQoYZp2ztJjVB" -H "Accept: application/json"\ 
-H "Content-Type: application/json"\
http://localhost:3000/api/v1/users/3 -d\ 
  '{ "user":
    {
      "username":"juanito"
    }
  }'
```

Facebook Login
--------------
```
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"\
http://localhost:3000/api/v1/users/facebook_login -d\
  '{ "user":
    {
      "facebook_id":"id1234",
      "first_name":"face",
      "last_name": "book",
      "email":"face@book.com"
    }
  }'
```

Update user with facebook
--------------
```
curl -X PUT -H "X-USER-TOKEN: f84KxyzgwsjDyoJjbwbJ" -H "X-USER-FACEBOOK: id1234"\
-H "Accept: application/json"  -H "Content-Type: application/json"\
http://localhost:3000/api/v1/users/3 -d \
  '{ "user":
    {
      "username":"juanito2"
    }
  }'
```
