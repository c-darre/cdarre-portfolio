# Expose les feuilles SCSS de Bootstrap (gem) au compilateur dart-sass,
# et coupe le bruit des dépréciations connues de Bootstrap 5.3.
#
# Contexte : Bootstrap 5.3 est écrit avec l'ancienne API Sass (@import,
# fonctions globales) — c'est l'API officiellement documentée jusqu'à la v6,
# qui passera au système de modules (@use). Les centaines de warnings viennent
# de LEUR code : on les tait de façon ciblée, sans masquer les nôtres.
bootstrap_scss = File.join(Gem.loaded_specs["bootstrap"].full_gem_path, "assets", "stylesheets")

Rails.application.config.dartsass.build_options.concat [
  "--load-path=#{bootstrap_scss}",
  "--quiet-deps",                  # tait les dépréciations émises dans les DÉPENDANCES (Bootstrap)
  "--silence-deprecation=import"   # tait la seule dépréciation déclenchée par NOS fichiers (@import)
]
