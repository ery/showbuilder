Gem::Specification.new do |s|
  s.name          = 'view_builder'
  s.version       = '0.0.1'
  s.date          = '2011-12-07'
  s.summary       = "A Rails View Builder."
  s.description   = "A Rails View Builder gem."
  s.authors       = ["Ery wang"]
  s.email         = 'ery@baoleihang.com'
  s.files         = [
                      "lib/view_builder.rb",
                      "lib/view_builder/corekit.rb",
                      "lib/view_builder/i18n_text.rb",
                      "lib/view_builder/show_form.rb",
                      "lib/view_builder/show_model_form.rb",
                      "lib/view_builder/show_model_list.rb",
                      "lib/view_builder/show_model_view.rb",
                      "lib/view_builder/builders/form_builder.rb",
                      "lib/view_builder/builders/model_form_builder.rb",
                      "lib/view_builder/builders/model_list_builder.rb",
                      "lib/view_builder/builders/model_view_builder.rb",
                      "lib/view_builder/builders/template_methods.rb"
                    ]
  s.homepage      = 'http://rubygems.org/gems/hola'
  s.require_paths = ["lib"]  
end


