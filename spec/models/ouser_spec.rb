# == Schema Information
#
# Table name: ousers
#
#  id         :bigint(8)        not null, primary key
#  provider   :string
#  uid        :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Ouser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
