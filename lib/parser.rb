class Parser
  require 'parser/org_parser'
  require 'parser/entry_transform'

  def initialize(org)
    @org = org
  end

  def entries
    @entries ||= ast.eval
  end

  def ast
    @ast ||= begin
               parser = Parser::OrgParser.new
               transform = Parser::EntryTransform.new
               transform.apply(
                 parser.parse(@org)
               )
             end
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
