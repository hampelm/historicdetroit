[![Build Status](https://travis-ci.org/hampelm/historicdetroit.svg?branch=master)](https://travis-ci.org/hampelm/historicdetroit) [![Maintainability](https://api.codeclimate.com/v1/badges/a789f2b9763000c2f20b/maintainability)](https://codeclimate.com/github/hampelm/historicdetroit/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/hampelm/historicdetroit/badge.svg?branch=master)](https://coveralls.io/github/hampelm/historicdetroit?branch=master)

# Historic Detroit Rails App

We're rebuilding historicdetroit.org with Rails

## Install

```
bundle install
```

## Configure

Optional Skylight performance monitoring: set the `SKYLIGHT_AUTHENTICATION`
environment variable.

## Develop

```
rails s
```

### Test

```
rake
```

## Deploy

You'll need to make sure the Google Cloud Storage key in is set in `storage.yml`

### Import order

```
rake import:architects[""]
```

- Architects
- Buildings (uses Architects)
- Galleries (uses Buildings)

### Notes

```
rails g migration CreateJoinTable table1 table2
```

## Use

### Admin

`/admin` for Rails Admin
