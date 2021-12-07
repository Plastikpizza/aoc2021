for line in $(cat input.txt)
do
    list+=($line)
done
len=${#list[*]}
let len=$len-1
let counter=0
for ((i=0; i<len; i++))
do
    let ni=$i+1
    if ((list[$i] < list[$ni]))
    then
        let counter+=1
    fi
done
echo $counter
let len=$len-2
let counter=0
for ((i=0; i<len; i++))
do
    let s1=0
    let s2=0
    for ((j=0; j<3; j++))
    do
        let s1+=list[$i+$j]
    done
    for ((j=1; j<4; j++))
    do
        let s2+=list[$i+$j]
    done
    if (($s1 < $s2))
    then
        let counter+=1
    fi
done
echo $counter