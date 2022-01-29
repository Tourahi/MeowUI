Root = assert require MeowUI.cwd .. "Core.Root"
Singleton = assert require MeowUI.cwd .. "Core.Singleton"
Timer = love.timer
Mouse = love.mouse


dispatch = (control, name, ...) ->
    control.events\dispatch control.events\getEvent(name),
      ...

class Manager extends Singleton
  @callbacks: {
    'update'
    'draw'
    'mousemoved'
    'mousepressed'
    'mousereleased'
    'keypressed'
    'keyreleased'
    'wheelmoved'
    'textinput'
  }

  new: =>
    @rootControl = Root!
    @rootControl\setEnabled true
    @hoverControl = nil
    @focusControl = nil
    @holdControl = nil
    @lastClickControl = nil
    @lastClickTime = Timer.getTime!

  getRoot: =>
    @rootControl

  update: (dt) =>
    if @rootControl then @rootControl\update dt

  draw: =>
    if @rootControl then @rootControl\draw!

  mousemoved: (x, y, dx, dy) =>
    if not @rootControl then return

    hitControl = @rootControl\hitTest x, y
    if hitControl ~= @hoverControl
      if @hoverControl then dispatch @hoverControl, "UI_MOUSE_LEAVE"

      @hoverControl = hitControl

      if hitControl then dispatch hitControl, "UI_MOUSE_ENTER"

    if @holdControl then dispatch @holdControl, "UI_MOUSE_MOVE", x, y, dx, dy
    else
      if @hoverControl then dispatch @hoverControl, "UI_MOUSE_MOVE", x, y, dx, dy

  setFocuse: (control) =>
    if @focusControl == control then return

    if @focusControl then dispatch @focusControl, "UI_UN_FOCUS"

    @focusControl = control

    if @focusControl then dispatch @focusControl, "UI_FOCUS"


  mousepressed: (x, y, button, isTouch) =>
    if not @rootControl then return

    hitControl = @rootControl\hitTest x, y

    if hitControl
      dispatch hitControl, "UI_MOUSE_DOWN", x, y, button, isTouch
      @holdControl = hitControl

    @setFocuse hitControl

  mousereleased: (x, y, button, isTouch) =>
    if @holdControl
      dispatch @holdControl, "UI_MOUSE_UP", x, y, button, isTouch
      if @rootControl
        hitControl = @rootControl\hitTest x, y
        if hitControl == @holdControl
          if @lastClickControl and
            @lastClickControl == @holdControl and
            (Timer.getTime! - @lastClickTime <= 0.4)

            dispatch @holdControl, "UI_DB_CLICK", @holdControl, x, y
            @lastClickControl = nil
            @lastClickTime = 0
          else

            dispatch @holdControl, "UI_CLICK", @holdControl, x, y
            @lastClickControl = @holdControl
            @lastClickTime = Timer.getTime!

      @holdControl = nil

  wheelmoved: (x, y) =>
    hitControl = @rootControl\hitTest Mouse\getX!, Mouse\getY!
    while hitControl
      @mousemoved Mouse\getX!, Mouse\getY!, 0, 0
      if dispatch hitControl, "UI_WHELL_MOVE", x, y then return
      hitControl = hitControl\getParent!


  keypressed: (key, scancode, isrepeat) =>
    if @focusControl then dispatch @focusControl, "UI_KEY_DOWN", key, scancode, isrepeat

  keyreleased: (key) =>
    if @focusControl then dispatch @focusControl, "UI_KEY_UP", key

  textinput: (text) =>
    if @focusControl then dispatch @focusControl, "UI_TEXT_INPUT", text

  resize: (w, h) =>
    @rootControl\resize w, h
