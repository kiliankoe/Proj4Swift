//
//  ProjectionTests.swift
//  Proj4SwiftTests
//
//  Created by Fang-Pen Lin on 3/12/16.
//  Copyright © 2016 Fang-Pen Lin. All rights reserved.
//

import XCTest

import Proj4

class ProjectionTests: XCTestCase {
    static let WGS840 = "+proj=longlat +ellps=WGS84 +no_defs"
    // web mercator http://spatialreference.org/ref/sr-org/7483/
    static let WebMercator = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs"
    func testInitError() {
        do {
            let _ = try Projection(parameters: "bad parameters")
            XCTFail("Should throw error")
        } catch Projection.Error.InitFailed(let code, let message) {
            XCTAssertEqual(code, 2)
            XCTAssertEqual(message, "no arguments in initialization list")
        } catch {
            XCTFail("Wrong error \(error)")
        }
    }
    
    func testTransform() {
        let projWGS840 = try? Projection(parameters: ProjectionTests.WGS840)
        let projMerc = try? Projection(parameters: ProjectionTests.WebMercator)
        XCTAssertNotNil(projWGS840)
        XCTAssertNotNil(projMerc)
        
        // for more testing points, we can reference to
        // https://github.com/proj4js/proj4js/blob/master/test/testData.js
        
        let points = [
            Point3D(x: -122.407679 * Projection.degToRad, y: 37.781520 * Projection.degToRad, z: 0)
        ]
        let resultPoints = try? projWGS840!.transform(points, toProjection: projMerc!)
        XCTAssertNotNil(resultPoints)
        
        XCTAssertEqualWithAccuracy(resultPoints!.first!.x, -13626360.495466487, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(resultPoints!.first!.y, 4548607.725511416, accuracy: 0.01)
        XCTAssertEqual(resultPoints!.first!.z, 0)
    }
    
    func testTransformError() {
        let projWGS840 = try? Projection(parameters: ProjectionTests.WGS840)
        let projMerc = try? Projection(parameters: ProjectionTests.WebMercator)
        let points = [
            // the point should be in radian, but we pass degree instead
            Point3D(x: -122.407679, y: 37.781520, z: 0)
        ]
        do {
            let _ = try projWGS840!.transform(points, toProjection: projMerc!)
            XCTFail("Should throw error")
        } catch Projection.Error.TransformFailed(let code, let message) {
            XCTAssertEqual(code, -14)
            XCTAssertEqual(message, "latitude or longitude exceeded limits")
        } catch {
            XCTFail("Wrong error \(error)")
        }
    }
    
    
}

