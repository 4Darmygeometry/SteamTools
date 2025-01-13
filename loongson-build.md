龙芯版Watt Toolkit仅支持在龙芯3A5000及以上含LSX的LoongArch真机或用X86 Linux的.net 9交叉编译构建，构建原则遵循[Software Development and Build Convention for LoongArch™ Architectures](https://github.com/loongson/la-softdev-convention)。
龙芯版构建仅构建新世界版本。
- 系统要求
	- [AOSC OS 12 或更高版本](https://aosc.io/download)
	- loongnix 25 或更高版本
	- [Loongnix server 23.1 或更高版本](http://pkg.loongnix.cn/loongnix-server/23.1/isos/)
	- [Deepin 25 或更高版本](https://www.deepin.org/zh/download/)
	- Yongbao 2.9 或更高版本
	- [Alpine Linux 3.21.0 或更高版本](https://alpinelinux.org/downloads/)
	- [GXDE OS 15.14.2 或更高版本](https://www.gxde.top/)
	- [Debian 13 或更高版本](https://www.debian.org/)
- 工作负荷
	- .NET版本
		- [.NET 9.0及以上](https://github.com/loongson-community/dotnet-unofficial-build)
	- vscodium
		- [vscodium 1.96.2.24355及以上](https://github.com/VSCodium/vscodium)
	- Web 和云
		- ASP.NET 和 Web 开发
	- 桌面应用
		- .NET 桌面开发

### 由于新世界nuget尚未完全上游化，本项目龙芯版本使用[龙芯官方提供的nuget源](https://nuget.loongnix.cn)以提供SkiaSharp、HarfBuzzSharp等。借此也可以兼容Loongnix 20、UOS 20、银河麒麟这三个旧世界发行版。
### 龙架构旧世界用户可以在[龙芯开源社区](https://www.loongnix.cn/zh/api/dotnet/)自行下载.net 9及以上版本编译此项目。常见问题可以看[参考文档](https://docs.loongnix.cn/dotnet/support/list/01.%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98-FAQ.html#%E9%BE%99%E8%8A%AFnuget%E6%BA%90%E7%9A%84%E9%85%8D%E7%BD%AE%E6%96%B9%E6%B3%95)。
### 龙架构新世界用户编译此项目时，可能会混入旧世界二进制文件，建议装[liblol旧世界兼容工具](https://liblol.aosc.io)以保证正常编译和运行。AOSC OS、Deepin 23、Yongbao一般自带liblol,无需额外安装。
