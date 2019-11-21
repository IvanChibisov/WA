module Workarea
  class MagentoCategoriesImporter

    def initialize(source_file)
      @products_file = source_file
    end

    def run
      file = CSV.parse(File.read(@products_file), headers: true)
      all_categories = Array.new
      file.each do |row|
        row['category'].split("\n").each do |elem|
          if !all_categories.include? elem
            all_categories << elem
          end
        end
      end

      category_products = Hash.new {|hash, key| hash[key] = []}
      file.each do |row|
        all_categories.each do |category|
          category_products[category] << row['sku'] if row['category'].include? category
        end
      end

      category_products.each do |key, value|
        begin
          cat = Workarea::Catalog::Category.find_by(name: key)
          unless cat.nil?
            value.each { |x| cat.product_ids << x }
            cat.save!
          end
        rescue Mongoid::Errors::DocumentNotFound
          Workarea::Catalog::Category.create!(name: key, product_ids: value)
        end
      end
    end
  end
end
