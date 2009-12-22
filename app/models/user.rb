class User < ActiveRecord::Base
  has_many :projects
  has_many :versions, :through => :projects
  has_many :authored_comments, :class_name => "Comment", :foreign_key => "author_id"
  has_many :comments, :as => :commentable
  
  acts_as_authentic
  has_permalink :login, :update => true, :unique => true
  
  def is_owner_of(ownable)
    ownable.user == self
  end
  
  def to_param
    permalink
  end
end
