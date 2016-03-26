# == Schema Information
#
# Table name: application_clusters
#
#  id               :integer          not null, primary key
#  application_id   :integer
#  application_type :string
#  cluster_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe ApplicationCluster, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
