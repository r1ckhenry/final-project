class Query < ActiveRecord::Base
  # attr_accessible :title, :body

  def get_date_ranges
    date_ranges = [
      {
        date => ['TODAY', 'Today']
      },
      {
        date => ['YESTERDAY', 'Yesterday']
      },
      {
        date => ['LAST_7_DAYS', 'Previous 7 days']
      },
      {
        date => ['LAST_30_DAYS', 'Previous 30 days']
      },
    ]
  end

end
