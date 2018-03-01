class AddRollsToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :rolls, :string, default: [].to_yaml, array: true
  end
end
