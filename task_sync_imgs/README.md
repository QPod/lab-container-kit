# Task Sync Images

This task sync docker images from source registries to target registries based on the configuration files.

```shell
docker run -it --rm -v $(pwd):/root/app -w /root/app docker.io/qpod/docker-kit
```

To sync images in batch, two config files (or combine them in one as `--config`) are needed.

The `auth.yaml` file should look like:

```yaml
docker.io:
  username: ""
  password: ""
  insecure: true
registry.cn-hangzhou.aliyuncs.com:
  username: ""
  password: ""
  insecure: true
```

The `images.yaml` file should look like:

```yaml
quay.io/qpod/docker-kit:
  - docker.io/qpod/docker-kit
  - registry.cn-hangzhou.aliyuncs.com/qpod/docker-kit
```
