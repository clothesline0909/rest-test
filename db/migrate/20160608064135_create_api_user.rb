class CreateApiUser < ActiveRecord::Migration
  def change
    create_table :api_users do |t|
        t.string :api_token
        t.timestamps
    end
  end
end
