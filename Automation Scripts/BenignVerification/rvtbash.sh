#!/usr/bin/env bash

echo "Starting Checking Script in API"
ap[0]="apikey=\"09adf60fb076ea047de9b978a576dc2abac78c6c090f32145b5745959ae0e2d1\""
ap[1]="apikey=\"e27022dd1392f71b8b149608c8e545b6033f97fc92065ab5f6b3882cfbe4d118\""
ap[2]="apikey=\"c906fed8ab7ef9cc323b31fe0bb2eb1854305c66a8dfc8ce0b320bf011b2acc6\""
ap[3]="apikey=\"e755fcb39b8731193c29a3b112ba55d95d34e7acce1d54ce4d7c8804403f6a0a\""
num=$(cat /home/doonu/Desktop/mainwork/vscfile.txt | cut -c 1-4)
# num=1
for ((i = 1; i <= 4; i++)); do

    vn=1
    echo "API-$i ************** "
    echo ${ap[$i - 1]} >/home/doonu/.vt.toml
    for ((j = 1; j <= 4; j++)); do
        echo "Value of j is = $j"
        var1=$(cat /home/doonu/Desktop/mainwork/vfile/$i/vfile$j.txt | cut -c 1-60)
        echo "Hash ID is: $var1"
        var2=$(vt analysis $var1 --include=stats | sed '5!d' | cut -c 16)
        var3=$(vt analysis $var1 --include=status | cut -c 12-20)
        vt analysis $var1 --include=stats --include=status
        echo "Malicious count:$var2"
        echo "Scanner file number:$num"

        if [[ "$var3" == "completed" ]]; then
            if [[ "$var2" == "0" ]]; then
                echo "Beign File Found"
                sudo mv /home/doonu/Desktop/mainwork/newSample/bb$num.exe /home/doonu/Desktop/mainwork/benign/vbeign$num.exe
                ((num = num + 1))

            else
                echo "malicious file found"
                sudo mv /home/doonu/Desktop/mainwork/newSample/bb$num.exe /home/doonu/Desktop/mainwork/malicious/vmalicious$num.exe
                ((num = num + 1))

            fi
        else
            echo "Value of j is = $j"
            sleep 5

            ((j = j - 1))
            ((vn = vn + 1))
            if [[ "$vn" == "10" ]]; then
                ((j = j + 1))
                echo "$var1" | cat >>/home/doonu/Desktop/mainwork/queue.txt
                ((num = num + 1))
            fi
        fi
        sleep 2
    done
done

echo "Final Scanned File is:$num minus 1"
# true >queue.txt
echo "$num" | cat >/home/doonu/Desktop/mainwork/vscfile.txt
exit
