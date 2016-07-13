# Haskell Container Deployment on Heroku

More complicated (unorganized) version is here: https://github.com/hi-ogawa/yesod-experiment

## Development on Cabal Sandbox

```
$ cabal sandbox init
$ cabal repl
```

## Deployment

First Time Setup:

```
$ heroku plugins:install heroku-container-registry
$ heroku login
$ docker login --email=<heroku account email> --username=<heroku account email> --password=$(heroku auth:token) registry.heroku.com
$ heroku apps:create haskell-free-deploy
```

Continuous Update:

```
$ docker-compose run --rm builder  # generate tarball of static linked executable
$ docker-compose build distributor # extract executable inside of container and set as CMD
$ docker push registry.heroku.com/haskell-free-deploy/web
$ heroku open -a haskell-free-deploy
```
