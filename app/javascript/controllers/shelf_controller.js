import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box"]

  select(event) {
    const clickedCube = event.currentTarget
    const movieTitle = clickedCube.dataset.shelfTitleParam
    const movieImage = clickedCube.dataset.shelfImageParam
    const emptyBox = this.boxTargets.find(box => box.innerHTML === `<div class="placeholder d-flex justify-content-center"></div>`)
    if (emptyBox) {
      emptyBox.innerText = movieTitle
      emptyBox.innerHTML = `<img src="${movieImage}">`

    } else {
      console.log("Wow, wow, hold your spam big fella!")
    }
  }

  deselected(event) {
    const button = event.currentTarget
    const box = button.closest('[data-shelf-target="box"]')

    if (box) {
      box.innerHTML = ""
    }
  }
}
