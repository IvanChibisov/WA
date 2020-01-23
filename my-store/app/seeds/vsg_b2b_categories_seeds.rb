module Workarea
  class VsgB2bCategoriesSeeds

    def perform
      puts 'Importing VsgB2b categories using VsgB2bCategoriesImporter ...'
      root = 'app/workers/data/'
      files = ["products_gear_bags.csv", "products_gear_fitness_equipment_ball.csv", "products_gear_fitness_equipment_strap.csv", "products_gear_fitness_equipment.csv", "products_gear_watches.csv"]
      files.each { |file| VsgB2bCategoriesImporter.new(root + file).run }
    end
  end
end
