import Foundation
import Vision

import XCTest
@testable import VisionUtils

fileprivate let shouldPrintJSON:Bool = true

fileprivate func maybePrint(_ s:String) -> Void {
  guard shouldPrintJSON else { return }
  print(s)
}


final class VisionUtilsTests: XCTestCase {
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    XCTAssertEqual(DummyStruct().text, "Hello, world")
  }

  func testImagePresent() {
    let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg")
    XCTAssert(imageURL != nil)
  }

  func testFaceJSOSN() {
    guard let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let result:String = try faceDetect(image: imageURL)
      maybePrint(result)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }

  func testNoFacesJSON() {
    guard let imageURL = Bundle.module.url(forResource: "potatoes", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let result:String = try faceDetect(image: imageURL)
      maybePrint(result)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }


  func testFacesDetect() {
    guard let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let results:[VNFaceObservation] = try faceDetectWithVision(image: imageURL)
      XCTAssert(results.count == 2)

      // quick output the string
      let data:Data = try! JSONEncoder().encode(results)
      let out:String = String(data: data, encoding: .utf8)!
      maybePrint(out)

    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }

  func testFacesDetecWithLandmarkst() {
    guard let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let results:[VNFaceObservation] = try faceDetectWithVision(image: imageURL, withLandmarks: true)
      XCTAssert(results.count == 2)

      // quick output the string
      let data:Data = try! JSONEncoder().encode(results)
      let out:String = String(data: data, encoding: .utf8)!
      maybePrint(out)

    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }

  func testCreateJSONFacesDetecWithLandmarkst() {
    guard let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let output:String = try faceDetect(image: imageURL, outputFormat: .createML)
      maybePrint(output)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }


  func testNoFacesDetected() {
    guard let imageURL = Bundle.module.url(forResource: "potatoes", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let results:[VNFaceObservation] = try faceDetectWithVision(image: imageURL)
      XCTAssert(results.isEmpty)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }

  func testJSONEquality() {
    // a complex JSON specimen with strings, numbers, null, array, object
    let fancyJsonString = """
    {"web-app": {
      "servlet": [
        {
          "servlet-name": "cofaxCDS",
          "servlet-class": "org.cofax.cds.CDSServlet",
          "init-param": {
            "configGlossary:installationAt": "Philadelphia, PA",
            "configGlossary:adminEmail": "ksm@pobox.com",
            "configGlossary:poweredBy": "Cofax",
            "configGlossary:poweredByIcon": "/images/cofax.gif",
            "configGlossary:staticPath": "/content/static",
            "templateProcessorClass": "org.cofax.WysiwygTemplate",
            "templateLoaderClass": "org.cofax.FilesTemplateLoader",
            "templatePath": "templates",
            "templateOverridePath": "",
            "defaultListTemplate": "listTemplate.htm",
            "defaultFileTemplate": "articleTemplate.htm",
            "useJSP": false,
            "jspListTemplate": "listTemplate.jsp",
            "jspFileTemplate": "articleTemplate.jsp",
            "cachePackageTagsTrack": 200,
            "cachePackageTagsStore": 200,
            "cachePackageTagsRefresh": null,
            "cacheTemplatesTrack": 100,
            "cacheTemplatesStore": 50,
            "cacheTemplatesRefresh": 15,
            "cachePagesTrack": 200,
            "cachePagesStore": 100,
            "cachePagesRefresh": 10,
            "cachePagesDirtyRead": 10,
            "searchEngineListTemplate": "forSearchEnginesList.htm",
            "searchEngineFileTemplate": "forSearchEngines.htm",
            "searchEngineRobotsDb": "WEB-INF/robots.db",
            "useDataStore": true,
            "dataStoreClass": "org.cofax.SqlDataStore",
            "redirectionClass": "org.cofax.SqlRedirection",
            "dataStoreName": "cofax",
            "dataStoreDriver": "com.microsoft.jdbc.sqlserver.SQLServerDriver",
            "dataStoreUrl": "jdbc:microsoft:sqlserver://LOCALHOST:1433;DatabaseName=goon",
            "dataStoreUser": "sa",
            "dataStorePassword": "dataStoreTestQuery",
            "dataStoreTestQuery": "SET NOCOUNT ON;select test='test';",
            "dataStoreLogFile": "/usr/local/tomcat/logs/datastore.log",
            "dataStoreInitConns": 10,
            "dataStoreMaxConns": 100,
            "dataStoreConnUsageLimit": 100,
            "dataStoreLogLevel": "debug",
            "maxUrlLength": 500}},
        {
          "servlet-name": "cofaxEmail",
          "servlet-class": "org.cofax.cds.EmailServlet",
          "init-param": {
          "mailHost": "mail1",
          "mailHostOverride": "mail2"}},
        {
          "servlet-name": "cofaxAdmin",
          "servlet-class": "org.cofax.cds.AdminServlet"},

        {
          "servlet-name": "fileServlet",
          "servlet-class": "org.cofax.cds.FileServlet"},
        {
          "servlet-name": "cofaxTools",
          "servlet-class": "org.cofax.cms.CofaxToolsServlet",
          "init-param": {
            "templatePath": "toolstemplates/",
            "log": 1,
            "logLocation": "/usr/local/tomcat/logs/CofaxTools.log",
            "logMaxSize": "",
            "dataLog": 1,
            "dataLogLocation": "/usr/local/tomcat/logs/dataLog.log",
            "dataLogMaxSize": "",
            "removePageCache": "/content/admin/remove?cache=pages&id=",
            "removeTemplateCache": "/content/admin/remove?cache=templates&id=",
            "fileTransferFolder": "/usr/local/tomcat/webapps/content/fileTransferFolder",
            "lookInContext": 1,
            "adminGroupID": 4,
            "betaServer": true}}],
      "servlet-mapping": {
        "cofaxCDS": "/",
        "cofaxEmail": "/cofaxutil/aemail/*",
        "cofaxAdmin": "/admin/*",
        "fileServlet": "/static/*",
        "cofaxTools": "/tools/*"},

      "taglib": {
        "taglib-uri": "cofax.tld",
        "taglib-location": "/WEB-INF/tlds/cofax.tld"}}}
    """

    let simpleJsonString = "[1,2,3,4,5.005]"


    let fancyJsonData:Data = fancyJsonString.data(using: .utf8)!
    let simpleJsonData:Data = simpleJsonString.data(using: .utf8)!

    XCTAssert(approximatelyEqual(jsonData: fancyJsonData, otherJsonData: fancyJsonData))
    XCTAssert(!approximatelyEqual(jsonData: fancyJsonData, otherJsonData: simpleJsonData))

  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
