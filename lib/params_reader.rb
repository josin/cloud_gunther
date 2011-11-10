module ParamsReader
  
  protected
  
  def read_from_params(field, key)
    if self.respond_to?(field) && self.send(field).is_a?(Hash)
      self.send(field)[key.to_s]
    else
      ""
    end
  end

end