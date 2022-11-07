#base go image
FROM golang:1.18-alpine as builder
#creating an folder
RUN mkdir /app
#copying all the files to app folder
COPY . /app
#set workding directory 
WORKDIR /app

#running the go app
#disabling C library  go and giving alias as broker app
RUN CGO_ENABLED=0 go build -o brokerApp ./cmd/api
#giving executable permission to folder
RUN chmod +x /app/brokerApp

# build a tiny docker image
FROM alpine:latest

RUN mkdir /app 
#copying only the executable files from bigger image to this smaller image
COPY --from=builder /app/brokerApp /app

CMD ["/app/brokerApp"]