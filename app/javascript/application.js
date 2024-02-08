// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "echarts"

echarts.registerTheme('finb', {
  backgroundColor: 'hsl(var(--background))',
  label: {
    color: 'hsl(var(--foreground))'
  },
  legend: {
    textStyle: {
      fontFamily: 'Inter var',
      color: 'hsl(var(--foreground))'
    }
  },
  title: {
    textStyle: {
      fontFamily: 'Inter var',
      color: 'hsl(var(--primary))'
    }
  }
})
