class ErrorsController < ApplicationController
  layout "error"

  def show
    @exception = request.env["action_dispatch.exception"] ||= "unknown error"
    render text: request.path
  end
end
