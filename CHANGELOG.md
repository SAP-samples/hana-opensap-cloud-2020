# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## 1.202101.1

### Changed

- Renaming to match new SAP Business Technology Platform branding
- Major dependent package version updates including CAP 4.4 and HANA Client 2.7 as well as adding support for Node.js 14
- Restructure folders to support HANA development within CAP on Business Application Studio
- Change over to server.js custom boostrap for CAP
- CAP service now runs from the root folder with a single package.json and node_modules in the root
- Change XSUAA service plan to application