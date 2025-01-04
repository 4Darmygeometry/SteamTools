set -e
dotnet workload restore src/BD.WTTS.Client.Avalonia.App/BD.WTTS.Client.Avalonia.App.csproj
dotnet build -c Release src/BD.WTTS.Client.AppHost/BD.WTTS.Client.AppHost.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -a loongarch64 -o "realbuild/"
dotnet build -c Release src/BD.WTTS.Client.Plugins.Accelerator.ReverseProxy/BD.WTTS.Client.Plugins.Accelerator.ReverseProxy.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -a loongarch64 -o "realbuild/"
dotnet build -c Release src/BD.WTTS.Client.Avalonia.App/BD.WTTS.Client.Avalonia.App.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -a loongarch64 -o "realbuild/"
dotnet build -c Release src/BD.WTTS.Client.Avalonia.Designer.HostApp/BD.WTTS.Client.Avalonia.Designer.HostApp.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -a loongarch64 -o "realbuild/"
#dotnet test src/BD.WTTS.UnitTest/BD.WTTS.UnitTest.csproj -c Release -p:GeneratePackageOnBuild=false --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -a loongarch64 -o "realbuild/"
echo "Done!"
