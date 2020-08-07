Gem::Specification.new do |s|
  s.name    = "email_builder"
  s.version = "1.0.0"
  s.summary = "Parse email formats and generate addresses"
  s.authors = ["Alex Serebryakov"]
  s.files   = Dir['lib/**/*.rb']
  s.add_runtime_dependency 'unicode', '~> 0.4'
  s.add_runtime_dependency 'unidecoder', '~> 1.1'
end
