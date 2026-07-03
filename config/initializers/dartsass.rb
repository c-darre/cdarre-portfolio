# Expose les feuilles SCSS de Bootstrap (fournies par la gem) au compilateur dart-sass.
bootstrap_scss = File.join(Gem.loaded_specs["bootstrap"].full_gem_path, "assets", "stylesheets")
Rails.application.config.dartsass.build_options << "--load-path=#{bootstrap_scss}"
