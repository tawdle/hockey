module SoftDelete
  extend ActiveSupport::Concern

  included do
    scope :without_deleted, where(:deleted_at => nil)
  end

  def destroy
    update_attribute(:deleted_at, Time.now)
  end

  def delete
    destroy
  end
end
