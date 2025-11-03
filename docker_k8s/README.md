# k8s reload images

## k3s

```bash
docker run --rm -it -v /opt/k3s/:/tmp/ quay.io/labnow/k3s-ctk
create_cri_dockerd_unit_files
create_systemd_service_file
```

## k0s
