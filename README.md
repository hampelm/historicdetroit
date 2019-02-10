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

### Regenerate thumbnails

```
Photo.all.each { |i|   i.photo.recreate_versions!(:sidebar_slim) if i.photo?  }
Photo.all.each { |i|   i.photo.recreate_versions! if i.phto?  }
```

### Maps

https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/geojson(%7B%22type%22%3A%22Point%22%2C%22coordinates%22%3A%5B-73.99%2C40.7%5D%7D)/-73.99,40.70,12/500x300?access_token=