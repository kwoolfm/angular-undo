describe "History Service", ->
  [history, action, undo, redo, actionStub] = [undefined]
  beforeEach module "undo"

  describe "is able to undo and redo actions.", ->
    beforeEach ->
      undo = jasmine.createSpy 'undo'
      redo = jasmine.createSpy 'redo'
      actionStub = jasmine.createSpy('action').and.returnValue
        undo: undo
        redo: redo

      module ($provide) ->
        $provide.value 'action', actionStub
        return
      inject (_history_) ->
        history = _history_

    it "should ensure routines added to the history invoked immediately ", ->
      history.add undo, redo
      expect(actionStub).toHaveBeenCalled()
      expect(redo).toHaveBeenCalled()
      expect(undo).not.toHaveBeenCalled()

    it "should be able to undo a command", ->
      history.add undo, redo
      history.undo()
      expect(undo).toHaveBeenCalled()

    it "should be able to redo a command", ->
      history.add undo, redo
      history.undo()
      history.redo()
      expect(redo).toHaveBeenCalled() # multiple times (maybe use sinon)

    it "should not allow redo/undo with no history", ->
      expect(history.undo).toThrow()
      expect(history.redo).toThrow()

    it "should clear both redo and undo when clear is called", ->
      history.add undo, redo
      history.add undo, redo
      history.undo()
      # There should be both undo and redo available at this point
      history.clear()
      expect(history.undo).toThrow()
      expect(history.redo).toThrow()
