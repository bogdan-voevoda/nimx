import sdl2

{.push stack_trace:off.}
proc performOnMainThread*(fun: proc(data: pointer) {.cdecl.}, data: pointer) =
    var evt: UserEventObj
    evt.kind = UserEvent5
    evt.data1 = fun
    evt.data2 = data
    discard pushEvent(cast[ptr Event](addr evt))
{.pop.}
