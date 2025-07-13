import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { wrapperSelector: String };

  connect() {
    this.wrapper = this.element.querySelector(this.wrapperSelectorValue);
    this.template = this.element.querySelector("template#rule-template").innerHTML.trim();
  }

  add() {
    const newId = new Date().getTime();
    const content = this.template.replace(/NEW_RECORD/g, newId);
    this.wrapper.insertAdjacentHTML("beforeend", content);
  }

  remove(event) {
    event.preventDefault();
    const fieldWrapper = event.target.closest("[data-new-record]");
    if (fieldWrapper) fieldWrapper.remove();
  }
}
