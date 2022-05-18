class MainController < ApplicationController
  def index
    redirect_to discussions_path
  end
end
