# Vivi
Vivi is a XMPP chatting client at OS X. [Swiften](http://swift.im/swiften.html) is used as XMPP client library to communicate with XMPP server.

The main language is Swift language. All UI code is programed with Swift. However, the XMPP tool is written with Objective-C and C++, since Swiften is a C++ based lib. The Objective-C and C++ codes are all included in ViviSwiften.framework. The framework provide the protocol for Swift based UI code. As a result, you can implement the protocol of the framework to write your own XMPP client GUI.

### Version 1.0 Features

Here list all features would be implement in Vivi version 1.0. 

- [ ] Single chat window.
- [ ] Window split.
- [ ] Notification and reply on notification bar.
- [ ] Contact tag.
- [ ] AIML Chat bot assistant.
- [ ] File transfer.
- [ ] Voice transfer in one button.
- [ ] Voice call.

If you have any seggestion or report a bug, please create an issue at [GitHub](https://github.com/jyhong836/Vivi/issues).

### Compile Swiften

Before starting to code, compile the Swiften lib firstly. 

+ If you have not installed `libboost*` (check with `ls /usr/local/lib | grep boost`), run below in bash:
    ```bash
    ./setupSwiften.sh
    ```

+ If you have installed `libboost*`, still run the command above, and you need to add `/usr/local/include/boost` and  `/usr/local/lib/` to `Header Search Paths` and `Library Search Paths` in Xcode Building Settings.

Read `SwiftXMPP/Documentation/BuildingOnUnix` for more details about compiling Swiften.

##### Some Issues

If it occurred to be some **linker error** or **compile error** about Swiften when building Xcode target, please check your linker and c flag settings flow below steps:

1. In xcodeproject porject settings `Build Settings` tab, check the value of `Header Search Paths` and `Library Search Paths` (use the search tool in Build Settings to search the defines). They should point to the dir include Swiften's source dir `Swiften` and library `Swifetn.a`.
2. In xcodeproject porject settings `Build Settings` tab, check the value of `SWIFTEN_LINKER_FLAGS` and `SWIFTEN_C_FLAGS`. 

The Swiften provide a tool to print the linker and c flag messages:

```bash
cd Frameworks/bin
./swiften-config --libs # print to be linked libs
./swiften-config --cflag # print c++ flags
# ignore the -LXXX or -IXXX output, it has been set in 'Build Phase' and 'Header Search Paths'
```

### Development

This client is developed by Junyuan Hong (jyhong836@gmail.com), started at Jul 22, 2015. If you want to take part in development, just contact me.
