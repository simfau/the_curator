import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shelf"
export default class extends Controller {
  static targets = ["box"]
  select(event) {
    const clickedCube = event.currentTarget
    const movieTitle = clickedCube.dataset.shelfTitleParam
    const movieImage = clickedCube.dataset.shelfImageParam
      console.log(`selected: ${movieTitle}`);
      console.log(`image URL: ${movieImage}`);
    this.boxTarget.innerText=movieTitle
  }
}
