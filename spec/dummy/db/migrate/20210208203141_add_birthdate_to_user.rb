class AddBirthdateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :birthdate, :date
  end
end
