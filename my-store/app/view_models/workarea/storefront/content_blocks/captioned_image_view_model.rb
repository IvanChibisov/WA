module Workarea
  module Storefront
    module ContentBlocks
      class CaptionedImageViewModel < ContentBlockViewModel
        def products
          skus_with_sale = []
          pricing_skus = Workarea::Pricing::Sku.all
          pricing_skus.each do |pricing_sku|
            skus_with_sale << pricing_sku if pricing_sku.on_sale
          end

          skus = []
          skus_with_sale.each { |sku_with_sale| skus << sku_with_sale._id }
          products_with_sale = []
          skus.each do |sku|
            products_with_sale << Workarea::Catalog::Product.find_by_sku(sku)
          end
          products_with_sale.map { |product| ProductViewModel.wrap(product) }
        end
      end
    end
  end
end
