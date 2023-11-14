KEYWORD=RELEASE

run: build
	docker run --rm release-by-keyword-action $(KEYWORD)

build:
	docker build --tag release-by-keyword-action .

test:
	./entrypoint.sh $(KEYWORD)