// Function to show the div after the button, which is the answer to a question.
function showAnswer(e) {
  // Get the div
  var answer = e.target.nextElementSibling
  // Show the div and hide the button
  answer.style.display = "block"
  e.target.style.display = "none"
}

function addToggle(toc) {
  var lis = toc.getElementsByTagName("li")
  var i;
  for (i = 0; i < lis.length; i++) {
    var li = lis[i]
    if (li.getElementsByTagName("ul").length > 0) {
      li.innerHTML = '<span class="pointer" onclick="toggleTOC(event)">&#x276f; </span>' + li.innerHTML
      li.getElementsByTagName("ul")[0].style.display = "none"
    } else  {
      li.innerHTML = '<span class="pointer_dot">&#x2022  </span>' + li.innerHTML
    }
  }
}

function toggleTOC(e) {
  var list = e.target.nextElementSibling.nextElementSibling
  if (list.style.display == "none") {
    list.style.display = "block"
  } else {
    list.style.display = "none"
  }
  e.target.classList.toggle("pointer_down")
}

window.onload = function () {
  addToggle(document.getElementsByClassName("toc")[0])
  document.getElementsByClassName("toc")[0].style.display = "block"
}
