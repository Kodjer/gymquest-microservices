# Try to create notification to see structure
$apikey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFkanl6cmhuYnJ4dWdhbGNxdWJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwMzQ3NDIsImV4cCI6MjA4MDYxMDc0Mn0.BU6M61AMh7p5l6JN9IdERrJldYJDWVgS3NlqHtrXEqs"
$baseUrl = "https://qdjyzrhnbrxugalcqubg.supabase.co/rest/v1"

$headers = @{
    'apikey' = $apikey
    'Authorization' = "Bearer $apikey"
    'Content-Type' = 'application/json'
    'Prefer' = 'return=representation'
}

Write-Host "Attempting to create notification..."
$notifData = @{
    id = (New-Guid).ToString()
    player_id = "e5dc2a5b-009c-4945-907b-d0aeb166c17c"
    message = "Test notification"
    type = "info"
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/notifications" -Method POST -Headers $headers -Body $notifData
    Write-Host "SUCCESS!" -ForegroundColor Green
    $result
} catch {
    Write-Host "ERROR:" -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host $_.ErrorDetails.Message
}
