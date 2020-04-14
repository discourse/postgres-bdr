IMAGE := discourse/postgres-bdr
TAG := latest

.PHONY: default
default: push
	@printf "${IMAGE}:${TAG} ready\n"

.PHONY: push
push: git-check build
	docker push ${IMAGE}:${TAG}

.PHONY: build
build:
	docker build --pull --build-arg=http_proxy="${http_proxy}" -t ${IMAGE}:${TAG} .

.PHONY: git-check
git-check:
	@if [ "${TAG}" = "latest" ]; then \
		if [ -n "$$(git status --porcelain)" ]; then \
			echo "\033[1;31mCan only build 'latest' from a clean working copy\033[0m" >&2; \
			echo "\033[1;31mFor testing purposes, provide an alternate tag, eg make TAG=bobtest\033[0m" >&2; \
			exit 1; \
		fi; \
		git push; \
	fi
