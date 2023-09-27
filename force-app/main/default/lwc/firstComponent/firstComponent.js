import { LightningElement } from 'lwc';

export default class FirstComponent extends LightningElement {
  paramAddition(a, b) {  //function with paramters..
    let sum = a + b;
    return sum;
  }

  returnFunction() {  //function without paramters..
    return (3 + 2);
  }

  connectedCallback() {
    var result = this.returnFunction();
    console.log('Result-->' + result);
    
//Functions with parameter to perform Mathematical Operations....
function sum(x, y) {
  return x + y;
}

function sub(x, y) {
  return x - y;
}

function mul(x, y) {
  return x * y;
}

function div(x, y) {
  return x / y;
}

//Generic Function....
function calculatorfunction(fn, x, y) {
  return fn(x, y);
}
console.log("sum-->", calculatorfunction(sum, 10, 7));
console.log("sub-->", calculatorfunction(sub, 20, 10));
console.log("mul-->", calculatorfunction(mul, 30, 6));
console.log("div-->", calculatorfunction(div, 40, 5));

    // Diff Between let, var, const.....
    // var a;
    // console.log('typeof a', typeof a);

    // a = 5;
    // console.log('a'+a);
    // console.log('typeof a', typeof a);

    // a = 'Hello';
    // console.log('a'+a);
    // console.log('typeof a', typeof a);

    // a = true;
    // console.log('a'+a);
    // console.log('typeof a', typeof a);

    // var a; // redeclaring variable.
    // a = 6;
    // console.log('a'+a);

    // if(a == 6){ //'=='-->compares only values.
    //     console.log('Inside if ==');
    // }
    // if(a === 6){ //'===' -->compares values and datatypes.
    //     console.log('Inside if ===');
    // }
    // else{
    //     console.log('inside else ===');
    // }

    // if(a == 6){
    //     a = 7;
    //     var ab = 'Hey';
    // }
    // console.log(ab);

    // let b;
    // b = 6;
    // b = 'Hello';
    // b = false;

    // if(a == 6){
    //     a = 7;
    //     let abc = 'Hi';
    // }
    //console.log(abc);

    //Checking boolean value of datatype.
    //undefined....
    // var abc;
    // if(abc){
    //     console.log('hi');  //true
    // }
    // else{
    //     console.log('hello'); //false
    // }
    // //number...
    // var num = 0;
    // if(num){
    //     console.log('hi');
    // }
    // else{
    //     console.log('hello');
    // }

    // num = -1;
    // if(num){
    //     console.log('hi');
    // }
    // else{
    //     console.log('hello');
    // }

    // num = 1;
    // if(num){
    //     console.log('hi');
    // }
    // else{
    //     console.log('hello');
    // }

    // //string...
    // var str = '';
    // if(str){
    //     console.log('hi String');
    // }
    // else{
    //     console.log('hello String');
    // }

    // var str = ' ';
    // if(str){
    //     console.log('hi String Space');
    // }
    // else{
    //     console.log('hello String Space');
    // }

    // var str = 'abc';
    // if(str){
    //     console.log('hi String Value');
    // }
    // else{
    //     console.log('hello String Value');
    // }

    //Arrays in Javascript...
    // var arr = [];
    // arr = [1,2,4,5,5,6];
    // console.log('value--'+arr[0]);
    // console.log('value--'+arr[0]);
    // arr[10] = 9;
    // console.log('value--'+arr);

    // //Checking boolean values for array...
    // if(arr){
    //     console.log('inside arr true');
    // }
    // else{
    //    console.log('inside arr false');
    // }

    // if(arr[6]){
    //     console.log('inside value true');
    // }
    // else{
    //    console.log('inside value false');
    // }

    // var arr2 = [];
    // if(arr2){
    //     console.log('inside arr2 true');
    // }
    // else{
    //    console.log('inside arr2 false');
    // }

    // if(arr.length>0){
    //    console.log('inside if lenght--'+arr.length);
    // }
    // else{
    //     console.log('inside else lenght--'+arr.length);

    // }

    // if(arr2.length>0){
    //     console.log('inside if lenght--'+arr2.length);
    //  }
    //  else{
    //      console.log('inside else lenght--'+arr2.length);

    //  }
    //Using loops..
    //1.)Array of number....

    // var numArray = [99,1000,1,2,45,89,9];
    // console.log('lenght of Array-->'+numArray.length);

    // //using traditional loop...
    // for(let i=0; i<numArray.length; i++){
    //     console.log('mynumber--->'+numArray[i]);
    //     if(numArray[i] == 9){
    //         console.log('value found 9');
    //     }
    //     else{
    //         console.log('value not found 9');
    //     }
    //  }

    // //using forEach loop...
    // console.log("myArray",numArray);

    // numArray.forEach((currNum, index, array) => {
    //     console.log(currNum);
    //     console.log(index);
    //     console.log(array);
    // });

    // //Using for of loops
    // for(let currNum of numArray){
    //     console.log('Numbers in Arrays-->'+currNum);

    // }
    // //Access index,value of numArray...
    // for(let currNum of numArray.entries()){
    //     console.log('Numbers in Arrays-->'+currNum);

    // }
    // //using for in loop...
    // for(let currNum in numArray){
    //     console.log(currNum, numArray[currNum]);
    // }


    // //2.)Array of string....
    // let myCars = ["Audi","Lambo","Bmw","Ferrari"];

    // for (let i=0; i<myCars.length; i++){
    //     console.log('mycars-->'+myCars[i]);
    // }

    // //Using forEach loop...
    // myCars.forEach((currStr, index, array) => {
    //     console.log(currStr);
    //     console.log(index);
    //     console.log(array);
    // });

    // //using for of loop..
    // for(let currStr of myCars){
    //     console.log('Cars in Array--->'+currStr);
    // } 

    // //Access index,value of string..
    // for(let currStr of myCars.entries()){
    //     console.log('Numbers in Arrays-->'+currStr);
    // }

    // //using for in loop.
    // for(let currStr in myCars){
    //     console.log(myStr, myCars[currStr]);

    // } 

    //Objects in Javascript....
    var obj = {
      'name': 'Sandy',
      28: 'age',
      'Phone': [8888, 9999],
      'parent': {
        'mom': 'raj',
        'dad': 'vijay'
      },
      true: 'male',
      'arr': [{ 'hello': 'ci8' }, { 'Welcome': 'LWC' }]
    };

    console.log('name-->' + obj.name);
    console.log('phone-->' + obj.name);
    console.log('family-->' + JSON.stringify(obj.parent));
    let calcResult = this.paramAddition(6, 4);
    console.log(calcResult);
    console.log('mother-->' + obj.parent.mom);
    console.log('arr--->' + obj.arr[0].hello);
    console.log('age--->' + obj[28]);
    console.log('boolean-->' + obj.true);

    //Task 1:-
    var object = {
      data: [
        {
          type: "articles",
          id: "1",
          attributes: {
            title: "JSON:API paints my bikeshed!",
            body: "The shortest article. Ever.",
            created: "2015-05-22T14:56:29.000Z",
            updated: "2015-05-22T14:56:28.000Z",
          },
          relationships: { author: { data: { id: "42", type: "people" } } },
        },
      ],
      included: [
        {
          type: "people",
          id: "42",
          attributes: { name: "John", age: 80, gender: "male" },
        },
      ],
    };

    console.log("title--->" + object.data[0].attributes.title);
    console.log("author--->" + object.included[0].attributes.name);
    console.log("author--->" + object.included[0].attributes.gender);

    //Task 2:-
    var object = {
      meta: { totalPages: 13 },
      data: [
        {
          type: "articles",
          id: "3",
          attributes: {
            title: "JSON:API paints my bikeshed!",
            body: "The shortest article. Ever.",
            created: "2015-05-22T14:56:29.000Z",
            updated: "2015-05-22T14:56:28.000Z",
          },
        },
      ],
      links: {
        self: "http://example.com/articles?page[number]=3&page[size]=1",
        first: "http://example.com/articles?page[number]=1&page[size]=1",
        prev: "http://example.com/articles?page[number]=2&page[size]=1",
        next: "http://example.com/articles?page[number]=4&page[size]=1",
        last: "http://example.com/articles?page[number]=13&page[size]=1",
      },
    };
    console.log("body--->" + object.data[0].attributes.body);
    console.log("next--->" + object.links.next);

    //Task 3:-
    var object = {
      errors: [
        {
          status: "403",
          source: { pointer: "/data/attributes/secretPowers" },
          detail: "Editing secret powers is not authorized on Sundays.",
        },
        {
          status: "422",
          source: { pointer: "/data/attributes/volume" },
          detail: "Volume does not, in fact, go to 11.",
        },
        {
          status: "500",
          source: { pointer: "/data/attributes/reputation" },
          title: "The backend responded with an error",
          detail: "Reputation service not responding after three requests.",
        },
      ],
    };

    console.log('source status--->' + object.errors[1].status);

    //Task 4:-   
    var obj = {
      "glossary": {
        "title": "example glossary",
        "GlossDiv": {
          "title": "S",
          "GlossList": {
            "GlossEntry": {
              "ID": "SGML",
              "SortAs": "SGML",
              "GlossTerm": "Standard Generalized Markup Language",
              "Acronym": "SGML",
              "Abbrev": "ISO 8879:1986",
              "GlossDef": {
                "para": "A meta-markup language, used to create markup languages such as DocBook.",
                "GlossSeeAlso": ["GML", "XML"]
              },
              "GlossSee": "markup"
            }
          }
        }
      }
    }
    console.log('glossaryseeAlso--->' + obj.glossary.GlossDiv.GlossList.GlossEntry.GlossDef.GlossSeeAlso);
    const glossSeeAlsoArray = obj.glossary.GlossDiv.GlossList.GlossEntry.GlossDef.GlossSeeAlso;

    for (let i = 0; i<glossSeeAlsoArray.length; i++) {
      const term = glossSeeAlsoArray[i];
      console.log("seeAlsoterm-->"+term);
    }

    //Task 5:-
    var object = {
      "menu": {
        "id": "file",
        "value": "File",
        "popup": {
          "menuitem": [
            { "value": "New", "onclick": "CreateNewDoc()" },
            { "value": "Open", "onclick": "OpenDoc()" },
            { "value": "Close", "onclick": "CloseDoc()" }
          ]
        }
      }
    }
    const menuItemsObj = object.menu.popup.menuitem;
    console.log("menuItems-->"+JSON.stringify(menuItemsObj));

    for (let i = 0; i < menuItemsObj.length; i++) {
      if (menuItemsObj[i].value === "Open") {
        const openDocValue = menuItemsObj[i].onclick;
        console.log("OpenDoc Value--->" + openDocValue);
      }
    }

  }

}