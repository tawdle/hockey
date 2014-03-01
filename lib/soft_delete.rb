module SoftDelete
  extend ActiveSupport::Concern

  included do
    scope :without_deleted, where(:deleted_at => nil)
  end

  def destroy
    update_attribute(:deleted_at, Time.now)
    run_callbacks(:destroy)
  end

  def delete
    update_attribute(:deleted_at, Time.now)
  end
end
