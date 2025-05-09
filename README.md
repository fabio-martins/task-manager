# 🐳 Running the Project with Docker

This project uses Docker to streamline the development environment. You can spin up all required services using Docker Compose. You can access the application at this link: [App Demo](https://task-manager-1s97.onrender.com)

## 📦 Prerequisites

Make sure you have the following installed on your machine:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## OpenAI API Configuration

To use the OpenAI API in your project, you'll need to add your API key to the `.env` file.

1. Create a `.env` file in the root of the project if it doesn't exist already.
2. Add the following line to the `.env` file with your OpenAI API key:
   ```
   OPENAI_API_KEY=YOUR_API_KEY_HERE
   ```
   Replace `YOUR_API_KEY_HERE` with your actual OpenAI API key.

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

  - To run the tests
  ```bash
  docker exec -it app bash -c "rails test"
  ```
