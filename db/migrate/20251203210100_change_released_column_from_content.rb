class ChangeReleasedColumnFromContent < ActiveRecord::Migration[7.1]
  def change
    change_column(:contents, :date_of_release, :string)
  end
end
