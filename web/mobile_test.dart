import 'dart:html';

class Line {
  final Point start;
  final Point end;
  Line(this.start, this.end);
}

CanvasElement canvas;
CanvasRenderingContext2D context;
List<Line> lines = [];

Point lastPoint;
bool dragging = false;

int width;
int height;

void main() {
  canvas = querySelector('#content');
  resizeContext(null);
  querySelector('#clear-button').onClick.listen(clear);
  querySelector('#clear-button').onTouchStart.listen((Event e) {
    e.preventDefault();
    clear(null);
  });
  window.onResize.listen(resizeContext);
  canvas.onTouchStart.listen(touchStart);
  canvas.onTouchMove.listen(touchMove);
  canvas.onMouseDown.listen(clickStart);
  canvas.onMouseMove.listen(clickMove);
  canvas.onMouseOut.listen(clickEnd);
  canvas.onMouseUp.listen(clickEnd);
}

void resizeContext(_) {
  width = window.innerWidth;
  height = window.innerHeight - 45;
  if (height < 0) height = 0;
  canvas.style.height = '${height}px';
  width = (width * window.devicePixelRatio).round();
  height = (height * window.devicePixelRatio).round();
  canvas.width = width;
  canvas.height = height;
  context = canvas.getContext('2d');
  draw();
}

void clear(_) {
  lines = [];
  draw();
}

void draw() {
  context.clearRect(0, 0, width, height);
  
  context.strokeStyle = 'rgb(0, 0, 0)';
  context.lineWidth = 5 * window.devicePixelRatio;
  context.lineCap = 'round';
  context.beginPath();
  double scale = window.devicePixelRatio;
  for (Line l in lines) {
    context.moveTo(l.start.x * scale, (l.start.y - 45) * scale);
    context.lineTo(l.end.x * scale, (l.end.y - 45) * scale);
  }
  context.stroke();
}

void touchStart(TouchEvent event) {
  event.preventDefault();
  if (event.touches.length != 1) {
    return;
  }
  lastPoint = event.touches[0].page;
}

void touchMove(TouchEvent event) {
  event.preventDefault();
  if (event.touches.length != 1) {
    return;
  }
  lines.add(new Line(lastPoint, event.page));
  lastPoint = event.page;
  draw();
}

void clickStart(MouseEvent event) {
  dragging = true;
  lastPoint = event.page;
}

void clickMove(MouseEvent event) {
  if (!dragging) return;
  lines.add(new Line(lastPoint, event.page));
  lastPoint = event.page;
  draw();
}

void clickEnd(_) {
  dragging = false;
}
