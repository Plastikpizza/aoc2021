input=$(cat input.txt | tr "," "\n")
median=$(for n in $input; do printf "%d\n" $n; done | datamash median 1)
avg=$(for n in $input; do printf "%d\n" $n; done | datamash mean 1)
let avg=$(printf "%.0f" $avg)-1

sumTo() {
	let n=$1
	let "a=($n*($n+1))/2"
	echo $a
}

let fuel1=0
let fuel2=0
for line in $input
do
	let num1=$line-$median
	let abs1=${num1#-}
	let fuel1+=$abs1

	let num2=$line-$avg
	let abs2=${num2#-}
	let fuel2+=$(sumTo $abs2)
done
printf "part 1: %d\n" $fuel1
printf "part 2: %d\n" $fuel2