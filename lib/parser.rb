class Parser
  require 'parser/org_parser'
  require 'parser/entry_transform'
  class ParseFailed < StandardError
  end

  def initialize(org)
    @org = org
  end

  def entries
    @entries ||= ast
  end

  def ast
    @ast ||= begin
               parser = Parser::OrgParser.new
               transform = Parser::EntryTransform.new
               transform.apply(
                 parser.parse(@org)
               )
             end
  rescue Parslet::ParseFailed => failure
    cause = failure.parse_failure_cause
    root = cause
    root = root.children.first until root.children.empty?
    lineno, column = root.source.line_and_column(root.pos)
    line = root.pos.instance_variable_get('@string').lines[lineno - 1]
    indicator = 'at |' + (' ' * (column + 1)) + 'V'
    at = "in | #{line}"
    raise ParseFailed, "\n#{indicator}\n#{at}\n#{failure.parse_failure_cause.ascii_tree}"
  end

  private
  def parse_line(str)
    return unless str =~ /^\s*-\s*</

    case str
    when %r~<([^>]*)> (FBSC1) \(([^)]+)\) ([0-9-]+)\s?([^)]+)?~
      FSBCEntry.new(*Regexp.last_match.captures)
    else
      out "??? #{str}"
      nil
    end
  end
end
