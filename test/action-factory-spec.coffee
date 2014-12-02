#
# Do/Redo is equivalent to Routine
# Undo is equivalent to Inverse
#
describe "Action Factory Specification", ->
  beforeEach module "undo"

  [action, $q, routine, inverse, routineMessage, $rootScope, routineDeferral, inverseDeferral,
  inverseMessage] = [undefined]

  beforeEach ->
    inject ( _action_, _$q_, _$rootScope_) ->
      action = _action_
      $q = _$q_
      $rootScope = _$rootScope_

  setup = ->
    spyOn($q, "when").and.callThrough()

    routineDeferral = $q.defer()
    inverseDeferral = $q.defer()

    routine = jasmine.createSpy("routine").and.returnValue routineDeferral.promise
    inverse = jasmine.createSpy("inverse").and.returnValue inverseDeferral.promise


  describe "Undo and Redo", ->

    describe "types as promises", ->
      beforeEach setup

      it "should force our undo result into a promise by wrapping the execution in $q.when", ->
        actionable = action routine, inverse
        actionable.undo()
        expect($q.when).toHaveBeenCalledWith jasmine.any(Object)

      it "should force our redo result into a promise by wrapping the execution in $q.when", ->
        actionable = action routine, inverse
        actionable.redo()
        expect($q.when).toHaveBeenCalledWith jasmine.any(Object)

    describe "execution", ->
      beforeEach setup

      it "should invoke our inverse when undo is called", ->
        actionable = action routine, inverse
        actionable.undo()
        expect(inverse).toHaveBeenCalledWith jasmine.any(Object)
        expect(routine).not.toHaveBeenCalled()

      it "should invoke our routine when redo is called", ->
        actionable = action routine, inverse
        actionable.redo()
        expect(routine).toHaveBeenCalledWith jasmine.any(Object)
        expect(inverse).not.toHaveBeenCalled()

    describe "missing or incomplete parameters", ->
      beforeEach setup

      it "should not handle a missing routine", ->
        expect(action, routine, inverse).toThrow()

      it "should handle a missing inverse function", ->
        actionable = action routine, inverse
        expect(actionable.undo).not.toThrow()

    describe "messaging via function context", ->
      beforeEach ->
        routineMessage = "routine message"
        inverseMessage = "inverse message"

        routine = ->
          @message = routineMessage
        inverse = ->
          @message = inverseMessage

      it "routine can set its message upon execution", ->
        actionable = action(routine, inverse)
        actionable.redo()
        expect(actionable.getRedoMessage()).toEqual routineMessage

      it "inverse can set its message upon execution", ->
        actionable = action(routine, inverse)
        actionable.undo()
        expect(actionable.getUndoMessage()).toEqual inverseMessage

    describe "results as parameters", ->
      beforeEach setup

      it "should receive undo results from redo", (done) ->
        routine = (result) ->
          result.then (returnValue) ->
            expect(returnValue).toBe "inverseResult"
            done()

        actionable = action(routine, inverse)
        actionable.undo()
        actionable.redo()
        inverseDeferral.resolve "inverseResult"
        $rootScope.$digest()

      it "should receive redo results from undo", (done) ->
        inverse = (result) ->
          result.then (returnValue) ->
            expect(returnValue).toBe "routineResult"
            done()

        actionable = action(routine, inverse)
        actionable.redo()
        actionable.undo()
        routineDeferral.resolve "routineResult"
        $rootScope.$digest()