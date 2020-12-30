package com.github.purkhusid.echo

import java.util.logging.Logger

import io.grpc.{Server, ServerBuilder}
import com.github.purkhusid.proto.echo.service.{EchoServiceGrpc}
import com.github.purkhusid.proto.echo.models.{Request, Response}

import scala.concurrent.{ExecutionContext, Future}

object EchoService {
  private val logger = Logger.getLogger(classOf[EchoService].getName)

  def main(args: Array[String]): Unit = {
    val server = new EchoService(ExecutionContext.global)
    server.start()
    server.blockUntilShutdown()
  }

  private val port = 8080
}

class EchoService(executionContext: ExecutionContext) { self =>
  private[this] var server: Server = null

  private def start(): Unit = {
    server = ServerBuilder.forPort(EchoService.port).addService(EchoServiceGrpc.bindService(new EchoServiceImpl, executionContext)).build.start
    EchoService.logger.info("Server started, listening on " + EchoService.port)
    sys.addShutdownHook {
      System.err.println("*** shutting down gRPC server since JVM is shutting down")
      self.stop()
      System.err.println("*** server shut down")
    }
  }

  private def stop(): Unit = {
    if (server != null) {
      server.shutdown()
    }
  }

  private def blockUntilShutdown(): Unit = {
    if (server != null) {
      server.awaitTermination()
    }
  }

  private class EchoServiceImpl extends EchoServiceGrpc.EchoService {
    override def echo(req: Request) = {
      val reply = Response(message = req.message)
      Future.successful(reply)
    }
  }

}
