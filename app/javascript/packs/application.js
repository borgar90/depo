document.addEventListener("turbo:load", () => {
  document.addEventListener("turbo:before-stream-render", (event) => {
    const target = event.target;
    if (target && target.classList.contains("line-item-highlight")) {
      target.classList.add("highlight");
      setTimeout(() => {
        target.classList.remove("highlight");
      }, 1000); // Remove highlight after 1 second
    }
  });
});
