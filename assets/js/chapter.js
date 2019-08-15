// Function to show the div after the button, which is the answer to a question.
function showAnswer(e) {
  // Get the div
  var answer = e.target.nextElementSibling
  // Show the div and hide the button
  answer.style.display = "block";
  e.target.style.display = "none";
}

