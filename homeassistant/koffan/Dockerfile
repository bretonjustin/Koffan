# Build stage
ARG BUILD_FROM
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Install build dependencies for SQLite and git
RUN apk add --no-cache gcc musl-dev git

# Clone the repository
ARG BUILD_VERSION=main
RUN git clone --depth 1 --branch ${BUILD_VERSION} https://github.com/PanSalut/Koffan.git .

# Download dependencies
RUN go mod download

# Read version and build with ldflags
RUN VERSION=$(cat VERSION | tr -d '\n') && \
    CGO_ENABLED=1 go build -ldflags "-X shopping-list/handlers.AppVersion=$VERSION" -o shopping-list .

# Production stage
FROM $BUILD_FROM

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache ca-certificates tzdata libc6-compat

# Copy binary from builder
COPY --from=builder /app/shopping-list .

# Copy templates and static files
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/static ./static

# Copy run script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Set environment variables
ENV APP_ENV=production
ENV PORT=3000

CMD ["/run.sh"]
