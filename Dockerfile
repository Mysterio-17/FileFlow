# Multi-stage build for FileFlow P2P File Sharing Application

# Stage 1: Build stage
FROM golang:1.22.3-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build server binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/bin/server ./server/cmd/server.go

# Build client binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/bin/client ./client/cmd/client.go

# Stage 2: Runtime stage
FROM alpine:latest

# Install ca-certificates for HTTPS
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy binaries from builder
COPY --from=builder /app/bin/server .
COPY --from=builder /app/bin/client .

# Create directory for file storage
RUN mkdir -p /root/shared

# Expose default port
EXPOSE 8080

# Default command (can be overridden)
CMD ["./server", "--port", "8080"]
