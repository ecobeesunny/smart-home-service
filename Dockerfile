FROM golang:1.22.2-bullseye as build

WORKDIR /app

# content need to include vendor folder so docker can build with private packages
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o smart-home cmd/smart-home/main.go

FROM gcr.io/distroless/base-debian11 AS release

WORKDIR /app

COPY --from=build /app/smart-home /app/smart-home

# Set to non root user
USER nonroot:nonroot

EXPOSE 8080
EXPOSE 9999

# Run
CMD ["./smart-home"]