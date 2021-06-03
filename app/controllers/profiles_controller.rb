class ProfilesController < ApplicationController
  def show
    @profile = Profile.friendly.find(params[:id])
    @user = Profile.find(@profile.id).user
    @publication = Publication.get_latest_publication_with_pdf(params[:id])
  end

  def pdf
    @latest_publication = Publication.get_lastest_publication(params[:id])
    @user = @latest_publication.story.user

    send_file("#{@latest_publication.pdf_file_path}", type: "application/pdf", disposition: "attachment", stream: true, status: 200, filename: "#{@user.first_name.downcase}-#{@user.last_name.downcase}-mystorybooklet-#{@latest_publication.publication_number}.pdf")
  end

end
