require 'json'
require 'fsbc_entry'

class MakeGraph
  def initialize(org, html)
    @org = org
    @html = html
  end

  def run
    out "parsing #{@org}"
    @entries = Parser.new(File.read(@org)).entries
    out "found #{@entries.size} entries"

    File.open(@html, 'w') do |f|
      f.write render_template
    end
    out "Generated #{@html}"
  end

  def render_template
    num_sets = 4
    opa_base = 1
    data = 1.upto(num_sets).map do |i|
      { x: @entries.map(&:formatted_time),
        y: @entries.map { |e| e.reps_in_set(i) },
        hovertext: @entries.map(&:comment),
        marker: {
          color: @entries.map { |e| e.color_in_set(i, num_sets) },
          opacity: (i + opa_base).to_f / (num_sets + opa_base),
        },
        name: "Set #{i}",
        type: 'bar'
      }
    end

    layout = {
      title: "FBSC",
      xaxis: {
        tickangle: -45,
      },
      showlegend: false,
      barmode: 'stack'
    }

    <<-EOHTML
<!doctype html>
<html lang="de">
  <head>
    <meta charset="UTF-8" />
    <title>Sport #{Time.now}</title>
    <script src="https://cdn.plot.ly/plotly-2.34.0.min.js" charset="utf-8"></script>
    <style>
      #fsbc {
            width: 90vw;
            height: 90vh;
      }
    </style>
  </head>
  <body>
    <div id="fsbc"></div>
    <script>
      const fsbc = document.getElementById('fsbc');
      Plotly.newPlot(fsbc, #{data.to_json}, #{layout.to_json}, {responsive: true});
    </script>
  </body>
</html>
    EOHTML
  end

  def out(message)
    $stderr.puts "#{Time.now}: #{message}"
  end
end
