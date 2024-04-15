# Resource Monitor App
#### Author Michael Shields

## About

A bash app that displays system information in a table format
The app checks for updates in the system information at regular intervals 
and refreshes the table if any of the system information has changed since 
the previous refresh.

## Wire-frame 

<pre>
╔══════════════════════════════════════════╗
║ System Information                       ║
╠════════════════════╤═════════════════════╣
║ Host Name          │ ________________    ║
╟────────────────────┼─────────────────────╢
║ Operating System   │ ________________    ║
╟────────────────────┼─────────────────────╢
║ Running Tasks      │ ___                 ║
╟────────────────────┼─────────────────────╢
║ Available RAM      │ ___GB               ║
╟────────────────────┼─────────────────────╢
║ Total Disk Space   │ ___GB               ║
╟────────────────────┼─────────────────────╢
║ Free Disk Space    │ ___GB               ║
╟────────────────────┼─────────────────────╢
║ Host IP Address    │ ___.___.___.___     ║
╟────────────────────┼─────────────────────╢
║ IP Addressing Mode │ Dynamic || Static   ║
╚════════════════════╧═════════════════════╝
</pre>

## Test

The <a href="https://bats-core.readthedocs.io/en/stable/index.html">bats-core library</a> is used for testing

To run the suite of tests, run the following command in the project's root directory

```bash
$ ./run_all_tests.sh
```