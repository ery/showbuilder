class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :number
      t.string :name
      t.integer :grade
      t.string :department

      t.timestamps
    end
  end
end
