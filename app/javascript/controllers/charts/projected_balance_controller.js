import { Controller } from "@hotwired/stimulus"
import { format, parseISO } from 'date-fns'

export default class extends Controller {
  static values = { balances: Array }

  connect() {
    const chart = echarts.init(this.element, 'finb', { renderer: 'svg' });
    window.addEventListener('resize', function () {
      chart.resize();
    });

    chart.setOption({
      xAxis: {
        type: 'category',
        data: this.balancesValue.map(point => format(parseISO(point[0]), 'MMM/yy')),
      },
      yAxis: {
        type: 'value'
      },
      tooltip: {
        trigger: 'axis',
        formatter: (params) => {
          return `${params[0].axisValue}<br />Balance: ${params[0].value}`;
        },
      },
      series: [{
        data: this.balancesValue.map(point => point[1]),
        type: 'line',
        smooth: true,
        itemStyle: {
          color: 'var(--color-primary)',
        },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'var(--color-primary)' },
            { offset: 1, color: 'var(--color-base-100)' }
          ])
        },
        emphasis: {
          disabled: true
        }
      }]
    })
  }
}
