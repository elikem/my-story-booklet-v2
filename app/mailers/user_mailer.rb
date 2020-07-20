class UserMailer < ApplicationMailer
    default from: "the.significance.project@gmail.com"

    def email_pdf_to_user(publication_id)
        @publication = Publication.find(publication_id)
        @user = @publication.story.user
        # replace the extension .idml with .pdf when name the attachment stored in the database
        @publication_filename = @publication.publication_filename.gsub(".idml", ".pdf")
        
        mail(to: @user.email, subject: "My Story Booklet: Your Story is Ready!")
    end
end
