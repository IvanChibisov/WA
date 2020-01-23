module Workarea
  class VsgB2bCategoriesImporter

    def initialize(source_file)
      @products_file = source_file
    end

    def run
      file = CSV.parse(File.read(@products_file), headers: true)
      all_categories = []
      file.each do |row|
        row['category'].split("\n").each do |category|
          if !all_categories.include? category
            all_categories << category
          end
        end
      end

      category_products = Hash.new {|hash, key| hash[key] = []}
      file.each do |row|
        all_categories.each do |category|
          category_products[category] << row['sku'] if row['category'].include? category
        end
      end

      category_products.each do |category, products|
        begin
          existing_category = Workarea::Catalog::Category.find_by(name: category)
          unless existing_category.nil?
            products.each { |product| existing_category.product_ids << product }
            existing_category.save!
          end
        rescue Mongoid::Errors::DocumentNotFound
          Workarea::Catalog::Category.create!(name: category, product_ids: products)
        end
      end
    end
  end
end
