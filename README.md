# Haskell Container Deployment on Heroku

More complicated (unorganized) version is here: https://github.com/hi-ogawa/yesod-experiment

## Tools on local

```
$ ghc --version
The Glorious Glasgow Haskell Compilation System, version 7.10.2

$ cabal --version
cabal-install version 1.22.6.0
using version 1.22.4.0 of the Cabal library

$ docker -v
Docker version 1.11.1, build 5604cbe

$ docker-compose -v
docker-compose version 1.7.0, build 0d7bf73

$ heroku version
heroku-toolbelt/3.43.5 (x86_64-darwin10.8.0) ruby/1.9.3
heroku-cli/5.2.24-4b7e305 (darwin-amd64) go1.6.2
=== Installed Plugins
heroku-container-registry@4.0.0
```

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
$ heroku addons:create heroku-redis -a haskell-free-deploy
```

Continuous Update:

```
$ docker-compose run --rm builder  # generate tarball of static linked executable
$ docker-compose build distributor # extract executable inside of container and set as CMD
$ docker push registry.heroku.com/haskell-free-deploy/web # image is only 182.7 MB
$ heroku open -a haskell-free-deploy
```
