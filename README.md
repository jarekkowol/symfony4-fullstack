### 1. Pre-requisite
Depending of your Operating system, you will need to install Docker daemon and docker-compose.

### 2. Architecture
- App - php-fpm with Symfony4 framework as a PHP backend service.
- Web - Nginx as web server

### 3. Build
To create the images and launch the containers, we just have to run the following command:
```bash
$ make build
$ make up
```

And to check the status of the containers, we have the following command:
```bash
$ docker container ps
```

Your app is now running and you can access your frontend using `localhost:8050`