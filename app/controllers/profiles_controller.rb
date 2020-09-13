class ProfilesController < ApplicationController
  def show
    flash[:alert] = "User profile not found"; redirect_to controller: "errors", action: "show" unless @profile = Profile.friendly.find(params[:id])
    flash[:alert] = "User not found"; redirect_to controller: "errors", action: "show" unless @user = Profile.find(@profile.id).user
    flash[:alert] = "Publication not found"; redirect_to controller: "errors", action: "show" unless @publication = Publication.get_latest_publication_with_pdf(params[:id])

    flash[:alert] = "This profile is not public"; redirect_to controller: "errors", action: "show" unless @profile.public_access
  end

  def update
    @profile = Profile.find_by_username(params[:id])
    @user = @profile.user

    respond_to do |format|
      if @profile.update_attributes(profile_params)
        format.js
      else
        format.js
      end
    end
  end

  def pdf
    @latest_publication = Publication.get_lastest_publication(params[:id])
    @user = @latest_publication.story.user

    send_file("#{@latest_publication.pdf_file_path}", type: "application/pdf", disposition: "attachment", stream: true, status: 200, filename: "#{@user.first_name.downcase}-#{@user.last_name.downcase}-mystorybooklet-#{@latest_publication.publication_number}.pdf")
  end

  private

  def profile_params
    params.require(:profile).permit(:public_access)
  end
end