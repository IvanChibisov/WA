module Workarea
  class MagentoCategoriesSeeds

    def perform
      puts 'Importing Magento categories using MagentoCategoriesImporter ...'
      root = 'app/workers/data/'
      files = ["products_gear_bags.csv", "products_gear_fitness_equipment_ball.csv", "products_gear_fitness_equipment_strap.csv", "products_gear_fitness_equipment.csv", "products_gear_watches.csv"]
      navigation_hash = Hash.new {|hash, key| hash[key] = []}
      files.each do |x|
        MagentoCategoriesImporter.new(root + x).run
        file = CSV.parse(File.read(root + x), headers: true)
        file.each do |row|
          top = row["category"].split("\n").first
          second = row["category"].split("\n").second
          navigation_hash[top] << second
        end
      end
        
      navigation_hash.each do |key, value|
        navigation_hash[key].uniq!
        category = Workarea::Catalog::Category.find_by(name: key)
        category_taxon = Workarea::Navigation::Taxon.create!(navigable: category)
        menu = Workarea::Navigation::Menu.create!(taxon: category_taxon)

        content = Content.for(menu)

        navigation_hash[key].each do |x|
          content_category = Workarea::Catalog::Category.find_by(name: x)
          content_taxon = Workarea::Navigation::Taxon.create!(navigable: content_category)
          content.blocks.create!(
            type: 'taxonomy',
            data: { start: content_taxon.id }
          )
        end
      end
    end
  end
end
