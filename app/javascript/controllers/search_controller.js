import { Controller } from "@hotwired/stimulus"
import {renderComicList} from "./utilities";

export default class extends Controller {
  static targets = ["input", "list"]

  connect() {
    this.inputTarget.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    if (event.key === 'Enter') {
      // Reset the page number to 0 when a new search is made
      this.page = 0
      this.fetchCharacter().then(r => {
        console.log('Connected to search controller. Page:', this.page)
      })
    }
  }

  async fetchCharacter() {
    const query = this.inputTarget.value
    let url = `/api/v1/comics`
    if (query.length > 0) {
      url = `${url}/character?name=${query}`
    }

    await fetch(url)
      .then(response => response.json())
      .then(data => {
        renderComicList(data)
        // Save the current search query to the session storage for pagination
        sessionStorage.setItem('activeQuery', JSON.stringify(query))
      })
      .catch(error => {
        console.error('Error fetching character:', error)
        this.listTarget.innerHTML = 'Error fetching character'
      })
  }
}
