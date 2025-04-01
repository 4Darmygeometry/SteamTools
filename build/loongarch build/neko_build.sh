set -e
dotnet workload restore src/BD.WTTS.Client.Avalonia.App/BD.WTTS.Client.Avalonia.App.csproj
#发布主程序
dotnet publish -c Release src/BD.WTTS.Client.Avalonia.App/BD.WTTS.Client.Avalonia.App.csproj -p:UseAppHost=false -p:PublishDir=realbuild/assemblies -p:PublishSingleFile=false -p:PublishReadyToRun=false -p:PublishTrimmed=true -p:PublishDocumentationFile=false -p:PublishDocumentationFiles=false -p:PublishReferencesDocumentationFiles=false -f net9.0 -r linux-loongarch64 -v q /property:WarningLevel=1 --sc false --force --nologo -o "realbuild/assemblies"
#发布插件
dotnet publish -c Release src/BD.WTTS.Client.Plugins.Accelerator.ReverseProxy/BD.WTTS.Client.Plugins.Accelerator.ReverseProxy.csproj -p:UseAppHost=true -p:PublishDir=realbuild/modules/Accelerator -p:PublishSingleFile=true -p:PublishReadyToRun=false -p:PublishTrimmed=true -p:PublishDocumentationFile=false -p:PublishDocumentationFiles=false -p:PublishReferencesDocumentationFiles=false -f net9.0 -r linux-loongarch64 -v q /property:WarningLevel=1 --sc false --force --nologo -o "realbuild/modules/Accelerator"

dotnet build -c Release src/BD.WTTS.Client.Plugins.GameAccount/BD.WTTS.Client.Plugins.GameAccount.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -o "realbuild/modules/GameAccount"
dotnet build -c Release src/BD.WTTS.Client.Plugins.GameList/BD.WTTS.Client.Plugins.GameList.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -o "realbuild/modules/GameList"
dotnet build -c Release src/BD.WTTS.Client.Plugins.Authenticator/BD.WTTS.Client.Plugins.Authenticator.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -o "realbuild/modules/Authenticator"
dotnet build -c Release src/BD.WTTS.Client.Plugins.SteamIdleCard/BD.WTTS.Client.Plugins.SteamIdleCard.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -o "realbuild/modules/SteamIdleCard"
dotnet build -c Release src/BD.WTTS.Client.Plugins.Accelerator/BD.WTTS.Client.Plugins.Accelerator.csproj --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -o "realbuild/modules/Accelerator"
#dotnet test src/BD.WTTS.UnitTest/BD.WTTS.UnitTest.csproj -c Release -p:GeneratePackageOnBuild=false --nologo -v q --property:WarningLevel=1 --property:DebugType=pdbonly -a loongarch64 -o "realbuild/"
echo "Publish Done!"
echo "Start Copy File"
# to do
