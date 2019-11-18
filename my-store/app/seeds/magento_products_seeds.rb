module Workarea
  class MagentoProductsSeeds

    def perform
      puts 'Importing Magento products using MagentoProductsImporter ...'
      root = 'app/workers/data/'
      MagentoProductsImporter.new(root + 'products_gear_bags.csv', root + 'images_gear_bags.csv').run
    end
  end
end
