module ParamsReader
  
  protected
  
  def read_from_params(field, key)
    if self.respond_to?(field) && self.send(field)
      self.send(field)[key]
    else
      ""
    end
  end

end