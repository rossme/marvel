import { Controller } from "@hotwired/stimulus";
import { addHeartIcon, renderComicList } from "./common";

export default class extends Controller {
  static targets = ["list", "pagination", "hover"];

  connect() {
    // Remove the active search query from the session storage when the controller is connected
    sessionStorage.removeItem('activeQuery');

    // Initialize the page number to 0 and disable the previous page button
    this.page = 0;
    const previousPageBtn = document.getElementById('previous-page');
    previousPageBtn.disabled = true;

    // Fetch the comics data for the current page
    this.fetchComics(this.page).then(r => {
      this.paginationTarget.classList.remove('invisible');
      console.log('Connected to comics controller. Page:', this.page);
    });
  }

  onClick(event) {
    event.preventDefault();

    const clickedElement = event.currentTarget;
    const comicId = clickedElement.dataset.id;

    // Get an Array of current favourite comic ids from the session storage
    let likedComics = JSON.parse(sessionStorage.getItem('likedComics')) || [];

    // If the comic is not in the favourite array, add it
    if (!likedComics.includes(comicId)) {
      likedComics.push(comicId);
      sessionStorage.setItem('likedComics', JSON.stringify(likedComics));
    } else {
      // If the comic is already in the favourite array, remove it
      likedComics = likedComics.filter(id => id !== comicId);
      sessionStorage.setItem('likedComics', JSON.stringify(likedComics));
    }

    // Remove the heart icon if it exists, otherwise add it
    let image = clickedElement.querySelector('.heart-icon');
    if (image) {
      image.remove();
    } else {
      addHeartIcon(clickedElement);
    }
  }

  mouseOver(event) {
    event.preventDefault();

    const hoverElement = event.currentTarget;

    let overlay = hoverElement.querySelector('.text-overlay');
    if (!overlay) {
      overlay = document.createElement('div');
      overlay.classList.add('text-overlay');

      // Use the comic data title attribute as the overlay text
      overlay.innerText = hoverElement.dataset.title;
      hoverElement.appendChild(overlay);
    } else {
      overlay.remove();
    }

    const image = hoverElement.querySelector('img');
    if (image) {
      image.classList.toggle('image-opacity');
    }
  }

  mouseOut(event) {
    event.preventDefault();

    const hoverElement = event.currentTarget;
    hoverElement.classList.remove('inner-box-shadow');
    let overlay = hoverElement.querySelector('.text-overlay');
    if (overlay) {
      overlay.remove();
    }

    const image = hoverElement.querySelector('img');
    if (image) {
      image.classList.toggle('image-opacity');
    }
  }

  nextPage(event) {
    event.preventDefault();

    this.changePage(true);
  }

  previousPage(event) {
    event.preventDefault();

    this.changePage(false);
  }

  changePage(isNext) {
    if (isNext) {
      this.page += 1;
    } else {
      this.page -= 1;
    }

    const previousPageBtn = document.getElementById('previous-page');
    previousPageBtn.disabled = this.page === 0;

    this.fetchComics(this.page).then(r => {
      console.log(`Page ${this.page} loaded`);
    });
  }

  async fetchComics(page) {
    // To prevent additional API calls, disable the next and previous page buttons when fetching data
    const nextPageBtn = document.getElementById('next-page');
    nextPageBtn.disabled = true;
    const previousPageBtn = document.getElementById('previous-page');
    previousPageBtn.disabled = true;

    // Get the active search query from the session storage
    const activeQuery = JSON.parse(sessionStorage.getItem('activeQuery'))?.trim();
    console.log('Active query:', activeQuery);

    // Initialize the URL to the default comics endpoint
    let url = `/api/v1/comics?page=${page}`;

    // Check if activeQuery is a non-empty string
    if (typeof activeQuery === 'string' && activeQuery.length > 0) {
      url = `/api/v1/comics/character?name=${encodeURIComponent(activeQuery)}&page=${page}`;
    }

    await fetch(url)
      .then(response => {
        if (!response.ok) {
          return response.json().then(err => {
            throw new Error(`HTTP error! status: ${response.status}, message: ${err.errors}`);
          });
        }

        return response.json();
      })
      .then(data => {
        renderComicList(data);
        nextPageBtn.disabled = false;
        previousPageBtn.disabled = page <= 0;
      })
      .catch(error => {
        console.error('Error fetching comics:', error);
      });
  }
}
