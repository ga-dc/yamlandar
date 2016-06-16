# Yamlandar

![yamlandar](./yamlandar.jpg)

Generates an HTML schedule from YAML.

## CLI

```
$ gem install yamlandar
$ yamlandar
```

Starts a sinatra server and expects a `schedule.yml` file in your
current working directory.

```
$ yamlandar -c
```

Compiles the HTML and expects a `schedule.yml` file in your current
working directory. Useful for scripting.

## Local Setup

```
$ git clone https://github.com/ga-dc/yamlandar.git
$ cd yamlandar
$ bundle install
$ bin/make
```
