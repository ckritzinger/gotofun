class AddStatusToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :status, :string, default: "PUBLIC"
  end
end
