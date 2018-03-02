class AddRollsToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :rolls, :string, array: true, default: [].to_yaml
  end
end
