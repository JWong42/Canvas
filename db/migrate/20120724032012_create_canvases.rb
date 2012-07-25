class CreateCanvases < ActiveRecord::Migration
  def change
    create_table :canvases do |t|
      t.timestamps
    end
  end
end
