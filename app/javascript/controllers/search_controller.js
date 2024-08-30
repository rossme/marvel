import { Controller } from "@hotwired/stimulus";
import { renderComicList } from "./common";

export default class extends Controller {
  static targets = ["input", "list"];

  connect() {
    this.inputTarget.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  handleKeydown(event) {
    if (event.key === 'Enter') {
      // Reset the page number when a new search is made
      this.page = 0;
      const nextPageBtn = document.getElementById('next-page');
      const previousPageBtn = document.getElementById('previous-page');
      nextPageBtn.disabled = true;
      previousPageBtn.disabled = true;
      this.fetchCharacter().then(r => {
        console.log('Connected to search controller. Page:', this.page);
        nextPageBtn.disabled = false;
        previousPageBtn.disabled = this.page <= 0;
      });
    }
  }

  async fetchCharacter() {
    const query = this.inputTarget.value;
    let url = `/api/v1/comics`;
    if (query.length > 0) {
      url = `${url}/character?name=${query}`;
    }

    await fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}, statusText: ${response.statusText}`);
        }

        return response.json();
      })
      .then(data => {
        renderComicList(data);
        // Save the current search query to the session storage for pagination
        sessionStorage.setItem('activeQuery', JSON.stringify(query));
      })
      .catch(error => {
        console.error('Error fetching character:', error);
        this.listTarget.innerHTML = 'Error fetching character';
      });
  }
}
