----
-- A box class (rectangle)
-- @classmod Box
-- @usage b = Box!

class Box
  --- constructor passed a pos (`x`, `y`) and `width`/`height` which must be `numbers`.
  -- @tparam number x
  -- @tparam number y
  -- @tparam number width
  -- @tparam number height
  new: (x = 0, y = 0, width = 0, height = 0) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."
    assert (type(width) == 'number') and (type(height) == 'number'),
      "Width and Height must be of type number."
    @x = x
    @y = y
    @width = width
    @height = height

  --- tests if a given point is inside the box.
  -- @tparam number x
  -- @tparam number y
  -- @treturn boolean
  contains: (x, y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."

    if x < @x or x >= @width or y < @y or y >= @height
      return false
    return true


  --- getter for the box position.
  -- @treturn table
  getPosition: =>
    @x, @y

  --- getter for the box size.
  -- @treturn table
  getSize: =>
    @width - @x, @height - @y

  --- getter for the box width.
  -- @treturn number
  getWidth: =>
    @width - @x

  --- getter for the box height.
  -- @treturn number
  getHeight: =>
    @height - @y

  --- setter for the box position.
  -- @tparam number x
  -- @tparam number y
  setPosition: (x, y) =>
    assert (type(x) == 'number') and (type(y) == 'number'),
      "x and y must be of type number."
    @x, @y = x, y

  --- getter for the circle x position.
  -- @treturn number
  getX: =>
    @x

  --- getter for the circle y position.
  -- @treturn number
  getY: =>
    @y

  --- setter for the box size.
  -- @tparam number width
  -- @tparam number height
  setSize: (width, height) =>
    assert (type(width) == 'number') and (type(height) == 'number'),
      "width and height must be of type number."
    @width, @height = width, height

Box
