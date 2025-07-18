class Parser
  def initialize(org)
    @org = org
  end

  def entries
    @entries = @org.lines.map(&method(:parse_line)).reject(&:nil?)
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
