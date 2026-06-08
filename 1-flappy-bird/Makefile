IMAGE_NAME := love-builder

.PHONY: image build

image:
	docker build -t $(IMAGE_NAME) ../.

build: image
	docker run --rm \
		-v $(PWD):/game \
		$(IMAGE_NAME) \
		makelove
