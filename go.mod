module github.com/purkhusid/bazel-monorepo

go 1.15

require (
	github.com/purkhusid/bazel-bootstrap/src/proto/echo/models v0.0.0
	github.com/purkhusid/bazel-bootstrap/src/proto/echo/service v0.0.0
	github.com/sirupsen/logrus v1.7.0 // indirect
	golang.org/x/net v0.0.0-20190311183353-d8887717615a
	google.golang.org/grpc v1.34.0
)

// START OF GENERATED
replace github.com/purkhusid/bazel-bootstrap/src/proto/echo/service v0.0.0 => ./bazel-bin/src/proto/echo/service/service_go_proto_/github.com/purkhusid/bazel-bootstrap/src/proto/echo/service

replace github.com/purkhusid/bazel-bootstrap/src/proto/echo/models v0.0.0 => ./bazel-bin/src/proto/echo/models/models_go_proto_/github.com/purkhusid/bazel-bootstrap/src/proto/echo/models

// END OF GENERATED
