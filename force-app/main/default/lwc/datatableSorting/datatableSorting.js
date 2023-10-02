import { LightningElement, track, wire } from 'lwc';
import getContactList from '@salesforce/apex/LightningDataTableController.getContactList';
const columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text', editable: 'true', sortable: 'true' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text', editable: 'true', sortable: 'true' },
    { label: 'Phone', fieldName: 'Phone', type: 'Phone', sortable: 'true' },
    { label: 'Email', fieldName: 'Email', type: 'email', sortable: 'true' }

];

export default class DatatableSorting extends LightningElement {

    columns = columns;
    data;
    error;
    @track sortBy;
    @track sortDirection;

    @wire(getContactList)
    contactMethod(result) {
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
        }
        else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        //Return the value stored in field..
        let keyValue = (a) => {
            return a[fieldname];
        };
        //checking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;

        //sorting Data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';  //handling null values..
            y = keyValue(y) ? keyValue(y) : '';

            //sorting values based on direction
            return isReverse * ((x > y) - (y > x));

        });
        this.data = parseData;
    }
}
