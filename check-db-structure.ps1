# Check DB table structures
$apikey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFkanl6cmhuYnJ4dWdhbGNxdWJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwMzQ3NDIsImV4cCI6MjA4MDYxMDc0Mn0.BU6M61AMh7p5l6JN9IdERrJldYJDWVgS3NlqHtrXEqs"
$baseUrl = "https://qdjyzrhnbrxugalcqubg.supabase.co/rest/v1"

$headers = @{
    'apikey' = $apikey
    'Authorization' = "Bearer $apikey"
}

Write-Host "Checking Players table..."
try {
    $players = Invoke-RestMethod -Uri "$baseUrl/players?limit=1" -Headers $headers
    if ($players.Count -gt 0) {
        Write-Host "Players table columns:"
        $players[0].PSObject.Properties | ForEach-Object { Write-Host "  - $($_.Name): $($_.Value)" }
    } else {
        Write-Host "Players table is empty"
    }
} catch {
    Write-Host "Error: $_"
}

Write-Host "`nChecking Quests table..."
try {
    $quests = Invoke-RestMethod -Uri "$baseUrl/quests?limit=1" -Headers $headers
    if ($quests.Count -gt 0) {
        Write-Host "Quests table columns:"
        $quests[0].PSObject.Properties | ForEach-Object { Write-Host "  - $($_.Name): $($_.Value)" }
    } else {
        Write-Host "Quests table is empty"
    }
} catch {
    Write-Host "Error: $_"
}

Write-Host "`nChecking Notifications table..."
try {
    $notifs = Invoke-RestMethod -Uri "$baseUrl/notifications?limit=1" -Headers $headers
    if ($notifs.Count -gt 0) {
        Write-Host "Notifications table columns:"
        $notifs[0].PSObject.Properties | ForEach-Object { Write-Host "  - $($_.Name): $($_.Value)" }
    } else {
        Write-Host "Notifications table is empty"
    }
} catch {
    Write-Host "Error: $_"
}
