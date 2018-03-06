class CreateRolls < ActiveRecord::Migration[5.1]
  def change
    create_table :rolls do |t|
      t.integer :pin
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
