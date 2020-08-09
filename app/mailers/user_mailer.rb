class UserMailer < ApplicationMailer
    default from: "the.significance.project@gmail.com"

    def email_pdf_to_user(publication_id)
        @publication = Publication.find(publication_id)
        @user = @publication.story.user
        
        attachments[@publication.pdf_publication_filename] = File.read("#{@publication.publication_folder_path}/#{@publication.pdf_publication_filename}")
        mail(to: @user.email, subject: "My Story Booklet: Your Story is Ready!")

        # TODO: Fix email template with the correct messaging (both erb and txt)
    end
end
