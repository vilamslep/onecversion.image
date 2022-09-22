package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/ilyakaznacheev/cleanenv"
	"github.com/vilamslep/onec.versioning/lib"
	"github.com/vilamslep/onec.versioning/logger"
	"github.com/vilamslep/onec.versioning/raw"
)

type config struct {
	Socket struct {
		Host string `env:"APIHOST" env-default:"0.0.0.0"`
		Port int    `env:"APIPORT" env-default:"4000"`
	}
}

func main() {
	logger.Info("config initialization")
	conf := config{}
	if err := cleanenv.ReadEnv(&conf); err != nil {
		head := "Onec Versioning: Service 'Api' "
		if desc, err := cleanenv.GetDescription(conf, &head); err == nil {
			logger.Fatal(desc)
		} else {
			logger.Fatal(err)
		}
	}

	if err := lib.CreateDatabaseConnection(); err != nil {
		logger.Fatal(err)
	}

	logger.Info("setting router")
	r := chi.NewRouter()
	r.Use(logger.MiddlewareLogger())
	r.Use(middleware.Recoverer)
	r.Use(middleware.RequestID)

	r.Route("/version", func(r chi.Router) {
		r.Post("/list", List)
		r.Get("/entity", EntityById)
	})

	logger.Info("starting web service")
	if err := http.ListenAndServe(fmt.Sprintf(":%d", conf.Socket.Port), r); err != nil {
		logger.Fatal(err)
	}
}

func List(w http.ResponseWriter, r *http.Request) {

	if r.Body == http.NoBody {
		logger.Error("request body is nobody")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("request body is nobody"))
		return
	}
	defer r.Body.Close()

	data, err := ioutil.ReadAll(r.Body)
	if err != nil {
		logger.Error("can not read body")
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("can not read body"))
		return
	}

	if len(data) == 0 {
		logger.Info("input is empty")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("body is empty"))
	}

	if ok := raw.CheckRawDataRef(string(data)); !ok {
		logger.Info("input have unexpected data")
		logger.Info(string(data))
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("body contents unexpected data"))
		return
	}

	ref := string(data)

	recs, err := lib.ListVersions(ref)

	logger.Infof("list versions has %d of records", len(recs))

	if content, err := json.Marshal(recs); err == nil {
		w.Write(content)
	} else {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
	}
}

func EntityById(w http.ResponseWriter, r *http.Request) {
	id := r.URL.Query().Get("id")
	if id == "" {
		logger.Warn("have not been define 'id' value")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("have not been define 'id' value"))
	}

	if v, err := lib.GetVersionById(id); err == nil {
		w.Write(v)
	} else {
		logger.Error(err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("can not get version's record"))
	}
}
