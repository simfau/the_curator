import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box"]

  select(event) {
    const clickedCube = event.currentTarget
    const movieTitle = clickedCube.dataset.shelfTitleParam
    const movieImage = clickedCube.dataset.shelfImageParam
    const emptyBox = this.boxTargets.find(box => box.innerHTML === `<i class="fa-solid fa-plus"></i>`)
    if (emptyBox) {
      emptyBox.innerText = movieTitle
      emptyBox.innerHTML = `<img src="${movieImage}" class="img-fluid h-100 object-fit-contain">`

    } else {
      console.log("Wow, wow, hold your spam big fella!")
    }
  }
}
