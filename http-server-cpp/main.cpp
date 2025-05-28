#include <cstdio>
#include <iostream>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT 8080

int main() {
  int server_fd;
  struct sockaddr_in address;
  int addrlen = sizeof(address);

  server_fd = socket(AF_INET, SOCK_STREAM, 0);
  if (server_fd == 0) {
    perror("Socket failed");
    return -1;
  }
  address.sin_family = AF_INET;
  address.sin_addr.s_addr = INADDR_ANY;
  address.sin_port = htons(PORT);

  // Bind the socket
  if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
    perror("Bind Failed");
    return -1;
  }

  // Listen for incoming connection
  if (listen(server_fd, 3) < 0) {
    perror("Listen failed");
    return -1;
  }
  std::cout << "Server is listening on port" << PORT << std::endl;
  return 0;
}
