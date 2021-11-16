# TCP & UCP

- [The Transport Layer](#the-transport-layer)
  - [What is the Transport Layer?](#what-is-the-transport-layer)
  - [What is multiplexing and how is it enabled?](#what-is-multiplexing-and-how-is-it-enabled)
  - [What is a socket?](#what-is-a-socket)
  - [Connection Oriented Systems vs Connectionless Systems](#connection-oriented-system-vs-connectionless-system)
  - [What is Network Reliability?](#what-is-network-reliabilty)
  - [What is Pipelining?](#what-is-pipelining)
- [TCP](#tcp)
  - [What is TCP?](#what-is-tcp)
  - [What is the three-way handshake?](#tcp-handshake)
  - [What are some disadvantages of TCP?](#tcp-disadvantages)
  - [What is Flow Control?](#flow-control)
  - [What is Congestion Avoidance?](#congestion-avoidance)
- [UDP](#udp)
  - [What is the PDU for UDP?](#udp-pdu)
  - [What are the advantages and disadvantages of UDP?](#pros-and-cons)
  - [What are some use cases for UDP over TCP?](#use-cases)

## The Transport Layer

### What is the Transport Layer?

- The Transport layer is the level of the networking model that is concerned with providing end-to-end communications between specific processes.
- The two most common protocols that govern this communication are TCP and UDP.
- These protocols are able to direct data transfer to a specific process or application on a host because the facilitate **multiplexing**.
- This gives us the ability to transmit multiple signals, each pertaining to a potentially different process or networked application, over the single host-to-host connection provided by IP (The Internet / Network Layer).

### What is multiplexing and how is it enabled?

- Multiplexing is the transmission of multiple data inputs over a single channel of communication, such as a single device communicating with the browser, the e-mail client, and streaming Spotify all through the same Network connection.
- This is important because often there are multiple applications running on a single device, and yet IP addresses only provide a single channel.
- Multiplexing is implemented through the use of **port** numbers alongside IP addresses.
- Each specific process is assigned a single port, which can be used to identify that same process running on a different device.
- An IP address and port number combined define a communication end-point known as a **network socket**.
- These sockets allow both IP and the protocol operating at the Transport Layer to transmit data between devices and processes.

### What is a socket?

- A **socket** refers to the communication end-point that consists of the port number and IP address together.
- The IP address gets us the correct device on the network and the port number gets us to the correct application on that device.
- This is how we can achieve end-to-end communication between devices.

PORTS:

- A **port** is a way to identify a specific process or application running on a host. It is represented by a single integer in the range 0-65535. There are three kinds of ports, and some are reserved:
  - 0-1023 = _well-known ports_ are assigned to processes that provide commonly used network services, such as port 80 for HTTP or port 443 for HTTPS
  - 1024-49151 = _registered ports_ can be assigned to private entities as requested (such as Microsoft or IBM) or can be assigned as ephemeral ports
  - 49152-65535 = _dynamic_ or _private ports_ cannot be registered for specific use and are only used for allocation on the client side as ephemeral ports.

OTHER THINGS TO CONSIDER:

- The ability to programmatically instantiate socket objects specifically defined to listen for particular communications (i.e. for a certain application from a certain host) allows for us to implement both connection oriented and connectionless communication systems.
- Conceptually, a socket facilitates multiplexing. On a practical level, instantiation of a socket object in code can implement a TCP or UDP connection specifically.

### Connection oriented system vs connectionless system

- A connection-oriented system instantiates new socket object to establish a dedicated virtual connection channel between two processes running on separate devices.
  - When new communication comes into the first listening socket, a new socket is created that listens specifically for messages that match its **four-tuple**, i.e. the IP and port of sender along with the IP and port of the receiver.
  - This is useful for establishing specific rules of communication (i.e. message acknowledgement and in order delivery of TCP)
- A connectionless system relies on a single socket for all communication, does not establish dedicated communication channels, and responds to all communications individually as they arrive.
  - It does not matter from what process transmissions come, a single socket listens to all messages regardless and responds to each as it arrives.
  - This is useful because it is a) a simpler and more flexible process than a connection-oriented system and b) it reduces latency overhead because a connection does not have to be established.

### What is Network Reliability?

- Network Reliability ensures that a reliable communication channel is established between processes.
- That is, that all transmitted data is received at communication end-point in the correct order.
- Consists of 4 key elements:
  - In-order delivery
  - Error detection
  - Handling data loss (ensures missing data is retransmitted)
  - Handing duplication (ensures duplicate data is eliminated)
- Network reliability is implemented by TCP in the Transport Layer.
- Lower level protocols are inherently unreliable, because they drop corrupted data with no protocols for replacement or retrieval.

### What is pipelining?

- Sending multiple messages at once, without waiting for an acknowledgement.
- This is necessary because if each data transmission must _stop and wait_ for an acknowledgement too much time is spent waiting for the recipient's acknowledgment, which contributes greatly to latency.
- Pipelining transmissions can mitigate the latency added by additional waiting time, specifically with regards to the acknowledgement required in TCP and the three way handshake.
- This ensures that TCP is reliable but also as efficient as possible.

## TCP

### What is TCP?

What is the TCP protocol and what services does it provide?

- Transmission Control Protocol operates in the Transport Layer
- It is a connection-oriented protocol that ensures reliable data transfer between applications on top of the unreliable channel of the lower-layer protocols.
- It provides both _multiplexing_ services, enabling end-to-end communication between processes, and provides features such as the TCP Handshake process that ensure network reliability.
- TCP Data is encapsulated into a PDU called a TCP segment, which provides five main services:
  - Multiplexing through source and destination port numbers
  - Error detection through a checksum
  - In-order deliver, handling data loss, and handling data duplication through sequence and acknowledgment numbers
  - Flow control through window size data
  - Congestion avoidance through dynamic adjustment of flow according to data loss

Higher Level / More abstract:

Transmission Control Protocol is a protocol that operates within the Transport Later. It provides multiplexing, or end-to-end communication between multiple processes over the single channel provided by IP, via port numbers. It also has features that ensure reliability. It uses a three-way handshake to establish dedicated communication connections and this ensures data integrity, de-duplication, in-order delivery, and retransmission of lost data. The complexity of this process can cause significant latency overhead. To mitigate this and to be as efficient as possible, TCP provides flow control and congestion avoidance.

### TCP Handshake

What are the steps for the three-way handshake? What is its purpose?

- The TCP handshake is used for _establishing dedicated and reliable connections_ between processes over the network.
- First the sender sends a `SYN` segment, which ostensibly asks if the receiver is ready to receive.
- Upon receipt of the `SYN` segment, the receiver sends back a `SYN ACK` segment, indicating that it received the previous message and ensuring its messages are also being received.
- Finally, upon receiving the `SYN ACK`, the original sender sends an `ACK` segment, indicating it is also receiving messages from the receiver, and the connection can be (and subsequently is) established.
- This not only ensures a reliable connection between both devices, but synchronizes sequence numbers that will be used during the connection.
- It is this aspect of TCP that enables network reliability, that is, handling data loss through message acknowledgement, and ensuring in order delivery and de-duplication via the synchronized segment numbers.

### TCP Disadvantages

What are the disadvantages of TCP?

- TCP provides reliability at the cost of speed (that is, its reliability functions can contribute greatly to latency)
- First, there is added overhead due to the need of establishing a connection with the three-way handshake, which can add up to two round trip times.
- There is also the possibility of additional delays due to Head-of-Line blocking as a result of in-order delivery.
  - Because TCP provides in-order delivery of segments, a single segment that has a delay (say, due to being dropped and retransmitted) can "hold up" the other segments behind it in the buffer.
  - This can lead to increased queuing delay.
- It's not as flexible as other Transport Layer protocols such as UDP.

### Flow Control

What is flow control?

- Provided by TCP, flow control helps to ensure that data is transmitted as efficiently as possible.
- This, in turn, helps to mitigate the increased latency inherent in TCP connections.
- Flow control is used to prevent the sender from overwhelming the receiver with too much data all at once.
- It is implemented via the _window_ field of the TCP segment header.
  - The _window_ header contains data sent by the receiver letting the sender know the maximum amount of data it can accept at any given time.
  - This number is dynamically generates, and therefore the receiver can lower the amount if the buffer is getting full, and the sender will respond accordingly.

### Congestion Avoidance

What is congestion avoidance?

- Congestion avoidance is a service provided by TCP that attempts to prevent network congestion, a situation in which more data is being transmitted than there is capacity.
- To implement this, TCP uses data loss as a feedback mechanism to determine how "congested" the network is, by tracking how many retransmissions are required.
- A lot of data loss, or a lot of retransmissions, indicates there is more data on the network than there is capacity to process that data.
- TCP will take this as a sign to reduce the size of the transmission window, that is, it will send less data along the given channel.
- This is to make data transmission as efficient as possible to mitigate the latency overhead inherent in TCP connections.

## UDP

What is UDP?

- User Datagram Protocol is a protocol that establishes end-to-end connections between processes in the Transport Layer.
- It is a very simple and _connectionless_ protocol.
- Like TCP, it enables multiplexing through source and destination port numbers.
- Unlike TCP, it does not provide reliability features beyond optional error detection via a checksum.
- It makes up for this lack of reliability with its speed and flexibility.
- Specifically, UDP provides speed because it doesn't take the time to establish a dedicated connection, its lack of in-order delivery means no latency due to Head-of-Line blocking, and the one way data flow of a connectionless system cuts down on latency due to extra round trips (there are no acknowledgments).
- Furthermore, UDP acts as a base that programmers can build upon. The specifics of what type of reliability functions to include are left up to the developer to implement at the Application level.

### UDP PDU

What is the PDU for UDP and how is it structured?

- The PDU of UDP is known as a **datagram**
- It consists of metadata in the form of headers, and a data payload, which is the encapsulated HTTP request or response from the Application Layer above.
- Its headers contain source port and destination port data, which provides for multiplexing and socket routing, information about the length of the datagram, and a checksum.

### Pros and Cons

What are the advantages and disadvantages of UDP?

- UDP does not provide any of the reliability of TCP. It is just as inherently unreliable as the layers below it.
- With UDP there is no guarantee of message delivery, delivery order, congestion avoidance, flow control, or state tracking.
- Its main advantages are speed and flexibility (see above).

### Use Cases

What are some use cases for UDP over TCP?

- UDP is a good option for any application that prioritizes speed and flexibility.
- For example, video calling applications and online games that prioritize speed over the potential for small amounts of lost data, can utilize UDP.
