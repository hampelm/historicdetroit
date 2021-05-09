class Street < ApplicationRecord
  default_scope { order(name: :asc) }
end
