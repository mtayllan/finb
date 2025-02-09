import { Controller } from "@hotwired/stimulus";
import { endOfMonth, format, parse } from "date-fns";
import { useClickOutside } from 'stimulus-use';

export default class extends Controller {
  static targets = ["months", "currentYearLabel", "calendar", "input"]

  connect() {
    useClickOutside(this);
    let initialDate;
    if (this.inputTarget.value) {
      initialDate = parse(this.inputTarget.value, 'MMM yyyy', new Date());
    } else {
      initialDate = endOfMonth();
    }
    this.currentYear = initialDate.getFullYear();
    this.selectedMonth = new Date(this.currentYear, initialDate.getMonth(), 1);

    this.renderCalendar();
  }

  clickOutside() {
    this.closeCalendar();
  }

  renderCalendar() {
    this.currentYearLabelTarget.innerText = this.currentYear;
    Array.from(this.monthsTarget.children).forEach((month, monthIdx) => {
      if (monthIdx === this.selectedMonth.getMonth() && this.currentYear === this.selectedMonth.getFullYear()) {
        month.classList.add('bg-primary', 'text-primary-foreground', 'hover:bg-primary', 'hover:text-primary-foreground', 'focus:bg-primary', 'focus:text-primary-foreground');
      } else {
        month.classList.remove('bg-primary', 'text-primary-foreground', 'hover:bg-primary', 'hover:text-primary-foreground', 'focus:bg-primary', 'focus:text-primary-foreground');
      }
    });
  }

  openCalendar() {
    const calendarRectBottom = this.element.getBoundingClientRect().bottom;
    if (calendarRectBottom + 280 > window.innerHeight) {
      this.calendarTarget.style.top = 'auto';
      this.calendarTarget.style.bottom = '100%';
    }
    this.calendarTarget.classList.remove('hidden');
  }

  closeCalendar() {
    this.calendarTarget.classList.add('hidden');
  }

  selectMonth(event) {
    this.selectedMonth = new Date(this.currentYear, event.params.monthNumber - 1, 1);
    this.inputTarget.value = format(this.selectedMonth, 'MMM yyyy');

    this.renderCalendar();
  }

  nextYear() {
    this.currentYear += 1;
    this.renderCalendar();
  }

  previousYear() {
    this.currentYear -= 1;
    this.renderCalendar();
  }
}
