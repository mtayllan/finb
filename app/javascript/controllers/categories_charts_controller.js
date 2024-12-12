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

    const sortedData = data.sort((a, b) => b.value - a.value);
    const maxSegments = 9; // To reserve one slot for "Others"
    const processedData = {
      mainSegments: sortedData.slice(0, maxSegments).map(item => ({
        value: item.value,
        name: item.name,
        itemStyle: {
          color: item.color
        },
      })),
      smallSegments: sortedData.slice(maxSegments)
    };
    if (processedData.smallSegments.length > 0) {
      const othersValue = processedData.smallSegments.reduce((sum, item) => sum + parseFloat(item.value), 0);
      const total = data.reduce((sum, item) => sum + parseFloat(item.value), 0);

      processedData.mainSegments.push({
        name: 'Others',
        value: othersValue,
        itemStyle: { color: '#999' },  // Grey color for Others
        tooltip: {
          formatter: (params) => {
            const segments = processedData.smallSegments
              .map(item => `${item.name}: $${item.value} (${((item.value / total) * 100).toFixed(1)}%)`)
              .join('<br/>');
            return `Others: $${othersValue} (${(params.percent).toFixed(1)}%)<br/>${segments}`;
          }
        }
      });
    }

    chart.setOption({
      tooltip: {
        trigger: 'item',
        formatter: '{b}: ${c} ({d}%)'
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
          data: processedData.mainSegments,
        }
      ]
    })

  }
}
