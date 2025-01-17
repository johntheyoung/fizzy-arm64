Rails.application.config.after_initialize do
  Rails::HTML5::SafeListSanitizer.allowed_tags.merge(%w[ s table tr td th thead tbody details summary ])
  Rails::HTML5::SafeListSanitizer.allowed_attributes.merge(%w[ data-local-time-target data-delimiter ])
end
