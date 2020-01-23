module Workarea
  class VsgB2bProductsImporter
    def initialize(source_file, img_file)
      @products_file = source_file
      @img_file = img_file
    end

    def run
      file = CSV.parse(File.read(@products_file), headers: true)
      img_file = CSV.parse(File.read(@img_file), headers: true)

      img_skus = []
      img_paths = []

      img_file.each do |row|
        if (!img_skus.include?(row['sku']))
          img_skus << row['sku']
          img_paths << "app/workers/data/product" + row['image']
        end
      end

      file.each.with_index do |row, i|
        product = Workarea::Catalog::Product.new(
          id: row['sku'],
          name: row['name'],
          description: row['description'].match(/>(.*)</)[1],
          template: "option_selects"
        )

        unless row['material'].nil?
          row['material'].split("\n").each.with_index do |material, j|
            variant_sku = row['sku'] + "_#{j + 1}"
            product.variants.build(
              sku: variant_sku,
              details: {
                material: material
              }
            )
            Workarea::Pricing::Sku.create(
              _id: variant_sku,
              msrp: (row['price'].to_m),
              prices: [
                { regular: (row['price'].to_f + rand(-2.0..2.0)).to_m }]
            )
            Workarea::Inventory::Sku.create(
              _id: variant_sku,
              available: row['qty'].to_i + rand(-2..2)
            )
          end
        end
        product.save!
        materials = product.variants.map { |v| v.details[:material] }
        product.filters = { 'Material'=> materials.uniq }
        product.save!
        product.images.create(
          image: open(img_paths[i])
        )

      end
    end
  end
end
