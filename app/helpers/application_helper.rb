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
  
  # Return a title on a per-page basis
  def title
    base_title = t("app_name")
    if @title.blank?
      base_title
    else
      "#{@title.reverse.to_sentence(:words_connector => " | ", :last_word_connector => " | ", :two_words_connector => " | ")} | #{base_title}"
    end
  end
  
  def pagination(resource)
    output = ActiveSupport::SafeBuffer.new
    output.safe_concat will_paginate(resource).to_s # .to_s => prevent nil error
    output.safe_concat page_entries_info(resource)
    output
  end
end # of module
