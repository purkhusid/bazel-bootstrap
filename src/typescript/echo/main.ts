import { IEchoServiceServer, EchoServiceService, IEchoServiceService } from 'monorepo/src/proto/echo/service/service_grpc_pb';
import { Request, Response } from 'monorepo/src/proto/echo/models/models_pb';
import * as grpc from '@grpc/grpc-js';
import { sendUnaryData } from '@grpc/grpc-js/build/src/server-call';
import { ServiceDefinition, UntypedHandleCall } from '@grpc/grpc-js';

class EchoServiceServer implements IEchoServiceServer {
    // Argument of type 'Greeter' is not assignable to parameter of type 'UntypedServiceImplementation'.
    // Index signature is missing in type 'Greeter'.ts(2345)
    [method: string]: UntypedHandleCall;
    
    echo(call: grpc.ServerUnaryCall<Request, Response>, callback: sendUnaryData<Response>): void {
        const response = new Response()
        response.setMessage(call.request.getMessage())
        callback(null, response);
    }
}

function serve(): void {
    const server = new grpc.Server();
    server.addService(EchoServiceService as any, new EchoServiceServer());
    server.bindAsync(`localhost:8080`, grpc.ServerCredentials.createInsecure(), (err, port) => {
        if (err) {
            throw err;
        }
        console.log(`Listening on ${port}`);
        server.start();
    });
}

serve()