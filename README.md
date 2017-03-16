Remarkdown
==========

This is extends of Markdown lib from Crystal Stdlib for Support Markdown GFM.

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
