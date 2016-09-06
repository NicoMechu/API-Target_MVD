# TTL Target_MVD API

API for the Test aplication Target MVD from Top Tier Labs.

## Usage

For every action is needed to send the **Authentication Token** in the HEADER in the following format:
```
Accept: application/json
Content-Type: application/json
```
_(In all the exameples change elements in < > acording your needs.)_ 
### User Accounts

#### Sign Up
To Sign Up in the application.

In orden to create a new user account is need to create a post request to the following url.

_(in this case the server is on the host)_

```
http://<Server_IP>/api/v1/users/
```

The body should contain:

```
{ "user":
    { 
    "email":<email: String>,
    "password":<password: String>,
    "password_confirmation":<password: String>,
    "name":<name: String>,
    "gender":<gender: String - Enum('male','female') >,
    }
}
```

And retruns:

```
{
  "token": <token: String>,
  "email": <email: String>,
  "name": <name: String>,
  "gender": <gender: String - Enum('male','female') >,
  "user_id": <user_id: Number>
}
```

Example:
```
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://<Server_IP>/api/v1/users/ -d '{ "user":{ "email":"test@target.com", "password":"123456789", "password_confirmation":"123456789", "name":"Nico Prueba", "gender":1}}'
```

#### Log In

**There is two ways to log in in this aplication.**

##### Facebook
Is needed to send the facebook authentication token

```
{ 
    "type": <type: String>,
    "fb_access_token": <fb_authentication_token: String>
}
```

Example:
```
curl -X POST -H "Content-Type: application/json" -d '{ 
    "type": <type: String>,
    "fb_access_token": VALID_TOKEN
}' "http://<Server_IP>/api/v1/users/sign_in"
```

And returns:
```
{
  "token": <token: String>,
  "email": <email: String>,
  "user_id": <user_id: Number>,
  "name": <name: String>
}
```

##### Manualy

With email and password

```
{ "user": 
    { 
    "email": <email: String>, 
    "password": <password: String>
    }
}
```

Example:
```
curl -X POST -H "Content-Type: application/json" -d '{ "user": 
    { 
    "email": <email: String>, 
    "password": <password: String> 
    }
}' "http://<Server_IP>/api/v1/users/sign_in"
```

#### Log Out
For logging out is needed to make a **DELETE** request with the authenitcation token in the header in the following format:

_(The authentication token in the header is the way the aplication ahutenticates the user, so its needed in every request)_

```
X-USER-TOKEN: <token: String>,
```
Example
```
curl -X DELETE -H "Content-Type: application/json" -H "X-USER-TOKEN: <token>" -d '' <Server_IP>/api/v1/users/sign_out
```


#### Update user
For update user is needed to make a **PUT** request with the authenitcation token in the header in the following format:

```
<Server_IP>/api/v1/users/<User_Id>
```

```
{ "user":
    { 
    "email": <email: String>,
    "name": <name: String>,
    "gender": <gender: Number>
    }
}
```

Example:
```
curl -X PUT -H "Content-Type: application/json" -H "X-USER-TOKEN: sRhya5xuGc2R8eL1FgzB" -d '{ "user":
    { 
    "email": <email: String>,
    "name": <name: String>,
    "gender": <gender: String - Enum('male','female') >
    }
}' "http://192.168.1.145:3000/api/v1/users/114"
```

It will returns the updated user in the following format:
```
{
  "user_id": <user_id: Number>,
  "name": <name: String>,
  "email": <email: String>,
  "authentication_token": <authentication_token: String>
}
```

---

### Targets
_(The authentication token in the header is the way the aplication ahutenticates the user, so its needed in every request)_


#### Create a new Target
In order to create a new Target is ndeeded to create a **POST** request with the following format:
```
{"target": 
    { 
    "lat": <lat: Float>, 
    "lng": <lng: Float>, 
    "radius": <radius: Float>,
    "topic": <topic_id: Integer>
    }
}
```

Example:
```
curl -X POST -H "Content-Type: application/json" -H "X-USER-TOKEN: MMGssP5gJMgrAskkioPM" -d '{"target": 
    { 
    "lat": <lat: Number>, 
    "lng": <lng: Number>, 
    "radius": <radius: Number>,
    "topic_id": <topic_id: Number>
    }
}' "http://<Server_IP>/api/v1/users/1/targets"
```

It will returns the created target with the following format:
```
{
  "target": {
    "id": <target_id: Number>,
    "latitud": <latitud: Number>,
    "longitud": <longitud: Number>,
    "radius": <radius: Number>,
    "topic": <topic: Topic>
  },
  "compatible": [
      {
        "id": <target_id: Number>,
        "latitud": <latitud: Number>,
        "longitud": <longitud: Number>,
        "user": <user_id: Number>,
      },
      {
        "id": <target_id: Number>,
        "latitud": <latitud: Number>,
        "longitud": <longitud: Number>,
        "user": <user_id: Number>,
      }
  ]
}
```

#### See my existent Targets
In order to access to the list of targuets from a user sending a **GET** request to the following _url_:
```
<Server_IP>/api/v1/users/<user_id>/targets
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
      "latitud": <latitud: Number>,
      "longitud": <longitud: Number>,
      "radius": <radius: Number>,
      "topic": <topic: String>
    },
    {
      "latitud": <latitud: Number>,
      "longitud": <longitud: Number>,
      "radius": <radius: Number>,
      "topic": <topic label>
    },
  ]
}
```

#### Update an existing Target
In order to update an existing target from a user is need to send a **PUT** request to the following _url_:
```
<Server_IP>/api/v1/users/<user_id>/targets/<target_id>
```

With the following format:
```
{"target": 
    { 
    "lat":<latitud: Number>, 
    "lng":<longitud: Number>, 
    "radius": <radius: Number>,
    "topic": <topic_id: Number>
    }
}
```

Example:
```
curl -X PUT -H "Content-Type: application/json" -H "X-USER-TOKEN: MMGssP5gJMgrAskkioPM" -d '{"target": 
    { 
    "lat": <lat: Number>, 
    "lng": <lng: Number>, 
    "radius": <radius: Number>,
    "topic": <topic: Number>
    }
}' "http://<Server_IP>/api/v1/users/1/targets/6/"
```

It will returns the updated target with the following format:
```
{
  "target": {
    "id": <target_id: Number>,
    "latitud": <latitud: Number>,
    "longitud": <longitud: Number>,
    "radius": <radius: Number>,
    "topic": <topic: String>
  },
  "compatible": [
      {
        "id": <target_id: Number>,
        "latitud": <latitud: Number>,
        "longitud": <longitud: Number>,
        "user": <user_id: Number>,
      },
      {
        "id": <target_id: Number>,
        "latitud": <latitud: Number>,
        "longitud": <longitud: Number>,
        "user": <user_id: Number>,
      }
  ]
}
```

#### Delete an existing Target
In order to delete an existing target from a user is need to send a **DELETE** request to the following _url_:
```
<Server_IP>/api/v1/users/<user_id>/targets/<target_id>
```

Example:
```
curl -X DELETE -H "Content-Type: application/json" -H "X-USER-TOKEN: MMGssP5gJMgrAskkioPM" -d '' <Server_IP>/api/v1/users/1/targets/27/
```

It will returns the updated target with the following format:
```
{
  "target": {
    "id": <target_id: Number>,
    "latitud": <latitud: Number>,
    "longitud": <longitud: Number>,
    "radius": <radius: Number>,
    "topic": <topic: String>
  }
}
```


---

### Topics
_(The authentication token in the header is the way the aplication ahutenticates the user, so its needed in every request)_


Every user can access to the list of aviables topics sending a **GET** request to the following _url_:
```
<Server_IP>/api/v1/topics
```

Example:
```
curl -X GET -H "Content-Type: application/json" -H "X-USER-TOKEN: MMGssP5gJMgrAskkioPM" "http://<Server_IP>/api/v1/topics"
```

This returns the new target with a list of others targets wich had matched:

```
{
  "topics": [
    {
      "topic_id=": <topic_id: Number>,
      "label=": <label: String>
    },
    {
      "topic_id=": <topic_id: Number>,
      "label=": "<label: String>,
      "icon": <icon_url: Url>
    },
  ]
}
```

---

### Martches
_(The authentication token in the header is the way the aplication ahutenticates the user, so its needed in every request)_


#### List Matches

Every user can access to the list matches sending a **GET** request to the following _url_:
```
<Server_IP>/api/v1/users/<User_Id>/match_conversations
```

Example:
```
curl -X GET -H "Content-Type: application/json" -H "X-USER-TOKEN: sRhya5xuGc2R8eL1FgzB" "http://192.168.1.145:3000/api/v1/users/114/match_conversations"

```

This returns the new target with a list of others targets wich had matched:

```
{
  "matches": [
    {
      "match_id": <match_id: Number>,
      "topic": <topic: Number>,
      "user": {
        "id": <id: Number>,
        "email": <email: String>,
        "authentication_token": <authentication_token: String>,
        "facebook_id": <facebook_id: String>,
        "created_at": <created_at: String>,
        "updated_at": <updated_at: String>,
        "gender": <gender: String - Enum('male','female') >,
        "name": <name: String>,
        "image": {
          "url": <url: Url>
        }
      },
      "channel_id": <channel_id: String>,
      "unreaded": <unreaded: Number>,
      "last_message": []
    }
  ]
}
```

#### Close conversation

The aplication will send reveived messagas to an user who has the chat view opend. When an user close the chat view it must send a request to notify the aplication that he stopped reading messages. This request should be a **POST** request to the following _url_:


```
<Server_IP>/api/v1/users/<User_Id>/match_conversations/< Match_id >/close

```

Example:
```
```

And it should return a JSON with this format:

```
{
  "match_id": <match_id: Number>,
  "topic": <topic: Number>,
  "user": {
    "id": <id: Number>,
    "email": <email: String>,
    "authentication_token": <authentication_token: String>,
    "facebook_id": <facebook_id: String>,
    "created_at": <created_at: String>,
    "updated_at": <updated_at: String>,
    "gender": <gender: String - Enum('male','female') >,
    "name": <name: String>,
    "image": {
      "url": <url: Url>
    }
  },
  "last_logout": <last_logout: String>
}
```

---


### Messages
_(The authentication token in the header is the way the aplication ahutenticates the user, so its needed in every request)_


#### Create a new Message
In order to create a new Message is ndeeded to create a **POST** request with the following format:
```
<Server_IP>/api/v1/users/<User_Id>/match_conversations/<Match_id>/messages
```
```
{"message": 
    { 
    "text": <text: String>
    }
}
```

Example:
```
curl -X POST -H "Content-Type: application/json" -H "X-USER-TOKEN: sRhya5xuGc2R8eL1FgzB" -d '{"message": 
    { 
    "text": <text: String>
    }
}' "http://192.168.1.145:3000/api/v1/users/114/match_conversations/12/messages"
```

It will returns the created message with the following format:
```
{
  "id": <id: Number>,
  "sender": <sender: Number>,
  "receiver": <receiver: Number>,
  "text": <text: String>
}

```
#### List all Messages for a Conversation
In order to access to the list of Messages from a conversation is needed to send a **GET** request to the following _url_:
```
<Server_IP>/api/v1/users/<User_Id>/match_conversations/<Match_id>/messages
```

Example
```
curl -X GET -H "Content-Type: application/json" -H "X-USER-TOKEN: sRhya5xuGc2R8eL1FgzB" "http://192.168.1.145:3000/api/v1/users/114/match_conversations/12/messages"
```

This request will return a list of the messages with the following format:
```
{
  "messages": [
    {
      "id": <id: Number>,
      "sender": <sender: Number>,
      "receiver": <receiver: Number>,
      "text": <text: String>
    }
  ]
}
```

---

