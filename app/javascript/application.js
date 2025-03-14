// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "echarts"

echarts.registerTheme('finb', {
  label: {
    color: 'var(--color-base-content)'
  },
  legend: {
    textStyle: {
      fontFamily: 'Inter',
      color: 'var(--color-base-content)'
    }
  },
  title: {
    textStyle: {
      fontFamily: 'Inter',
      color: 'var(--color-base-content)'
    }
  },
  categoryAxis: {
    axisLabel: {
      fontFamily: 'Inter',
      color: "var(--color-base-content)"
    },
  },
  valueAxis: {
    axisLabel: {
      fontFamily: 'Inter',
      color: "var(--color-base-content)"
    },
  }
})
