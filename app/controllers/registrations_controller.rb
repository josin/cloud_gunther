class RegistrationsController < Devise::RegistrationsController
  
  # only :edit and :udpate actions could have application layout
  layout Proc.new { |controller|
    ["edit", "update"].include?(controller.request.params[:action]) ? 'application' : 'login'
  }
  
end
