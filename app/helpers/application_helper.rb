module ApplicationHelper
  def navigation_link(name, options = {})
    current, link = "", nil
    
    controller_klass = "#{name}_controller".camelize.constantize
    current = "current" if !controller_klass.blank? and controller.class == controller_klass 

    link_name = options[:title].presence || name.titleize
    
    link = link_to(link_name, public_send("#{name}_path"))
    
    html_class = "tab #{name} #{current}"
    content_tag(:li, link, :class => html_class)
  end
end # of module
