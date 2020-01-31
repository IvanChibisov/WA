Workarea.define_content_block_types do
  block_type 'My Block' do
    tags %w(image)
    description 'A group of images.'
    repeat do
      field 'Image', :asset, default: find_asset_id_by_file_name('960x470_dark.png'), alt_field: 'Alt'
      field 'Alt', :string, default: ''
      field 'Link', :url, default: '/'
    end
  end
end
