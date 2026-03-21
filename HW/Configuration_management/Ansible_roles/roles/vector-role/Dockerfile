FROM alpine:latest

# Create directories (rarely changes)
RUN mkdir -p /etc/vector /var/log/vector

# Install dependencies (rarely changes)
RUN apk add --no-cache curl bash

# Install Vector (changes with version)
RUN curl --proto '=https' --tlsv1.2 -sSfL https://sh.vector.dev | bash -s -- -y --prefix /usr/local

# Run Vector (always last)
CMD ["/usr/local/bin/vector"]
