docker run --gpus all --mount type=bind,source="$(pwd)",target=/workspace mastering_urlb:v1 "$@"