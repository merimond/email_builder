module EmailBuilder
  Variant = Struct.new(:first, :middle, :last) do
    def f
      first ? first[0] : nil
    end
    def m
      middle ? middle[0] : nil
    end
    def l
      last ? last[0] : nil
    end
  end
end
