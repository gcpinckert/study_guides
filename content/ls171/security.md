# Security

- [What are the security risks to HTTP, and how do we deal with them?](#security-in-http)
  - [Session Hijacking](#session-hijacking)
  - [Same Origin Policy](#same-origin-policy)
  - [Cross Site Scripting](#cross-site-scripting)
- [TLS](#tls)
  - [What are the services that TLS provides?](#what-are-the-services-that-tls-provides)
  - [A general overview of the TLS Handshake](#the-tls-handshake)
  - [TLS Encryption](#tls-encryption)
    - [What is symmetric key encryption?](#symmetric-key-encryption)
    - [What is asymmetric key encryption?](#asymmetric-key-encryption)
    - [What is a cipher suite?](#cipher-suites)
  - [TLS Authentication](#tls-authentication)
    - [Certificate Authorities](#certificate-authorities)
  - [TLS Integrity](#tls-integrity)
  - [DTLS](#dtls)

## Security in HTTP

- HTTP is a text based protocol, and all it's requests and responses consist of plain text.
- As such, it is _inherently insecure_.
- Attackers can employ techniques like _packet sniffing_ and _session hijacking_ to obtain information and perform malignant acts.
- Requests/responses often contain information about the `session id` which uniquely identifies a user to the server, and anyone who gets access to this can pose as the user to get logged in without needing to authenticate with a username and password.
- Using HTTPS, which utilizes TLS to ensure a secure connection helps with this.

### Session Hijacking

What is session hijacking? What measures can be taken to prevent this?

- **Session hijacking** refers to a malignant action in which a hacker utilizes a stolen `session id` to authenticate themselves and share sessions
- Because a `session id` is used to identify a user to the server, it can also be used by hackers to pose as the user and get logged in without needing to authenticate with a username and password.
- This can be mitigated by frequently resetting sessions, i.e. making sure users re-authenticate when doing anything sensitive.
- Putting an expiration time on sessions gives attackers a narrower window for access to the `session id`.

### Same Origin Policy

- Designing for the **same-origin policy** can help to mitigate the lack of security in HTTP by restricting interactions between resources.
- This policy only permits interaction between resources of the _same origin_, but restricts interactions between resources of a different origin.
- Resources of the "same-origin" means they share the same _scheme_, _host_, and _port_.
- Only those resources that share all three aspects are allows to issue requests unrestrictedly.
- This prevents attackers from using this mechanism to access session ids or other session information.

### Cross Site Scripting

- Websites that allow some kind of input, such as allowing users to enter a comment that will be displayed, must protect against **cross site scripting** or **XSS**.
- This is when a malicious party uses site input fields to inject HTML or JavaScipt into the site directly.
- This can be prevented by performing _input sanitation_, such as getting rid of anything that might be problematic such as `<script>` tags.
- It's also possible to escape certain characters that indicate JavaScript or HTML code.
- Site's can also choose to only accept a safer form of input, such as Markdown.

## TLS

What is the TLS protocol, and what is its purpose?

- TLS stands for **Transport Layer Security**, and it is a protocol that utilizes cryptography to provide more secure communications between networked applications.
- It is what provides the security aspect of HTTPS, enabling measures of _encryption_, _authentication_, and _integrity_ over the inherently insecure protocol of HTTP.
- It consists of both the TLS _record_ and TLS _handshake_.
- TLS operates between HTTP and TCP. 

Why do we need TLS?

- Beach HTTP is a text based protocol, it is inherently insecure.
- Any intercepted requests/responses are easy to read.
- Furthermore, HTTP is a fairly simple protocol, concerned only with basic message structure.
- It provides no check for whether or not the source of an HTTP response is trustworthy, nor does it provide a means of determining if the messages are being tampered with in transit.

Purpose of TLS:

- TLS enables us to provide encryption to the inherently insecure plain text of the HTTP protocol.
- It provides authentication services, checking to see if the source of an HTTP response is trustworthy.
- It also provides a means of ensuring data integrity, that is, determining whether or not HTTP messages have been tampered with.

### What are the services that TLS provides?

- **TLS Encryption** allows HTTP messages to be encoded in such a way that only the authorized parties are able to decode and read the plain text version of the messages.
  - This secure channel is established with the TLS handshake, which uses both symmetric and asymmetric key encryption
  - It encrypts, which increases security, but adds several round-trips of latency which impacts performance
- **TLS Authentication** provides a means of verifying the identity of participants in a message exchange.
  - This ensures that the source of an HTTP response is trustworthy, and so the provided resource can be safely processed.
  - It is implemented with digital _certificates_, which are signed by a chain of _Certificate Authorities_.
  - These certificates are exchanged during the TLS handshake process.
- **TLS Integrity** ensures that a message hasn't been altered or interfered with during transit.
  - Data that is being exchanged via HTTP is encapsulated into a TLS record which contains a Message Authentication Code (MAC), which is used by the protocol to determine whether the message has been tampered with or faked.
  - This is slightly different than a regular checksum, which is only concerned with error detection.

### The TLS Handshake

A general overview of the TLS handshake:

- The **TLS Handshake** is a special process that takes place after the TCP Handshake in which the client and the server exchange encryption keys.
- This exchange allows both parties to communicate via encrypted messages, thus giving a security advantage over the inherently insecure messages of HTTP.
- The encryption key exchange is accomplished via asymmetric key encryption.
- Once the encryption keys are exchanged in the handshake, communication via symmetric encryptions between the client and the server can commence.
- The TLS handshake also provides a means by which the two devices can decide on which TLS version should be used for the connection, as well as which algorithms should be used in the cipher suite.

How the TLS Handshake is implemented:

- The client sends a message to the server in the form of a `ClientHello`, which includes the maximum version of TLS protocol it supports and a list of available cipher suites.
- The server responds with a `ServerHello`, which contains a decision regarding which TLS version and cipher suite will be used. It also includes the server's certificate and public key. This ends with a `ServerHelloDone` marker.
- Next the client initiates the symmetric key exchange process, using the server's public key for asymmetric key encryption.
- Once the keys have been exchanged, the server sends a ready-to-go message unsing the symmetric key and secure message exchange commences.

Trade offs:

- Allows us to implement secure message exchange over the inherently insecure text based protocol of HTTP
- Because the TLS handshake is a complex process, it can add two round-trips of latency, this has an impact on speed and performance.

### TLS Encryption

#### Symmetric Key Encryption

What is symmetric key encryption>? What are it's advantages and disadvantages?

- Symmetric key encryption is an encrypted communication system in which both the sender and receiver posses a shared encryption key.
- The advantages to this are that it facilitates two-way communication. Both parties can use the shared key to encode, send, and decode messages to and from the other.
- This disadvantage is that a symmetric system relies on the fact that no one else has access to the key in order for it to remain secure.
- This means that it requires a secure way for both paries to exchange keys before symmetric encryption can be established, and this is difficult to do on the web.
- For this reason, it is used in _conjunction_ with asymmetric key encryption, which facilitates a secure exchange of a shared key

#### Asymmetric Key Encryption

What is asymmetric key encryption? What are its advantages and disadvantages?

- Asymmetric Key Encryption is an encrypted communications system which uses two distinct keys: a public key and a private key.
- The public key is used to encrypt and send a secure message to the recipient, who holds the private key, which is used to decode the encrypted message.
- This only facilitates one way communication, in which only the party who holds the private key can receive and decode secure communications.
- However, because it works only one way, we can se asymmetric key encryption as a means for hosts to exchange symmetric encryption keys during the TLS handshake process.

#### Cipher Suites

What is a cipher suite?

- A cipher suite is the set of ciphers (i.e. cryptographic algorithms) that are used for encryption, decryption, and other security tasks.
- In general, we want to have a distinct cipher (algorithm) for each task during secure communication.
- These tasks might be performing the key exchange, symmetric key encryption, and checking message integrity.
- Hosts agree on a cipher suite, or set of algorithms, they will use for each task during secure communication during the TLS handshake process.

### TLS Authentication

How does TLS Authentication Work?

- TLS authentication is a means by which devices securely identify the other party in a message exchange, to ensure that party is trustworthy.
- It uses digital certificates, which are provided by the server during the TLS handshake.
- The certificate includes a public key, a signature (which consists of data encrypted with the private key), and the original data that was used to create the signature.
- Upon receipt, the receiver decrypts the signature with the public key and checks that it matches against the original data, which tells it that the sender is who it says it is (because it holds the private key).
- The digital certificate the server provides is considered to be trustworthy on the basis of the issuing certificate authority and the chain of trust.

#### Certificate Authorities

What are Certificate Authorities and the Chain of Trust?

- Certificate Authorities are trustworthy sources that issue certificates used by servers to establish authentication.
- We use certificates provided by these authorities to ensure that the certificate in question is not being faked.
- Certificate authorities exist in a hierarchy known as the "chain of trust"
- Within this hierarchy, the certificate for lower level authorities is signed by the CA one level above it
- At the top of the chain there exists a Root CA whose certificate is "self-signed"
- These consist of a small group of organizations who have proved their high level trustworthiness through prominence and longevity.

### TLS Integrity

How does TLS Integrity work?

- TLS integrity makes sure that a message hasn't been altered, tampered with, or faked during transit.
- Data that is being exchanged with HTTP is encapsulated within the TLS record.
- Metadata such as the Message Authentication Code (MAC) allows us the check to see if the message has been interfered with.
- The sender creates a digest of the data payload with a hashing algorithm (pre-agreed upon in the TLS handshake)
- This data is then encrypted with the symmetric key and sent to the receiver
- The receiver decrypts the data, creates a digest with the same pre-agreed upon hashing algorithm, and checks to see if the two match.

### DTLS

What is DTLS and why do we need it?

- DTLS stands for Datagram Transport Layer Security.
- It is a separate protocol based on TLS that is used with network connections that utilize UDP instead of TCP
- Because TLS is interlinked with TCP and the TCP handshake, separate protocols are needed to meet the security requirements of UDP.
