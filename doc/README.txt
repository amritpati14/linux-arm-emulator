
   =================================================
     Linux/ARM Emulator (to Evaluate .NET Core)
   =================================================


1. Host PC Information:
===================================

1.1 Linux Distribution: 
ubuntu 14.04 LTS 64bit (Recommended)

1.2 Required Packages: 
ubu14.04-64bit$> sudo apt-get install qemu qemu-* libguestfs-*

2. System software Information:
=================================
Emulator: QEMU emulator ver. 2.0.0,  
Target: ARM Little Endian, ELF, Cortex-A9, EABI, NEON SIMD (VFPv3-D16)
ARM Instruction: ARM
Kernel: Linux 3.10 (Linux 4.3, Experimental)
Native GCC: 4.9
Link/Loader: (e)Glibc 2.21
Memory Allocator: PTMalloc (Multi-thread Malloc Implementation)
Thread Model: POSIX, Native Thread Thread Library (NPTL) Model
Mono   ARM: 4.2.1 (soft-float)
DotNET ARM: Coming Soon. !!! (By Developer eXperience Lab)


3. Screenshot: 
================
/ # cat /proc/cpuinfo 
processor	: 0
model name	: ARMv7 Processor rev 0 (v7l)
BogoMIPS	: 555.41
Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpd32 
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x0
CPU part	: 0xc09
CPU revision	: 0

Hardware	: ARM-Versatile Express
Revision	: 0000
Serial		: 0000000000000000
/ # 
/ # free
             total         used         free       shared      buffers
Mem:        253012         9912       243100            0           80
-/+ buffers:               9832       243180
Swap:            0            0            0
/ # 
/ # uname -a
Linux (none) 4.3.0 #1 SMP Tue Dec 15 17:01:12 KST 2015 armv7l GNU/Linux
/ #

4. Evaluate Mono
===================
 
# mono --version
Mono JIT compiler version 4.2.1 (Stable 4.2.1.102/6dd2d0d Tue Dec 15 02:27:31 UTC 2015)
Copyright (C) 2002-2014 Novell, Inc, Xamarin Inc and Contributors. www.mono-project.com
	TLS:           __thread
	SIGSEGV:       normal
	Notifications: epoll
	Architecture:  armel,vfp+fallback
	Disabled:      none
	Misc:          softdebug 
	LLVM:          supported, not enabled.
	GC:            sgen
/ # cd example
/ # vi hello.cs
--- hello.cs: start --------------------------
using System;

namespace Dela.Mono.Examples
{
   public class HelloWorld
   {
      public static void Main(string[] args)
      {
         Console.WriteLine("Hello C# World!!!");
      }
   } 
}

--- hello.cs: end   --------------------------
/ # mcs  hello.cs
/ # mono hello.exe



End of line. 
