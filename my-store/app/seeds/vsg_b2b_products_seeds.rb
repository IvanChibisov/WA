module Workarea
  class VsgB2bProductsSeeds

    def perform
      puts 'Importing VsgB2b products using VsgB2bProductsImporter ...'
      files = ["products_gear_bags.csv", "products_gear_fitness_equipment_ball.csv", "products_gear_fitness_equipment_strap.csv", "products_gear_fitness_equipment.csv", "products_gear_watches.csv"]
      img = ["images_gear_bags.csv", "images_gear_fitness_equipment.csv", "images_gear_fitness_equipment.csv", "images_gear_fitness_equipment.csv", "images_gear_watches.csv"]
      root = 'app/workers/data/'
      products_with_images = {}
      files.each.with_index do |products_file_name, index|
        products_with_images[root + products_file_name] = root + img[index]
      end

      products_with_images.each { |products_file, image_file| VsgB2bProductsImporter.new(products_file, image_file).run }
    end
  end
end
