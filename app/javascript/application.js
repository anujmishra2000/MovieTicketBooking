// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// import * as bootstrap from "bootstrap"
import "./channels"

document.addEventListener('click', function(e) {
  var dropdownToggles = document.querySelectorAll('.dropdown-toggle');
  var dropdownMenu = document.querySelector('.dropdown-menu');
  var dropdownToggle = e.target.closest('.dropdown-toggle');
  if (!dropdownToggle) {
    dropdownMenu.classList.remove('show');
    return;
  }
  for (var i = 0; i < dropdownToggles.length; i++) {
      dropdownMenu.classList.toggle('show');
  }
});
