#!/usr/bin/env ruby
require 'rdf'
require 'json/ld'

output_file = ARGV.pop
graph = RDF::Graph.new
ARGV.each { |file| graph.load(file, format: :jsonld) }
File.write(output_file, graph.dump(:jsonld))