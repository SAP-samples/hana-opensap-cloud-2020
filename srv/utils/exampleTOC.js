"use strict";

module.exports = {
    fill: function () {
        let tableOfContents =

            "</p>" +
            "<H1>Main Testing Entry Points</H1></br>" +
            "<a href=\"/api/api-docs/\">/api/api-docs</a> - Swagger UI</br>" +
            "<a href=\"/\">/</a> - Launchpad</br>" +            

            "</p>" +
            "<H1>Overall Node.js Examples Table of Contents</H1></br>" +
            "<a href=\"/rest/ex2/toc/\">/rest/ex2/toc</a> - Node.js Exercises #2</br>" +
            "<a href=\"/rest/auth/\">/rest/auth</a> - Authorizations</br>" +
            "<a href=\"/rest/excAsync/\">/rest/excAsync</a> - Node.js Asynchronous Non-Blocking I/O Examples</br>" +
            "<a href=\"/rest/JavaScriptBasics/\">/rest/JavaScriptBasics</a> - Node.js JavaScript Basics</br>" +
            "<a href=\"/rest/textBundle/toc/\">/rest/textBundle/toc</a> - Node.js Text Bundles and Language Processing Examples</br>" +
            "<a href=\"/rest/chat/\">/rest/chat</a> - Node.js Web Socket Chat Server Example</br>" +
            "<a href=\"/rest/excel/\">/rest/excel</a> - Node.js Excel Upload and Download Examples</br>" +
            "<a href=\"/rest/xml/\">/rest/xml</a> - Node.js XML Parsing Examples</br>" +
            "<a href=\"/rest/zip/\">/rest/zip</a> - Node.js ZIP archive Examples</br>" +
            "<a href=\"/rest/oo/\">/rest/oo</a> - Object Oriented Examples</br>" +
            "<a href=\"/rest/os/web/\">/rest/os/web/</a> - Web Based XSA CLI</br>" +
            "<a href=\"/rest/os/\">/rest/os</a> - OS Level Examples</br>" +
            "<a href=\"/rest/hanaClient/toc/\">/rest/client/toc</a> - Low Level HANA Client Examples</br>" +
            "<a href=\"/rest/auditLog/\">/rest/auditLog</a> - Node.js AuditLog Examples</br>" +
            "<a href=\"/rest/promises/\">/rest/promises</a> - Node.js Promises Examples</br>" +
            "<a href=\"/rest/await/\">/rest/await</a> - Node.js Async/Await</br>" +
            "<a href=\"/rest/es6/\">/rest/es6</a> - Node.js ES6 & ES2017 Examples</br>" +
            "<a href=\"/rest/es2018/\">/rest/es2018</a> - Node.js ES2018 Examples</br>" +
            "<a href=\"/rest/multiply/5/10\">/rest/multiply</a> - Multiply</br>" +
            "<a href=\"/rest/outboundTest/hana\">/rest/outboundTest</a> - Outbound HTTP</br>" +


            "</p>" +
            "<H1>Node.js CAP Services Table of Contents</H1></br>" +
            "<a href=\"/odata/test\">/odata/test</a> - CAP Service Test for OData V4 and REST endpoints</br>" +
            
           
            "<a href=\"/xsjs/clientFilter.xsjs\">/xsjs/clientFilter.xsjs</a> - XSJS Model with Client Column Filter via Analaytic Privilege</br>" +
            "<a href=\"/xsjs/excel.xsjs\">/xsjs/excel.xsjs</a> - XSJS Calling Node.js Excel Module Example</br>" +
            "<a href=\"/xsjs/exercisesMaster.xsjs?cmd=getSessionInfo\">/xsjs/exercisesMaster.xsjs</a> - XSJS Simple Example</br>" +
            "<a href=\"/xsjs/hdb.xsjs\">/xsjs/hdb.xsjs</a> -XSJS Simple Database Select Example</br>" +
            "<a href=\"/xsjs/hello.xsjs\">/xsjs/hello.xsjs</a> - XSJS Return Session User and Application User Example</br>" +
            "<a href=\"/xsjs/helloWorld.xsjs\">/xsjs/helloWorld.xsjs</a> - XSJS Hello World</br>" +
            "<a href=\"/xsjs/os.xsjs\">/xsjs/os.xsjs</a> - XSJS Interact with OS via Node.js Module Example</br>" +
            "<a href=\"/xsjs/procedures.xsjs\">/xsjs/procedures.xsjs</a> - XSJS Call Stored Procedures Example</br>" +
            "<a href=\"/xsjs/require.xsjs\">/xsjs/require.xsjs</a> - XSJS Node.js Module Example</br>" +
            "<a href=\"/xsjs/sessionInfo.xsjs\">/xsjs/sessionInfo.xsjs</a> - XSJS Session Context Viewer</br>" +
            "<a href=\"/xsjs/whoAmI.xsjs\">/xsjs/whoAmI.xsjs</a> - XSJS Different User Types Example</br>" +
            "<a href=\"/xsjs/whoAmI_SQLCC.xsjs\">/xsjs/whoAmI_SQLCC.xsjs</a> - XSJS User Details via Secondary Connection (SQLCC)</br>" +
            "<a href=\"/xsjs/xml.xsjs\">/xsjs/xml.xsjs</a> - XSJS XML SAX Parser API Example</br>" +
            "<a href=\"/xsjs/zip.xsjs\">/xsjs/zip.xsjs</a> - XSJS ZIP API Example</br>" +
            "<a href=\"/xsjs/JavaScriptBasics/array.xsjs\">/xsjs/JavaScriptBasics/array.xsjs</a> - XSJS Basics: Array</br>" +
            "<a href=\"/xsjs/JavaScriptBasics/classes.xsjs\">/xsjs/JavaScriptBasics/classes.xsjs</a> - XSJS Basics: Classes</br>" +
            "<a href=\"/xsjs/JavaScriptBasics/dates.xsjs\">/xsjs/JavaScriptBasics/dates.xsjs</a> - XSJS Basics: Dates</br>" +
            "<a href=\"/xsjs/JavaScriptBasics/json.xsjs\">/xsjs/JavaScriptBasics/json.xsjs</a> - XSJS Basics: JSON</br>" +
            "<a href=\"/xsjs/JavaScriptBasics/objects.xsjs\">/xsjs/JavaScriptBasics/objects.xsjs</a> - XSJS Basics: Objects</br>" +
            "<a href=\"/xsjs/JavaScriptBasics/strings.xsjs\">/xsjs/JavaScriptBasics/strings.xsjs</a> - XSJS Basics: Strings</br>" +
            "<a href=\"/sap/hana/democontent/epm/services/multiply.xsjs?cmd=multiply&num1=5&num2=10\">/sap/hana/democontent/epm/services/multiply.xsjs</a> - XSJS Multiply</br>" +
            "<a href=\"/sap/hana/democontent/epm/services/outboundTest.xsjs?cmd=Images&search=hana\">/sap/hana/democontent/epm/services/outboundTest.xsjs</a> - XSJS Outbound HTTP</br>" +

            "</p>" +
            "<H1>OData V2 Table of Contents</H1></br>" +
            "<a href=\"/odata/v2/MasterDataService/BusinessPartners\">/odata/v2/MasterDataService/BusinessPartners</a> Business Partners Service</br>" +
            "<a href=\"/odata/v2/MasterDataService/$metadata\">/odata/v2/MasterDataService/$metadata</a> Business Partners Service Metadata</br>" +
            "<a href=\"/odata/v2/MasterDataService/BusinessPartners?$top=3&$skip=5\">/odata/v2/MasterDataService/BusinessPartners?$skip=5&$top=3</a> Business Partners Data - Skip 5, Only Return Top 3</br>" +

            "<a href=\"/odata/v2/POService/POs\">/odata/v2/POService/POs</a> Purchase Orders Service</br>" +
            "<a href=\"/odata/v2/POService/$metadata\">/odata/v2/POService/$metadata</a> Purchase Orders Service Metadata</br>" +
            "<a href=\"/odata/v2/POService/POs?$top=10\">/odata/v2/POService/POs</a> Purchase Orders Service - Header Data</br>" +
            "<a href=\"/odata/v2/POService/POs?$top=10&$expand=item\">/odata/v2/POService/POs?$top=10&$expand=item</a> Purchase Orders Service - Header Data with Expanded Items</br>" +
            "<a href=\"/odata/v2/POService/PO_Worklist?$top=10\">/odata/v2/POService/PO_Worklist?$top=10/a> Purchase Orders Worklist View</br>" +            

            "<a href=\"/odata/v2/POService/POItems\">/odata/v2/POService/POItems</a> PO Items View</br>" +
            "<a href=\"/odata/v2/MasterDataService/Products\">/odata/v2/MasterDataService/Products</a> Products Service</br>" +

            "<a href=\"/odata/v2/MasterDataService/User\">/odata/v2/MasterDataService/User</a> User Service</br>" 

        return tableOfContents

    }
};