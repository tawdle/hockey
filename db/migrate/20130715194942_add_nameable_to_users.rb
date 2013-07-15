class AddNameableToUsers < ActiveRecord::Migration
  def up
    add_column :users, :nameable_type, :string
    add_column :users, :nameable_id, :integer
    rename_column :teams, :name, :full_name

    Team.all.each do |team|
      puts "migrating team #{team.full_name}..."
      username = team.full_name.parameterize.underscore.camelcase
      email = "#{username}_fake@mygameshot.com"
      user = User.find_by_name(username) || 
        User.find_by_email(email) || 
        User.new(:name => username, 
                 :email => email, 
                 :password => Digest::SHA1.hexdigest(Time.now.to_s))
      user.nameable = team
      user.save!
    end
  end

  def down
    remove_column :users, :nameable_type
    remove_column :users, :nameable_id
    rename_column :teams, :full_name, :name
  end
end
