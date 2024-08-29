// This file contains utility functions that are used in the stimulus controllers

export function renderComicList(data) {
  const comicList = document.getElementById('comic-list')
  comicList.innerHTML = data.map(comic => `
    <div class="relative bg-black shadow-md overflow-hidden mx-1 hover:opacity-70">
      <!-- Load the image thumbnail -->
      <img src="${comic['thumbnail']}" alt="Comic Image" class="w-full h-auto">
      <!-- <div class="p-4"> -->
      <!-- Load the title and description -->
      <!--   <h2 class="text-xl font-bold">${comic['title']}</h2> -->
      <!--   <p class="text-sm text-gray-600">${comic['id']}</p> -->
      <!-- </div> -->
      <div class="inner-box-shadow absolute inset-0"></div>
    </div>
  `).join('')
}
