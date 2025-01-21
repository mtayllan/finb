import { Controller } from "@hotwired/stimulus"
import { format, parseISO } from 'date-fns'

const FORMAT_BY_GRANULARITY = {
  day: 'MMM d',
  week: "'w'II/yy",
  month: 'MMM/yy',
}

export default class extends Controller {
  static values = { expenses: Array, income: Array, granularity: String }

  connect() {
    const chart = echarts.init(this.element, 'finb', { renderer: 'svg' });
    window.addEventListener('resize', function () {
      chart.resize();
    });
    chart.setOption({
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        }
      },
      xAxis: {
        type: 'category',
        data: this.expensesValue.map(expense => format(parseISO(expense[0]), FORMAT_BY_GRANULARITY[this.granularityValue])),
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          name: "Expenses",
          type: "bar",
          data: this.expensesValue.map(expense => expense[1] * -1),
          emphasis: {
            focus: 'series'
          },
          itemStyle: {
            color: '#f97315'
          }
        },
        {
          name: "Income",
          type: "bar",
          data: this.incomeValue.map(income => income[1]),
          emphasis: {
            focus: 'series'
          },
          itemStyle: {
            color: '#3b83f6'
          }
        }
      ]
    })
  }
}
