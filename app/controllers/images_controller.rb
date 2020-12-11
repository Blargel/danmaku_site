class ImagesController < ApplicationController
  inherit_resources
  actions :create, :destroy
  belongs_to :user, :finder => :find_by_permalink! do
    belongs_to :project, :finder => :find_by_permalink!
  end

  # preload all resource / collection in before filter
  before_action :collection, :only =>[:index]
  before_action :resource, :only => [:show, :edit, :update, :destroy]
  before_action :build_resource, :only => [:new, :create, :index]

  authorize_resource

  private

  def permitted_params
    params.permit(image: [])
  end
end
