# 🐳 Running the Project with Docker

This project uses Docker to streamline the development environment. You can spin up all required services using Docker Compose.

## 📦 Prerequisites

Make sure you have the following installed on your machine:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## 🚀 Starting the Project

To start the development environment, run the following command from the root of the project:

```bash
docker compose -f docker-compose.dev.yml up --build
```

This will:

- Build the images (if not already built)
- Start all containers defined in `docker-compose.dev.yml`

> 💡 Tip: To run the containers in detached mode (in the background), use:
>
> ```bash
> docker compose -f docker-compose.dev.yml up -d
> ```

## 🛑 Stopping the Project

To stop and remove all containers, run:

```bash
docker compose -f docker-compose.dev.yml down
```

## 🧪 Useful Tips

- To view logs:

  ```bash
  docker compose -f docker-compose.dev.yml logs -f
  ```

- To access a container's shell:

  ```bash
  docker exec -it app bash
  ```