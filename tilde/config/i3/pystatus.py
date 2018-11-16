from i3pystatus import Status

status = Status()

status.register("clock",
                format="%a %-d %b %R",)

status.register("battery",
                format="{status}/{consumption:.2f}W {percentage:.2f}% {remaining:%E%hh:%Mm}",
                status={
                    "DIS": "↓",
                    "CHR": "↑",
                    "FULL": "=",
                },)

status.register("disk",
    path="/",
    format="{used}/{total}G [{avail}G]",)

status.run()
