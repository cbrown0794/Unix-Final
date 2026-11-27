# bench-models.ps1 (GENERATED USING CLAUDE AI SONNET 5.5)
param(
  [string]$Model,
  [string]$Prompt,
  [int]$Port = 11434,
  [string]$OutFile = ""
)

$body = @{
  model = $Model; prompt = $Prompt; stream = $false
  options = @{ temperature = 0; seed = 42 }
} | ConvertTo-Json -Depth 5

$r = Invoke-RestMethod -Uri "http://localhost:$Port/api/generate" -Method Post `
     -Body $body -ContentType "application/json" -TimeoutSec 900

$summary = [pscustomobject]@{
  Timestamp    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Model        = $Model
  Port         = $Port
  LoadSec      = [math]::Round($r.load_duration / 1e9, 2)
  PromptTokens = $r.prompt_eval_count
  PromptSec    = [math]::Round($r.prompt_eval_duration / 1e9, 2)
  TTFT_Sec     = [math]::Round(($r.load_duration + $r.prompt_eval_duration) / 1e9, 2)
  GenTokens    = $r.eval_count
  TokPerSec    = [math]::Round($r.eval_count / ($r.eval_duration / 1e9), 1)
}

$text = ($summary | Format-List | Out-String) + "--- PROMPT ---`n$Prompt`n--- RESPONSE ---`n$($r.response)`n`n"
$text
if ($OutFile) { $text | Out-File -Encoding utf8 -Append $OutFile }

# $p1 = "Explain the difference between a process and a thread in Unix in 4 sentences."
# $ctx = "Context: The nightly backup runs at 02:00 UTC. Backups are stored on the /data/db logical volume and kept for 14 days. Restores require the operator to run restore.sh with the snapshot name."
# $p2 = "$ctx`n`nUsing only the context above, answer: How long are backups kept and where are they stored?"
# $p3 = "$ctx`n`nUsing only the context above, answer: Which cloud region hosts the backups?"