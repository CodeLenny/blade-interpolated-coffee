# Interpolated [CoffeeScript][] Filter for [Blade][]

Why have one layer of variable insertion, when you could have twice the complexity?

The regular `:coffeescript` filter for Blade keeps `#{}` as the standard CoffeeScript interpolation, but doesn't let you
use Blade variables in CoffeeScript snippets.  `blade-interpolated-coffee` allows you to use `${}` (or another symbol)
to insert Blade variables into the block code.

```blade
- var url = "/";
:interpolatedcoffee
  i = 0
  console.log "i for '${url}' is #{i}"
```

Could produce the following HTML:

```html
<script type="text/javascript">
  var i = 0;
  console.log("i for '/' is "+i);
</script>
```

## Installation

```sh
npm install @codelenny/blade-interpolated-coffee
```

```coffee
interpolatedCoffeeScript = require "@codelenny/blade-interpolated-coffee"
blade = require "blade"

blade.compile src,
    filters:
      interpolatedcoffee: interpolatedCoffeeScript
  , (err, html) -> # ...
```

## Customization

### Raw Filter

Don't want to have `<script type="text/javascript">` automatically inserted?
A raw mode is built in to the filter.

```coffee
interpolatedCoffeeScript = require "@codelenny/blade-interpolated-coffee"

opts =
  filters:
    "$cs": interpolatedCoffeeScript
    "$cs.raw": interpolatedCoffeeScript.raw
```

```blade
script#main(data-i="0")
  :$cs.raw
    # ...
```

### Change `${}`

blade-interpolated-coffee ships with `${}` as the default interpolation marker.  However, you can use another marker:
  
```coffee
interpolatedCoffeeScript = require "@codelenny/blade-interpolated-coffee"
myFilter = interpolatedCoffeeScript.custom /@\{/g
opts =
  filters:
    "$cs": myFilter
    "$cs.raw": myFilter.raw
```

`custom` takes two arguments: `needle` and `haystack`.

When blade-interpolated-coffee is given the contents of the text block, it passes the block to CoffeeScript
(which interpolates uses of `#{}` with variables in the runtime scope).


Then all instances of `needle` are replaced with `haystack`, and the resulting string is passed to Blade.
Blade will interpolate all inserted cases of `#{}` with variables in Blade's scope.

The marker could easily be changed by searching for `/@\{/g` as the needle, or more complex patterns can be created
using both the needle and haystack, such as making sure that only single variables are interpolated.

```coffeescript
complexFilter = interpolatedCoffeeScript.custom /\$\{([a-zA-Z_\s]+)\}/g, "\#{$1}"
```

[CoffeeScript]: http://coffeescript.org/
[Blade]: https://github.com/bminer/node-blade
