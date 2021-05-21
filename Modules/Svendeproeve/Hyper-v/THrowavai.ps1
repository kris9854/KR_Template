$ip = '10.0.255.'
[int]$counter = 4

do {
    write-host "$ip$counter"
    $counter + 4;
} while ($counter -ge '255')
