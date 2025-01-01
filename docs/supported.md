# What is SSH (Secure Shell)?
Secure Shell, often referred to as SSH or Secure Socket Shell, is a protocol that facilitates secure connections to remote computers or servers through a text-based interface.

Once an SSH connection is successfully established, a shell session begins, allowing users to interact with and control the remote server by executing commands from their local computer.

Widely used by system and network administrators, SSH is an essential tool for managing remote servers and machines. Its robust security features make it indispensable for anyone needing to remotely access and manage computers with a high degree of security.


## How does SSH work?
Both the client and server actively contribute to establishing a secure SSH communication channel. The process involves several key components and steps:

Client-Side Component:
The client-side component is a software application or program used to connect to a remote machine. It initiates the connection by sending the remote host's information to the server. Once the provided credentials are verified, the program establishes an encrypted connection, allowing secure communication.

Server-Side Component:
On the server side, an SSH daemon continuously listens on a designated TCP/IP port (typically port 22, the default for SSH) for incoming connection requests. When a client attempts to connect via this port, the SSH daemon responds by sharing the supported software and protocol versions. The default protocol version for SSH communication is version 2, as version 1 has been deprecated due to security vulnerabilities.

Authentication:
During the connection process, the client provides authentication credentials to the server. This can include methods like username/password combinations, cryptographic key pairs, or multi-factor authentication. Once the server verifies the credentials, it establishes a new encrypted session for secure communication.


!!! Tip
    Default ssh port : 22



### how to use putty to SSH on windows

PuTTY is a popular free and open-source terminal emulator that supports various network protocols, such as SSH (Secure Shell), Telnet, and Rlogin. It is widely used for remotely accessing servers and systems over a network. PuTTY allows users to interact with remote machines via a command-line interface, making it a valuable tool for system administrators, developers, and IT professionals.

!!! Tip
    Download a [putty application](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html){:download}


1) Connect to 127.0.0.1:22 
 
![poster](img/putty1.png)


2) Enter the username and password (default : admin / admin) 

![poster](img/putty2.png)



3) Enter the commands 

![poster](img/putty3.png)



# What is MQTT (Message Queuing Telemetry Transport)
MQTT is a lightweight messaging protocol primarily designed for efficient message transmission between IoT (Internet of Things) devices. This protocol is optimized to work in environments with limited network bandwidth, offering fast and reliable communication. MQTT is based on a publish/subscribe model, simplifying interactions between clients that send and receive data.

 
## How does MQTT work?


MQTT (Message Queuing Telemetry Transport) operates on the publish/subscribe model, where devices (clients) communicate through a central server known as the broker. Here's how it works in a simplified flow:

### MQTT Operation Flow

1.Clients

Clients can either publish messages to a specific topic or subscribe to topics to receive messages. A client can act as both a publisher and a subscriber.

2.Broker

The broker is the central server that manages message distribution. It receives messages from publishers and forwards them to subscribers who are subscribed to the relevant topic(s).

3.Topics

A topic is a string that represents the channel or category of a message. Clients subscribe to topics to receive messages. Topics can be hierarchical, allowing complex topic structures (e.g., home/livingroom/temperature).
Steps in MQTT Communication:

4.Connection

A client connects to the MQTT broker using a specific IP address and port. It may provide credentials for authentication.

### Subscription

A client subscribes to one or more topics of interest. This tells the broker which messages it wants to receive.

1.Publishing

Another client can publish a message to a topic. The broker will check which clients are subscribed to that topic.
Message Distribution:

The broker sends the message to all clients subscribed to the topic. The message is delivered according to the Quality of Service (QoS) level defined by the publisher and subscriber.

2.QoS Levels

QoS 0: Message is delivered at most once (no guarantee of delivery).
QoS 1: Message is delivered at least once (guaranteed delivery but possible duplication).
QoS 2: Message is delivered exactly once (guaranteed delivery without duplication).

3.Disconnect

After the communication, a client can disconnect from the broker, but the broker retains subscriptions for clients that maintain a persistent session.

4.Key Concepts

- Publish : A client sends a message to a topic (e.g., sending sensor data).
- Subscribe : A client listens to a specific topic to receive messagees.
- Broker : A server that handles the routing and delivery of messages.
- Topics : Categories or channels that messages are published to and subscribed from.

### How to use Mosquitto on windows

`path : ..\sample\app\mqtt\room1.pub`

`url  : app\mqtt\room1.pub`

``` 
room1 RoomTemp1 \\ [group-name] [message-name] 
room2 RoomTemp1
``` 



[mosquitto](https://mosquitto.org/download/){:download} 

![poster](img/mosquitto_login.png)

![poster](img/mosquitto.png)
