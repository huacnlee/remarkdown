Remarkdown
==========

[![Build status](https://travis-ci.org/huacnlee/remarkdown.svg?branch=master)](https://travis-ci.org/huacnlee/remarkdown)

This is extends of Markdown lib from Crystal Stdlib for Support Markdown GFM.

## Features

- Built on Crystal stdlib [Markdown](https://crystal-lang.org/api/0.21.1/Markdown.html) to implement like Markdown GFM.
- **space_after_headers** - `# Hello` not `#Hello`
- Add `id` attribute for Heading `<h1 id="hello-world">Hello world</h1>`.
- **strikethrough** : `~~Foo~~` to `<del>Foo</del>`

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
