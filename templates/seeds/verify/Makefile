# Project verify gate (Turboplan seed — Go)
# Bootstrap copies/adapts this to the project root as Makefile.
# Prefer: make verify  (lint + test + build)
#
# Install hooks once: make install-hooks
#
# Override examples:
#   make build-all BINARY=myapp MAIN_PKG=./cmd/myapp

GO ?= go
GOLANGCI_LINT ?= golangci-lint
BINARY ?= $(notdir $(CURDIR))
DIST ?= dist
MAIN_PKG ?= ./cmd/...

# Cross-compile matrix (override as needed)
GOOS_LIST ?= linux darwin
GOARCH_LIST ?= amd64 arm64

.PHONY: help lint vet fmt test build build-all verify clean install-hooks

help:
	@echo "Targets:"
	@echo "  make verify        - lint + test + build (default gate; CI / lefthook)"
	@echo "  make lint          - golangci-lint run"
	@echo "  make vet           - go vet ./..."
	@echo "  make fmt           - go fmt ./... (+ goimports if installed)"
	@echo "  make test          - go test ./..."
	@echo "  make build         - go build ./... (host)"
	@echo "  make build-all     - cross-compile into $(DIST)/ ($(GOOS_LIST) × $(GOARCH_LIST))"
	@echo "  make clean         - remove $(DIST)/"
	@echo "  make install-hooks - lefthook install (pre-commit → make verify)"

lint:
	$(GOLANGCI_LINT) run ./...

vet:
	$(GO) vet ./...

fmt:
	$(GO) fmt ./...
	@command -v goimports >/dev/null 2>&1 && goimports -w . || true

test:
	$(GO) test ./...

build:
	$(GO) build ./...

# Multi-platform binaries (not part of `verify` — run explicitly for releases).
build-all:
	@mkdir -p "$(DIST)"
	@set -e; \
	for goos in $(GOOS_LIST); do \
	  for goarch in $(GOARCH_LIST); do \
	    out="$(DIST)/$(BINARY)-$${goos}-$${goarch}"; \
	    echo "→ $$out"; \
	    GOOS=$${goos} GOARCH=$${goarch} CGO_ENABLED=0 \
	      $(GO) build -trimpath -ldflags="-s -w" -o "$$out" $(MAIN_PKG); \
	  done; \
	done

verify: lint test build

clean:
	rm -rf "$(DIST)"

install-hooks:
	lefthook install
