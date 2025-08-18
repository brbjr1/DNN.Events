## Development Guide

This guide summarizes how to work with the Pack TX site and the `DotNetNuke.Modules.Events` module for day-to-day development. It is distilled from the environment README and excludes Telerik removal notes.

### Environments

- **Development**: `https://packdev.brbjr.com`
- **Local**: `https://localhost` (if configured)
- **Production**: `https://www.packtx.org`

### Technical Stack

- **Platform**: DotNetNuke (DNN) 9.13.8
- **.NET Framework (site runtime)**: 4.5
- **Project target framework**: 4.5.1
- **Database**: SQL Server
- **Web Server**: IIS

### Site Folder Structure (reference)

```text
c:\inetpub\packdev\
├── web.config         # Configuration
├── bin\              # Compiled assemblies
├── DesktopModules\   # Custom modules
├── App_Data\         # Data/cache
└── tmp\              # Temporary compilation
```

### Prerequisites

1. IIS with ASP.NET 4.5
2. SQL Server access to the DNN database
3. DNN 9.13.8 installed under `c:\inetpub\packdev\`
4. Visual Studio (recommended) with .NET 4.x development tools

### Local Development (site)

1. Place the DNN site under `c:\inetpub\packdev\` and configure an IIS site pointing to that folder.
2. Configure HTTPS (developer certificate is fine for local).
3. Verify the database connection string in `web.config` under `<connectionStrings>`.
4. Ensure `c:\inetpub\packdev\tmp\` exists and the IIS AppPool identity has read/write access.

### Module Development (Events)

This repository contains the Events module source and solution. In the development environment the module source is typically in `DesktopModules\Events` and the compiled output is the `DotNetNuke.Modules.Events.dll` in the site `bin` folder.

Workflow:

1. Open `DotNetNuke.Events.sln` in Visual Studio.
2. Target .NET Framework 4.5.1 and restore/build.
3. After a successful build, deploy outputs to the DNN site:
   - Copy `DotNetNuke.Modules.Events.dll` (and any satellite assemblies) to `c:\inetpub\packdev\bin\`.
   - Ensure the module resource files and controls in `DesktopModules\Events\` are present under the site at `c:\inetpub\packdev\DesktopModules\Events\`.
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

- Get the connection string from `web.config` (`SiteSqlServer`). Do not hardcode secrets in source. Use the existing configured credentials.

### Deployment (Dev → Prod)

1. Back up production files and database.
2. Verify all changes on the development site.
3. Deploy updated module files to production:
   - `bin\DotNetNuke.Modules.Events.dll`
   - Any updated files under `DesktopModules\Events\`
4. Update configuration (if applicable) on production `web.config`.
5. Verify site functionality.

## Recent Changes - EditEvents Grid Column Fixes

### Issue
The "Edit Event Enrolled Users" grid had column alignment issues after removing the "Approved" and "Event Date" columns. Column names were "off" and data was not displaying correctly.

### Changes Made

#### 1. EditEvents.ascx.cs - ShowHideEnrolleeColumns Method
- **Fixed column visibility logic**: Added missing `else` clauses for emergency contact, waiver, and membership columns
- **Corrected column indices**: Updated column visibility logic to match the current grid structure
- **Added missing data population**: Added emergency contact, waiver, and membership field population for anonymous users

#### 2. EditEvents.ascx
- **Grid structure**: Confirmed the grid has the correct column definitions:
  - Column 0: Select (TemplateColumn)
  - Column 1: UserName
  - Column 2: DisplayName  
  - Column 3: Full Name
  - Column 4: Email
  - Column 5: Phone
  - Column 6: Qty
  - Column 7: Emergency Contact Name
  - Column 8: Emergency Contact Number
  - Column 9: Emergency Contact Details
  - Column 10: Waver Current
  - Column 11: Waver Expiration Date
  - Column 12: MemberShip Current
  - Column 13: MemberShip Expiration Date

### Files Modified
- `EditEvents.ascx.cs` - Fixed column visibility logic and data population
- `EditEvents.ascx` - Grid column definitions (already correct)

### Deployment
- **Compiled DLL**: `bin\DotNetNuke.Modules.Events.dll` → `C:\inetpub\packdev\bin\`
- **Source file**: `EditEvents.ascx` → `C:\inetpub\packdev\DesktopModules\Events\`

### Testing
After deployment, verify that:
1. The "Edit Event Enrolled Users" grid displays all columns correctly
2. Column headers match the expected names
3. Data is populated in the correct columns
4. Emergency contact, waiver, and membership information displays for registered users
5. Anonymous users show empty values for these fields (as expected)

### Troubleshooting

- Site won’t load: check DB connectivity, AppPool identity permissions, and that `tmp\` exists.
- Build errors referencing `Microsoft.WebApplication.targets`: install Visual Studio Build Tools with Web development build tools workload and MSBuild.
- Mixed content/HTTPS issues: verify CSP headers and external resources use HTTPS.
- Admin pages visibility: ensure proper roles and page visibility in DNN Admin; you can also navigate directly using `Default.aspx?tabId=...`.

### Notes

- This guide intentionally omits deep Telerik removal details. See `README.md` for the broader initiative and the site-level `c:\inetpub\packdev\README.md` for environment specifics.

---

## Recent Changes - Restore Full Name Column in EditEvents Grid

### Issue
After removing the "Qty" column from the "Edit Event Enrolled Users" grid, the "Full Name" column next to "Display Name" was missing. This was caused by the `EnrolmentColumns` method in `EventBase.cs` not including "FullName" in the column visibility logic.

### Changes Made

#### 1. Components/EventBase.cs - EnrolmentColumns Method
- **Added FullName field**: Added `;FullName` to the `txtColumns` string for event editors
- **Added code mapping**: Added `txtColumns = txtColumns.Replace("07", "FullName");` to map code "07" to "FullName"

#### 2. Column Structure (Confirmed)
The "Edit Event Enrolled Users" grid now has the correct column structure:
- Column 0: Select (TemplateColumn)
- Column 1: UserName
- Column 2: DisplayName  
- Column 3: Full Name
- Column 4: Email
- Column 5: Phone
- Column 6: Emergency Contact Name
- Column 7: Emergency Contact Number
- Column 8: Emergency Contact Details
- Column 9: Waver Current
- Column 10: Waver Expiration Date
- Column 11: MemberShip Current
- Column 12: MemberShip Expiration Date

### Files Modified
- `Components/EventBase.cs` - Added FullName to column visibility logic

### Deployment
- **Compiled DLL**: `bin\DotNetNuke.Modules.Events.dll` → `C:\inetpub\packdev\bin\`
- **Source file**: `Components\EventBase.cs` → `C:\inetpub\packdev\DesktopModules\Events\Components\`
- **App Pool Recycle**: Touched `web.config` to trigger reload

### Testing
After deployment, verify that:
1. The "Full Name" column appears next to "Display Name" in the "Edit Event Enrolled Users" grid
2. The column is visible for event editors (admins, moderators, owners)
3. All other columns maintain their correct order and data alignment
4. Emergency contact, waiver, and membership columns display correctly

### Technical Details
The issue was in the `EnrolmentColumns` method which determines which columns should be visible based on user roles and module settings. By adding "FullName" to the `txtColumns` string and mapping code "07" to "FullName", the column visibility logic in `ShowHideEnrolleeColumns` can now properly control the Full Name column's display.

---

## Quickstart

1) Prepare DNN site and permissions
- Ensure the site lives at `c:\inetpub\packdev\` and the IIS AppPool identity has read/write to `c:\inetpub\packdev\tmp\` and the site folders.

2) Prepare module references (once per machine)
- Create a `.references` folder in the repo root.
- Copy required DLLs from the DNN site's `bin` to `.references`:
  - `DotNetNuke.dll`
  - `DotNetNuke.Web.dll`
  - `DotNetNuke.Web.Deprecated.dll`
  - `Microsoft.ApplicationBlocks.Data.dll`
  - `CountryListBox.dll`
  - `Telerik.Web.UI.dll` (temporary; only needed until Telerik is fully removed)

3) Build
- Visual Studio: open `DotNetNuke.Events.sln` → Build (Debug recommended).
- MSBuild (no VS): install Build Tools (see command below) and run the build command.

4) Deploy to the dev site
- Copy `bin\DotNetNuke.Modules.Events.dll` to `c:\inetpub\packdev\bin\`.
- Ensure control files in `DesktopModules\Events\` are present in the site at `c:\inetpub\packdev\DesktopModules\Events\`.
- Recycle the AppPool or touch `web.config`.

---

## Reference setup details

This solution expects third-party and platform DLLs under `.references` as declared in `DotNetNuke.Events.csproj`. If the folder is missing:

```powershell
New-Item -ItemType Directory -Path .\.references -Force | Out-Null
Copy-Item "c:\inetpub\packdev\bin\DotNetNuke*.dll" .\.references -Force
Copy-Item "c:\inetpub\packdev\bin\Microsoft.ApplicationBlocks.Data.dll" .\.references -Force
Copy-Item "c:\inetpub\packdev\bin\CountryListBox.dll" .\.references -Force -ErrorAction SilentlyContinue
Copy-Item "c:\inetpub\packdev\bin\Telerik.Web.UI.dll" .\.references -Force  # temporary
```

---

## Build options

- Debug build: fast, does not require MSBuild Community Tasks or DNNtc tasks.
- Release build: triggers `Installation/Project.targets` packaging steps (DNN install/source ZIPs). This requires task libraries under `.build` (MSBuild Community Tasks and DNNtc tasks). If those are not present, prefer Debug.

Install Visual Studio Build Tools (if you do not have full VS):

```powershell
Invoke-WebRequest -Uri https://aka.ms/vs/17/release/vs_BuildTools.exe -OutFile $env:TEMP\vs_BuildTools.exe
Start-Process -FilePath $env:TEMP\vs_BuildTools.exe -ArgumentList "--quiet --norestart --nocache --installPath `"C:\\BuildTools`" --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools --add Microsoft.VisualStudio.Workload.WebBuildTools --add Microsoft.Net.Component.4.7.2.TargetingPack --add Microsoft.Net.Component.4.8.SDK --add Microsoft.Net.ComponentGroup.TargetingPacks.netFramework --wait" -NoNewWindow -Wait
```

Build command:

```powershell
& "C:\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe" ".\\DotNetNuke.Events.sln" /t:Rebuild /p:Configuration=Debug /m /nologo /v:m /p:VisualStudioVersion=17.0 /p:VSToolsPath="C:\\BuildTools\\MSBuild\\Microsoft\\VisualStudio\\v17.0"
```

Outputs after a successful build:
- `bin\\DotNetNuke.Modules.Events.dll` (main module)
- `Controls/DotNetNuke.Events.ScheduleControl/bin/DotNetNuke.Modules.Events.ScheduleControl.dll` (sub-control)

Known benign warnings:
- `AllRules.ruleset` missing in Code Analysis settings.
- WebApplication targets missing if Web Build Tools not installed.

---

## Deploy to the dev site

```powershell
$site = "c:\\inetpub\\packdev"
Copy-Item ".\\bin\\DotNetNuke.Modules.Events.dll" "$site\\bin\\" -Force
# Copy ScheduleControl assembly if it was rebuilt
Copy-Item ".\\Controls\\DotNetNuke.Events.ScheduleControl\\bin\\DotNetNuke.Modules.Events.ScheduleControl.dll" "$site\\bin\\" -Force -ErrorAction SilentlyContinue
# If you edited .ascx/.resx/etc., sync the module folder too
robocopy "." "$site\\DesktopModules\\Events" *.ascx *.resx *.css *.js *.gif *.jpg *.png *.xslt /S /XO /NFL /NDL /NJH /NJS /NP | Out-Null
# Recycle by touching web.config
(Get-Item "$site\\web.config").LastWriteTime = Get-Date
```

---

## Git workflow (repo hygiene)

- Create a feature branch per task. Example: `git checkout -b feature/remove-telerik`.
- Commit small, focused edits. Include module name and area in messages.
- Keep `chat.md` updated with any non-obvious build/deploy quirks or one-time setup steps you discover.

---

## Telerik removal notes (high level)

- Current references include `Telerik.Web.UI.dll` via `.references`. While removing Telerik, replace controls/usages, then remove the reference and any related scripts/styles. Rebuild and verify.
- Do not delete Telerik from the running site until the module is rebuilt and tested without it.

---

## Keep this file current

- When you hit a snag or discover an environment nuance, add a short note here so the next developer is unblocked.

---

## Add EnrollFullName deployment instructions

Changed files for the Enrolled Users grid Full Name feature:
- `Components/EventInfo.cs` — added `EnrollFullName` property to `EventEnrollList`.
- `EventDetails.ascx` — inserted `EnrollFullName` column next to `EnrollDisplayName`.
- `EventDetails.ascx.cs` — populated `EnrollFullName` for enrolled users; added header/visibility helpers; restricted Full Name visibility to Admins/Moderators/Event Owner.

What to deploy (manual copy):
- Non-compiled: `EventDetails.ascx` → `c:\inetpub\packdev\DesktopModules\Events\EventDetails.ascx`
- Compiled: `bin\DotNetNuke.Modules.Events.dll` → `c:\inetpub\packdev\bin\DotNetNuke.Modules.Events.dll`
- Optional if rebuilt: `Controls\DotNetNuke.Events.ScheduleControl\bin\DotNetNuke.Modules.Events.ScheduleControl.dll` → `c:\inetpub\packdev\bin\` (only if timestamp changed)

PowerShell deploy snippet:
```powershell
$repo = "$PSScriptRoot"  # adjust if not running from repo root
$site = "c:\inetpub\packdev"

Copy-Item "$repo\EventDetails.ascx" "$site\DesktopModules\Events\EventDetails.ascx" -Force
Copy-Item "$repo\bin\DotNetNuke.Modules.Events.dll" "$site\bin\DotNetNuke.Modules.Events.dll" -Force
if (Test-Path "$repo\Controls\DotNetNuke.Events.ScheduleControl\bin\DotNetNuke.Modules.Events.ScheduleControl.dll") {
  Copy-Item "$repo\Controls\DotNetNuke.Events.ScheduleControl\bin\DotNetNuke.Modules.Events.ScheduleControl.dll" "$site\bin\" -Force
}
(Get-Item "$site\web.config").LastWriteTime = Get-Date
```

Notes:
- Full Name column visibility is limited to Admins, Module Editors, Moderators, or the Event Owner. Regular users will not see it.
- No resource (.resx) updates are required; the header uses the literal "Full Name".

---

## Production Deployment - Complete Feature Set

### Overview
This section documents all files that need to be deployed to production for the complete feature set including:
1. Full Name column in EventDetails Enrolled Users grid
2. Full Name column in EditEvents Enrolled Users grid  
3. CSV export customization (removed columns, added emergency contact/waiver/membership fields)
4. Grid column cleanup (removed Approved, Event Start, Qty columns)

### Files to Deploy to Production

#### 1. Compiled Assemblies (Required)
- **`bin\DotNetNuke.Modules.Events.dll`** → `{PRODUCTION_SITE}\bin\`
  - Contains all code-behind logic changes
  - Must be deployed for any functionality changes

#### 2. User Control Files (Required)
- **`EventDetails.ascx`** → `{PRODUCTION_SITE}\DesktopModules\Events\`
  - Contains the Enrolled Users grid structure
  - Includes Full Name column and removed Approved column

- **`EditEvents.ascx`** → `{PRODUCTION_SITE}\DesktopModules\Events\`
  - Contains the Edit Event Enrolled Users grid structure
  - Includes Full Name column and removed Qty column

#### 3. Code-Behind Files (Required)
- **`EventDetails.ascx.cs`** → `{PRODUCTION_SITE}\DesktopModules\Events\`
  - Contains CSV export logic and data population
  - Handles emergency contact, waiver, and membership data

- **`EditEvents.ascx.cs`** → `{PRODUCTION_SITE}\DesktopModules\Events\`
  - Contains grid data binding and column visibility logic
  - Handles Full Name column display for event editors

#### 4. Component Files (Required)
- **`Components\EventBase.cs`** → `{PRODUCTION_SITE}\DesktopModules\Events\Components\`
  - Contains column visibility logic for Full Name
  - Must be deployed for Full Name column to appear

- **`Components\EventInfo.cs`** → `{PRODUCTION_SITE}\DesktopModules\Events\Components\`
  - Contains data model definitions
  - Includes emergency contact, waiver, and membership properties

#### 5. XSLT Transformation File (Required)
- **`EventEnrollees.xslt`** → `{PRODUCTION_SITE}\DesktopModules\Events\`
  - Controls CSV export column selection and formatting
  - Must be deployed for CSV changes to take effect

#### 6. Resource Files (Required)
- **`App_LocalResources\EventDetails.ascx.resx`** → `{PRODUCTION_SITE}\DesktopModules\Events\App_LocalResources\`
  - Contains localized strings for new columns
  - Required for proper column headers in CSV export

#### 7. SubControl Files (Required)
- **`SubControls\EventUserGrid.ascx`** → `{PRODUCTION_SITE}\DesktopModules\Events\SubControls\`
- **`SubControls\EventUserGrid.ascx.cs`** → `{PRODUCTION_SITE}\DesktopModules\Events\SubControls\`
  - Contains user search functionality for EditEvents
  - Includes Full Name display in user selection grid

### Production Deployment Commands

#### PowerShell Deployment Script
```powershell
# Set paths
$repo = "C:\Users\Administrator\source\repos\DNN.Events"  # Adjust to your repo path
$prodSite = "C:\inetpub\wwwroot"  # Adjust to your production site path

# 1. Deploy compiled assembly
Copy-Item "$repo\bin\DotNetNuke.Modules.Events.dll" "$prodSite\bin\" -Force

# 2. Deploy user control files
Copy-Item "$repo\EventDetails.ascx" "$prodSite\DesktopModules\Events\" -Force
Copy-Item "$repo\EditEvents.ascx" "$prodSite\DesktopModules\Events\" -Force

# 3. Deploy code-behind files
Copy-Item "$repo\EventDetails.ascx.cs" "$prodSite\DesktopModules\Events\" -Force
Copy-Item "$repo\EditEvents.ascx.cs" "$prodSite\DesktopModules\Events\" -Force

# 4. Deploy component files
Copy-Item "$repo\Components\EventBase.cs" "$prodSite\DesktopModules\Events\Components\" -Force
Copy-Item "$repo\Components\EventInfo.cs" "$prodSite\DesktopModules\Events\Components\" -Force

# 5. Deploy XSLT file
Copy-Item "$repo\EventEnrollees.xslt" "$prodSite\DesktopModules\Events\" -Force

# 6. Deploy resource files
Copy-Item "$repo\App_LocalResources\EventDetails.ascx.resx" "$prodSite\DesktopModules\Events\App_LocalResources\" -Force

# 7. Deploy subcontrol files
Copy-Item "$repo\SubControls\EventUserGrid.ascx" "$prodSite\DesktopModules\Events\SubControls\" -Force
Copy-Item "$repo\SubControls\EventUserGrid.ascx.cs" "$prodSite\DesktopModules\Events\SubControls\" -Force

# 8. Recycle application pool
(Get-Item "$prodSite\web.config").LastWriteTime = Get-Date

Write-Host "Production deployment completed successfully!" -ForegroundColor Green
```

#### Manual Deployment Checklist
- [ ] Copy `DotNetNuke.Modules.Events.dll` to production `bin\` folder
- [ ] Copy `EventDetails.ascx` to production `DesktopModules\Events\` folder
- [ ] Copy `EditEvents.ascx` to production `DesktopModules\Events\` folder
- [ ] Copy `EventDetails.ascx.cs` to production `DesktopModules\Events\` folder
- [ ] Copy `EditEvents.ascx.cs` to production `DesktopModules\Events\` folder
- [ ] Copy `EventBase.cs` to production `DesktopModules\Events\Components\` folder
- [ ] Copy `EventInfo.cs` to production `DesktopModules\Events\Components\` folder
- [ ] Copy `EventEnrollees.xslt` to production `DesktopModules\Events\` folder
- [ ] Copy `EventDetails.ascx.resx` to production `DesktopModules\Events\App_LocalResources\` folder
- [ ] Copy `EventUserGrid.ascx` to production `DesktopModules\Events\SubControls\` folder
- [ ] Copy `EventUserGrid.ascx.cs` to production `DesktopModules\Events\SubControls\` folder
- [ ] Touch `web.config` to trigger application pool recycle

### Post-Deployment Verification

#### 1. EventDetails Page
- [ ] Full Name column appears next to Display Name in Enrolled Users grid
- [ ] Full Name column is only visible to admins/moderators/event owners
- [ ] CSV download includes all new columns (Emergency Contact, Waiver, Membership)
- [ ] CSV download excludes removed columns (Location, Category, Reference Number, etc.)

#### 2. EditEvents Page
- [ ] Full Name column appears next to Display Name in Enrolled Users grid
- [ ] Full Name column is visible to event editors
- [ ] Qty column is removed
- [ ] Emergency contact, waiver, and membership columns display correctly

#### 3. User Search Functionality
- [ ] "Enroll User to Event:" dropdown selection persists after refresh
- [ ] Full Name appears in user search results
- [ ] User selection and enrollment works correctly

### Rollback Plan
If issues occur, restore the previous version of `DotNetNuke.Modules.Events.dll` from backup and remove the modified source files. The compiled DLL contains all the logic, so restoring it will revert all functionality changes.

### Notes
- **Critical**: Always backup production files before deployment
- **Critical**: Deploy during maintenance windows to minimize user impact
- **Critical**: Test thoroughly in development environment before production deployment
- The compiled DLL contains all code-behind logic; source files are required for UI changes
- Application pool recycle is required for changes to take effect
