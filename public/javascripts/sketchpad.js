var Sketchpad = {};

// Call this to setup the sketchpad
Sketchpad.initialise = function(){
  Sketchpad.canvas  = Raphael('canvas', 600, 400);
  Sketchpad.history = [];

  Sketchpad.bindMouseControls();
  Sketchpad.useTool('freehand'); // default tool
}

Sketchpad.useTool = function(tool){
  Sketchpad.tool = tool;
  jQuery('#toolbar .tool.current').removeClass('current');
  jQuery('#toolbar .tool.'+tool).addClass('current');
  return false;
};

Sketchpad.currentTool = function(){
  return Sketchpad.tool;
}

Sketchpad.bindMouseControls = function(){
  var offset = jQuery('#canvas').offset();
  var start_x
  var start_y
  var shape;
  var path;
  var moving;

  jQuery('#canvas').mousedown(function (event) {
    moving = true
    start_x = event.pageX - offset.left;
    start_y = event.pageY - offset.top;

    switch (Sketchpad.currentTool()) {
      case 'rectangle':
        shape = Sketchpad.canvas.rect(start_x, start_y, 0, 0);
        break;
      case 'ellipse':
        shape = Sketchpad.canvas.ellipse(start_x, start_y, 0, 0);
        break;
      case 'line':
        path  = [["M", start_x, start_y],["L", start_x, start_y]]
        shape = Sketchpad.canvas.path(path);
        break;
      case 'freehand':
        path  = [["M", start_x, start_y],["L", start_x, start_y]]
        shape = Sketchpad.canvas.path(path);
        break;
    }
    shape.attr({'stroke-width' : 2, 'opacity': 0.4});
    Sketchpad.history.push(shape);
  });

  jQuery('#canvas').mousemove(function(event){
    if(moving){
      switch (Sketchpad.currentTool()) {
        case 'rectangle':
          var current_x = (event.pageX-offset.left)
          var current_y = (event.pageY-offset.top)
          var attrs = {
            x      : start_x,
            y      : start_y,
            width  : current_x - start_x,
            height : current_y - start_y
          }

          if(current_x < start_x) { attrs.x = current_x; attrs.width = start_x - current_x }
          if(current_y < start_y) { attrs.y = current_y; attrs.height = start_y - current_y }
          shape.attr(attrs);
          break;
        case 'ellipse':
          shape.attr({ rx: (event.pageX-offset.left) - start_x, ry : (event.pageY-offset.top) - start_y});
          break;
        case 'line':
          path[1][1] = (event.pageX-offset.left)
          path[1][2] = (event.pageY-offset.top)
          shape.attr({path: path})
          break;
        case 'freehand':
          path[path.length] = ['L', (event.pageX-offset.left), (event.pageY-offset.top)]
          shape.attr({path: path})
          break;
      }
    };
  });

  jQuery('#canvas').mouseup(function (event) {
    moving = false

    payload = {
      tool    : Sketchpad.currentTool(),
      x       : shape.attrs['x'],
      y       : shape.attrs['y'],
      width   : shape.attrs['width'],
      height  : shape.attrs['height'],
      cx      : shape.attrs['cx'],
      cy      : shape.attrs['cy'],
      rx      : shape.attrs['rx'],
      ry      : shape.attrs['ry'],
      'path[]': shape.attrs['path']
    }

    web_socket.trigger('draw', payload);
  });
}

Sketchpad.unbindMouseControls = function(){
  jQuery('#canvas').unbind('mousedown');
  jQuery('#canvas').unbind('mousemove');
  jQuery('#canvas').unbind('mouseup');
}

Sketchpad.undo = function(){
  var shape = Sketchpad.history.pop();
  if(shape){ shape.remove() };
  return false;
};

Sketchpad.rx = {}
Sketchpad.rx.clear = function(){
  Sketchpad.canvas.clear();
  Sketchpad.history = [];
  return true
}

Sketchpad.rx.draw = function(obj){
  var shape;
  switch (obj.tool) {
    case 'rectangle':
      shape = Sketchpad.canvas.rect(obj.x, obj.y, obj.width, obj.height);
      break;
    case 'ellipse':
      shape = Sketchpad.canvas.ellipse(obj.cx, obj.cy, obj.rx, obj.ry);
      break;
    case 'line':
      shape = Sketchpad.canvas.path(obj.paths);
      break;
    case 'freehand':
      shape = Sketchpad.canvas.path(obj.paths);
      break;
  }
  shape.attr({'stroke-width' : 2, 'opacity': 0.8});
  Sketchpad.history.push(shape)
  return shape
}

Sketchpad.rx.disableTools = function(){
  Sketchpad.unbindMouseControls();
  jQuery('#toolbar .tool').animate({'opacity': 0.2}, 1000);
  jQuery('#toolbar .tool').addClass('disabled');
  return true;
}

Sketchpad.rx.enableTools = function(){
  Sketchpad.bindMouseControls();
  jQuery('#toolbar .tool').animate({'opacity': 1}, 1000);
  jQuery('#toolbar .tool').removeClass('disabled');
  return true;
}

//////////////////////////////////

jQuery(document).ready(function(){
  Sketchpad.initialise();
});
