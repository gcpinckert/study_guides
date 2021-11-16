# Lower Level Protocols

- [The Link/Data Link Layer](#the-link/data-link-layer)
  - [What is the Ethernet Protocol?](#what-is-the-ethernet-protocol)
  - [How does Ethernet Implement Framing?](#how-does-ethernet-implement-framing)
  - [How does Ethernet Implement Addressing?](#how-does-ethernet-implement-addressing)
- [The Internet/Network Layer](#the-internet/network-layer)
  - [How does IP implement its functionality?](#how-does-IP-implement-its-functionality)
  - [What is an IP address?](#what-is-an-ip-address)
- [DNS](#dns)

## The Link/Data Link Layer

- The Link/Data Link Layer consists of a series of protocols that _identify the next network "node" to which data should be sent_, and move that data over the physical network between devices.
- It is ostensibly the interface between the physical network and the more logical layers above it.

### What is the Ethernet Protocol?

- The Ethernet protocol is the most common protocol operating at the Link/Data Link Layer.
- Its overall purpose in networked communication is to govern communication between devices in a local network.
- It provides two main functions:
  - **Framing** = adds logical structure to the streams of bits traveling through the Physical Layer by categorizing data into 'fields' that have specific lengths and orders.
  - **Addressing** = identifies the next network "node" to which data should be sent through the use of MAC addresses.

### How does Ethernet implement framing?

- Through use of a PDU known as an **Ethernet Frame**, which adds the first kind of logical structure to the streams of bits traveling through the physical layer.
- This allows Ethernet to function as the interface between the physical layer and the more logical layers above it.
- An Ethernet Frame consists of:
  - _Preamble and SFD_: A synchronization measure that notifies the receiving device data is coming, and identifies said data.
  - _Source and Destination MAC address_: physical address for the sender and recipient devices
  - _Length_: size of data payload
  - _Data Payload_: the entire PDU from the Network/Internet Layer above, commonly an IP packet.
  - _Frame Check Sequence_: a checksum
  - _Interframe Gap_: A pause between transmissions

### How does Ethernet implement addressing?

- Through **MAC addresses**, which are:
- A physical, permanent, "burned-in" address for a specific network device.
- Consists of a sequence of six two digit hexadecimal numbers (i.e. `00:1a:b2:3f`)
- Different kinds of network devices are assigned different ranges of MAC addresses.
- MAC addresses work well in LANs, where devices are connected to a central hub that recalls their specific MAC address.
- They do not work well in large decentralized systems, nor are they scalable:
  - They are physical, not logical, i.e. they do not change based on location
  - The are flat, and do not posses a hierarchical structure that allows us to categorize them into searchable subdivisions.

## The Internet/Network Layer

- The Internet/Network Layer is concerned with communication between devices on different networks (i.e. inter-network communication).
- It comes between protocols at the Link/DataLink Layer and protocols at the Transport Layer
- The primary protocol that governs this function is the Internet Protocol (IP)
- IP provides routing capability between devices on different networks via IP addresses
- It also encapsulates data into packets

### How does IP implement its functionality?

- IP uses a PDU called an **IP Packet**
- A packet consists of a header and a data payload
- The header contains information that allows the packet to be routed:
  - Which version of IP is being uses (IPv4 vs IPv6)
  - **Source and destination IP address**
  - Fragmentation data if the transported data is too big for a single packet
  - TTL (Time to Live) the maximum amount of network hops a packet can take
  - Which protocol is used in data payload (TCP vs UDP)
  - Checksum
- Data Payload:
  - Encapsulated TCP segment or UDP datagram from Transport Layer above
- The source and destination IP addresses in the header allow for IP addressing
- IP addresses have two main features that allow for inter-network communication across a large distributed system
  - They are logical: they are assigned as required when devices join a network
  - They are hierarchical: the structure of the address allows us to categorize them into searchable subdivisions. The overall network is divided into logical sub-networks and numbers are allocated according to this hierarchy.

### What is an IP address?

- A logical and hierarchical address that can be assigned as needed to different devices as they join a network.
- A range of IP addresses is defined by network hierarchy, and each subnetwork is assigned a given range of addresses.
- The _network address_ is assigned to the first address in the range and the _broadcast address_ is assigned to be the last address in that range.
- There are two types of IP addresses in two different versions of IP:
  - IPv4 = 32-bit addresses provides 4.3 billion possible addresses, which is not enough for all the devices on the network
  - IPv6 = 128-bit addresses provide 340 undecillion addresses, hopefully will be enough for a long time to come

Strengths and weaknesses of IP addresses:

- MAC addresses, due to their nature, are not _scalable_. IP addresses fill this gap. Because they are logical and hierarchical, they work well in large distributed systems.
- The IP address only gets us in communication with the intended device. It does not allow us to isolate any particular application of process running on that device. For that we need the Port numbers provided by the Transport Layer protocol.

## DNS

- DNS stands for **Domain Name System**
- It is a distributed database that translates a domain name (like `www.google.com`) to an IP address (like `123.456.123.456`)
- DNS provides a service that allows us to utilize user friendly domain names rather than hard to recall strings of numbers like IP addresses when trying to access resources on the web.

How does DNS work?

- DNS databases are stored on special devices called DNS servers.
- Each of these is a member of a huge hierarchical system and contains only a part of the database that maps domain names to IP addresses.
- When a domain name is entered into a browser address bar, a *DNS request* is sent to retrieve the corresponding IP address
- If the DNS server that receives the request does not have the correct domain name, it will route the request up the hierarchical system until it finds it
- DNS then hands that IP address to the lower level protocols that are responsible for routing the HTTP request to the proper location. (??)
