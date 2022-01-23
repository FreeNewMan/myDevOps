package main

import "fmt"

func main() {
	fmt.Print("Введите значение в метрах: ")
	var input float64
	fmt.Scanf("%f", &input)

	//--
	output := Mtof(input)
	fmt.Println(output)

	//
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	minval := Getmin(x)
	fmt.Println(minval)

	//
	xmnin := 1
	xmax := 100
	outval := Get3val(xmnin, xmax)
	fmt.Println(outval)

}

func Mtof(inval float64) float64 {
	a := inval / 0.3048
	return a
}

func Getmin(a []int) int {
	mc := a[0]
	for _, value := range a {
		if value < mc {
			mc = value
		}
	}
	return mc
}

func Get3val(xmin int, xmax int) []int {
	var a []int

	for i := xmin; i <= xmax; i++ {
		if !(i%3 > 0) {
			a = append(a, i)
		}

	}

	return a
}
