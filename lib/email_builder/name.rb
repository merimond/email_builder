require 'unicode'
require 'unidecoder'
require 'email_builder/alternatives'
require 'email_builder/variant'

module EmailBuilder
  class Name
    ALLOWED_ATTS = [:first, :middle, :last]

    def initialize(tokens = {})
      unless tokens.is_a?(Hash)
        throw "Hash expected, got #{tokens.class.name} instead"
      end
      @tokens = Hash[tokens.map do |key, value|
        sanitize_token(key, value)
      end.compact]
    end

    def first
      @tokens[:first] || []
    end

    def middle
      @tokens[:middle] || []
    end

    def last
      @tokens[:last] || []
    end

    def each_first(&block)
      unless block_given?
        return to_enum(:each_first)
      end

      first.each(&block)
      alts = Alternative.get(first) - first
      alts.each(&block)
      self
    end

    def each_middle(&block)
      unless block_given?
        return to_enum(:each_middle)
      end

      middle.each(&block)
      self
    end

    def each_last(&block)
      unless block_given?
        return to_enum(:each_last)
      end

      last.each(&block)
      self
    end

    def each_variant_for_middle(first, last)
      each_middle.each do |middle|
        yield EmailBuilder::Variant.new(first, middle, last)
      end
      if middle.empty?
        yield EmailBuilder::Variant.new(first, nil, last)
      end
    end

    def each_variation(&block)
      unless block_given?
        return to_enum(:each_variation)
      end

      each_first.each do |first|
        each_last.each  do |last|
          each_variant_for_middle(first, last, &block)
        end
        if last.empty?
          each_variant_for_middle(first, nil, &block)
        end
      end

      if first.empty?
        each_last.each do |last|
          each_variant_for_middle(nil, last, &block)
        end
      end

      self
    end

    private

    def sanitize_token(key, val)
      if !key.is_a?(String) && !key.is_a?(Symbol)
        return nil
      end

      if key.is_a?(String) && key.strip.empty?
        return nil
      end

      key = key.to_sym
      val = val.is_a?(Array) ? val : [val]

      unless ALLOWED_ATTS.include?(key)
        return nil
      end

      values = val.select do |v|
        v.is_a?(String)
      end.map do |v|
        v.downcase.to_ascii.gsub(/[^\w]/, "")
      end.reject do |v|
        v.empty?
      end

      [key, values.uniq]
    end

  end
end
