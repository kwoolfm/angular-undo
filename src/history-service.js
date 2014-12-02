(function () {
  /**
   * Gives app undo/redo capabilities
   *
   * currently history doesn't block on actions
   * blocking on actions helps with correctness as the cost
   * of responsiveness which is a costly trade off.
   */
  angular.
    module('undo').
    service('history', history).
    value('maxHistory', 100);

  history.$inject = ['action', 'maxHistory'];

  function history (action, maxHistory) {
    var self = this;
    var undoStack = [];
    var redoStack = [];

    self.add = add;
    self.redo = redo;
    self.undo = undo;
    self.clear = clear;
    self.hasUndo = hasUndo;
    self.hasRedo = hasRedo;

    /**
     * Adds an item to the undo queue invoking it
     * @param command - routine to execute
     * @param inverse - inverse routine to store in undo queue
     * @returns {*} - result from invoking @param command
     */
    function add (command, inverse) {
      redoStack = [];
      return transfer([action(command, inverse)], undoStack).redo();
    }

    /**
     * redo an action
     */
    function redo () {
      transfer(redoStack, undoStack).redo();
    }

    /**
     * undo an action
     */
    function undo () {
      transfer(undoStack, redoStack).undo();
    }

    /**
     * Clears all history
     */
    function clear () {
      undoStack = [];
      redoStack = [];
    }

    /**
     * Indicates if a redo action is available
     * @returns {int} - number of actions available
     *                  permissible as boolean
     */
    function hasRedo () {
      return redoStack.length;
    }

    /**
     * Indicates if an undo action is available
     * @returns {int} - number of actions available
     *                  permissible as boolean
     */
    function hasUndo () {
      return undoStack.length;
    }

    /**
     *  Transfers one stack-like to another while returning the item
     *
     * @param from - a stack-like to pop
     * @param to - a stack-like to push onto
     * @returns {*} - item that was moved
     */
    function transfer (from, to) {
      if (from.length === 0) {
        throw new Error('No actions left');
      } else if (to.length > maxHistory) {
        to.shift()
      }

      var actionable = from.pop();
      to.push(actionable);

      return actionable;
    }
  }
})();