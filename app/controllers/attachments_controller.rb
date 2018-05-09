class AttachmentsController < ApplicationController
  before_action :find_attachment

  def destroy
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash[:notice] = 'Your attachment successfully deleted.'
    else
      flash[:alert] = "You can't delete another user's attachment!"
    end
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
