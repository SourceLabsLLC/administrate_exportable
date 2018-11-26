class AddWalkTimeToDog < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :walk_time, :datetime
  end
end
