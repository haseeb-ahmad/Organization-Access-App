// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import NestedFormController from "./controllers/nested_form_controller";
application.register("nested-form", NestedFormController);