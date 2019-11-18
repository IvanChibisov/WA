module Workarea
  class MagentoCategoriesSeeds

    def perform
      puts 'Importing Magento categories using MagentoCategoriesImporter ...'

      MagentoCategoriesImporter.new('app/workers/data/products_gear_bags.csv').run
    end
  end
end
