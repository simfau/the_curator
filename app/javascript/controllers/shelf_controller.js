import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box", "link"]

  select(event) {
    const clickedCube = event.currentTarget
    const sourceId = clickedCube.id
    const movieTitle = clickedCube.dataset.shelfTitleParam
    const movieImage = clickedCube.dataset.shelfImageParam
    const emptyBox = this.boxTargets.find(box => !box.querySelector(".shelf-item"))

    if (!emptyBox) {
      window.alert("Shelf is full!")
      return
    }
    const url = new URL(this.linkTarget.href)
    const params = url.searchParams
    params.append("content_ids[]", sourceId)
    this.linkTarget.href = url.toString()

    clickedCube.classList.add("picked")
    emptyBox.innerHTML = `
        <div class="shelf-item position-relative d-flex justify-content-center">
          <img src="${movieImage}" alt="${movieTitle}" class="img-fluid">

        <button
          type="button"
          class="btn btn-sm btn-light position-absolute top-0 end-0 rounded-circle"
          data-action="click->shelf#remove"
          data-source-id="${sourceId}"
        >
          ×
        </button>
      </div>
    `
  }

  remove(event) {
    event.stopPropagation()
    const button = event.currentTarget
    const sourceId = button.dataset.sourceId
    const shelfItem = button.closest(".shelf-item")
    const boxTarget = button.closest("[data-shelf-target='box']")

    const originalMovieId = button.dataset.sourceId



    const originalMovieCard = document.getElementById(originalMovieId)

    if (originalMovieCard) {
      originalMovieCard.classList.remove("picked")
    }
    if (shelfItem) {
      shelfItem.remove()
      if (boxTarget) {
        const url = new URL(this.linkTarget.href)
        const params = url.searchParams
        params.delete("content_ids[]", sourceId)
        this.linkTarget.href = url.toString()

        boxTarget.innerHTML = `
          <div class="d-flex align-items-center justify-content-center text-muted">
            <div class="placeholder d-flex justify-content-center"></div>
          </div>
        `;
      }
    }
  }
}
