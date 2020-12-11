class Project < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :category
  belongs_to :danmakufu_version
  has_many   :images,  :as => :attachable, :dependent => :destroy
  has_one    :archive, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  acts_as_taggable_on :tags
  has_permalink :title, :update => true, :unique => false

  validates_presence_of :title, :message => "Title is required."
  validates_presence_of :version_number, :message => "Version number is required."
  validate :title_excludes_new_by_permalink, :title_is_unique_by_permalink

  def title_excludes_new_by_permalink
    errors.add(:title, "Title cannot be named 'new'") if
      permalink == "new"
  end

  def title_is_unique_by_permalink
    project_with_permalink = user.projects.find_by_permalink(permalink)
    errors.add(:title, "Title is already in use by another project you own.") if
      project_with_permalink && project_with_permalink != self
  end

  def to_param
    permalink
  end

  def increment_download_counter!
    Project.where(:id => id).update_all(:downloads => self.downloads += 1)
  end

  def takedown(reason)
    Project.where(:id => id).update_all(:soft_deleted => true, :deleted_reason => reason)
    images.destroy_all if images && images.present?
    archive.destroy if archive
  end

  def self.featured
    self.publically_viewable.order("created_at DESC").limit(100).max do |p1, p2|
      p1.downloads <=> p2.downloads
    end
  end

  def self.publically_viewable
    self.joins(:archive).
      where(:unlisted => false, :soft_deleted => false).
      where("attachable_id IS NOT NULL")
  end

  def self.most_downloaded
    self.joins(:archive).publically_viewable.order('downloads DESC').limit(5)
  end

  def self.latest
    self.joins(:archive).publically_viewable.order('created_at DESC').limit(5)
  end
end
