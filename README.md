# marzban-docker-compose
docker run --rm teddysun/xray:24.12.31 xray x25519

for i in $(seq 1 8); do
  openssl rand -hex 8
done

bash
set -o allexport
. .env
set +o allexport
envsubst < ./settings/xray_config.template.json > ./settings/xray_config.rendered.json
exit

docker run --rm --entrypoint "" virb3/wgcf:latest sh -c \
"/wgcf register --accept-tos \
&& /wgcf generate \
&& cat wgcf-profile.conf"

cd xray
wget https://github.com/XTLS/Xray-core/releases/download/v25.9.11/Xray-linux-64.zip
unzip Xray-linux-64.zip
rm Xray-linux-64.zip