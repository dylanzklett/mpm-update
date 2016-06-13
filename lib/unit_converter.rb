module UnitConverter
  def convert(field, to)
    converting(self.send(field), 'mm', to)
  end

  def converting(what, from, to)
    return if what.nil?
    Unit("#{what} #{from}").convert_to(to).scalar.to_f.round(2)
  end
  module_function :converting
end
