class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :content 
      t.timestamps
    end
  end
end
