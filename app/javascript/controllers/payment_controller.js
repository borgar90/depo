import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="payment"
export default class extends Controller {
  static targets = ["selection", "additionalFields"];

  initialize() {
    this.showAdditionalFields();
  }

  showAdditionalFields() {
    // Get the selected payment type id
    const selectedId = this.selectionTarget.value;
    console.log("Selected payment type ID:", selectedId);

    // Loop through each additional fieldset
    this.additionalFieldsTargets.forEach((fieldset) => {
      // Compare the id of the payment type with the data-type attribute of the fieldset
      const paymentTypeId = fieldset.dataset.id;
      console.log("Fieldset payment type ID:", paymentTypeId);

      if (paymentTypeId == selectedId) {
        fieldset.hidden = false;
        fieldset.style.display = "block"; // Ensure fieldset is displayed
      } else {
        fieldset.hidden = true;
        fieldset.style.display = "none"; // Ensure fieldset is hidden
      }
    });
  }
}
