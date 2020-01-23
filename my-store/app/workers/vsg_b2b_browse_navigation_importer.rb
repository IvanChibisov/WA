module Workarea
  class VsgB2bBrowseNavigatonImporter

    def initialize(root, files)
      @root = root
      @files = files
    end

    def run
      navigation_hash = Hash.new {|hash, key| hash[key] = []}

      @files.each do |file|
        file_current = CSV.parse(File.read(@root + file), headers: true)
        file_current.each do |row|
          upper = row["category"].split("\n").first
          nested = row["category"].split("\n").second
          navigation_hash[upper] << nested
        end
      end

      navigation_hash.each do |upper, nested|
        nested.uniq!
        category = Workarea::Catalog::Category.find_by(name: upper)
        category_taxon = Workarea::Navigation::Taxon.root.children.create!(navigable: category)


        nested.each do |nested_categories|
          content_category = Workarea::Catalog::Category.find_by(name: nested_categories)
          category_taxon.children.create!(navigable: content_category)
        end

        menu = Workarea::Navigation::Menu.create!(taxon: category_taxon)
        content = Content.for(menu)
        content.blocks.create!(
          type: 'taxonomy',
          data: { start: category_taxon.id.to_s}
        )
      end
    end
  end
end
