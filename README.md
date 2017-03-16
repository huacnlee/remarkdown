Remarkdown
==========

![Build status](https://travis-ci.org/huacnlee/remarkdown.svg?branch=master)

This is extends of Markdown lib from Crystal Stdlib for Support Markdown GFM.

## Features

- `space_after_headers`
- `strikethrough`

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  remarkdown:
    github: huacnlee/remarkdown
```

## Usage

```crystal
require "remarkdown"

Remarkdown.to_html("Hello **world**")
```
