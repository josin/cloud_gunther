module TasksHelper
  
  # Sample usage:
  #
  #   <%= sort_link nil, :name %> => "Name"
  #   <%= sort_link nil, :name, 'Company Name' %> => "Company Name"
  #   <%= sort_link @search, :name %> => "MetaSearch::...sort_link"
  def sortable_link(builder, attribute, *args)
    return sort_link(builder, attribute, *args) unless builder.nil?
    
    return attribute.to_s.humanize if args.empty?
    args[0]
  end
  
  
end
