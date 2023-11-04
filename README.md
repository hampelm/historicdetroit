[![Build Status](https://travis-ci.org/hampelm/historicdetroit.svg?branch=master)](https://travis-ci.org/hampelm/historicdetroit) [![Maintainability](https://api.codeclimate.com/v1/badges/a789f2b9763000c2f20b/maintainability)](https://codeclimate.com/github/hampelm/historicdetroit/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/hampelm/historicdetroit/badge.svg?branch=master)](https://coveralls.io/github/hampelm/historicdetroit?branch=master)

# Historic Detroit Rails App

We're rebuilding historicdetroit.org with Rails

## Install

```
bundle install
```

### If having trouble with PG:

```
bundle config build.pg --with-pg-config=/usr/local/bin/pg_config
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

```
Postcard.all.each { |i|  i.front.recreate_versions!(:sidebar_slim) if i.front?; i.back.recreate_versions!(:sidebar_slim) if i.back?  }
```

