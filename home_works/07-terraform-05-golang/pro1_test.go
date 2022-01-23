package main

import "testing"

func TestMtof(t *testing.T) {
	//Входные данные
	ex := 4
	//Ожидаемы результат
	out := 13.123359580052492

	var v float64
	v = Mtof(float64(ex))

	if v != out {
		t.Errorf("Ожидали %v, получили %v ", out, v)
	}

}

func TestGetmin(t *testing.T) {
	//Входные данные
	ex := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	//Ожидаемы результат
	out := 9

	//Запускаем функцию
	var v int
	v = Getmin(ex)

	if v != out {
		t.Errorf("Ожидали %v, получили %v ", out, v)
	}

}

func TestGet3val(t *testing.T) {
	//Входные данные
	xmnin := 1
	xmax := 10
	//Ожидаемы результат
	out := []int{3, 6, 9}

	//Запускаем функцию
	var v []int
	v = Get3val(xmnin, xmax)

	if !Equal(v, out) {
		t.Errorf("Ожидали %v, получили %v ", out, v)
	}

}

func Equal(a, b []int) bool {
	if len(a) != len(b) {
		return false
	}
	for i, v := range a {
		if v != b[i] {
			return false
		}
	}
	return true
}
