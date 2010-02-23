class Version < ActiveRecord::Base
  belongs_to :project
  has_one    :user, :through => :project
  has_one    :archive, :as => :attachable, :dependent => :destroy
  has_many   :comments, :as => :commentable, :dependent => :destroy
  
  validates_presence_of :version_number, :message => "Version number is required."

  acts_as_voteable

  has_permalink :version_number, :update => true, :unique => false
  validate :version_number_excludes_new_by_permalink, :version_number_is_unique_by_permalink

  def version_number_excludes_new_by_permalink
    errors.add(:version_number, "Version number cannot be named 'new'") if
      permalink == "new"
  end

  def version_number_is_unique_by_permalink
    version_with_permalink = project.versions.find_by_permalink(permalink)
    errors.add(:title, "Version number is already in use by the same project.") if
      version_with_permalink && version_with_permalink != self
  end
  
  def to_param
    permalink
  end
  
  def increment_download_counter!
    Version.transaction do
      update_attributes(:download_count => self.download_count += 1)
      update_project_download_counter_cache
    end
  end
  
  private
  def update_project_download_counter_cache
    project.update_attributes!(:downloads => project.calculate_download_count)
  end
  
end
