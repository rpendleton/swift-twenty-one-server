FROM swift:4.1
WORKDIR /app

COPY Package.resolved Package.swift ./
RUN swift package update
COPY . ./

RUN swift build
