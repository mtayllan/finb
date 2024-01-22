import { Controller } from "@hotwired/stimulus";
import {
  eachDayOfInterval,
  startOfToday, endOfMonth, endOfWeek, startOfWeek,
  format, parse, parseISO, add, getDay,
  isEqual, isToday, isSameMonth
} from "date-fns";
import { useClickOutside } from 'stimulus-use';

export default class extends Controller {
  static targets = ["days", "currentMonth", "calendar", "input"]

  connect() {
    let initialDate;
    if (this.inputTarget.value) {
      initialDate = parse(this.inputTarget.value, 'dd/MM/yyyy', new Date());
    } else {
      initialDate = startOfToday();
    }
    this.currentMonth = format(initialDate, 'MMM-yyyy');
    this.selectedDay = initialDate;
    this.renderCalendar();
    useClickOutside(this);
  }

  clickOutside() {
    this.closeCalendar();
  }

  openCalendar() {
    this.calendarTarget.classList.remove('hidden');
  }

  closeCalendar() {
    this.calendarTarget.classList.add('hidden');
  }

  renderCalendar() {
    this.renderDays();
    this.renderSelectedDay();
    this.renderCurrentMonth();
  }

  renderDays() {
    const firstDayCurrentMonth = parse(this.currentMonth, 'MMM-yyyy', new Date());

    this.days = eachDayOfInterval({
      start: startOfWeek(firstDayCurrentMonth),
      end: endOfWeek(endOfMonth(firstDayCurrentMonth)),
    })

    this.daysTarget.innerHTML = '';

    this.days.forEach((day, dayIdx) => {
      const container = document.createElement('div');
      container.classList.add('day');
      if (dayIdx === 0 && COL_START_CLASSES[getDay(day)]) container.classList.add(COL_START_CLASSES[getDay(day)])

      const button = document.createElement('button');
      button.type = 'button';
      button.classList.add('mx-auto', 'flex', 'h-8', 'w-8', 'items-center', 'justify-center', 'rounded-full');
      const dayIsEqualToSelectedDay = isEqual(day, this.selectedDay);
      const dayIsToday = isToday(day);
      const dayIsSameMonth = isSameMonth(day, firstDayCurrentMonth);

      if (dayIsEqualToSelectedDay) button.classList.add('text-white');
      if (!dayIsEqualToSelectedDay && dayIsToday) button.classList.add('text-blue-500');
      if (!dayIsEqualToSelectedDay && !dayIsToday && dayIsSameMonth) button.classList.add('text-gray-900');
      if (!dayIsEqualToSelectedDay && !dayIsToday && !dayIsSameMonth) button.classList.add('text-gray-400');
      if (dayIsEqualToSelectedDay && dayIsToday) button.classList.add('bg-blue-500');
      if (dayIsEqualToSelectedDay && !dayIsToday) button.classList.add('bg-gray-900');
      if (!dayIsEqualToSelectedDay) button.classList.add('hover:bg-gray-200');
      if (dayIsEqualToSelectedDay || dayIsToday) button.classList.add('font-semibold');

      button.dataset['action'] = 'date-picker#selectDay';

      const time = document.createElement('time');
      time.dateTime = format(day, 'yyyy-MM-dd');
      time.textContent = format(day, 'd');

      button.appendChild(time);
      container.appendChild(button);

      this.daysTarget.appendChild(container);
    });
  }

  renderSelectedDay() {
    this.inputTarget.value = format(this.selectedDay, 'dd/MM/yyyy');
  }

  renderCurrentMonth() {
    const firstDayCurrentMonth = parse(this.currentMonth, 'MMM-yyyy', new Date());
    this.currentMonthTarget.textContent = format(firstDayCurrentMonth, 'MMMM yyyy');
  }

  selectDay(event) {
    this.selectedDay = parseISO(event.currentTarget.querySelector('time').dateTime);
    this.renderCalendar();
    this.closeCalendar();
  }

  quickSelect(event) {
    this.selectedDay = parse(event.params.value, 'dd/MM/yyyy', new Date());
    this.renderCalendar();
    this.closeCalendar();
  }

  nextMonth() {
    const firstDayCurrentMonth = parse(this.currentMonth, 'MMM-yyyy', new Date());
    const firstDayNextMonth = add(firstDayCurrentMonth, { months: 1 });
    this.currentMonth = format(firstDayNextMonth, 'MMM-yyyy');
    this.renderCalendar();
  }

  previousMonth() {
    const firstDayCurrentMonth = parse(this.currentMonth, 'MMM-yyyy', new Date());
    const firstDayPreviousMonth = add(firstDayCurrentMonth, { months: -1 });
    this.currentMonth = format(firstDayPreviousMonth, 'MMM-yyyy');
    this.renderCalendar();
  }

}

const COL_START_CLASSES = [
  '',
  'col-start-2',
  'col-start-3',
  'col-start-4',
  'col-start-5',
  'col-start-6',
  'col-start-7',
]
