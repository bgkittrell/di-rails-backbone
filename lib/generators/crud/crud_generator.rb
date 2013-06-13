class CrudGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_crud_file
    copy_file "controller.rb", "app/controllers/#{plural_name}_controller.rb"
  end
end
