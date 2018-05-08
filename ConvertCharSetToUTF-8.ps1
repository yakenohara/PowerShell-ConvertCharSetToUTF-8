#変換対象ファイル拡張子
$extCandidates = @(
    ".awk",
    ".c",
    ".cpp",
    ".cxx",
    ".cc",
    ".cp",
    ".c++",
    ".h",
    ".hpp",
    ".hxx",
    ".hh",
    ".hp",
    ".h++",
    ".rc",
    ".hm",
    ".cbl",
    ".cpy",
    ".pco",
    ".cob",
    ".html",
    ".htm",
    ".shtml",
    ".plg",
    ".java",
    ".jav",
    ".bat",
    ".dpr",
    ".pas",
    ".cgi",
    ".pl",
    ".pm",
    ".sql",
    ".plsql",
    ".tex",
    ".ltx",
    ".sty",
    ".bib",
    ".log",
    ".blg",
    ".aux",
    ".bbl",
    ".toc",
    ".lof",
    ".lot",
    ".idx",
    ".ind",
    ".glo",
    ".bas",
    ".frm",
    ".cls",
    ".ctl",
    ".pag",
    ".dob",
    ".dsr",
    ".vb",
    ".asm",
    ".txt",
    ".log",
    ".1st",
    ".err",
    ".ps",
    ".rtf",
    ".ini",
    ".inf",
    ".cnf",
    ".kwd",
    ".col"
)

#変数宣言
$scs = 0
$err = 0
$excluded = 0

#変換ループ
foreach ($path in $Args) {
    
    Write-Host $path
    
    #ファイルの場合
    if (Test-Path $path -PathType leaf) { #ファイルの場合
        
        $nowExt = [System.IO.Path]::GetExtension($path)
        
        $conv = $FALSE #変換するかどうか
        
        #変換対象ファイル拡張子かどうかチェック
        foreach ($extCandidate in $extCandidates) {
            
            if ($extCandidate -eq $nowExt) { #変換対象ファイル拡張子の時
                $conv = $TRUE #変換するを設定
                break
            }
            
        }
        
        if ($conv) { #変換対象ファイル拡張子の時
            
            try{
                #UTF-8に変換
                &{[IO.File]::WriteAllText($path, [IO.File]::ReadAllText($path, [Text.Encoding]::Default))}
                $scs++
                
            } catch { #変換失敗の場合
                Write-Error $error[0]
                $err++
                
            }
        
        } else { #変換対象ファイル拡張子でない
            Write-Warning "変換対象外ファイルです。処理から除外します。"
            $excluded++
            
        }
    }
}

Write-Host ""
Write-Host "除外数"
Write-Host $excluded
Write-Host "失敗数"
Write-Host $err

if (($excluded -gt 0 ) -Or ($err -gt 0 )){
    exit 1
    
}else {
    exit 0
    
}
