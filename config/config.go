package config

import (
	"strings"
	"sync"

	log "github.com/ashokrajar/zerolog_wrapper"
	"github.com/spf13/viper"
)

var once sync.Once

func InitConfig() {
	once.Do(func() {
		viper.SetConfigName(".go-app-cli-template") // name of config file (without extension)
		viper.AddConfigPath(".")                    // look for config in the working directory
		viper.AddConfigPath("$HOME/")               // optionally adding home directory as second search path
		viper.AutomaticEnv()                        // Load from environments
		viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))

		logLevel := strings.ToLower(viper.GetString("log.level"))
		if logLevel == "" {
			logLevel = "info"
		}

		appEnv := strings.ToLower(viper.GetString("app.env"))
		if appEnv == "" {
			appEnv = "dev"
		}

		log.InitLog(log.LogLevel(logLevel), log.Env(appEnv))

		// If a config file is found, read from it.
		if err := viper.ReadInConfig(); err != nil {
			log.Info().Msg("Unable to read application config file. Using defaults & environment variables.")
		} else {
			log.Info().Str("ConfigFile", viper.ConfigFileUsed()).Msg("Using config file & environment variables")
		}
	})
}

var (
	LogLevel   = viper.Get("log.level")
	AppEnv     = viper.Get("app.env")
	AppVersion string
)
