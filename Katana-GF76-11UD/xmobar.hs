Config {
    font = "JetBrainsMono Nerd Font Bold 11",
    position = Static { xpos = 0 , ypos = 0, width = 1920, height = 24 },
    bgColor = "#0b0e14",
    fgColor = "#bfbdb6",
    commands = [
        Run Network "wlo1" ["-L","0","-H","32"] 10,
        Run Cpu ["-L","3","-H","50"] 10,
        Run Memory ["-t","Mem: <usedratio>%"] 10,
        Run Com "uname" ["-s","-r"] "" 36000,
        Run Com "lux" ["-G"] "brightness" 1,
        Run Com "sh" ["-c", "acpi | egrep -o '[0-9]{0,3}%'"] "battery" 1,
        Run Com "sh" ["-c", "amixer -D pulse get Master | egrep -o '[0-9]{1,3}%' | tail -n1"] "volume" 1,
        Run Date "%a %b %d %Y %H:%M:%S" "date" 10,
        Run Kbd [("bg(phonetic)", "BG"), ("us", "US")],
        Run Com "echo" ["\xf240"] "battery_icon" 3600,
        Run Com "echo" ["\xf073"] "date_icon" 3600,
        Run Com "echo" ["\xf17c"] "linux_icon" 3600,
        Run Com "echo" ["\xf028"] "volume_icon" 3600,
        Run Com "echo" ["\xf185"] "sun_icon" 3600,
        Run Com "echo" ["\xf2db"] "cpu_icon" 3600,
        Run Com "echo" ["\xf233"] "memory_icon" 3600,
        Run Com "echo" ["\xf1eb"] "wifi_icon" 3600,
        Run Com "echo" ["\xf1ab"] "language_icon" 3600,
        Run UnsafeStdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "<fc=#839496> %UnsafeStdinReader% </fc>}{\
            \ <box type=Bottom mb=2 width=2 color=#CDA1FA><fc=#CDA1FA> %linux_icon% %uname% </fc></box>\
            \ <box type=Bottom mb=2 width=2 color=#aad94c><fc=#aad94c> %wifi_icon% %wlo1% </fc></box>\
            \ <box type=Bottom mb=2 width=2 color=#90e1c6><fc=#90e1c6> %cpu_icon% %cpu% </fc></box>\
            \ <box type=Bottom mb=2 width=2 color=#ea6c73><fc=#ea6c73> %memory_icon% %memory% </fc></box>\
            \ <box type=Bottom mb=2 width=2 color=#f9af4f><fc=#f9af4f> %volume_icon% %volume% </fc></box>\
            \ <box type=Bottom mb=2 width=2 color=#7fd962><fc=#7fd962> %language_icon% %kbd% </fc></box>\
            \ <box type=Bottom mb=2 width=2 color=#53bdfa><fc=#53bdfa> %date_icon% %date% </fc></box> "
}
