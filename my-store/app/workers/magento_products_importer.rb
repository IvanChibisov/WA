module Workarea
  class MagentoProductsImporter
    def initialize(source_file, img_file)
      @products_file = source_file
      @img_file = img_file
    end

    def run
      file = CSV.parse(File.read(@products_file), headers: true)
      img_file = CSV.parse(File.read(@img_file), headers: true)
      skus = []
      names = []
      descriptions = []
      prices = []
      qty = []
      img_skus = []
      img_paths = []
      correct_images = []
      materials = Hash.new {|hash, key| hash[key] = []}

      file.each do |row|
        names << row['name']
        descriptions << row['description'].match(/>(.*)</)[1]
        skus << row["sku"]
        qty << row["qty"]
        prices << row['price']
        @temp = []
        unless row['material'].nil?
          row['material'].split("\n").each { |x| @temp << x}
          materials[row["sku"].to_s] = @temp
        end
      end
      img_file.each do |row|
        if (!img_skus.include?(row['sku']))
          img_skus << row['sku']
          img_paths << row['image']
        end
      end
      img_paths.each do |elem|
        correct_images << "app/workers/data/product" + elem
      end

      skus.each.with_index  do |x, i|
        product = Workarea::Catalog::Product.create(
          id: x,
          name: names[i],
          description: descriptions[i],
          template: "option_selects"
        )

        materials[x].each.with_index do |material, j|
          sku_temp = x + "_#{j + 1}"
          product.variants.create(
            sku: sku_temp,
            details: {
              material: material
            }
          )
          Workarea::Pricing::Sku.create(
            _id: sku_temp,
            msrp: (prices[i].to_m),
            prices: [
              { regular: (prices[i].to_f + rand(-2.0..2.0)).to_m }]
          )
          Workarea::Inventory::Sku.create(
            _id: sku_temp,
            available: qty[i].to_i + rand(-2..2)
          )
        end
        product.images.create(
          image: open(correct_images[i])
        )


      end
    end
  end
end
