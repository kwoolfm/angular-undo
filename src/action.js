(function () {
/**
 *  The Command Pattern allows for undo and redo in our application.
 *      see https://en.wikipedia.org/wiki/Command_pattern#Javascript
 *
 *  An action will be a future as it could rely on a response from an original action.
 *  For example POST to /resource returns and id that is needed for DELETE /resource/id
 *
 *  A routine is simply a function to be executed.
 *
 *  All routines will enjoy:
 *    Given the result from their inverse action as an argument in the form of a promise
 *    It's a good idea to return the result in a consumable format to your counter part
 *    this.message, a human readable string to be displayed and set by the routine
 */
  angular.
    module('undo').
    factory('action', action);

  action.$inject = ['$q'];

  function action($q) {
    /**
     * @param routine - action to perform
     * @param (inverse) - optional, reverse action
     * @returns {{redo: *, undo: *, redoMessage: String, undoMessage: String}}
     */
    return function (routine, inverse) {
      var redoResult = {}
        , undoResult = {}
        , redoCtx = { message: 'applying generic action' }
        , undoCtx = { message: 'undoing generic action' };

      handleMissingRoutine();
      handleOptionalInverse();

      return {
        redo: redo,
        undo: undo,
        getRedoMessage: function () {
          return redoCtx.message;
        },
        getUndoMessage: function () {
          return undoCtx.message;
        }
      };

      function redo () {
        redoResult = $q.when(execute(routine, redoCtx, undoResult));
      }

      function undo () {
        undoResult = $q.when(execute(inverse, undoCtx, redoResult));
      }

      /**
       * Execute undo / redo with a context
       *
       * @param action - method to invoke
       * @param context - containing property message
       * @param prevResult - passed in as an argument
       * @returns {deferred} - result of method invocation
       */
      function execute (action, context, prevResult) {
          return action.call(context, prevResult);
      }

      /**
       * Ensure routine must be a function
       */
      function handleMissingRoutine () {
        if (!_.isFunction(routine)) {
          throw new Exception('Cannot create an action from ' + ftn);
        }
      }

      /**
       * If no inverse is not specified or invalid, create a dummy one.
       */
      function handleOptionalInverse () {
        if (!_.isFunction(inverse)) {
          inverse = function () {
            this.message = 'Cannot undo previous action.';
          };
        }
      }
    }
  }
})();