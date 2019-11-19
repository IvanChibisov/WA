module Workarea
  class MagentoProductsSeeds

    def perform
      puts 'Importing Magento products using MagentoProductsImporter ...'
      files = ["products_gear_bags.csv", "products_gear_fitness_equipment_ball.csv", "products_gear_fitness_equipment_strap.csv", "products_gear_fitness_equipment.csv", "products_gear_watches.csv"]
      img = ["images_gear_bags.csv", "images_gear_fitness_equipment.csv", "images_gear_fitness_equipment.csv", "images_gear_fitness_equipment.csv", "images_gear_watches.csv"]
      root = 'app/workers/data/'
      products = {}
      files.each.with_index do |x, i|
        products[root + x] = root + img[i]
      end
      products.each do |key, value|
        MagentoProductsImporter.new(key, value).run
      end
    end
  end
end
