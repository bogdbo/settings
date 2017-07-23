## Posh-Git extra settings

### Warning: Check compatibility as this might be deprecated on newer installs (Get-Module)

Location: `C:\Users\username\Documents\WindowsPowerShell\Modules\posh-git`

Points of interest
```
232: function GitTabExpansionInternal($lastBlock, $GitStatus = $null) {
....


416: function TabExpansion($line, $lastWord) {
....
```

----

### posh-git v0.7.2.0
##### Add tab expansion:

```powershell
function GitTabExpansionInternal($lastBlock, $GitStatus = $null) {
  #bb
  if ($lastBlock -match "^add.* (?<files>\S*)$") {
    gitAddFiles $GitStatus $matches['files']
  }

  if ($lastBlock -match "^(?:co).* (?<ref>\S*)$") {
    gitBranches $matches['ref'] $true
    gitRemoteUniqueBranches $matches['ref']
    gitTags $matches['ref']
  }
...........
}
```

##### In TabExpansion

```powershell
function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()

    switch -regex ($lastBlock) {
        # Execute git tab completion for all git-related commands
        "^$(Get-AliasPattern git) (.*)" { GitTabExpansion $lastBlock }
        "^$(Get-AliasPattern tgit) (.*)" { GitTabExpansion $lastBlock }
        "^$(Get-AliasPattern gitk) (.*)" { GitTabExpansion $lastBlock }
        "^add (.*)" { GitTabExpansion $lastBlock } #bb
        "^co (.*)" { GitTabExpansion $lastBlock } #bb
        # Fall back on existing tab expansion
        default {
            if (Test-Path Function:\TabExpansionBackup) {
                TabExpansionBackup $line $lastWord
            }
        }
    }
}
```
