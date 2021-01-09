//
//  RogueBeer.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 8/1/21.

//   let rogueBeer = try? newJSONDecoder().decode(RogueBeer.self, from: jsonData)

import Foundation

// MARK: - RogueBeerElement
class RogueBeerElement: Codable {
    let id: Int
    let name, tagline, firstBrewed, rogueBeerDescription: String
    let imageURL: String
    let abv, ibu: Double
    let targetFg: Int
    let targetOg: Double
    let ebc, srm: Int
    let ph: Double
    let attenuationLevel: Int
    let volume, boilVolume: BoilVolume
    let method: Method
    let ingredients: Ingredients
    let foodPairing: [String]
    let brewersTips, contributedBy: String

    enum CodingKeys: String, CodingKey {
        case id, name, tagline
        case firstBrewed = "first_brewed"
        case rogueBeerDescription = "description"
        case imageURL = "image_url"
        case abv, ibu
        case targetFg = "target_fg"
        case targetOg = "target_og"
        case ebc, srm, ph
        case attenuationLevel = "attenuation_level"
        case volume
        case boilVolume = "boil_volume"
        case method, ingredients
        case foodPairing = "food_pairing"
        case brewersTips = "brewers_tips"
        case contributedBy = "contributed_by"
    }

    init(id: Int, name: String, tagline: String, firstBrewed: String, rogueBeerDescription: String, imageURL: String, abv: Double, ibu: Double, targetFg: Int, targetOg: Double, ebc: Int, srm: Int, ph: Double, attenuationLevel: Int, volume: BoilVolume, boilVolume: BoilVolume, method: Method, ingredients: Ingredients, foodPairing: [String], brewersTips: String, contributedBy: String) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.firstBrewed = firstBrewed
        self.rogueBeerDescription = rogueBeerDescription
        self.imageURL = imageURL
        self.abv = abv
        self.ibu = ibu
        self.targetFg = targetFg
        self.targetOg = targetOg
        self.ebc = ebc
        self.srm = srm
        self.ph = ph
        self.attenuationLevel = attenuationLevel
        self.volume = volume
        self.boilVolume = boilVolume
        self.method = method
        self.ingredients = ingredients
        self.foodPairing = foodPairing
        self.brewersTips = brewersTips
        self.contributedBy = contributedBy
    }
}

// MARK: - BoilVolume
class BoilVolume: Codable {
    let value: Double
    let unit: String

    init(value: Double, unit: String) {
        self.value = value
        self.unit = unit
    }
}

// MARK: - Ingredients
class Ingredients: Codable {
    let malt: [Malt]
    let hops: [Hop]
    let yeast: String

    init(malt: [Malt], hops: [Hop], yeast: String) {
        self.malt = malt
        self.hops = hops
        self.yeast = yeast
    }
}

// MARK: - Hop
class Hop: Codable {
    let name: String
    let amount: BoilVolume
    let add, attribute: String

    init(name: String, amount: BoilVolume, add: String, attribute: String) {
        self.name = name
        self.amount = amount
        self.add = add
        self.attribute = attribute
    }
}

// MARK: - Malt
class Malt: Codable {
    let name: String
    let amount: BoilVolume

    init(name: String, amount: BoilVolume) {
        self.name = name
        self.amount = amount
    }
}

// MARK: - Method
class Method: Codable {
    let mashTemp: [MashTemp]
    let fermentation: Fermentation
    let twist: JSONNull?

    enum CodingKeys: String, CodingKey {
        case mashTemp = "mash_temp"
        case fermentation, twist
    }

    init(mashTemp: [MashTemp], fermentation: Fermentation, twist: JSONNull?) {
        self.mashTemp = mashTemp
        self.fermentation = fermentation
        self.twist = twist
    }
}

// MARK: - Fermentation
class Fermentation: Codable {
    let temp: BoilVolume

    init(temp: BoilVolume) {
        self.temp = temp
    }
}

// MARK: - MashTemp
class MashTemp: Codable {
    let temp: BoilVolume
    let duration: JSONNull?

    init(temp: BoilVolume, duration: JSONNull?) {
        self.temp = temp
        self.duration = duration
    }
}

typealias RogueBeer = [RogueBeerElement]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
