import { Controller } from "@hotwired/stimulus"
import { HttpStatus } from "helpers/http_helpers"

export default class extends Controller {
  static targets = [ "input", "form", "confirmation" ]
  static classes = [ "error", "confirmation", "help" ]

  disconnect() {
    if (this.waitingForConfirmation) { this.#reset() }
  }

  // Actions

  focus() {
    this.inputTarget.focus()
  }

  executeCommand(event) {
    if (this.#showHelpCommandEntered) {
      this.#showHelpMenu()
      event.preventDefault()
      event.stopPropagation()
    } else {
      this.hideHelpMenu()
    }
  }

  hideHelpMenu() {
    if (this.#showHelpCommandEntered) { this.#reset() }
    this.element.classList.remove(this.helpClass)
  }

  handleKeyPress(event) {
    if (this.waitingForConfirmation) {
      this.#handleConfirmationKey(event.key.toLowerCase())
      event.preventDefault()
    }
  }

  handleCommandResponse(event) {
    if (event.detail.success) {
      this.#reset()
    } else {
      const response = event.detail.fetchResponse.response
      this.#handleErrorResponse(response)
    }
  }

  restoreCommand(event) {
    const target = event.target.querySelector("[data-line]") || event.target
    if (target.dataset.line) {
      this.#reset(target.dataset.line)
      this.focus()
    }
  }

  hideError() {
    this.element.classList.remove(this.errorClass)
  }

  get #showHelpCommandEntered() {
    return [ "/help", "/?" ].includes(this.inputTarget.value)
  }

  #showHelpMenu() {
    this.element.classList.add(this.helpClass)
  }

  get #isHelpMenuOpened() {
    return this.element.classList.contains(this.helpClass)
  }

  async #handleErrorResponse(response) {
    const status = response.status
    const message = await response.text()

    if (status === HttpStatus.UNPROCESSABLE) {
      this.#showError()
    } else if (status === HttpStatus.CONFLICT) {
      this.#requestConfirmation(message)
    }
  }

  #reset(inputValue = "") {
    this.formTarget.reset()
    this.inputTarget.value = inputValue
    this.confirmationTarget.value = ""
    this.waitingForConfirmation = false
    this.originalInputValue = null

    this.element.classList.remove(this.errorClass)
    this.element.classList.remove(this.confirmationClass)
  }

  #showError() {
    this.element.classList.add(this.errorClass)
  }

  async #requestConfirmation(message) {
    this.originalInputValue = this.inputTarget.value
    this.element.classList.add(this.confirmationClass)
    this.inputTarget.value = `${message}? [Y/n] `

    this.waitingForConfirmation = true
  }

  #handleConfirmationKey(key) {
    if (key === "enter" || key === "y") {
      this.#submitWithConfirmation()
    } else if (key === "escape" || key === "n") {
      this.#reset(this.originalInputValue)
    }
  }

  #submitWithConfirmation() {
    this.inputTarget.value = this.originalInputValue
    this.confirmationTarget.value = "confirmed"
    this.formTarget.requestSubmit()
  }
}
