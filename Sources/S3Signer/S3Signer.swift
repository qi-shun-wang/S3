import Foundation
import Service
import HTTP
import Crypto


/// S3 Client: All network calls to and from AWS' S3 servers
public final class S3Signer: Service {
    
    /// Errors
    public enum Error: Swift.Error {
        case badURL(String)
        case invalidEncoding
        case featureNotAvailableWithV2Signing
    }
    
    /// S3 authentication support version
    public enum Version {
        case v2
        case v4
    }
    
    /// S3 Configuration
    public struct Config: Service {
        /// AWS authentication version
        let authVersion: Version
        
        /// AWS Access Key
        let accessKey: String
        
        /// AWS Secret Key
        let secretKey: String
        
        /// The region where S3 bucket is located.
        public let region: Region
        
        /// AWS Security Token. Used to validate temporary credentials, such as those from an EC2 Instance's IAM role
        let securityToken : String?
        
        /// AWS Service type
        let service: String = "s3"
        
        /// Initalizer
        public init(accessKey: String, secretKey: String, region: Region, version: Version = .v4, securityToken: String? = nil) {
            self.accessKey = accessKey
            self.secretKey = secretKey
            self.region = region
            self.securityToken = securityToken
            self.authVersion = version
        }
        
    }
    
    /// Configuration
    public private(set) var config: Config
    
    /// Initializer
    public init(_ config: Config) throws {
        self.config = config
    }
    
}


extension S3Signer {
    
    /// Generates auth headers for Simple Storage Services
    public func headers(for httpMethod: HTTPMethod, urlString: URLRepresentable, region: Region? = nil, bucket: String? = nil, headers: [String: String] = [:], payload: Payload) throws -> HTTPHeaders {
        return try self.headers(for: httpMethod, urlString: urlString, region: region, bucket: bucket, headers: headers, payload: payload, dates: Dates(Date()))
    }
    
    /// Create a pre-signed URL for later use
    public func presignedURL(for httpMethod: HTTPMethod, url: URL, expiration: Expiration, region: Region? = nil, headers: [String: String] = [:]) throws -> URL? {
        return try presignedURL(for: httpMethod, url: url, expiration: expiration, region: region, headers: headers, dates: Dates(Date()))
    }
}
