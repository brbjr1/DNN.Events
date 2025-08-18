## Development Guide

This guide summarizes how to work with the Pack TX site and the `DotNetNuke.Modules.Events` module for day-to-day development. It is distilled from the environment README and excludes Telerik removal notes.

### Environments

- **Development**: `https://packdev.brbjr.com`
- **Local**: `https://localhost` (if configured)
- **Production**: `https://www.packtx.org`

### Technical Stack

- **Platform**: DotNetNuke (DNN) 9.13.8
- **.NET Framework**: 4.5
- **Database**: SQL Server
- **Web Server**: IIS

### Site Folder Structure (reference)

```text
c:\inetpub\packdev\
├── httpdocs\            # Main DNN application
│   ├── web.config       # Configuration
│   ├── bin\            # Compiled assemblies
│   ├── DesktopModules\ # Custom modules
│   └── App_Data\       # Data/cache
└── tmp\                # Temporary compilation
```

### Prerequisites

1. IIS with ASP.NET 4.5
2. SQL Server access to the DNN database
3. DNN 9.13.8 installed under `c:\inetpub\packdev\httpdocs\`
4. Visual Studio (recommended) with .NET 4.x development tools

### Local Development (site)

1. Place the DNN site under `c:\inetpub\packdev\httpdocs\` and configure an IIS site pointing to that folder.
2. Configure HTTPS (developer certificate is fine for local).
3. Verify the database connection string in `httpdocs\web.config` under `<connectionStrings>`.
4. Ensure `c:\inetpub\packdev\tmp\` exists and the IIS AppPool identity has read/write access.

### Module Development (Events)

This repository contains the Events module source and solution. In the development environment the module source is typically in `DesktopModules\Events` and the compiled output is the `DotNetNuke.Modules.Events.dll` in the site `bin` folder.

Workflow:

1. Open `DotNetNuke.Events.sln` in Visual Studio.
2. Target .NET Framework 4.5 and restore/build.
3. After a successful build, deploy outputs to the DNN site:
   - Copy `DotNetNuke.Modules.Events.dll` (and any satellite assemblies) to `c:\inetpub\packdev\httpdocs\bin\`.
   - Ensure the module resource files and controls in `DesktopModules\Events\` are present under the site at `c:\inetpub\packdev\httpdocs\DesktopModules\Events\`.
4. Recycle the IIS AppPool or touch `web.config` to reload.
5. Test the module on the site.

Tip: Keep a backup of the working `bin\DotNetNuke.Modules.Events.dll` before overwriting.

### Build Instructions

You can build either with Visual Studio or with MSBuild from Visual Studio Build Tools.

1) Visual Studio (recommended)
- Open `DotNetNuke.Events.sln`
- Ensure workloads installed: Desktop development with .NET + ASP.NET/Web
- Build → Rebuild Solution (Debug or Release)

2) MSBuild (Visual Studio Build Tools)
- If needed, install Build Tools (includes MSBuild and Web build tools):
```powershell
Invoke-WebRequest -Uri https://aka.ms/vs/17/release/vs_BuildTools.exe -OutFile $env:TEMP\vs_BuildTools.exe
Start-Process -FilePath $env:TEMP\vs_BuildTools.exe -ArgumentList "--quiet --norestart --nocache --installPath `"C:\\BuildTools`" --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools --add Microsoft.VisualStudio.Workload.WebBuildTools --add Microsoft.Net.Component.4.7.2.TargetingPack --add Microsoft.Net.Component.4.8.SDK --add Microsoft.Net.ComponentGroup.TargetingPacks.netFramework --wait" -NoNewWindow -Wait
```
- Build the solution from the repository root:
```powershell
& "C:\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe" ".\\DotNetNuke.Events.sln" /t:Rebuild /p:Configuration=Debug /m /nologo /v:m /p:VisualStudioVersion=17.0 /p:VSToolsPath="C:\\BuildTools\\MSBuild\\Microsoft\\VisualStudio\\v17.0"
```

Outputs
- `Controls/DotNetNuke.Events.ScheduleControl/bin/DotNetNuke.Modules.Events.ScheduleControl.dll`
- `bin/DotNetNuke.Modules.Events.dll`

Notes
- You may see warnings about a missing `AllRules.ruleset`; these can be ignored.
- If MSBuild reports missing `Microsoft.WebApplication.targets`, ensure the Web Build Tools workload is installed.

### Database Access

- Get the connection string from `httpdocs\web.config` (`SiteSqlServer`). Do not hardcode secrets in source. Use the existing configured credentials.

### Deployment (Dev → Prod)

1. Back up production files and database.
2. Verify all changes on the development site.
3. Deploy updated module files to production:
   - `bin\DotNetNuke.Modules.Events.dll`
   - Any updated files under `DesktopModules\Events\`
4. Update configuration (if applicable) on production `web.config`.
5. Verify site functionality.

### Troubleshooting

- Site won’t load: check DB connectivity, AppPool identity permissions, and that `tmp\` exists.
- Build errors referencing `Microsoft.WebApplication.targets`: install Visual Studio Build Tools with Web development build tools workload and MSBuild.
- Mixed content/HTTPS issues: verify CSP headers and external resources use HTTPS.
- Admin pages visibility: ensure proper roles and page visibility in DNN Admin; you can also navigate directly using `Default.aspx?tabId=...`.

### Notes

- This guide intentionally omits the Telerik removal project details. See the main README for that initiative when needed.

