chai = require "chai"
should = chai.should()

interpolatedCoffeeScript = require "../interpolated-coffeescript"

input = '''
x = 1
y = "x is #{x}"
'''

output = """
(function() {
  var x, y;

  x = 1;

  y = "x is " + x;

}).call(this);

"""

standard =
  name: "standard mode"
  interpolate: interpolatedCoffeeScript
  transform: (raw) ->
    """
      <script type="text/javascript">
        #{raw}
      </script>
    """

raw =
  name: "raw mode"
  interpolate: interpolatedCoffeeScript.raw
  transform: (a) -> a

describe "default filter", ->

  for mode in [standard, raw]
    do (mode) ->
      describe mode.name, ->

        it "should interpolate '\#{test}' with CoffeeScript", ->
          src = mode.interpolate '''
            x = 1
            y = "x is #{x}"
          '''
          src.should.equal mode.transform """
            (function() {
              var x, y;

              x = 1;

              y = "x is " + x;

            }).call(this);

          """

        it "should transform '${test}' for Blade", ->
          src = mode.interpolate '''
            url = "${url}"
          '''
          src.should.equal mode.transform '''
            (function() {
              var url;

              url = "#{url}";

            }).call(this);

          '''
