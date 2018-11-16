class CreateDogs < ActiveRecord::Migration[5.2]
  def change
    create_table :dogs do |t|
      t.belongs_to :user
      t.string :name
      t.timestamps
    end
  end
end
