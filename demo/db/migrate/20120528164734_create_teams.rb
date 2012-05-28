class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.references :teacher

      t.timestamps
    end
    add_index :teams, :teacher_id
  end
end
