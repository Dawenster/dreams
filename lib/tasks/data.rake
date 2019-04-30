require 'csv'

namespace :data do
  desc 'Seed DB for tasks POC'
  task(load: [:environment]) do
    create_elements
    create_dreams
  end
end

def create_elements
  file_path = File.join(File.dirname(__FILE__), '../../db', 'csvs', 'elements.csv')
  csv_text = File.read(file_path)
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    Element.create!(row.to_hash)
  end
end

def create_dreams
  file_path = File.join(File.dirname(__FILE__), '../../db', 'csvs', 'dreams.csv')
  csv_text = File.read(file_path)
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    Dream.create!(row.to_hash)
  end
end
