#Angular Undo


### a lightweight history for model/api changes


|todo|

Angular undo gives the ability to undo/redo state changes in your angular app. It can affect local or remote state

Some use cases include: 

* a <-> b local state changes. Changing the state of anything in the app
* a <-> b PUT or PATCH. Changing a single field or a group of object properties in an API.
* a -> !a POST and DELETE. Creating and deleting an object in an API





* todo code pen example

* todo travis CI for building


bold: under active development

## Getting Started

* Add as a bower dependency `npm install angular-undo-redo`
* placeholder test


An example of using history

```javascript
function onChange (prop) {
    history.add(update($scope.collection[prop]), update(old[prop]));
}

function update (value) {
  return function () {
    this.message = prop + ' edited';
    
    var data = {};
    data[prop] = value;
    
    // Custom Angular Resource Patch
    api.update(data);
  }
}
```

## Working with APIs
todo

## History as a double stack

todo

## Non-blocking vs. Correctness

todo

Resources

videos 

extras
