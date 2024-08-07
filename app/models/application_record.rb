class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def date_not_in_past
    if expiration_date.present? && expiration_date < Date.today
      errors.add(:expiration_date, "過去の日付では提出できません。書類の更新をしてください。")
    end
  end
end
