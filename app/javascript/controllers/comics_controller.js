import { Controller } from "@hotwired/stimulus"
import {addHeartIcon, renderComicList} from "./utilities";

export default class extends Controller {
  static targets = ["list", "pagination", "hover"]

  connect() {
    sessionStorage.removeItem('activeQuery')
    this.page = 0
    this.fetchComics(this.page).then(r => {
      console.log('Connected to comics controller. Page:', this.page)
    })
  }

  onClick(event) {
    const clickedElement = event.currentTarget
    const comicId = clickedElement.dataset.id

    // Get the liked comics from the session storage or an empty array
    let likedComics = JSON.parse(sessionStorage.getItem('likedComics')) || []

    // If the comic is not in the liked comics array, add it
    if (!likedComics.includes(comicId)) {
      likedComics.push(comicId)
      sessionStorage.setItem('likedComics', JSON.stringify(likedComics))
    } else {
      // If the comic is already in the liked comics array, remove it
      likedComics = likedComics.filter(id => id !== comicId)
      sessionStorage.setItem('likedComics', JSON.stringify(likedComics))
    }

    // Remove the heart icon if it exists, otherwise add it
    let image = clickedElement.querySelector('.heart-icon')
    if (image) {
      image.remove()
    } else {
      addHeartIcon(clickedElement)
    }
  }

  mouseOver(event) {
    const hoverElement = event.currentTarget

    let overlay = hoverElement.querySelector('.text-overlay')
    if (!overlay) {
      overlay = document.createElement('div')
      overlay.classList.add('text-overlay')
      // Use the comic data title attribute as the overlay text
      overlay.innerText = hoverElement.dataset.title
      hoverElement.appendChild(overlay)
    } else {
      overlay.remove()
    }

    const image = hoverElement.querySelector('img')
    if (image) {
      image.classList.toggle('image-opacity')
    }
  }

  mouseOut(event) {
    const hoverElement = event.currentTarget
    hoverElement.classList.remove('inner-box-shadow')
    let overlay = hoverElement.querySelector('.text-overlay')
    if (overlay) {
      overlay.remove()
    }

    const image = hoverElement.querySelector('img')
    if (image) {
      image.classList.toggle('image-opacity')
    }
  }

  nextPage() {
    if (this.page === 0) {
      const previousPageBtn = document.getElementById('previous-page')
      previousPageBtn.classList.remove('opacity-70')
      previousPageBtn.disabled = false
    }

    this.page += 1

    this.fetchComics(this.page).then(r => {
      console.log(`Page ${this.page} loaded`)
    })
  }

  previousPage() {
    if (this.page > 0) {
      this.page -= 1
      let searchInput = document.getElementById('search-input')
      const query = searchInput?.value
      this.fetchComics(this.page).then(r => {
        console.log(`Page ${this.page} loaded`)
      })
    } else {
      const previousPageBtn = document.getElementById('previous-page')
      previousPageBtn.disabled = true
    }
  }

  async fetchComics(page) {
    const nextPageBtn = document.getElementById('next-page')
    nextPageBtn.disabled = true

    // Get the current search query from the session storage
    const activeQuery = JSON.parse(sessionStorage.getItem('activeQuery'))?.trim()
    console.log('Active query:', activeQuery)

    // Initialize the URL to the default comics endpoint
    let url = `/api/v1/comics?page=${page}`

    // Check if activeQuery is a non-empty string
    if (typeof activeQuery === 'string' && activeQuery.length > 0) {
      url = `/api/v1/comics/character?name=${encodeURIComponent(activeQuery)}&page=${page}`
    }

    try {
      const response = await fetch(url)
      const data = await response.json()
      await renderComicList(data)
      this.paginationTarget.classList.remove('invisible')
    } catch (error) {
      console.error('Error fetching comics:', error)
    } finally {
      nextPageBtn.disabled = false
    }
  }
}
