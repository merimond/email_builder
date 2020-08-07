require 'securerandom'
require 'unicode'
require 'unidecoder'
require 'email_builder/diminutives'

module EmailBuilder

  def self.sanitize(string)
    unless string.is_a?(String)
      return nil
    end

    sanitized = string
      .downcase
      .to_ascii
      .gsub(/[^\w]/, "")

    sanitized.empty? ? nil : sanitized
  end

  def self.sanitize_tokens(atts = {})
    first   = sanitize(atts[:first])
    middle  = sanitize(atts[:middle])
    last    = sanitize(atts[:last])

    return {
      first:  first,
      middle: middle,
      last:   last,
      f:      first ? first[0] : nil,
      m:      middle ? middle[0] : nil,
      l:      last ? last[0] : nil
    }
  end

  def self.diminutives_for(name)
    unless name.is_a?(String)
      return []
    end
    key = name.downcase.strip
    DIMINUTIVES[key] || []
  end

  def self.parse_exactly(addr, first:, middle:, last:, f:, m:, l:, **p)
    case
    when addr =~ /^#{first}$/ && first
      "first"
    when addr =~ /^#{last}$/ && last
      "last"
    when addr =~ /^#{f}#{l}$/ && f && l
      "fl"
    when addr =~ /^#{f}#{last}$/ && f && last
      "flast"
    when addr =~ /^#{f}#{m}#{last}$/ && f && m && last
      "fmlast"
    when addr =~ /^#{first}\.#{last}$/ && first && last
      "first.last"
    when addr =~ /^#{first}#{last}$/ && first && last
      "firstlast"
    when addr =~ /^#{f}\.#{last}$/ && f && last
      "f.last"
    when addr =~ /^#{first}\.#{m}\.#{last}$/ && first && m && last
      "first.m.last"
    when addr =~ /^#{first}_#{last}$/ && first && last
      "first_last"
    when addr =~ /^#{first}_#{m}_#{last}$/ && first && m && last
      "first_m_last"
    when addr =~ /^#{first}#{l}$/ && first && l
      "firstl"
    else
      nil
    end
  end

  def self.parse_likely(addr, first:, middle:, last:, f:, m:, l:, **p)
    case
    when addr =~ /^#{first}\.\w\.#{last}$/ && m.nil?
      "first.m.last"
    when addr =~ /^#{first}\.\w{2,}\.#{last}$/ && m.nil?
      "first.middle.last"
    else
      nil
    end
  end

  def self.build_exactly(fmt, first:, middle:, last:, f:, m:, l:, **p)
    case
    when fmt == "first" && first
      "#{first}"
    when fmt == "last" && last
      "#{last}"
    when fmt == "fl" && f && l
      "#{f}#{l}"
    when fmt == "flast" && f && last
      "#{f}#{last}"
    when fmt == "fmlast" && f && m && last
      "#{f}#{m}#{last}"
    when fmt == "first.last" && first && last
      "#{first}\.#{last}"
    when fmt == "firstlast" && first && last
      "#{first}#{last}"
    when fmt == "f.last" && f && last
      "#{f}\.#{last}"
    when fmt == "first.m.last" && first && m && last
      "#{first}\.#{m}\.#{last}"
    when fmt == "first_last" && first && last
      "#{first}_#{last}"
    when fmt == "first_m_last" && first && m && last
      "#{first}_#{m}_#{last}"
    when fmt == "firstl" && first && l
      "#{first}#{l}"
    else
      nil
    end
  end

  def self.parse(address, tokens = {})
    unless address.is_a?(String)
      return nil
    end

    sanitized = address
      .downcase
      .split("@")
      .first

    tokens = sanitize_tokens(tokens)
      parse_exactly(sanitized, **tokens) ||
      parse_likely(sanitized, **tokens)
  end

  def self.build(format, tokens = {}, host = nil)
    tokens = sanitize_tokens(tokens)
    local = build_exactly(format, **tokens)
    host ? "#{local}@#{host}" : local
  end

end
