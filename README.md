# docker-electrum-daemon

**Electrum client 4.0.9 running as a daemon in docker container with JSON-RPC enabled.**

[Electrum client](https://electrum.org/) is light bitcoin wallet software operates through supernodes (Electrum server instances actually).

Don't confuse with [Electrum server](https://github.com/spesmilo/electrum-server) that use bitcoind and full blockchain data.

Star this project on Docker Hub :star2: https://hub.docker.com/r/osminogin/electrum-daemon/

### Ports

* `7000` - JSON-RPC port.

### Volumes

* `/data` - user data folder (on host it usually has a path ``/home/user/.electrum``).


## Getting started

#### docker

Running with Docker:

```bash
chown -R 1000:1000 ./data
docker run --rm --name electrum \
    --env TESTNET=false \
    --publish 127.0.0.1:7000:7000 \
    --volume /srv/electrum:/data \
    internetportal/docker-electrum-daemon
```
```bash
docker exec -it electrum-daemon electrum create
docker exec -it electrum-daemon electrum load_wallet
docker exec -it electrum-daemon electrum getinfo
docker exec -it electrum-daemon electrum getbalance
{
    "auto_connect": true,
    "blockchain_height": 660633,
    "connected": true,
    "default_wallet": "/home/electrum/.electrum/wallets/default_wallet",
    "fee_per_kb": 59261,
    "path": "/home/electrum/.electrum",
    "server": "blockstream.info",
    "server_height": 660633,
    "spv_nodes": 10,
    "version": "4.0.6"
}
```


#### docker-compose

[docker-compose.yml](https://github.com/vencis/docker-electrum-daemon/blob/master/docker-compose.yml) to see minimal working setup. When running in production, you can use this as a guide.

```bash
docker-compose up
docker-compose exec electrum electrum getinfo
docker-compose exec electrum electrum create
docker-compose exec electrum electrum load_wallet
docker-compose exec electrum electrum getbalance
curl --data-binary '{"id":"1","method":"listaddresses"}' http://electrum:electrumz@localhost:7000
```

:exclamation:**Warning**:exclamation:

Always link electrum daemon to containers or bind to localhost directly and not expose 7000 port for security reasons.

## API

* [Electrum protocol specs](http://docs.electrum.org/en/latest/protocol.html)
* [API related sources](https://github.com/spesmilo/electrum/blob/master/lib/commands.py)

## License

See [LICENSE](https://github.com/vencis/docker-electrum-daemon/blob/master/LICENSE)

