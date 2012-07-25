class CreateUnfairAdvantages < ActiveRecord::Migration
  def change
    create_table :unfair_advantages do |t|
      t.string :content
      t.timestamps
    end
  end
end
