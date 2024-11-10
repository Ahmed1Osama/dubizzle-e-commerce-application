*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Resource    ${CURDIR}/../resources/common/commonKeywords.resource
Resource    ${CURDIR}/../resources/homepage/homePage.resource 
Suite Teardown         Close browser



*** Test Cases ***
Simple Search Query
  Open Browser and Maximize
  Search For Product    iphone

Search with As-You-Type Suggestions
 Open Browser and Maximize
   Search with Suggestions  iphone

Search with Multiple Filters
  Open Browser and Maximize
   Search with Multiple Filters  iphone  1000  40000
   Sort Results Randomly

Validation of Real-Time Filter Application
  Open Browser and Maximize
   Real Time Filter  Vehicles


