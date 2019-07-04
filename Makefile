.PHONY: help
.DEFAULT_GOAL := help

help:
	@echo "                                      __   __  __"
	@echo "                                      \ \ / / / /"
	@echo "                                       \ V / / / "
	@echo "                                        \_/  \/  "
	@echo ""
	@echo "                                      V E C T O R"
	@echo ""
	@echo "---------------------------------------------------------------------------------------"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

bench: ## Run internal benchmarks
	@cargo bench --all

build: ## Build the project
	@cargo build

check: ## Check all code and formatting
	@cargo check --all --all-features --all-targets
	@cargo fmt -- --check
	@bundle install --gemfile=scripts/generate-docs/Gemfile
	@scripts/check-docs.sh

generate-docs: ## Generate docs from the /.metadata.toml file
	@bundle install --gemfile=scripts/generate-docs/Gemfile
	@scripts/generate-docs.sh

fmt: ## Format code
	@cargo fmt

run: ## Starts Vector in development mode
	@cargo run

signoff: ## Signsoff all previous commits since branch creation
	@scripts/signoff.sh

test: ## Spins up Docker resources and runs _every_ test
	@docker-compose up -d
	@cargo test --all --features docker -- --test-threads 4

##@ Releasing

build-archive: ## Build a Vector archive for a given $TARGET and $VERSION
	@scripts/build-archive.sh

build-ci-docker-images: ## Build the various Docker images used for CI
	@scripts/build-ci-docker-images.sh

package-deb: ## Create a .deb package from artifacts created via `build`
	@scripts/package-deb.sh

package-rpm: ## Create a .rpm package from artifacts created via `build`
	@scripts/package-rpm.sh

release: ## Interactive script that releases the next version (major or minor)
	@scripts/release.sh

release-deb: ## Release .deb via Package Cloud
	@scripts/release-deb.sh

release-docker: ## Release to Docker Hub
	@scripts/release-docker.sh

release-github: ## Release to Github
	@scripts/release-github.sh

release-homebrew: ## Release to timberio Homebrew tap
	@scripts/release-homebrew.sh

release-rpm: ## Release .rpm via Package Cloud
	@scripts/release-rpm.sh

release-s3: ## Release artifacts to S3
	@scripts/release-s3.sh

version: ## Get the current Vector version
	@scripts/version.sh
