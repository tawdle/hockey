class AddLanguageToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :language, :string
  end
end
