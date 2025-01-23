import { Controller } from "@hotwired/stimulus"

const MAX_ROWS = 25

export default class extends Controller {
  static targets = [ "cell", "item" ]
  static values = { date: String }

  cellTargetConnected(target) {
    const dt = new Date(target.dataset.datetime)
    target.classList.toggle("future", dt > new Date())
    target.classList.toggle("current-hour", this.#isCurrentHour(dt))
  }

  itemTargetConnected(target) {
    const dt = new Date(target.dataset.datetime)
    target.classList.toggle("out-of-range", !this.#dateIsToday(dt))
    target.style.gridRowStart = MAX_ROWS - dt.getHours()
  }

  #dateIsToday(dt) {
    const date = new Date(this.dateValue)
    return dt.getYear() == date.getYear() &&
      dt.getMonth() == date.getMonth() &&
      dt.getDay() == date.getDay()
  }

  #isCurrentHour(dt) {
    const now = new Date()
    const utcHour = dt.getUTCHours()
    const localHour = now.getHours()
    return utcHour === localHour
  }
}
