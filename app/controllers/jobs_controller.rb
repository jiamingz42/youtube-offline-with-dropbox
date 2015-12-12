class JobsController < ApplicationController

  def status
    @status = Resque::Plugins::Status::Hash.get(params[:job_id]) || {}
    respond_to do |format|
      format.json { render json: @status }
    end
  end

end
