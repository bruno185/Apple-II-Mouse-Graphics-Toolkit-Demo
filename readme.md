# Apple II : Mouse Graphics Toolkit Demo in Merlin 32 syntax

Here is the translation in Merlin 32 syntax of the "Mouse Graphics Toolkit" demo program. This very good library greatly facilitated the writing of double hires Apple II programs with the "Desktop" look, as on Macintosh and GS/OS. 

The original source file is TK.DEMO.original.s; the file in Merlin 32 format is tkdemo.s.

## Use
This archive contains a ProDOS disk image (tkdemo.po) to be used it your favourite Apple II emulator or your Apple II.
* Start your Apple II with the "tkdemo.po" disk.
* The startup basic program will launch the demo program.


## Requirements to compile and run

Here is my configuration:

* Visual Studio Code with 2 extensions :

-> [Merlin32 : 6502 code hightliting](https://marketplace.visualstudio.com/items?itemName=olivier-guinart.merlin32)

-> [Code-runner :  running batch file with right-clic.](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

* [Merlin32 cross compiler](https://brutaldeluxe.fr/products/crossdevtools/merlin)

* [Applewin : Apple IIe emulator](https://github.com/AppleWin/AppleWin)

* [Applecommander ; disk image utility](https://applecommander.sourceforge.net)

* [Ciderpress ; disk image utility](https://a2ciderpress.com)

Note :
DoMerlin.bat puts it all together. If you want to compile yourself, you will have to adapt the path to the Merlin32 directory, to Applewin and to Applecommander in DoMerlin.bat file.

DoMerlin.bat is to be placed in project directory.
It compiles source (*.s) with Merlin32, copy 6502 binary to a disk image (containg ProDOS), and launch Applewin with this disk in S6,D1.

