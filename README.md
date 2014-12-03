#Angular Undo


### a lightweight history for model and api changes

Angular undo gives the ability to undo/redo state changes in your angular app. It can affect local or remote state


## Getting Started

* Bower install: `bower install angular-undo`
* Import the module from your app.js `angular.module('undo', []);`
* Add to your list of depencies `angular.module('<your module>', [..., 'undo']);`


## Examples
* RESTful Endpoints. Create (POST) to a resource, undo (DELETE) with the ID that is returned
* a <-> b PUT or PATCH. Changing a single field or a group of object properties in an API.
* a <-> b local state changes. Changing the state of anything in the app

### undo/redo API resource creation/deletion

```javascript
var url = 'www.example.com/resource';

function create (name) {
  $http.post(url);
}

// id is a promise injected by history
function delete (id) {
  id.then(function () {
    $http.delete(url, id);
  }
}

// invokes create
history.add(create, delete);

// invokes delete
history.undo();

// invokes create (new resource)
history.redo();

```

### updating an API on change events


```javascript
function onChange (prop) {
    history.add(update($scope.collection[prop]), update(old[prop]));
}

function update (value) {
  return function () {
    this.message = prop + ' edited';
    
    var data = {};
    data[prop] = value;
    
    // Custom Angular Resource PATCH
    api.update(data);
  }
}
```



## Non-blocking vs. Correctness


## Resources
[Slide deck](http://www.slideshare.net/kwoolfm/temporal-composability)

See also: 
* [angular-undo-redo](https://github.com/bobey/angular-undo-redo) an Object Oriented approach
* [chronology.js](https://github.com/wout/chronology.js) as a microjs library



