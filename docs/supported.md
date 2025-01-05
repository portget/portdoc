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


