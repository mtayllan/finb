# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "date-fns" # @4.1.0
pin "stimulus-use" # @0.52.3
pin "echarts", to: "echarts.min.js"
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.12
