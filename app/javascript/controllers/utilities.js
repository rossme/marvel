// This file contains utility functions that are used in the stimulus controllers

export async function renderComicList(data) {
  const comicList = document.getElementById('comic-list')
  comicList.innerHTML = data.map(comic => `
    <div class="relative bg-black shadow-md overflow-hidden mx-1" data-comics-target="hover" data-action="mouseover->comics#mouseOver mouseout->comics#mouseOut click->comics#onClick"" data-id="${comic['id']}" data-title="${comic['title']}">
      <!-- Load the comic thumbnail image -->
      <img src="${comic['thumbnail']}" alt="Comic Image" class="w-full h-auto">
    </div>
  `).join('')

  let likedComics = JSON.parse(sessionStorage.getItem('likedComics'))
  likedComics.forEach(comicId => {
    let element = document.querySelector(`[data-id="${comicId}"]`)
    if (element) {
      addHeartIcon(element)
    }
  })
}

// Add the heart icon to the liked comics
export function addHeartIcon(element) {
  let image = document.createElement('img')
  image.src = '/assets/heart_on.png'
  image.alt = 'Love Heart'
  image.classList.add('heart-icon')
  element.appendChild(image)
}
