interpolatedCoffeeScript = (needle, haystack) ->
  needle ?= /\$\{/g
  haystack ?= '#{'
  raw = (src) -> require("coffee-script").compile(src).replace needle, haystack
  filter = (src) ->
    """
    <script type="text/javascript">
      #{raw src}
    </script>
    """
  filter.raw = raw
  filter.custom = interpolatedCoffeeScript
  filter

module.exports = interpolatedCoffeeScript()
