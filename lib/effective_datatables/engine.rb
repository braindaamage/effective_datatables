module EffectiveDatatables
  
  DT_OPS = {}

  class Engine < ::Rails::Engine
    engine_name 'effective_datatables'

    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    # Include Helpers to base application
    initializer 'effective_datatables.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper EffectiveDatatablesHelper
      end
    end

    # Set up our default configuration options.
    initializer "effective_datatables.defaults", :before => :load_config_initializers do |app|
      eval File.read("#{config.root}/lib/generators/templates/effective_datatables.rb")
    end

    initializer 'effective_datatables.load_options' do |app|
      begin
        DT_OPS.merge! YAML::load_file(Rails.root.join("config", "datatables.yml"))
        DT_OPS.symbolize_keys!
        DT_OPS.each do |key, val|
          DT_OPS[key].symbolize_keys! if DT_OPS[key].is_a?(Hash)
        end
      rescue
        puts "#{Time.zone.now} - [Error] No se pudo cargar el archivo datatables.yml"
      end
    end

  end
end
