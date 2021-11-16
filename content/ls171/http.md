# HTTP

- [What is HTTP?](#what-is-http)
- [What is an HTTP request?](#http-requests)
  - [What are GET and POST requests?](#get-and-post-requests)
- [What is an HTTP response?](#http-responses)
  - [What are status codes?](#status-codes)
- [Browsers vs HTTP tools](#http-tools)
- [What is the HTTP request/response cycle?](#the-http-request-response-cycle)
- [What is meant by 'state' in the context of the web?](#state)
  - [How do we simulate statefulness?](#simulating-state)

## What is HTTP?

What is HTTP? What is it's purpose? What does it consist of?

- HTTP stands for **Hypertext Transfer Protocol**
- It is the protocol that governs how applications structure messages syntactically between each other in the Application Layer of networked communications.
- It determines how requests for resources on the web are made, as well as how those requests should be responded to.
- It provides uniformity to the way resources are transferred. In other words, it is an agreed-upon format on how to communicate.
- HTTP is based on the _client-server_ paradigm, in which a client (usually some kind of browser) makes a _request_ through the network for a particular web resource stored on a server.
- The server, then, sends a _response_ to this request that ideally contains the requested resource, or if not, some kind of messaging that explained what happened.
  - The server's response provides the client with the requested resource, informs the client that the action requested has been carried out, or else informs the client that an error occured in the process.
- HTTP governs the syntax of these messages, which together consist of the request/response cycle.
- HTTP is a _text-based_ protocol. All requests and responses are made in plain text, which makes it inherently insecure.

## HTTP Requests

What is an HTTP request?

- An HTTP request is a text-based message sent from the client to the serve with the aim of accessing a resource on the server.
- Entering something into the browser address bar, clicking a link, submitting a form, or any number of other "user interaction" with a resources on the web can instigate the sending on an HTTP request.

What does it consist of?

- An HTTP request consists of a _request line_, _headers_, and an optional _body_.
- The HTTP _request line_ contains the **method**, **path**, and **version**
  - The **method** indicates what kind of action the request is performing (for example, `GET` or `POST`).
  - The **path** indicates where to find the particular resource locally within the server.
  - The **version** tells us which version of HTTP is being used (i.e. 1.0, 1.1, 2)
- HTTP _headers_ are a way to give more information about both the client and the resource that is being requested
  - The **host** header:
    - has bee required since HTTP 1.1
    - indicates where the resource in question is located as a server may contain many hosts
  - Other headers might include:
    - fields about what languages are accepted by the client
    - specially formatted string that identifies the client such as a `session id`
    - information about cookies that help applications maintain the appearance of state
    - what type of connection the client prefers (such as `keep-alive`)
- The _body_ of an HTTP request contains data that is transmitted with the HTTP request
  - What this looks like depends on the type of request methond sent (i.e. method)
  - The body is mainly used with a `POST` request, which is used to send data to the server
  - Said data is typically included in the body of the request

### GET and POST requests

What are `GET` and `POST` requests? What are their use cases?

- A `GET` request is used to _retrieve_ some resource from the server.
- A `POST` request is used whenever you want to _send_ something to the server, either to transmit data or to initiate some kind of server side action.
- Without `POST` requests, we are limited to sending data to the server via query strings
- There not only have a length limitation, but can also expose sensitive data
- A `POST` request, on the other hand, allows us to send larger data (such as images or videos) as well as deal with more sensitive data such as a username or password
- Typically a `POST` request will be used when submitting some kind of form or other information (such as user authentication or form submission)
- A `GET` request will be used when clicking on a link or retrieving a resource (such as a webpage)

## HTTP Responses

What is an HTTP Response?

- HTTP responses are text-based messages sent from the server to the client with the aim of responding to the client's request.
- They either:
  - Provide the client with the resource required
  - Inform the client that the action it requested was carried out
  - Inform the client that an error occurred in the process

What does an HTTP Response consist of?

- An HTTP response consists of a _response line_, _headers_, and a _body_
- The _response line_ contains the **status code**, **status text**, and **version**
  - The status code is a three digit number indicating the specific status of the response, i.e. whether or not it was successful
  - It is accompanied by the status text that tells the status of the response
- HTTP response headers contain additional information about the response
  - information about the type of encoding used the data
  - the name of the server
  - a new resource location if applicable (`Location` header), which helps the client _redirect_ to the requested resource if it has been moved
  - the `content-type` (i.e. `text/html`), which helps the client correctly render the data in a user friendly way
- The HTTP response body consists of the raw data for the requested resource
  - This might be the HTML of the webpage, or the raw data of any files being requested, such as images, videos, or audio files

### Status Codes

What are some common status codes and what do they mean?

- Status codes are three-digit numbers provided in the response line of an HTTP response.
- They signify the status of the response
- `200` OK
  - the request was successfully handled, and the resource has been transmitted
  - all 200 level response codes indicate success
- `302` FOUND
  - the requested resource has been moved, and the new location has been found.
  - The new location is provided in the `Location` response header.
  - All 300 level status codes indicate some kind of redirect status
  - When the browser receives the 302 response, it will automatically issue an HTTP request to the updated URL provided in the `Location` header.
  - This, ideally, will result in the HTTP 200 OK response so that the browser can render the resource for the user.
- `404` NOT FOUND
  - Indicates the resource in question cannot be found, due to a client error with the request
  - All 400 level status codes indicate various client errors
- `500` INTERNAL SERVER ERROR
  - Indicates a generic server-side error took place while trying to retrieve the requested resource.
  - All 500 level status codes indicate server side errors.

## HTTP Tools

What are the differences when using a web browser versus using an HTTP tool?

- When using an HTTP tool, a new request for redirected resources (i.e. a `302` response) will not be issued automatically, as it is with a browser
- A browser will automatically request all referenced resources (i.e. dependencies) in the raw data of a response, and an HTTP tool will not
- A browser will render the row response data in a user friendly way, and an HTTP tool will not

## The HTTP request response cycle

- The HTTP request/response cycle is the interaction between client and server in which the client makes a _request_ and the server makes a _response_.
- It begins with the client making an HTTP request.
  - For our purposes, this is typically issued by a browser in response to some kind of user action or event (i.e. typing a url into an address bar, clicking a link, submitting a form, etc).
  - The request consists of at minimum the _method_ (i.e. `GET` or `POST`), the _host_ and the _path_.
  - The request is sent off to the server by means of the lower layer network protocols.
- When the server receives the request, it will analyze it.
  - This may include actions like verifying the user's session or loading any necessary data from a database
- Once the server has analysed the request, it will issue a response
  - This includes the _status field_, a numeric field that tells if the response was successful, _headers_ which contain important meta-data that helps the client process the response, and the _body_ which contains the raw data of the resource being sent.
- When the browser receives the response, it will process the information within and render the resource in a user-friendly manner.

## State

What is meant by 'state' in the context of the web?

- A "stateful" web application is one that maintains knowledge of past interactions.
  - This might include keeping track of individual user accounts and maintain a "logged in" status accross multiple resource requests and refreshes.
  - Stateful apps can also keep track of items a user has placed in an online "shopping cart", even over multiple days
  - When your e-mail client identifies you by name and displays some kind of customized greeting, this is also an aspect of "state"
- HTTP is a **stateless** protocol, meaning that no information is kept on the server between request/response cycles.
  - Each request/response cycle is independent, and has no effect on previous or subsequent cycles
- Stateless protocols are resilient, fast, and flexible as the server doesn't have to retain any information between each request/response cycle nor does any part of the system have to perform any clean up.
- However, because of the statelessness of HTTP, it can be very difficult to simulate a stateful experience and make it seem like a persistent connection exists as many modern web apps do.

### Simulating State

What are mechanisms that we can use to simulate state?

- **Sessions** are a means of identifying a specific client to a server so that it can be made to _seem_ as if a persistent connection exists between HTTP requests/responses
  - The server assigns some kind of unique `session id` to the client.
  - Then, the client includes that `session id` in each request it makes.
  - This allows the server to identify individual clients, and preserve the data associated with each identity.
  - This can be difficult to maintain because each HTTP request must be analyzed for a `session id`.
  - Furthermore, each `session id` must be validated and the server must establish procedures for invalid ids
  - If a `session id` is valid, the server needs to store and retrieve data associated with each `session id`, as well as recreate the state from that data when sending back a response

- **Cookies** are a way for the browser to store data sent from the server that helps maintain the appearance of persistent application state. They work in conjunction with `session id`s.
  - Cookies consist of small files stored in the browser that contain information about the `session id`.
  - These files are stored even if the browser is closed or shut down, which enables a longer and more consistent appearance of state.
  - The information stored in cookies is sent with each request to the server, then used to "unlock" the correct stored session data
  - This allows the server to recreate the correct state of the application, and the session id to be recognized each time a website is visited, even if some time has passed.

- **AJAX** or Asynchronous JavaScript and XML enables browsers to issue requests and process responses without have to refresh and reload the current webpage
  - Modern web pages tend to be fairly complex, including dynamically generated content as well as many resource dependencies.
  - Therefore, it behoves us to have a means of responding to both server data and user actions without having to refresh and reload the whole page.
  - AJAX enabled this functionality, allowing the client to send and retrieve information in small pieces that can be used to update the state of an application without refreshing/reloading, making it much easier to maintain state.
  - AJAX requests are sent like normal HTTP requests, and the server responds to them with a normal HTTP response.
  - Instead of the browser refreshing to process the HTTP response, it will process the response with a _callback function_, which can update the state of the web app.
