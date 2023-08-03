//
//  main.swift
//  CodablePractice
//
//  Created by 지준용 on 2023/08/03.
//

/// - IMPORTANT: 휴먼스케이프 기술블로그(https://medium.com/humanscape-tech/swift%EC%97%90%EC%84%9C-codable-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0-367587c5a591)를 참고했습니다.

import Foundation

// MARK: - Model

struct Track1: Codable {
    let title: String
    let artistName: String
    let isStreamable: Bool
}

// MARK: - Encoding

let sampleInput = Track1(title: "New Rules",
                         artistName: "Dua Lipa",
                         isStreamable: true)

do {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    
    let data = try encoder.encode(sampleInput)
    print(data) // 65 Bytes
    if let jsonString = String(data: data, encoding: .utf8) {
        print(jsonString)
    }
} catch {
    print(error)
}

// MARK: - Decoding

let jsonData = """
{
  "title" : "New Rules",
  "artistName" : "Dua Lipa",
  "isStreamable" : true
}
""".data(using: .utf8)!


do {
    let decoder = JSONDecoder()
    let data = try decoder.decode(Track1.self, from: jsonData)
    dump(data)
} catch {
    print(error)
}

/// - IMPORTANT: api 응답 데이터가 Snake_case 등 Swift Naming 규칙에 어긋나는 경우.
/// CodingKey를 사용한다.

struct Track2: Codable {
    let title: String
    let artistName: String
    let isStreamable: Bool
    
    enum CodingKeys: String, CodingKey {
        case title = "track_name"
        case artistName = "artist_name"
        case isStreamable = "is_streamable"
    }
}

///- IMPORTANT: JSON에는 날짜를 나타내는 데이터 타입이 없으므로, 클라이언트와 서버가 동의한 형식(일반적으로 ISO 8601)으로 시리얼라이즈한다.
///만약 형식을 정하지 않으면 Type Mismatch가 발생할 수 있음.

struct Track3: Codable {
    let title: String
    let artistName: String
    let isStreamable: Bool
    let releaseDate: Date
}

let jsonData3 = """
{
  "artistName" : "Dua Lipa",
  "isStreamable" : true,
  "title" : "New Rules",
  "releaseDate": "2017-06-02T12:00:00Z"
}
""".data(using: .utf8)!

print(jsonData3)

do {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let data = try decoder.decode(Track3.self, from: jsonData3)
    dump(data)
} catch {
    print(error)
}
            

print("==================")
/// - IMPORTANT:API 응답이 Wrapper Key를 포함하는 경우.

struct Response: Codable {
    let resultCount: Int
    let results: [Track4]
}

struct Track4: Codable {
    let title: String
    let artistName: String
    let isStreamable: Bool
}

let jsonData4 = """
{
    "resultCount": 50,
    "results": [{
        "title": "New Rules",
        "artistName" : "Dua Lipa",
        "isStreamable" : true
    }]
}
""".data(using: .utf8)!

do {
    let decoder = JSONDecoder()
    let data = try decoder.decode(Response.self, from: jsonData4)
    dump(data)
} catch {
    print(error)
}

print("============================")
/// - IMPORTANT: Decode Type as Enum
/// 만약 enum에서 선언하지 않은 값이 있다면 unknown을 추가 선언하고, init(from:)을 구현해 일치하는 값이 없으면 Unknown으로 매핑시켜 주어 오류를 방지할 수 있다.

struct Track5: Codable {
    let title: String
    let artistName: String
    let isStreamable: Bool
    let primaryGenreName: Genre
}

enum Genre: String, Codable {
    case pop
    case kPop = "k-pop"
    case rock
    case classical
    case hiphop = "hip-hop"
    case unknown
    
    init(from decoder: Decoder) throws {
        self = try Genre(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

let jsonData5 = """
{
  "artistName" : "Dua Lipa",
  "isStreamable" : true,
  "title" : "New Rules",
  "primaryGenreName": "pop"
}
""".data(using: .utf8)!

do {
    let decoder = JSONDecoder()
    let data = try decoder.decode(Track5.self, from: jsonData5)
    dump(data)
} catch {
    print(error)
}

print("==============")

/// - IMPORTANT: Decoding nested JSON data into a single struct
/// 중첩된 구조의 API 응답 데이터 구조를 변경하고 싶을 때 사용.

struct Track6 {
    let title: String
    let artistName: String
    let isStreamable: Bool
    let collectionName: String
    let collectionPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case title, artistName, isStreamable
        case collectionInfo = "collection"
    }
    
    enum CollectionKeys: String, CodingKey {
        case name
        case price
    }
}

/// 위의 코드는 CodingKeys 열거형의 키를 사용하는 컨테이너를 추출하며, 여기에서 추출된 컨테이너에서 nestedContainer를 사용하여 아래와 같이 중첩된 컨테이너를 추출할 수 있다.


extension Track6: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.isStreamable = try container.decode(Bool.self, forKey: .isStreamable)
        let collectionInfo = try container.nestedContainer(keyedBy: CollectionKeys.self, forKey: .collectionInfo)
        self.collectionName = try collectionInfo.decode(String.self, forKey: .name)
        self.collectionPrice = try collectionInfo.decode(Double.self, forKey: .price)
    }
}


extension Track6: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var collectionInfo = container.nestedContainer(keyedBy: CollectionKeys.self, forKey: .collectionInfo)
        try container.encode(title, forKey: .title)
        try container.encode(title, forKey: .artistName)
        try container.encode(title, forKey: .isStreamable)
        try collectionInfo.encode(collectionName, forKey: .name)
        try collectionInfo.encode(collectionPrice, forKey: .price)
    }
}
