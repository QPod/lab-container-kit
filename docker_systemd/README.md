# systemd 

## Debug

```bash
docker build -t ubuntu-systemd -f ./systemd.Dockerfile .

docker rm -f ubuntu-systemd

docker run -d \
    --name=ubuntu-systemd \
    --hostname=ubuntu-systemd \
    --cgroupns=host \
    --tmpfs /run \
    --tmpfs /run/lock \
    -v /sys/fs/cgroup:/sys/fs/cgroup \
    ubuntu-systemd
```
