class Asset < ApplicationRecord
  belongs_to :attachable, :polymorphic => true
  delegate :user, :to => :attachable
end
