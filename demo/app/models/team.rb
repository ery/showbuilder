class Team < ActiveRecord::Base
  belongs_to :teacher
  attr_accessible :name, :teacher_id
end
