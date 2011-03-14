class AttachmentsController < ApplicationController
  # before_filter :authenticate_user! # TODO: add ACL
  before_filter :find_attachment
  
  # TODO: add AC for Attachments
  
  def show
    send_file @attachment.data.path, 
              :filename => @attachment.data_file_name,
              :type => @attachment.data_content_type,
              :disposition => (@attachment.inlineable? ? 'inline' : 'attachment')
  end

  def destroy
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :nothing => true }
    end
  end
  
  private
  def find_attachment
    @attachment = Attachment.find params[:id]
    authorize! :manage, @attachment
  end
end
