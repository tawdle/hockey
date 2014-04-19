class AddLastReminderToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :last_reminder_sent_at, :datetime
  end
end
