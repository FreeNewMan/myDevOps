# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```

####Ответ:
```
package main

import "fmt"

func main() {
	fmt.Print("Введите значение в метрах: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := Mtof(input)

	fmt.Println(output)
}

func Mtof(inval float64) float64 {
	a := inval / 0.3048
	return a
}

```

 
1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
####Ответ:
```
package main

import "fmt"

func Getmin(a []int) int {
	mc := a[0]
	for _, value := range a {
		if value < mc {
			mc = value
		}
	}
	return mc
}

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	minval := Getmin(x)
	fmt.Println(minval)
}

```    
1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

####Ответ:
```
package main

import "fmt"

func Get3val(xmin int, xmax int) []int {
	var a []int

	for i := xmin; i <= xmax; i++ {
		if !(i%3 > 0) {
			a = append(a, i)
		}

	}

	return a
}

func main() {
	xmnin := 1
	xmax := 100
	outval := Get3val(xmnin, xmax)
	fmt.Println(outval)
}

```

В виде решения ссылку на код или сам код. 

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 
```
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
	//Ожидаемый результат
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

```

---

