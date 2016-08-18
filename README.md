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

##### HEADER
```
Accept: application/json
Content-Type: application/json
```
##### BODY

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
curl -X POST -H "Accept: application/json"  -H "Content-Type: application/json" http://<localhost:3000>/api/v1/users/ -d   '{ "user":{ "email":"test@target.com", "password":"123456789", "password_confirmation":"123456789", "name":"Nico Prueba", "gender":1}}'
```

#### Log In
**There is two ways to log in in this aplication.**

##### Facebook
Is needed to send the facebook authentication token

```
{   
    "type": "facebook",
    "fb_authentication_token":  "<fb_authentication_token: String>"
}
```

Example:
```
curl -X POST -H "Content-Type: application/json" -d '{   
    "type": "facebook",
    "fb_authentication_token": VALID_TOKEN
}' "http://<localhost:3000>/api/v1/users/sign_in"
```

##### Manualy

With email and password

```
{ "user": 
    { 
    "email":"<email: String>", 
    "password":"<password: String>" 
    }
}
```

Example:
```
curl -X POST -H "Content-Type: application/json"  -d '{ "user": 
    { 
    "email":"test@target.com", 
    "password":"123456789" 
    }
}' "http://<localhost:3000>/api/v1/users/sign_in"
```

#### Log Out
For logging out is needed to make a "Delete" request with the authenitcation token in the header in the following format:

_(The authentication token in the header is the way the aplication ahutenticates the user, so its needed in every request)_

```
X-USER-TOKEN: "<token: String>",
```
Example
```
curl -X DELETE -H "Content-Type: application/json" -H "X-USER-TOKEN: <token>"  -d '' "<localhost:3000>/api/v1/users/sign_out"
```

---

### Targets
_(The authentication token in the header is the way the aplication ahutenticates the user, so its needed in every request)_


#### Create a new Target
In order to create a new Target is ndeeded to create a **POST** request with the following format:
```
{"target": 
    { 
    "lat": "<lat: Float>", 
    "lng": "<lng: Float>", 
    "radius": "<radius: Float>",
    "topic": "<topic_id: Integer>"
    }
}
```

Example:
```
curl -X POST -H "Content-Type: application/json" -H "X-USER-TOKEN: MMGssP5gJMgrAskkioPM" -d '{"target": 
    { 
    "lat":"-34.8581", 
    "lng":-56.1707, 
    "radius": 100,
    "topic": 2
    }
}' "http://<localhost:3000>/api/v1/users/1/targets"
```

It will returns the created target with the following format:
```
{
  "target": {
    "id": <target_id>,
    "latitud": <latitud>,
    "longitud": <longitud>,
    "radius": <radius>,
    "topic": "<topic label>"
  },
  "compatible": [
      {
        "id": <target_id>,
        "latitud": <latitud>,
        "longitud": <longitud>,
        "user": <user_id>,
      },
      {
        "id": <target_id>,
        "latitud": <latitud>,
        "longitud": <longitud>,
        "user": <user_id>,
      }
  ]
}
```

#### See my existent Targets
In order to access to the list of targuets from a user sending a **GET** request to the following _url_:
```
<localhost:3000>/api/v1/users/<user_id>/targets
```

Example
```
curl -X GET -H "Content-Type: application/json" -H "X-USER-TOKEN: MMGssP5gJMgrAskkioPM" "http://192.168.1.141:3000/api/v1/users/1/targets"
```

This request will return a list of the targets with the following format:
```
{
  "targets": [
    {
      "latitud": <latitud>,
      "longitud": <longitud>,
      "radius": <radius>,
      "topic": "<topic label>"
    },
    {
      "latitud": <latitud>,
      "longitud": <longitud>,
      "radius": <radius>,
      "topic": "<topic label>"
    },
  ]
}
```

#### Update an existing Target
In order to update an existing target from a user sending a **PUT** request to the following _url_:
```
<localhost:3000>/api/v1/users/<user_id>/targets/<target_id>
```

With the following format:
```
{"target": 
    { 
    "lat":<latitud>, 
    "lng":<longitud>, 
    "radius": <radius>,
    "topic": <topic_id>
    }
}
```

Example:
```
curl -X PUT -H "Content-Type: application/json" -H "X-USER-TOKEN: MMGssP5gJMgrAskkioPM" -d '{"target": 
    { 
    "lat":-34.8581, 
    "lng":-56.1707, 
    "radius": 100,
    "topic": 3
    }
}' "http://<localhost:3000>/api/v1/users/1/targets/6/"
```

It will returns the updated target with the following format:
```
{
  "target": {
    "id": <target_id>,
    "latitud": <latitud>,
    "longitud": <longitud>,
    "radius": <radius>,
    "topic": "<topic label>"
  },
  "compatible": [
      {
        "id": <target_id>,
        "latitud": <latitud>,
        "longitud": <longitud>,
        "user": <user_id>,
      },
      {
        "id": <target_id>,
        "latitud": <latitud>,
        "longitud": <longitud>,
        "user": <user_id>,
      }
  ]
}
```

---

### Topics
_(The authentication token in the header is the way the aplication ahutenticates the user, so its needed in every request)_


Every user can access to the list of aviables topics sending a **GET** request to the following _url_:
```
<localhost:3000>/api/v1/topics
```

Example:
```
curl -X GET -H "Content-Type: application/json" -H "X-USER-TOKEN: MMGssP5gJMgrAskkioPM" "http://<localhost:3000>/api/v1/topics"
```

This returns the new target with a list of others targets wich had matched:

```
{
  "topics": [
    {
      "topic_id=": <topic_id>,
      "label=": "<label>"
    },
    {
      "topic_id=": <topic_id>,
      "label=": "<label>
    },
  ]
}
```

---

