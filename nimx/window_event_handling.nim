import types
import abstract_window
import event
import view_event_handling
import view_event_handling_new
import system_logger

proc canPassEventToFirstResponder(w: Window): bool =
    w.firstResponder != nil and w.firstResponder != w

method onKeyDown*(w: Window, e: var Event): bool =
    if w.canPassEventToFirstResponder:
        result = w.firstResponder.onKeyDown(e)

method onKeyUp*(w: Window, e: var Event): bool =
    if w.canPassEventToFirstResponder:
        result = w.firstResponder.onKeyUp(e)

method onTextInput*(w: Window, s: string): bool =
    if w.canPassEventToFirstResponder:
        result = w.firstResponder.onTextInput(s)

let newTouch : bool = true

method handleEvent*(w: Window, e: var Event): bool {.base.} =
    case e.kind:
        of etTouch:
            if newTouch:
                result = w.processTouchEvent(e)
            else:
                result = w.handleTouchEvent(e)
        of etMouse, etScroll:
            if newTouch and e.kind == etMouse:
                result = w.processTouchEvent(e)
            else:
                result = w.recursiveHandleMouseEvent(e)
        of etKeyboard:
            if e.buttonState == bsDown:
                result = w.onKeyDown(e)
            else:
                result = w.onKeyUp(e)
        of etTextInput:
            result = w.onTextInput(e.text)
        of etWindowResized:
            result = true
            w.onResize(newSize(e.position.x, e.position.y))
            w.drawWindow()
        else:
            result = false
