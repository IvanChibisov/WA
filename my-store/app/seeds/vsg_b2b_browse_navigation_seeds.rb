module Workarea
  class VsgB2bBrowseNavigationSeeds

    def perform
      puts 'Importing VsgB2b browse navigation using VsgB2bBrowseNavigatonImporter ...'
      root = 'app/workers/data/'
      files = ["products_gear_bags.csv", "products_gear_fitness_equipment_ball.csv", "products_gear_fitness_equipment_strap.csv", "products_gear_fitness_equipment.csv", "products_gear_watches.csv"]

      VsgB2bBrowseNavigatonImporter.new(root, files).run
      
    end
  end
end
