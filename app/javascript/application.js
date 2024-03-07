// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "echarts"

echarts.registerTheme('finb', {
  backgroundColor: 'oklch(var(--background))',
  label: {
    color: 'oklch(var(--foreground))'
  },
  legend: {
    textStyle: {
      fontFamily: 'Inter var',
      color: 'oklch(var(--foreground))'
    }
  },
  title: {
    textStyle: {
      fontFamily: 'Inter var',
      color: 'oklch(var(--primary))'
    }
  }
})
