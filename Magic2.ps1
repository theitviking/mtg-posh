#############
# GUI Block #
#############

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(475,300)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(350,75)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(350,105)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Paste your decklist below:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $True
$textBox.ScrollBars = "Vertical"
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(300,200)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

#################
# End GUI Block #
#################


# Assign text input to $INPUT variable.
# Output to deck.txt

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $INPUT = $textBox.Text
    $INPUT | Out-File -FilePath C:\Users\Luke.Anderson\Documents\PSscripts\deck.txt
}
elseif ($CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel) {
    exit
}

# Assign $DECK as an empty array

$DECK = @()

# Split text by column
# Store cards ($CARD) into a deck ($DECK) array for the total number ($COUNT) of each card ($CARD)

ForEach($LINE in Get-Content -Path C:\Users\Luke.Anderson\Documents\PSscripts\deck.txt) {
    $SPLITUP = $LINE -split "\s+"
    $COUNT = $SPLITUP[0]
    $CARD = ($SPLITUP[1] + " " + $SPLITUP[2] + " " + $SPLITUP[3] + " " + $SPLITUP[4])
    ForEach($NUM in 1..$COUNT) {
        $DECK += $CARD
    }
}    

# Pick 7 random items from $DECK array, write output

Write-Host `n"Here's your hand!"`n"-----------------"`n -ForegroundColor Green
$HAND = $DECK | Get-Random -Count 7
$HAND

# Convert deck to allow removal from array
# Remove hand from deck

$DECK = [System.Collections.ArrayList]$DECK
ForEach($ITEM in $HAND) {
    $DECK.Remove($ITEM)
}

# Randomize $DECK and write output

Write-Host `n"Here's your deck!"`n"-----------------"`n -ForegroundColor Green
$DECK = $DECK | Get-Random -Count 53
$DECK