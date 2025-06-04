import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "field", "option", "slider" ]

  optionChanged(e) {
    this.#setIndex(e.target.getAttribute("data-index"))
  }

  sliderChanged(e) {
    const index = e.target.value
    this.#setIndex(index)
    this.#setValue(index)
    console.log(index)
  }

  #setIndex(index) {
    this.fieldTarget.style.setProperty("--knob-index", `${index}`);
    this.sliderTarget.value = index;
  }

  #setValue(index) {
    const option = this.optionTargets.find(option => {
      return option.dataset.index === index;
    });

    option.checked = true;
  }
}
