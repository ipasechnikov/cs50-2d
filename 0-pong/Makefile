IMAGE_NAME := love-builder
BUILD_DIR := build

.PHONY: image build clean

image:
	docker build -t $(IMAGE_NAME) ../.

build: image
	docker run --rm \
		-v $(PWD):/game \
		$(IMAGE_NAME) \
		makelove

clean:
	rm -rf $(BUILD_DIR)
