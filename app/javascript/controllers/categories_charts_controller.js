import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    expenses: Array,
    income: Array,
  }

  static targets = ["income", "expenses"]

  connect() {
    this.buildPieChart(this.incomeValue, this.incomeTarget, 'Income by Category')
    this.buildPieChart(this.expensesValue, this.expensesTarget, 'Expenses by Category')
  }

  buildPieChart(data, chartElement, title) {
    const chart = echarts.init(chartElement, 'finb', { renderer: 'svg' });
    window.addEventListener('resize', function () {
      chart.resize();
    });
    chart.setOption({
      tooltip: {
        trigger: 'item'
      },
      legend: {
        top: '10%',
        left: 'center'
      },
      title: {
        text: title,
        left: 'center',
      },
      series: [
        {
          top: "12%",
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
          },
          label: {
            show: false,
            position: 'center'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: '1rem',
              fontWeight: 'bold'
            }
          },
          labelLine: {
            show: false
          },
          data: data.map((item) => {
            return {
              value: item.value,
              name: item.name,
              itemStyle: {
                color: item.color
              },
              tooltip: {
                valueFormatter: (value) => `$${value}`
              }
            }
          })
        }
      ]
    })

  }
}
