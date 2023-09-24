import { LightningElement, api } from "lwc";
import { deleteRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";
export default class DeleteRecordImperative extends NavigationMixin(
  LightningElement
) {
  @api recordId;

  handleDelete() {
    deleteRecord(this.recordId)
      .then((result) => {
        this[NavigationMixin.Navigate]({
          type: "standard__objectPage",
          attributes: {
            objectApiName: "Contact",
            actionName: "home"
          },
          state: {
            filterName: "recent"
          }
        });
      })
      .catch((error) => {});
  }
}
