module CloudEnginesHelper
  
  def cloud_engines_options_for_select(selected_id = nil)
    output = ActiveSupport::SafeBuffer.new
    
    CloudEngine.all.each do |cloud_engine|
      html_options = {
        :value => cloud_engine.id, 
        "data-availability-zones-info-url" => availability_zones_info_cloud_engine_path(cloud_engine.id),
        "data-availability-zones-url" => availability_zones_cloud_engine_path(cloud_engine.id)
      }
      
      html_options[:selected] = "selected" if selected_id && cloud_engine.id == selected_id
      output << content_tag(:option, cloud_engine.title, html_options)
    end
    
    output
  end
  
  
end
