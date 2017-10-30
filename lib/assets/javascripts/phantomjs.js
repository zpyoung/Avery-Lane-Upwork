var disableAnimationStyles = "-webkit-transition: none !important;" +
                             "-moz-transition: none !important;" +
                             "-ms-transition: none !important;" +
                             "-o-transition: none !important;" +
                             "transition: none !important;"

window.onload = function() {
  var animationStyles = document.createElement("style");
  animationStyles.type = "text/css";
  animationStyles.innerHTML = "* {" + disableAnimationStyles + "}" + "input[type=file] { opacity: 1 !important; }";
  document.head.appendChild(animationStyles);
};
