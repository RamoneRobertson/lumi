class AddProductiionCompanyToMovie < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :production_company_id, :integer
  end
end
