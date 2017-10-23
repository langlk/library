class CreateBooksCheckoutsPatrons < ActiveRecord::Migration[5.1]
  def change
    create_table(:books) do |t|
      t.column(:title, :string)
      t.column(:author_first, :string)
      t.column(:author_last, :string)
    end

    create_table(:patrons) do |t|
      t.column(:first_name, :string)
      t.column(:last_name, :string)
    end

    create_table(:checkouts) do |t|
      t.column(:patron_id, :integer)
      t.column(:book_id, :integer)
      t.column(:checkout_date, :date)
      t.column(:due_date, :date)
      t.column(:checked_in, :boolean)
    end
  end
end
