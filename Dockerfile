# Use the official Golang image as a base image
FROM golang:1.22 as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code from the current directory to the Working Directory inside the container
COPY . .

# Build the GoVWA executable
RUN go build -o govwa .

# Start a new stage from scratch
FROM alpine:latest  

# Set necessary environment variables
ENV PORT=80

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/govwa /app/govwa

# Expose port 80 to the outside world
EXPOSE 80

# Command to run the executable
CMD ["/app/govwa"]
