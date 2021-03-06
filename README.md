# linux-arm-emulator

"Linux/ARM Emulator" is to build/run .Net Core run-time on virtual Linux/ARM device. It is released as a virtual ARM device to encourage a contribution of the system developers that do not have any real embedded devices. It means that you can easily build .net core source and run an executable ARM binary using this emulator.


## Requirements

 * Host OS: Ubuntu 14.04 LTS X64 PC (Required RAM Size: 2GiB+)
 * Target Architecture: ARMV7LE
 * Compatible Target Boards: 
  - Ubuntu/ARM 14.04 based testbeds: Raspberry Pi2 Board, Samsung ARM Chromebook
  - Traditional Linux/ARM based testbeds: Odroid (X)U3 , Z3/TM1


## Major Goal

 * To enable Linux/ARM Continuous Integration (CI) based on QEMU/chroot
 * To build & run dotnet core components (e.g, coreclr and corefx) such as sandbox
 * To provide the system developers (that don't have embedded boards) with Virtual ARM Device

## Download

Download the latest version of Linux/ARM Emulator at the below webpage:

 * https://github.com/dotnet/coreclr/issues/3805


Archive for keeping the older versions (Thanks to Bruce Hoult)

 * http://hoult.org/coreclr/
