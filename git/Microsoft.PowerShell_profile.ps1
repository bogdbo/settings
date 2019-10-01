# Custom Git aliases
clear

function git-pull { git pull }
Set-Alias -Name pl -Value git-pull -Option AllScope -Force

function git-checkout { 
  if ($args[0] -eq "."`
      -or $args[0] -eq "-"`
      -or $args[0].Contains("develop")`
      -or $args[0].Contains("master")`
      -or $args[0].Contains("release")`
      -or $args[0].Contains("/")`
      -or $args[0].StartsWith("*")) {
    git checkout $args
  } else {
    $result = git-branchlist $args[0]
    if ($result -and $result.Matches -and $result.Matches[0]) {
      git checkout $result.ToString().Trim()
    } else {
      Write-Host "Cannot find any branch containing '$($args[0])'" -f red
    }
  }
}
Set-Alias -Name co -Value git-checkout -Option AllScope -Force

function git-checkoutbranch { git checkout -b $args }
Set-Alias -Name cob -Value git-checkoutbranch -Option AllScope -Force

function git-log { git log --color --oneline --pretty=format:'%C(yellow)%h %Cblue%>(12)%ad %Cred%d %Creset%s' --abbrev-commit --date=relative }
Set-Alias -Name l -Value git-log -Option AllScope -Force

function git-commit {
  $branch = (git rev-parse --abbrev-ref HEAD); 
  if ($branch -match '(.+?)/(.+?)/(\d+)') {
    $task = $branch -replace '(.+?)/(.+?)/(\d+)', 'https://doctorlink.atlassian.net/browse/DL-$3'; 
    $args[0] += "`r`n`r`n$task"; 
  } 
  git commit -m $args 
}
Set-Alias -Name c -Value git-commit -Option AllScope -Force

function git-commit-amend { 
  git commit --amend --no-edit;
  git push -f
}
Set-Alias -name ca -Value git-commit-amend -Option AllScope -Force

function git-branchlist { 
  if ($args -and $args[0]) {
    git branch -l | Select-String -pattern $args[0]
  } else {
    git branch -l 
  }
} 
Set-Alias -Name bl -Value git-branchlist -Option AllScope -Force

function git-status { git status -s $args }
Set-Alias -Name s -Value git-status -Option AllScope -Force

function git-push { git push -u origin (git rev-parse --abbrev-ref HEAD) }
Set-Alias -Name p -Value git-push -Option AllScope -Force

function git-add { git add $args }
Set-Alias -Name add -Value git-add -Option AllScope -Force

function git-diff { git difftool --diff-filter=M -y }
Set-Alias -Name dt -Value git-diff -Option AllScope -Force

function git-diffcached { git difftool --diff-filter=M -y --cached }
Set-Alias -Name dtc -Value git-diffcached -Option AllScope -Force

function git-sync {
  git fetch upstream
  git merge upstream/master
}
Set-Alias -Name gs -Value git-sync -Option AllScope -Force

import-module posh-git
$GitPromptSettings.EnableWindowTitle = ''
$GitPromptSettings.DefaultPromptPath = '`e[37;1m$($(pwd).Path.Split("\")[-1])`e[0m'
$GitPromptSettings.BeforeText = ' '
$GitPromptSettings.AfterText = ' '
$GitPromptSettings.DefaultPromptSuffix = '`e[94m$([DateTime]::Now.ToString("HH:mm:ss"))`e[0m`n'

