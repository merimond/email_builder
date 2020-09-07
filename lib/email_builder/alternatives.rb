module EmailBuilder
  module Alternative
    LIST = {
      "alexander"   => %w(alex),
      "andrew"      => %w(andy),
      "anthony"     => %w(tony),
      "arthur"      => %w(art),
      "benjamin"    => %w(ben),
      "catherine"   => %w(cathy),
      "charles"     => %w(charlie),
      "christopher" => %w(chris),
      "dave"        => %w(david),
      "david"       => %w(dave),
      "daniel"      => %w(dan),
      "dominic"     => %w(dom),
      "donald"      => %w(don),
      "douglas"     => %w(doug),
      "edward"      => %w(ed),
      "elizabeth"   => %w(liz),
      "jeffrey"     => %w(jeff),
      "matthew"     => %w(matt),
      "michael"     => %w(mike),
      "randall"     => %w(randy),
      "robert"      => %w(bob rob),
      "timothy"     => %w(tim),
      "william"     => %w(will),
      "zachary"     => %w(zach),
    }

    def self.get(name)
      case name
      when Array
        name.map { |n| get(n) }.flatten.compact.uniq
      when String
        LIST[name] || []
      when Symbol
        LIST[name.to_s] || []
      else
        []
      end
    end

  end
end
