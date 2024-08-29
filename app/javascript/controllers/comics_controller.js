import { Controller } from "@hotwired/stimulus"
import {renderComicList} from "./utilities";

export default class extends Controller {
  static targets = ["list", "pagination"]

  connect() {
    this.fetchComics()
  }

  nextPage(event) {
    this.fetchComics()
  }

  previousPage(event) {
    this.fetchComics()
  }

  fetchComics() {
    const url = '/api/v1/comics'
    fetch(url)
      .then(response => response.json())
      .then(data => {
        renderComicList(data)
        // Remove the hidden class from the pagination component
        this.paginationTarget.classList.remove('invisible')
      })
      .catch(error => {
        console.error('Error fetching comics:', error)
        this.listTarget.innerHTML = 'Error fetching comics'
      })
  }
}
