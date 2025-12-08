import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box"]

  select(event) {
    const deleteButton = `
      <div data-action="click->shelf#remove"
      class="position-absolute top-0 text-danger bg-white rounded-circle shadow-sm d-flex align-items-center justify-content-center"
      style="cursor: pointer; width: 20px; height: 20px; font-size: 10px;">
      <i class="fa-solid fa-xmark"></i>
      </div>`
    const clickedCube = event.currentTarget
    const movieTitle = clickedCube.dataset.shelfTitleParam
    const movieImage = clickedCube.dataset.shelfImageParam
    const emptyBox = this.boxTargets.find(box => box.innerHTML === `<div class="placeholder d-flex justify-content-center"></div>`)
    if (emptyBox) {
      emptyBox.innerText = movieTitle
      emptyBox.innerHTML = `<img src="${movieImage}">${deleteButton}`

    } else {
      console.log("Wow, wow, hold your spam big fella!")
    }
  }

}
