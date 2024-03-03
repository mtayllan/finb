import { Controller } from "@hotwired/stimulus"
import { format } from 'date-fns'

export default class extends Controller {
  static values = {
    balances: Array
  }

  connect() {
    const chartElement = this.element;
    const chart = echarts.init(chartElement, 'finb', { renderer: 'svg' });
    window.addEventListener('resize', function () {
      chart.resize();
    });

    chart.setOption({
      xAxis: {
        type: 'time',
      },
      yAxis: {
        type: 'value'
      },
      tooltip: {
        trigger: 'axis',
        formatter: (params) => {
          const date = new Date(params[0].value[0]);
          const formattedDate = format(date, 'd MMM, yyyy');
          const balance = params[0].value[1];
          return `Date: ${formattedDate}<br />Balance: $${balance}`;
        },
      },
      series: [{
        data: this.balancesValue,
        type: 'line',
        smooth: true,
        itemStyle: {
          color: 'white'
        },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            {
              offset: 0,
              color: 'rgba(255,255,255, 1)'
            },
            {
              offset: 1,
              color: 'rgba(255,255,255, 0)'
            }
          ])
        },
      }]
    })
  }
}
