# Deux builds : le site public (DA) et le back-office (Bootstrap par défaut).
# Isolation totale : retoucher les tokens publics ne touche jamais l'admin.
Rails.application.config.dartsass.builds = {
  "application.scss" => "application.css",
  "admin.scss"       => "admin.css"
}

# Expose les sources SCSS de Bootstrap (gem) + tait ses dépréciations connues.
bootstrap_scss = File.join(Gem.loaded_specs["bootstrap"].full_gem_path, "assets", "stylesheets")
Rails.application.config.dartsass.build_options.concat [
  "--load-path=#{bootstrap_scss}",
  "--quiet-deps",
  "--silence-deprecation=import"
]
