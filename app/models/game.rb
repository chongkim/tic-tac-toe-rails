class Game < ActiveRecord::Base
  belongs_to :first_user, :class_name => 'User'
  belongs_to :second_user, :class_name => 'User'
  attr_accessible :accepted, :completed, :email, :position, :turn
end
