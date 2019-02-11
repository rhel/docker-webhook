## Running webhook in Docker

The image provides the ability to run docker commands inside container in behalf of host docker daemon.

```shell
docker run \
    --name webhook \
    --port 9000:9000 \
    --volume /run/docker.sock:/run/docker.sock \
    --volume /path/to/webhook:/etc/webhook \
    --detach \
    pearbox/webhook \
    webhook -verbose -hooks=/etc/webhook/hooks.json -hotreload
```