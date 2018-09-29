# smock

### What is it?
---
smock is a simple mock server built using Vapor 3. Once running it can be used by posting your desired mock response to the server then calling it.
You can read a blog post about smock [here](http://localhost.com).
**Example payload**
```
{
  "code": 200,
  "method": "GET",
  "payload": {
    "name": "smock",
    "example": [
      "one",
      "two"
    ],
    "test": true
  },
  "route": "my_test",
  "headers": {
    "request-uuid": "bc909396-3a46-4271-9525-8581316f7aae"
  }
}
```
Then to retrieve this object again you would simply make a GET request to http://localhost:8080/my_test and it should return:
```
{
  "name": "smock",
  "example": [
    "one",
    "two"
  ],
  "test": true
}
```
With a status code of 200 and an additional header of `"request-uuid":"bc909396-3a46-4271-9525-8581316f7aae"`.

### To run the server
---
From the command line:
`$ vapor build && vapor run`
