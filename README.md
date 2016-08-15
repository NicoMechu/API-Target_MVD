# TTL Target_MVD API

API for the Test aplication Target MVD from Top Tier Labs.

## Usage

### User Accounts

#### Sign Up
To Sign Up in the application.

In orden to create a new user account is need to create a post request to the following url.

_(in this case the server is on the host)_

```
http://<localhost:3000>/api/v1/users/
```

And it should contain:

HEADER
```
Accept: application/json
Content-Type: application/json
```
BODY

_(change elements un < > acording to your needs.)_

```
{ "user":
    { 
    "email":"<email: String>",
    "password":"<password: String>",
    "password_confirmation":"<password: String>",
    "name":"<name: String>",
    "gender":"<gender: Enum(0:'female', 1:'male') >",
    }
}
```

Example:
```
curl -X POST -H "Accept: application/json"  -H "Content-Type: application/json" http://localhost:3000/api/v1/users/ -d   '{ "user":{ "email":"test@target.com", "password":"123456789", "password_confirmation":"123456789", "username":"Nico_Prueba", "first_name":"Nicolas", "birth_year":1992}}'
```


#### Log In

#### Log Out
