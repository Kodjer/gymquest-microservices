# Создание достижений в Supabase
$url = "https://qdjyzrhnbrxugalcqubg.supabase.co"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFkanl6cmhuYnJ4dWdhbGNxdWJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwMzQ3NDIsImV4cCI6MjA4MDYxMDc0Mn0.BU6M61AMh7p5l6JN9IdERrJldYJDWVgS3NlqHtrXEqs"

Write-Host "Creating achievements..." -ForegroundColor Yellow

# Achievement 1
$id1 = "e1111111-1111-1111-1111-111111111111"
$json1 = @"
[{"id":"$id1","name":"First Step","description":"Complete first quest"}]
"@
$json1 | Out-File -FilePath "ach1.json" -Encoding UTF8

# Achievement 2
$id2 = "e2222222-2222-2222-2222-222222222222"
$json2 = @"
[{"id":"$id2","name":"Level Master","description":"Reach level 5"}]
"@
$json2 | Out-File -FilePath "ach2.json" -Encoding UTF8

# Achievement 3
$id3 = "e3333333-3333-3333-3333-333333333333"
$json3 = @"
[{"id":"$id3","name":"Quest Hunter","description":"Complete 10 quests"}]
"@
$json3 | Out-File -FilePath "ach3.json" -Encoding UTF8

# Create achievements
Write-Host "1. Creating achievements in achievements table..."
curl.exe -s -X POST "$url/rest/v1/achievements" `
  -H "apikey: $key" `
  -H "Authorization: Bearer $key" `
  -H "Content-Type: application/json" `
  -H "Prefer: return=representation" `
  -d "@ach1.json"

curl.exe -s -X POST "$url/rest/v1/achievements" `
  -H "apikey: $key" `
  -H "Authorization: Bearer $key" `
  -H "Content-Type: application/json" `
  -H "Prefer: return=representation" `
  -d "@ach2.json"

curl.exe -s -X POST "$url/rest/v1/achievements" `
  -H "apikey: $key" `
  -H "Authorization: Bearer $key" `
  -H "Content-Type: application/json" `
  -H "Prefer: return=representation" `
  -d "@ach3.json"

Write-Host "2. Linking to user..."

# Link to user
$user1 = @"
[{"user_id":"demo-user-123","achievement_id":"$id1"}]
"@
$user1 | Out-File -FilePath "user1.json" -Encoding UTF8

$user2 = @"
[{"user_id":"demo-user-123","achievement_id":"$id2"}]
"@
$user2 | Out-File -FilePath "user2.json" -Encoding UTF8

$user3 = @"
[{"user_id":"demo-user-123","achievement_id":"$id3"}]
"@
$user3 | Out-File -FilePath "user3.json" -Encoding UTF8

curl.exe -s -X POST "$url/rest/v1/user_achievements" `
  -H "apikey: $key" `
  -H "Authorization: Bearer $key" `
  -H "Content-Type: application/json" `
  -H "Prefer: return=representation" `
  -d "@user1.json"

curl.exe -s -X POST "$url/rest/v1/user_achievements" `
  -H "apikey: $key" `
  -H "Authorization: Bearer $key" `
  -H "Content-Type: application/json" `
  -H "Prefer: return=representation" `
  -d "@user2.json"

curl.exe -s -X POST "$url/rest/v1/user_achievements" `
  -H "apikey: $key" `
  -H "Authorization: Bearer $key" `
  -H "Content-Type: application/json" `
  -H "Prefer: return=representation" `
  -d "@user3.json"

# Cleanup
Remove-Item ach*.json -Force
Remove-Item user*.json -Force

Write-Host "`nDone! Checking..." -ForegroundColor Green
Start-Sleep -Seconds 1

$result = Invoke-RestMethod "http://localhost:3003/api/achievements/demo-user-123"
Write-Host "Achievements: $($result.Count)" -ForegroundColor Cyan
$result | ForEach-Object {
    Write-Host "  - Achievement: $($_.achievement_id)" -ForegroundColor White
    Write-Host "    Unlocked: $($_.unlocked_at)" -ForegroundColor Gray
}
