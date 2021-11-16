# URLs

- [What is a URL?](#what-is-a-url)
- [What is a URI and how does it relate to a URL?](#uris)
- [What are the components of a URL?](#what-are-the-components-of-a-url)
- [What is URL Encoding?](#url-encoding)

## What is a URL?

- A URL is a **Uniform Resource Locator**
- It is a consistently formatted string that allows us to _locate_ a certain resource on [the web](../study_guide/the_internet.md#what-is-the-web?).
- It consists of a _scheme_, _host_, _path_, _port number_, and any _query strings_ that we wish to include as parameters.
- It provides us with a systematic means of locating resources that we are requesting (via an HTTP request).

## URIs

- A URL is a _type_ of URI, which stands for Uniform Resource Identifier.
- This refers to any kind of uniform string that identifies a particular resource, such as an ISBN for a publication.
- A URL, unlike a URI, _must_ include some piece of data that allows us to locate the resource in question, while a URI does not have this requirement.
- URL refers to a specific kind of URI in which the formatting has already been determined and it contains the location of a particular resource on the web.
- URL and URI are often used interchangeably but this is inaccurate.

## What are the components of a URL?

Example URL: `https://launchschool.com/staff/assessments/completed?course=RB109&verdict=passed`

- The **scheme** is the first part of the URL and tells us which protocol should be used to access the resource in question.
  - In the example, the scheme is `https`
  - A scheme is different from a protocol, although these terms are sometimes used interchangeably
  - It indicates which protocol group should be used, but not the specific version
  - Schemes and protocols can be differentiated by their case.
  - It is a mandatory component of the URL
- The **host** indicates where the resource in question is located (i.e. hosted).
  - This is written in the format of a _domain name_.
  - In the example, the host is `launchschool.com`
  - [DNS](../study_guide/lower_level_protocols.md#dns) takes this human readable domain and finds the equivalent IP so the request can be routed.
  - It is a mandatory component of the URL
- The **port** is an identifier for the specific process to which the communication should be routed.
  - The port number is optional, if none is supplied the default port number for the scheme will be used
  - In this case, no port number is specified, so the default for `https` which is port 443, will be used.
- The **path** indicates exactly what specific resource is being requested from the host.
  - In our example, the path is `/staff/assessments/completed`
  - The path must be included. If the resource in question is a home page, the path might consist of a single forward slash (`/`).
  - Historically, the path has indicated specifically where the resource was located on the server, but with the proliferation of dynamically generated content, this no longer always follows the absolute file path of the server.
- The **query string** passes additional information in the form of specially formatted query parameters to the server.
  - In our example, the query string is `?course=RB109&verdict=passed`
  - Query parameters are name-value pairs that are separated with the `=` sign
  - If there are multipple query parameters, they can be combined with the `&` sign
  - The beginning of a query string is denoted by `?`
  - Query strings are limited in use in that they have a maximum length, and are not suitable for sensitive information as they are plainly visible in the URL.
  - Query strings are mostly used with HTTP `GET` requests

## URL Encoding

What is URL encoding, and why is it necessary?

- URL Encoding is a special technique that replaces characters that aren't allowed in a URL with an ASCII code.
- A URL only allows certain characters in the standard 128-character set.
- Some of these characters are not allowed. These can include:
  - characters that are not members of the original ASCII set assigned to URLs
  - characters that are "reserved" because they have special meaning in a URL (such a `?` which indicates the beginning of the query string or `&` which separates query parameters)
  - characters that are considered "unsafe" because they can be misinterpreted (i.e. `%` or ` `)
- URL encoding works by replacing the character in question with a `5` + two hexadecimal digits (i.e. the character's ASCII code).
- We need a safe way to represent these characters in a URL because using them literally can "break" the URL, in that it will no longer be able to locate the resource in question.
