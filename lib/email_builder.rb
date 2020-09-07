require 'email_builder/name'

module EmailBuilder

  def self.parse_exactly(a, n)
    case
    when a =~ /^#{n.first}$/ && n.first
      "first"
    when a =~ /^#{n.last}$/ && n.last
      "last"
    when a =~ /^#{n.f}#{n.l}$/ && n.f && n.l
      "fl"
    when a =~ /^#{n.f}#{n.last}$/ && n.f && n.last
      "flast"
    when a =~ /^#{n.f}#{n.m}#{n.last}$/ && n.f && n.m && n.last
      "fmlast"
    when a =~ /^#{n.first}\.#{n.last}$/ && n.first && n.last
      "first.last"
    when a =~ /^#{n.first}#{n.last}$/ && n.first && n.last
      "firstlast"
    when a =~ /^#{n.f}\.#{n.last}$/ && n.f && n.last
      "f.last"
    when a =~ /^#{n.first}\.#{n.m}\.#{n.last}$/ && n.first && n.m && n.last
      "first.m.last"
    when a =~ /^#{n.first}_#{n.last}$/ && n.first && n.last
      "first_last"
    when a =~ /^#{n.first}_#{n.m}_#{n.last}$/ && n.first && n.m && n.last
      "first_m_last"
    when a =~ /^#{n.first}#{n.l}$/ && n.first && n.l
      "firstl"
    when a =~ /^#{n.f}#{n.m}#{n.l}$/ && n.f && n.m && n.l
      "fml"
    when a =~ /^#{n.last}#{n.f}$/ && n.last && n.f
      "lastf"
    when a =~ /^#{n.first}\.#{n.l}$/ && n.first && n.l
      "first.l"
    else
      nil
    end
  end

  def self.parse_likely(a, n)
    case
    when a =~ /^#{n.first}\.\w\.#{n.last}$/ && n.m.nil?
      "first.m.last"
    when a =~ /^#{n.first}\.\w{2,}\.#{n.last}$/ && n.m.nil?
      "first.middle.last"
    when a =~ /^#{n.f}\w#{n.l}$/ && n.m.nil?
      "fml"
    else
      nil
    end
  end

  def self.build_exactly(f, n)
    case
    when f == "first" && n.first
      "#{n.first}"
    when f == "last" && n.last
      "#{n.last}"
    when f == "fl" && n.f && n.l
      "#{n.f}#{n.l}"
    when f == "flast" && n.f && n.last
      "#{n.f}#{n.last}"
    when f == "fmlast" && n.f && n.m && n.last
      "#{n.f}#{n.m}#{n.last}"
    when f == "first.last" && n.first && n.last
      "#{n.first}\.#{n.last}"
    when f == "firstlast" && n.first && n.last
      "#{n.first}#{n.last}"
    when f == "f.last" && n.f && n.last
      "#{n.f}\.#{n.last}"
    when f == "first.m.last" && n.first && n.m && n.last
      "#{n.first}\.#{n.m}\.#{n.last}"
    when f == "first_last" && n.first && n.last
      "#{n.first}_#{n.last}"
    when f == "first_m_last" && n.first && n.m && n.last
      "#{n.first}_#{n.m}_#{n.last}"
    when f == "firstl" && n.first && n.l
      "#{n.first}#{n.l}"
    when f == "fml" && n.f && n.m && n.l
      "#{n.f}#{n.m}#{n.l}"
    when f == "lastf" && n.last && n.f
      "#{n.last}#{n.f}"
    when f == "first.l" && n.first && n.l
      "#{n.first}\.#{n.l}"
    else
      nil
    end
  end

  def self.each_format(address, tokens = {})
    unless block_given?
      return to_enum(:each_format, address, tokens)
    end

    unless address.is_a?(String)
      return
    end

    sanitized = address
      .downcase
      .split("@")
      .first

    Name.new(tokens).each_variation do |variation|
      if exact = parse_exactly(sanitized, variation)
        yield exact
      end
      if likely = parse_likely(sanitized, variation)
        yield likely
      end
    end
  end

  def self.each_address(format, tokens = {}, host = nil)
    unless block_given?
      return to_enum(:each_address, format, tokens, host)
    end

    Name.new(tokens).each_variation do |variation|
      if exact = build_exactly(format, variation)
        yield(host ? "#{exact}@#{host}" : exact)
      end
    end
  end

  def self.parse(address, tokens = {})
    each_format(address, tokens).first
  end

  def self.build(format, tokens = {}, host = nil)
    each_address(format, tokens, host).first
  end

end
