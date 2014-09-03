class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :message, nil: false
      t.datetime :created_at, nil: false
    end
  end
end
