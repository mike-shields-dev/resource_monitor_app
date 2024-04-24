# Resource Monitor App
#### Author Michael Shields

## About

A bash app that displays system information in a table format
The app checks for updates in the system information at regular intervals 
and refreshes the table if any of the system information has changed since 
the previous refresh.

## How to Run

The app can be run by executing the main.sh script in the src directory

```bash
$ cd src && ./main.sh
```

## Wire-frame 

<pre>
╔══════════════════════════════════════════════╗
║ Adex Resource Monitor                        ║
╠═════════════════════════╤════════════════════╣
║ Host Name               │                    ║
╟─────────────────────────┼────────────────────╢
║ Operating System        │                    ║
║─────────────────────────┼────────────────────╢
║ Number of Running Tasks │                    ║
╟─────────────────────────┼────────────────────╢
║ System Up-Time          │                    ║
╟─────────────────────────┼────────────────────╢
║ Total RAM:              │                    ║
╟─────────────────────────┼────────────────────╢
║ Free RAM:               │                    ║
╟─────────────────────────┼────────────────────╢
║ Total Disk Space:       │                    ║
╟─────────────────────────┼────────────────────╢
║ Free Disk Space:        │                    ║
╟─────────────────────────┼────────────────────╢
║ Host IP Address:        │                    ║
╟─────────────────────────┼────────────────────╢
║ IP Addressing Mode:     │                    ║
╚═════════════════════════╧════════════════════╝
</pre>
