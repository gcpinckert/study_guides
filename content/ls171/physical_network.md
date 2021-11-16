# The Physical Network

## What is the Physical Network?

- The Physical Network is the most basic level of the network.
- It consists of the tangible physical parts, i.e. network devices, cables, and wires, which transport bits in the form of radio waves, light signals, and electrical impulses.
- It's concerned only with how data is transported across a physical medium as bits.

## What are the characteristics of the Physical Network?

- The characteristics of the Physical Network are **latency** and **bandwidth**, which come from the physical limitations of the physical infrastructure itself.
- **Latency** is the measure of _time_ it takes for some data to get from one point in the network to another.
  - It is determined by real physical laws, such as the distance traveled and the speed of the signal traveling (i.e. speed of light, sound, or electricity).
- **Bandwidth** refers to the _amount of data_ that can be sent along the physical structure of the network for a particular unit of time (usually a second).
  - It is also determined by real physical laws, such as the capacity of the medium down which data is being transported.
  - Because this is almost never a constant amount, we consider the bandwidth of a connection to be whatever value is the lowest value over the entire connection.

### The Elements of Latency

Latency has four main aspects that occur during each network "hop" that data takes during its overall journey through the network:

- **Propagation delay** - the amount of time it takes for the first bit to travel from sender to receiver
- **Transmission delay** - amount of time it takes to transmit data into one of the "nodes" or "links" in the overall network.
- **Processing delay** - amount of time it takes to process the data within one of the "nodes" or "links" in the overall network.
- **Queuing delay** - amount of time the packet waits in the "buffer" if there is too much data to be processed at one time at the network device (i.e. "node" or "link") the data is being sent to.

Overall latency is the sum of all these elements for each network hop, plus any of the following delays:

- **Last-mile latency** - a "slowing down" that takes place at the network edge, as smaller and more frequent hops take place as data moves lower in the network hierarchy
- **RTT** - **Round Trip Time** - the time it takes for a single message to get from sender to receiver and then back again.
  - This can refer to exchanges between 'nodes' on a P2P network, or exchanges between client and server.
  - Latency overhead associated with additional round trips is often a trade off when dealing with the implementation of network reliability in TCP.
