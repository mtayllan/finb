# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "date-fns", to: "https://ga.jspm.io/npm:date-fns@3.0.6/index.mjs"
pin "stimulus-use", to: "https://ga.jspm.io/npm:stimulus-use@0.52.2/dist/index.js"
pin "echarts", to: "echarts.min.js"
