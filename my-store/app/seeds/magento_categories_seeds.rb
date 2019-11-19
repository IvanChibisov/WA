module Workarea
  class MagentoCategoriesSeeds

    def perform
      puts 'Importing Magento categories using MagentoCategoriesImporter ...'
      root = 'app/workers/data/'
      files = ["products_gear_bags.csv", "products_gear_fitness_equipment_ball.csv", "products_gear_fitness_equipment_strap.csv", "products_gear_fitness_equipment.csv", "products_gear_watches.csv"]

      files.each do |x|
        MagentoCategoriesImporter.new(root + x).run
      end
    end
  end
end
