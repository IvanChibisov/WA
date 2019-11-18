module Workarea
  class MagentoCategoriesImporter

    def initialize(source_file)
      @products_file = source_file
    end

    def run
      file = CSV.parse(File.read(@products_file), headers: true)
      c = Array.new
      c1 = Array.new
      file.each do |category|
        c << category['category']
      end
      c.uniq!
      c.each do |x|
        x.split("\n").each {|a| c1 << a}
      end
      c1.uniq!

      category_products = Hash.new {|hash, key| hash[key] = []}
      file.each do |x|
        c1.each do |el|
          category_products[el] << x['sku'] if x['category'].include? el
        end
      end

      category_products.each do |key, value|
        Workarea::Catalog::Category.create!(name: key, product_ids: value)
      end
    end
  end
end
