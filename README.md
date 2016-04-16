# linux-arm-emulator

"Linux/ARM Emulator" is to build/run .Net Core run-time on Linux/ARM devices. It has being released as a virtual ARM device to help system developers that don't have any real embedded devices such as Raspberry Pi2 Board, Samsung ARM Chromebook, and Odroid (X)U3 Board. It means that you can easily build .net core source and run an executable ARM binary on the emulator.

## Requirements

 * Host OS: Ubuntu 14.04 LTS X64 PC (Required RAM Size: 2GiB+)
 * Target Architecture: ARMV7LE

## Major Goal

 * To enable Linux/ARM Continuous Integration (CI) based on QEMU/chroot
 * To build & run dotnet core components (e.g, coreclr and corefx) like sandbox
 * To provide the system developers (that don't have embedded boards) with Virtual ARM Device

## Download

Download the latest version 20160404-1330.4 of Linux/ARM Emulator:
https://onedrive.live.com/redir?resid=C93799B86B006829!164

Archive for keeping the older versions (Thanks to Bruce Hoult)
http://hoult.org/coreclr/
