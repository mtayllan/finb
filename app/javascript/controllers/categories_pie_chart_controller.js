import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { data: Array, title: String }

  connect() {
    const chart = echarts.init(this.element, 'finb', { renderer: 'svg' });
    window.addEventListener('resize', function () {
      chart.resize();
    });
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
        text: this.titleValue,
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
          data: this.dataValue.map((item) => {
            return {
              value: item.value,
              name: item.name,
              itemStyle: {
                color: item.color
              },
            }
          })
        }
      ]
    })
  }

  buildPieChart(data, chartElement, title) {


  }
}
