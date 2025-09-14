# marzban-docker-compose
# Получить Public и Private ключи для xray
docker run --rm teddysun/xray:24.12.31 xray x25519

# Сгенерировать short id
for i in $(seq 1 8); do
  openssl rand -hex 8
done

# Зарендерить темплейты
set -o allexport
. .env
set +o allexport
envsubst < ./settings/xray_config.template.json > ./settings/xray_config.rendered.json
envsubst < ./settings/Caddyfile.template > ./settings/Caddyfile.rendered

# Получить данные от warp cloudflare
docker run --rm --entrypoint "" virb3/wgcf:latest sh -c \
"/wgcf register --accept-tos \
&& /wgcf generate \
&& cat wgcf-profile.conf"

# Скачать новую версию xray core
cd xray
wget https://github.com/XTLS/Xray-core/releases/download/v25.9.11/Xray-linux-64.zip
unzip Xray-linux-64.zip
rm Xray-linux-64.zip

# Скачать новый geoip
cd assets
wget https://cdn.jsdelivr.net/gh/Loyalsoldier/geoip@release/geoip.dat