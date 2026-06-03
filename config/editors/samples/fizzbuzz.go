package main

import "fmt"

// Prints "Fizz", "Buzz", or "FizzBuzz" for numbers from 1 to n.
// - "Fizz" for numbers divisible by 3.
// - "Buzz" for numbers divisible by 5.
// - "FizzBuzz" for numbers divisible by both 3 and 5.
// - Otherwise, prints the number itself.
func fizzBuzz(n int) {
	for i := 1; i <= n; i++ {
		if i%15 == 0 {
			fmt.Println("FizzBuzz")
		} else if i%3 == 0 {
			fmt.Println("Fizz")
		} else if i%5 == 0 {
			fmt.Println("Buzz")
		} else {
			fmt.Println(i)
		}
	}
}

func main() {
	fizzBuzz(15)
}
