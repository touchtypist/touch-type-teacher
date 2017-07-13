TouchTypeTeacherView = require './touch-type-teacher-view'
{CompositeDisposable} = require 'atom'

module.exports = TouchTypeTeacher =
  touchTypeTeacherView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @touchTypeTeacherView = new TouchTypeTeacherView(state.touchTypeTeacherViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @touchTypeTeacherView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'touch-type-teacher:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @touchTypeTeacherView.destroy()

  serialize: ->
    touchTypeTeacherViewState: @touchTypeTeacherView.serialize()

  toggle: ->
    console.log 'TouchTypeTeacher was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
