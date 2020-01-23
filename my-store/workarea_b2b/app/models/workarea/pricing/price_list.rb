module Workarea
  module Pricing
    class PriceList
      include ApplicationDocument
      include Commentable

      field :_id, type: String, default: -> { BSON::ObjectId.new.to_s }
      field :name, type: String, localize: true
    end
  end
end
