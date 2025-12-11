import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transition-page"
export default class extends Controller {
  static targets = ["overlay"]

  trigger(event) {
    console.log("Meme Triggered!")
    this.overlayTarget.classList.remove("hidden")
  }
}
