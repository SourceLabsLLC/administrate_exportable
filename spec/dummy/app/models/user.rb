class User < ApplicationRecord
  has_many :dogs
  has_one :cat
end
