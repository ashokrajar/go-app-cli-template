// Package cmd
/*
MIT License

# Copyright © Ashok Raja <ashokrajar@gmail.com>

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
package cmd

import (
	"fmt"
	"os"
	"os/user"
	"runtime/debug"
	"time"

	"github.com/spf13/cobra"
)

var (
	Version      = "Unknown"
	VCSBranch    = "Unknown"
	VCSCommitID  = "Unknown"
	LastCommitOn = time.Time{}
	BuildHost    = "Unknown"
	BuiltBy      = "Unknown"
	GOVersion    = "Unknown"
	GOArch       = "Unknown"
	GOOS         = "Unknown"
	DirtyBuild   = false
	BuildTime    = time.Now().Format("Mon, 02 Jan 2006 15:04:05 UTC")
)

func init() {
	rootCmd.AddCommand(versionCmd, buildInfoCmd)
}

func initBuildInfo() {
	buildInfo, _ := debug.ReadBuildInfo()

	GOVersion = buildInfo.GoVersion

	for _, kv := range buildInfo.Settings {
		switch kv.Key {
		case "vcs.revision":
			VCSCommitID = kv.Value[:7]
		case "vcs.time":
			LastCommitOn, _ = time.Parse(time.RFC3339, kv.Value)
		case "vcs.modified":
			DirtyBuild = kv.Value == "true"
		case "GOARCH":
			GOArch = kv.Value
		case "GOOS":
			GOOS = kv.Value
		}
	}

	hostName, err := os.Hostname()
	if err == nil {
		BuildHost = hostName
	}

	user, _ := user.Current()
	if err == nil {
		BuiltBy = user.Username
	}
}

// ShowBuildInfo displays the application build info
func ShowBuildInfo() {
	fmt.Println("##################### Build Info #####################")
	fmt.Printf("App Version   : %s\n", Version)
	fmt.Printf("GO Version    : %s\n", GOVersion)
	fmt.Printf("OS            : %s\n", GOArch)
	fmt.Printf("Architecture  : %s\n", GOOS)
	fmt.Printf("Git Branch    : %s\n", VCSBranch)
	fmt.Printf("Git Commit ID : %s\n", VCSCommitID)
	fmt.Printf("Build Time    : %s\n", BuildTime)
	fmt.Printf("Built By      : %s\n", BuiltBy)
	fmt.Printf("Build Host    : %s\n", BuildHost)
	fmt.Println("######################################################")
}

// versionCmd represents the version command
var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Display the application version.",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(Version)
	},
}

// buildInfoCmd represents the build-info command
var buildInfoCmd = &cobra.Command{
	Use:   "build-info",
	Short: "Displays the application build info.",
	Run: func(cmd *cobra.Command, args []string) {
		ShowBuildInfo()
	},
}
