module Workarea
  module Pricing
    module Calculators
      class PriceListItemCalculator
        include Calculator

        def adjust
          order.items.each do |item|
            price = pricing.for_sku(
              item.sku,
              quantity: item.quantity,
              list_id: Current.price_list_id
            )

            item.adjust_pricing(
              price: 'item',
              quantity: item.quantity,
              calculator: self.class.name,
              amount: price.sell * item.quantity,
              description: 'Item Subtotal',
              data: {
                'on_sale' => price.on_sale?,
                'original_price' => price.regular.to_f,
                'tax_code' => price.tax_code,
                'price_list_id' => price.price_list_id
              }
            )
          end
        end

      end
    end
  end
end
