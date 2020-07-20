class EmailPdfToUserJob < ApplicationJob
  queue_as :email_pdf_to_user

  def perform(publication_id)
    # send the publication_id to the email action for processing
    # UserMailer.email_pdf_to_user(publication_id).deliver_now
    UserMailer.email_pdf_to_user(publication_id).deliver
  end
end
