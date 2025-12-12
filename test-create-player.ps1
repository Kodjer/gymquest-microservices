# Try to create player directly via API to see error
$apikey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFkanl6cmhuYnJ4dWdhbGNxdWJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwMzQ3NDIsImV4cCI6MjA4MDYxMDc0Mn0.BU6M61AMh7p5l6JN9IdERrJldYJDWVgS3NlqHtrXEqs"
$baseUrl = "https://qdjyzrhnbrxugalcqubg.supabase.co/rest/v1"

$headers = @{
    'apikey' = $apikey
    'Authorization' = "Bearer $apikey"
    'Content-Type' = 'application/json'
    'Prefer' = 'return=representation'
}

Write-Host "Attempting to create player..."
$playerData = @{
    id = (New-Guid).ToString()
    username = "TestPlayer"
    level = 1
    xp = 0
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/players" -Method POST -Headers $headers -Body $playerData
    Write-Host "SUCCESS!" -ForegroundColor Green
    $result
} catch {
    Write-Host "ERROR:" -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host $_.ErrorDetails.Message
}
