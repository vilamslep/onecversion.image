FROM golang:1.18

COPY ./app.go /go/src/

RUN cd /go/src/ && go mod init app && go mod tidy && go build -o /go/bin/app app.go

ENTRYPOINT [ "/go/bin/app" ]  

