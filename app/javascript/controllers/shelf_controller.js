import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box", "actionButton", "input"]

  blurInput() {
    this.inputTarget.blur()
  }

  updateButtons() {
    const isEmpty = !this.boxTargets.some(box =>
      box.querySelector(".shelf-item")
    )
    this.actionButtonTargets.forEach(btn => {
      btn.classList.toggle("disabled", isEmpty)
      btn.disabled = isEmpty
    })
  }
  select(event) {
    const clickedCube = event.currentTarget
    const sourceId = clickedCube.id
    const movieTitle = clickedCube.dataset.shelfTitleParam
    const movieImage = clickedCube.dataset.shelfImageParam
    const emptyBox = this.boxTargets.find(box => !box.querySelector(".shelf-item"))
    const format = clickedCube.dataset.shelfFormatParam
    const creator = clickedCube.dataset.shelfCreatorParam


   if (!emptyBox) {
    document.getElementById("custom-alert").classList.remove("hidden")
    return
  }
    this.inputTarget.value = ""
    this.actionButtonTargets.forEach(btn => {
      const url = new URL(btn.href)
      const params = url.searchParams
      params.append("content_ids[]", sourceId)
      btn.href = url.toString()
    })

    clickedCube.classList.add("picked")
    emptyBox.innerHTML = format == "movie" ?`

        <div class="shelf-item position-relative d-flex justify-content-center">
          <img src="${movieImage}" alt="${movieTitle}" class="img-fluid">

        <button
          type="button"
          class="btn btn-sm btn-light position-absolute shelf-remove-button rounded-circle"
          data-action="click->shelf#remove touchend->shelf#remove"
          data-source-id="${sourceId}"
        >
          ×
        </button>
      </div>
    ` :`
    <div class="shelf-item position-relative">
          <img src="${movieImage}" alt="${movieTitle}" class="img-fluid">
          <div class="song-title d-flex mt-auto">
            <h5 class="text-center mb-0">${movieTitle}</h5>
            <p class="mb-0">${creator}</p>
          </div>
        <button
          type="button"
          class="btn btn-sm btn-light position-absolute shelf-remove-button rounded-circle"
          data-action="click->shelf#remove touchend->shelf#remove"
          data-source-id="${sourceId}"
        >
          ×
        </button>
      </div>`

    this.updateButtons()

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
      this.updateButtons()
      this.actionButtonTargets.forEach(btn => {
          const url = new URL(btn.href)
          const params = url.searchParams
          params.delete("content_ids[]", sourceId)
          btn.href = url.toString()
        })
      if (boxTarget) {

        boxTarget.innerHTML = `
          <div class="d-flex align-items-center justify-content-center text-muted">
            <div class="placeholder d-flex justify-content-center"></div>
          </div>
        `;
      }
    }
  }
}
