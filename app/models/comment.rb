class Comment < ApplicationRecord
  scope :search_by_range_ids, ->(gte: nil, lte: nil) do
    if gte && lte
      where(id: gte..lte)
    elsif gte
      where("comments.id >= ?", gte)
    elsif lte
      where("comments.id <= ?", lte)
    else
      self
    end
  end
end
