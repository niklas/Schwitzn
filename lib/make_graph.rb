class MakeGraph
  def initialize(org, html)
    @org = org
    @html = html
  end

  def run
    build_graphs
    @title = "Sport #{Time.now}"
    @livereload = if @html =~ /dev.html/
                    %Q[<script src="http://localhost:51754/livereload.js"></script>]
                  end
    File.open(@html, 'w') do |f|
      f.write render_template
    end
    out "Generated #{@html}"
  end

  def find_entries
    out "parsing #{@org}"
    all_entries = Parser.new(File.read(@org)).entries
    out "found #{all_entries.size} entries"
    entries = all_entries
                .grep_v(SkipEntry)
                .grep_v(AltEntry)
                .grep_v(NamedWorkout)
    out "considering #{entries.size} entries"
    entries
  end

  def build_graphs
    @entries = find_entries
    @by_name = @entries.group_by(&:name)
    out "found exercises: #{@by_name.keys.join(', ')}"
    opa_base = 1
    @graphs = @by_name.map do |name, entries|
      num_sets = entries.map { |e| e.reps.to_a.length }.max
      newest = (entries.map(&:time).max || Time.now) + 1.day
      oldest = (entries.map(&:time).min || Time.now) - 1.day
      oldest_seen = [newest - 300.days, oldest].max
      full_range = [oldest, newest].map { |t| HasTime.format(t) }
      default_range = [oldest_seen, newest].map { |t| HasTime.format(t) }

      data = 1.upto(num_sets).map do |set|
        { x: entries.map(&:formatted_time),
          y: entries.map { |e| e.size_of_set(set) },
          hovertext: entries.map(&:comment),
          marker: {
            color: entries.map { |e| e.color_in_set(set, num_sets) },
            opacity: (set + opa_base).to_f / (num_sets + opa_base),
          },
          name: "Set #{set}",
          width: 2.days.in_seconds * 1000,
          type: 'bar',
        }
      end

      {
        id: name.gsub(/\W/, '_'),
        name: name,
        data: data,
        layout:  {
          title: name,
          paper_bgcolor: Color.transparent,
          plot_bgcolor: Color.transparent,
          dragmode: 'pan',
          font: {
            color: Color.text,
          },
          xaxis: {
            range: default_range,
            minallowed: full_range.first,
            maxallowed: full_range.last,
            type: 'date',
            tickangle: -45,
            rangeslider: { range: full_range },
            rangeselector: {
              bgcolor: Color.button,
              font: {
                color: Color.links,
              },
              buttons: [
                {step: 'all'},
                {
                  count: 24,
                  label: '2y',
                  step: 'month',
                  stepmode: 'backward'
                },
                {
                  count: 12,
                  label: '1y',
                  step: 'month',
                  stepmode: 'backward'
                },
                {
                  count: 6,
                  label: '6m',
                  step: 'month',
                  stepmode: 'backward'
                },
              ]
            },
          },
          yaxis: {
            fixedrange: true,
            gridcolor: Color.grid,
          },
          showlegend: false,
          barmode: 'stack'
        },
        settings: {
          responsive: true,
        }
      }
    end
  end

  def render_template
    ERB.new(template).result(binding)
  end

  def out(message)
    $stderr.puts "#{Time.now}: #{message}"
  end

  def template
    <<-EOHTML
<!doctype html>
<html lang="de">
  <head>
    <meta charset="UTF-8" />
    <title><%= @title %></title>
    <script src="https://cdn.plot.ly/plotly-2.34.0.min.js" charset="utf-8"></script>
    <%= @livereload %>
    <style>
      :root {
        --bg: <%= Color.background %>;
        --text: <%= Color.text %>;
        --links: <%= Color.links %>;
      }
      body {
        background-color: var(--bg);
        color: var(--text);
      }
      body a {
        color: var(--links);
      }
      .plot {
            width: 95vw;
            height: 90vh;
      }
      aside#navigation {
        position: fixed;
        font-size: 120%;
        right: 0;
        top: 0;
        background-color: #000000DD;
        padding: 1rem 2rem;
        z-index: 1;
        border-bottom-color: white;
        border-left-color: white;
        border-width: 0 0 1px 1px;
        border-bottom-left-radius: 0.5em;
        border-style: solid;
      }
      aside#navigation a {
        display: block;
      }
      body:has(.plot:hover) aside#navigation {
        display: none;
      }
    </style>
  </head>
  <body>
    <aside id="navigation"><nav>
      <% @graphs.each do |graph|  %>
        <a href="#<%= graph[:id] %>"><%= graph[:name] %></a>
      <% end %>
    </nav></aside>
    <% @graphs.each do |graph|  %>
      <div id="<%= graph[:id] %>" class="plot"></div>
      <script>
        Plotly.newPlot(<%= graph[:id] %>, <%= graph[:data].to_json %>, <%= graph[:layout].to_json %>, <%= graph[:settings].to_json %>);
      </script>
    <% end %>
  </body>
</html>
    EOHTML
  end
end
