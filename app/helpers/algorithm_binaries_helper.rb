module AlgorithmBinariesHelper
  
  def active_binaries_for_select
    grouped_options = []
    @algorithms.each do |algorithm|
      label = algorithm.name
      
      options = algorithm.algorithm_binaries.active.collect { |i| [i.name, i.id ] }
      grouped_options << [label, options] unless options.blank?
    end
    
    grouped_options
  end
  
end
