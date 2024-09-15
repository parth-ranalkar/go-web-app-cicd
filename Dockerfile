# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

FROM golang:1.22.5 as base 

WORKDIR /app

COPY go.mod ./

# Download all the dependencies
RUN go mod download 

# Copy the source code to the working directory
copy . .

# Build the application
RUN go build -o main .

#######################################################
# Reduce the image size using multi-stage builds
# We will use a distroless image to run the application
FROM gcr.io/distroless/base 

COPY --from=base /app/main .

COPY --from=base /app/static ./static 

EXPOSE 8080

CMD ["./main"]
