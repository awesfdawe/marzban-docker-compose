# marzban-docker-compose
[Marzban](https://github.com/Gozargah/Marzban) с готовым к использованию прокси VLESS + REALITY steal oneself с маршрутизацией российских IP через Cloudflare WARP, заглушка [jellyfin](https://jellyfin.org/)
## Предварительные требования
- [Базовые навыки работы в Linux](https://www.geeksforgeeks.org/linux-unix/linux-commands-cheat-sheet/)
- [Базовые навыки работы с docker и docker compose](https://devhints.io/docker-compose)
- [Установленные Docker и Docker Compose v2](https://docs.docker.com/engine/install/)
- Домен, указывающий на ваш сервер (без CDN)
- Порты **80**, **443** и **8443** должны быть свободны

---

## Установка

1. Склонировать этот репозиторий на сервер и перейти в папку проекта
```bash
cd ~
git clone https://github.com/awesfdawe/marzban-docker-compose.git
cd marzban-docker-compose
```

2. Сгенерировать связку ключей для REALITY. Вывод команды сохранить на заполнение .env
```bash
docker run --rm teddysun/xray:24.12.31 xray x25519
```

3. Сгенерировать short IDs для REALITY. Вывод команды сохранить на заполнение .env
```bash
for i in $(seq 1 8); do
  openssl rand -hex 8
done
```

4. Получить данные от Cloudflare WARP. Вывод команды сохранить на заполнение .env
```bash
docker run --rm --entrypoint "" virb3/wgcf:latest sh -c \
"/wgcf register --accept-tos \
&& /wgcf generate \
&& cat wgcf-profile.conf"
```

5. Обновить версию ядра Xray. Версия v25.12.1 проверена
```bash
cd xray
wget https://github.com/XTLS/Xray-core/releases/download/v25.12.1/Xray-linux-64.zip
unzip Xray-linux-64.zip
rm Xray-linux-64.zip
cd ..
```

6. Скачать geoip
```bash
cd assets
./update.sh
cd ..
```
Желательно установить [cron задачу](https://linuxhandbook.com/crontab/) для автообновления geoip. Путь до скрипта указать свой
```cron
0 5 * * * /root/marzban-docker-compose/assets/update.sh > /dev/null 2>&1
```

7. Создать .env и заполнить его по шаблону
```bash
nano .env
```
```ini
SUDO_USERNAME="username"
SUDO_PASSWORD="password"
DASHBOARD_PATH="/randomstringwithoutspecialsymbols1/" # Слеш обязателен в начале и в конце
SUBSCRIPTION_PATH="/randomstringwithoutspecialsymbols2/" # Слеш обязателен в начале и в конце
DOMAIN="example.com"

# Пункт 2
REALITY_PRIVATEKEY="mK9eTseX8FmTbx593Mk35D7qmmCUNR9awZK2HjuUnzg"
REALITY_PUBLICKEY="20b5e7n7Hu5fT8d7NSs1t59BDbQloAURjQ1ckiunYVQ"

# Пункт 3
SHORTID1="827e8f367e501139"
SHORTID2="e891404488616fb1"
SHORTID3="ff505b5862b98aa4"
SHORTID4="4e342bb092b1bd85"
SHORTID5="671e40eb30802b92"
SHORTID6="7bf9da5a32a14432"
SHORTID7="c4ccd999b55220ab"
SHORTID8="adc748ffd45a118c"

# Пункт 4
WG_PRIVATEKEY="eJtsnHx+LShdEgYhI8ATHmdp+2DHN1b1vNXsrxV1cHQ="
WG_ENDPOINT="engage.cloudflareclient.com:2408"
WG_PUBLICKEY="bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuGP51h2wPfgyo="
```

8. Отрендерить шаблоны
```bash
set -o allexport
. .env
set +o allexport
envsubst < ./settings/xray_config.template.json > ./settings/xray_config.rendered.json
envsubst < ./settings/Caddyfile.template > ./settings/Caddyfile.rendered
```

9. Запустить этот docker compose и смотреть логи на наличие проблем
```bash
docker compose up -d
docker compose logs -f
```

10. После запуска зайти на сайт на своем домене и создать аккаунт в jellyfin

11. Перейти по домен + путь до dashboard для добавления пользователей

## Дополнение
- При добавлении пользователя не забывать включать **xtls-rprx-vision** flow
- После добавления пользователя надо перезагружать ядро xray, иначе этот пользователь не сможет подключиться
- Чтобы получить конфиг clash meta надо добавить **/clash-meta** в конец ссылки на подписку 
- Рекомендую включить BBR
