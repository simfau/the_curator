import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  // This is called after the form submission ends (if using data-turbo-stream)
  reset() {
    // Clear the value of the targeted input field
    this.inputTarget.value = ""
  }
}
