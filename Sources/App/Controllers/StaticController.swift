import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class StaticController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<Response> {
        // func index(_ req: Request) throws -> String {
        // // PRODUCTION: return index file
        if req.sharedContainer.environment.isRelease {
            let path = "\(DirectoryConfig.detect().workDir)front-end/build/index.html"
            return try req.streamFile(at: path)
        } else {
            // DEVELOPMENT proxy to localhost:3000
            let route = "http://localhost:3000" + req.http.url.path
            return try! req.client().get(route).map { get -> Response in
                let httpResponse = HTTPResponse(status: .ok, body: get.http.body)
                return Response.init(http: httpResponse, using: req.sharedContainer)
            }
        }
    }
}