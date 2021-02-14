module Tests

open System
open Grpc.Core
open Src.Proto.Echo.Service
open Src.Proto.Echo.Models
open System.Threading.Tasks

type EchoImpl() =
    inherit EchoService.EchoServiceBase()
    override this.Echo (request: Request, context: ServerCallContext): Task<Response> =
            Task.FromResult(Response(Message = request.Message))

[<EntryPoint>]
let main argv =
    let host = "127.0.0.1"
    let port = 8080

    let server = Server()
    server.Services.Add(EchoService.BindService(new EchoImpl()))
    server.Ports.Add(ServerPort(host, port, ServerCredentials.Insecure)) |> ignore
    server.Start()

    printf "Server listening on port %i\n" port
    printfn "Press any key to stop the server...\n"
    Console.ReadKey() |> ignore

    server.ShutdownAsync().Wait()
    0
