class CreateStrengths < ActiveRecord::Migration[5.1]
  def change
    create_table :strengths do |t|
      t.string :name, :null => false, :default => ""
      t.string :description, :null => false, :default => ""
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end
    add_index :strengths, :name, unique: true
  end
end
