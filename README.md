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

## Testing

The <a href="https://bats-core.readthedocs.io/en/stable/index.html">bats-core library</a> is used for testing. All test files are located in the test directory.


After cloning the project to your local machine, the necessary git submodules for the bats testing library need to be installed.

To do this you run the following command:

```bash
$ git submodule update --init --recursive
```

To run the suite of tests, run the following command in the project's root directory

```bash
$ ./run_all_tests.sh
```