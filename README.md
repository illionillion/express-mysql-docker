# 環境構築

1. `.env`ファイルを作成し必要な環境変数を設定

```env
MYSQL_USER=root
MYSQL_PORT=3306
MYSQL_PASSWORD=password
MYSQL_DATABASE=my_db
EXPRESS_PORT=8080
ADMIN_PORT=9090
```

2. 必要なライブラリをインストール

```bash
docker compose run --rm app npm i
```

3. コンテナの起動

```bash
docker compose up -d
```

4. コンテナの終了

```bash
docker compose down
```

# その他操作

- コンテナ一覧表示

```bash
docker ps
```

- コンテナのログ表示

```bash
docker logs -f コンテナ名
```

- コンテナの中に入る

```bash
docker exec -it コンテナ名 bash
```