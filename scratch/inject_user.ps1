$apiKey = "AIzaSyCZp1K6dGvQ7GsjNtU-S-8Rt_kMbt5Ez-4"
$projectId = "mierp-apps"

$loginBody = @{
    email = "admin@mierp.com"
    password = "password123"
    returnSecureToken = $true
} | ConvertTo-Json

Write-Output "Mencoba login untuk mendapatkan token..."
$idToken = $null
$uid = $null
try {
    $loginResponse = Invoke-RestMethod -Uri "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey" -Method Post -Body $loginBody -ContentType "application/json"
    $uid = $loginResponse.localId
    $idToken = $loginResponse.idToken
    Write-Output "Berhasil login. UID: $uid"
} catch {
    Write-Output "Gagal login: $_"
    exit
}

Write-Output "Menyimpan data role ke Firestore..."
$firestoreBody = @{
    fields = @{
        email = @{ stringValue = "admin@mierp.com" }
        first_name = @{ stringValue = "Admin" }
        last_name = @{ stringValue = "Warehouse" }
        role = @{ stringValue = "warehouse" }
        allow_google_login = @{ booleanValue = $false }
    }
} | ConvertTo-Json -Depth 5

# Notice we use documentId=? as parameter for the Create operation, but since we are patching we do this:
$firestoreUrl = "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid"

$headers = @{
    Authorization = "Bearer $idToken"
}

try {
    $firestoreResponse = Invoke-RestMethod -Uri $firestoreUrl -Method Patch -Body $firestoreBody -ContentType "application/json" -Headers $headers
    Write-Output "Berhasil menyimpan data Firestore."
} catch {
    Write-Output "Gagal menyimpan ke firestore: $_"
}
