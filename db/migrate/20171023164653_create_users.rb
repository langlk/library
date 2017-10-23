class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table(:users) do |t|
      t.column(:patron_id, :integer)
      t.column(:email, :string)
      t.column(:username, :string)
      t.column(:password, :string)
      t.column(:admin, :boolean)
    end
  end
end
