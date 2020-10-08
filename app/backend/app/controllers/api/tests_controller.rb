class Api::TestsController < ApplicationController
  def show
    render(json: "test is successful")
  end
end
