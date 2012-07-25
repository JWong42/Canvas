class CreateCostStructures < ActiveRecord::Migration
  def change
    create_table :cost_structures do |t|
      t.string :content
      t.timestamps
    end
  end
end
