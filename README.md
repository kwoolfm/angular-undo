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

### example of undo/redo API resource creation/deletion

```javascript
var url = 'www.example.com/resource';
var data = { foo: 'bar' };

function createResource (data) {
  return function () {
    return $http.post(url, data);
  };
}

// id is a promise injected by history
function deleteResource (id) {
  id.then(function () {
    $http.delete(url, id);
  }
}

// invokes create
history.add(createResource(data), deleteResource);

// invokes delete
history.undo();

// invokes create (new resource)
history.redo();

```

### example of updating an API with patch

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
* [chronology.js](https://github.com/wout/chronology.js) a microjs library



