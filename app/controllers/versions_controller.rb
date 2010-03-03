class VersionsController < ApplicationController
  inherit_resources
  include PermalinkResources  
  belongs_to :user, :finder => :find_by_permalink! do
    belongs_to :project, :finder => :find_by_permalink!
  end
  
  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  filter_access_to :all
  filter_access_to [:edit, :update], :attribute_check => true

  destroy! do |success, failure|
    success.html { redirect_to user_project_path(@user, @project) }
  end

  private
  def _collection
    end_of_association_chain.descend_by_created_at
  end
end
