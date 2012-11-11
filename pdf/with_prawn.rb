require 'prawn'
require 'pry'
require 'active_support/all'

width = 100
height = 100
cols = 3
rows = 5
gutter = 10 # My initial cards used this and it was terrible.
gutter = 0

inputs = File.read(ARGV.first).lines.to_a.reject(&:blank?).map {|e| e.gsub(/_/, '______')}

pdf_name = ARGV[1]

Prawn::Document.generate(pdf_name) do |pdf|
  pages = 0
  while inputs.any?
    pdf.define_grid(:columns => cols, :rows => rows, :gutter => gutter) 
    (0..(rows-1)).each do |i|
      (0..(cols-1)).each do |j|
	pdf.grid(i, j).bounding_box do
	  txt = inputs.pop 
	  pdf.text txt, :align => :center, :valign => :center unless txt.blank?
	  pdf.stroke_bounds
	end
      end
    end
    pdf.start_new_page
    pages += 1
  end
  pages.times do
    (0..(rows-1)).each do |i|
      (0..(cols-1)).each do |j|
	pdf.grid(i, j).bounding_box do
	  pdf.text "Question", :align => :center, :valign => :center
	  pdf.stroke_bounds
	end
      end
    end
    pdf.start_new_page
  end
end

