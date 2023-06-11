/*
MIT License

# Copyright © Ashok Raja

Authors: Ashok Raja <ashokrajar@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
package main

import (
	"fmt"
	"os"

	log "github.com/ashokrajar/zerolog_wrapper"
	"go-app-cli-template/config"
)

var Version string

func init() {
	config.InitConfig()
}

func main() {
	cliApp := &cli.App{
		Name:    "go-app-cli-template",
		Version: Version,
		Authors: []*cli.Author{
			&cli.Author{
				Name:  "Ashok Raja",
				Email: "ashokrajar@gmail.com",
			},
		},
		Copyright: "(c) 2023 Ashok Raja <ashokrajar@gmail.com>",
		Usage:     "A Simple Cli App",
		Action: func(*cli.Context) error {
			fmt.Println("Hello World !")
			return nil
		},
	}

	if err := cliApp.Run(os.Args); err != nil {
		log.Fatal().Err(err)
	}
}
