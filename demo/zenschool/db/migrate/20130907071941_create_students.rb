class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|

      t.string :number
      t.string :name
      t.integer :age
      t.string :sex
      t.references :group

      t.timestamps
    end
  end
end
