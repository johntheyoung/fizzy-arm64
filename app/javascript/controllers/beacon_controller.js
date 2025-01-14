import { post } from "@rails/request.js"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    post(this.urlValue, { responseKind: "turbo-stream" })
  }
}
