#!/usr/bin/env ruby
require 'json'

input_file, template_file, output_file = ARGV

data = JSON.parse(File.read(input_file))
nodes = data.is_a?(Array) ? data : (data['@graph'] || [data])

qids = nodes
  .map { |n| n['@id'] }
  .compact
  .select { |id| id =~ %r{\Ahttp://www\.wikidata\.org/entity/Q\d+\z} }
  .uniq

values_clause = qids.map { |q| "<#{q}>" }.join(' ')

template = File.read(template_file)
File.write(output_file, template.sub('__VALUES__', values_clause))