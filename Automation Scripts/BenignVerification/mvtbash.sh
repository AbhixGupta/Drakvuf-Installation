#!/usr/bin/env bash

echo "Starting Script in API-1"
var1=$(cat /home/doonu/Desktop/mainwork/scfile.txt | cut -c 1-4)
ap[0]="apikey=\"09adf60fb076ea047de9b978a576dc2abac78c6c090f32145b5745959ae0e2d1\""
ap[1]="apikey=\"e27022dd1392f71b8b149608c8e545b6033f97fc92065ab5f6b3882cfbe4d118\""
ap[2]="apikey=\"c906fed8ab7ef9cc323b31fe0bb2eb1854305c66a8dfc8ce0b320bf011b2acc6\""
ap[3]="apikey=\"e755fcb39b8731193c29a3b112ba55d95d34e7acce1d54ce4d7c8804403f6a0a\""

for ((k = 1; k <= 80; k++)); do
    for ((i = 1; i <= 4; i++)); do

        echo "API-$i ************** "
        echo ${ap[$i - 1]} >/home/doonu/.vt.toml

        for ((j = 1; j <= 4; j++)); do

            echo "Loop ID is = $var1"
            $(vt scan file /home/doonu/Desktop/mainwork/newSample/bb$var1.exe | grep -E -o '[a-zA-Z0-9]{58}==$' >/home/doonu/Desktop/mainwork/vfile/$i/vfile$j.txt)
            echo "Scanner file number:$var1"
            ((var1 = var1 + 1))
            sleep 4

        done

    done

    echo "Final Scanned File is:$var1 minus 1"
    echo "$var1" | cat >/home/doonu/Desktop/mainwork/scfile.txt

    sleep 20
    DISPLAY=:0 xterm -e bash -c "echo Verification starting;sleep 5"

    DISPLAY=:0 konsole -e bash -c "/bin/bash /home/doonu/Desktop/mainwork/rvtbash.sh"
    # /bin/bash /home/doonu/Desktop/mainwork/rvtbash.sh
done

#     #vt3
#     echo "apikey="e27022dd1392f71b8b149608c8e545b6033f97fc92065ab5f6b3882cfbe4d118"" > /home/doonu/.vt.toml
#     for ((j = 1; j <= 4; j++)); do

#     echo "Loop ID is = $var1"
#     $(vt scan file /home/doonu/Desktop/mainwork/newSample/bb$var1.exe | grep -E -o '[a-zA-Z0-9]{58}==$' > /home/doonu/Documents/vfile/2/vfile$j.txt)
#       ((var1=var1+1))

# done

#     #vt4
#     echo "apikey="c906fed8ab7ef9cc323b31fe0bb2eb1854305c66a8dfc8ce0b320bf011b2acc6"" > /home/doonu/.vt.toml
#     for ((j = 1; j <= 4; j++)); do

#     echo "Loop ID is = $var1"
#     $(vt scan file /home/doonu/Desktop/mainwork/newSample/bb$var1.exe | grep -E -o '[a-zA-Z0-9]{58}==$' > /home/doonu/Documents/vfile/3/vfile$j.txt)
#       ((var1=var1+1))

# done

#     #vt8
#     echo "apikey="e755fcb39b8731193c29a3b112ba55d95d34e7acce1d54ce4d7c8804403f6a0a"" > /home/doonu/.vt.toml
#     for ((j = 1; j <= 4; j++)); do

#     echo "Loop ID is = $var1"
#     $(vt scan file /home/doonu/Desktop/mainwork/newSample/bb$var1.exe | grep -E -o '[a-zA-Z0-9]{58}==$' > /home/doonu/Documents/vfile/4/vfile$j.txt)
#       ((var1=var1+1))

# done
