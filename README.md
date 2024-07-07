
# linux-distributions-practice

Dockerを使用してUbuntuとCentOSの仮想環境を構築するには、それぞれのDockerイメージを使用してコンテナを作成します。以下の手順に従ってください。

### 1. Dockerをインストールする

まず、Dockerがシステムにインストールされていることを確認します。インストールされていない場合は、[Dockerの公式サイト](https://www.docker.com/products/docker-desktop)からインストールしてください。

### 2. Dockerfileを作成する

それぞれの環境に対してDockerfileを作成します。

#### Ubuntuコンテナ用のDockerfile

`Dockerfile.ubuntu`という名前のファイルを作成し、以下の内容を追加します：

```Dockerfile
# Dockerfile.ubuntu
FROM ubuntu:latest

# 必要に応じてパッケージをインストール
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    git \
    && rm -rf /var/lib/apt/lists/*

# コンテナが起動時に実行するコマンド
CMD ["bash"]
```

#### CentOSコンテナ用のDockerfile

`Dockerfile.centos`という名前のファイルを作成し、以下の内容を追加します：

```Dockerfile
# Dockerfile.centos-stream
FROM centos:7

# 必要に応じてパッケージをインストール
RUN yum -y update && yum install -y \
  curl \
  vim \
  git \
  && yum clean all

# コンテナが起動時に実行するコマンド
CMD ["bash"]
```

### 3. Dockerイメージをビルドする

ターミナルを開き、Dockerfileがあるディレクトリに移動します。そこで以下のコマンドを実行してイメージをビルドします。

#### Ubuntuイメージをビルド

```sh
docker build -f Dockerfile.ubuntu -t my-ubuntu .
```

#### CentOSイメージをビルド

```sh
docker build -f Dockerfile.centos -t my-centos .
```

### 4. コンテナを起動する

それぞれのイメージからコンテナを起動します。

#### Ubuntuコンテナをイメージから起動

```sh
docker run -it --name my-ubuntu-container my-ubuntu
```

#### CentOSコンテナをイメージから起動

```sh
docker run -it --name my-centos-container my-centos
```

### 5. コンテナにアクセスする

すでに起動しているコンテナにアクセスするには、以下のコマンドを使用します。

#### Ubuntuコンテナにアクセス

```sh
docker exec -it my-ubuntu-container bash
```

#### CentOSコンテナにアクセス

```sh
docker exec -it my-centos-container bash
```

## docker compose コマンドで起動したコンテナにログイン

コンテナにログインするためには、`docker compose exec` コマンドを使用します。以下に、それぞれのコンテナにログインするためのコマンドを示します。

### Ubuntu コンテナにログイン

```bash
docker compose exec my-ubuntu bash
```

### CentOS コンテナにログイン

```bash
docker compose exec my-centos bash
```

これらのコマンドを実行すると、それぞれのコンテナのシェルにアクセスすることができます。コンテナ名は `docker-compose.yml` ファイルで指定した `container_name` に基づいています。
