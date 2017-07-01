1. Place files in %HOMEPATH%
2. Install [vim-plug](https://github.com/junegunn/vim-plug)
```
md ~\vimfiles\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\vimfiles\autoload\plug.vim"
  )
)
```
3. Run `:PlugInstall`
4. Restart vim
