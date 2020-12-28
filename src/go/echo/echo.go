package main

import (
	"log"

	"github.com/purkhusid/bazel-bootstrap/src/proto/echo/models"
	"golang.org/x/net/context"
)

// Server ...
type Server struct {
}

// Echo ...
func (s *Server) Echo(ctx context.Context, request *models.Request) (*models.Response, error) {
	log.Printf("Receive message body from client: %s", request.Message)
	return &models.Response{Message: request.Message}, nil
}
