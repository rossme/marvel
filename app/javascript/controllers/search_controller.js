import { Controller } from "@hotwired/stimulus"
import {renderComicList} from "./utilities";

export default class extends Controller {
  static targets = ["input", "list"]

  connect() {
    this.inputTarget.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    if (event.key === 'Enter') {
      this.fetchCharacter()
    }
  }

  fetchCharacter() {
    const query = this.inputTarget.value
    let url = `/api/v1/comics`
    if (query.length > 0) {
      url = `${url}/character?name=${query}`
    }

    fetch(url)
      .then(response => response.json())
      .then(data => {
        renderComicList(data)
      })
      .catch(error => {
        console.error('Error fetching character:', error)
        this.listTarget.innerHTML = 'Error fetching character'
      })
  }
}
