import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box"]

  select(event) {
    const clickedCube = event.currentTarget
    const movieTitle = clickedCube.dataset.shelfTitleParam
    const movieImage = clickedCube.dataset.shelfImageParam
    const isDuplicate = this.boxTargets.some(box => box.innerHTML.includes(movieImage))
    if (isDuplicate) {
      window.alert("You have alzheimer? Content already chosen")
      return
    }

    const emptyBox = this.boxTargets.find(box => !box.querySelector(".shelf-item"))

    if (!emptyBox) {
      window.alert("Shelf is full!")
      return
    }

    emptyBox.innerHTML = `
      <div class="shelf-item position-relative d-flex justify-content-center">
        <img src="${movieImage}" alt="${movieTitle}" class="img-fluid">

        <button
          type="button"
          class="btn btn-sm btn-light position-absolute top-0 end-0 rounded-circle"
          data-action="click->shelf#remove"
        >
          ×
        </button>
      </div>
    `
  }

  remove(event) {
    event.stopPropagation()
    const button = event.currentTarget
    const shelfItem = button.closest(".shelf-item")
    if (shelfItem) {
      shelfItem.remove()
    }
  }
}
