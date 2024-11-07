*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    random
Library    OperatingSystem
Library    FakerLibrary
Resource    ${CURDIR}/../homepage/homePage.resource


*** Variables ***

${SCREENSHOT_DIR}
${userName}
${contryFlagEN}    //div[@class="sc-ce86c11a-2 ggGusF"]//button[@class="sc-d33bd3f5-1 dgQbMR"]//img[@alt="country-eg"]
${contryFlagAR}    //div[@class="sc-ce86c11a-2 ggGusF"]//img[@alt="country-eg"]    


*** Keywords ***
GO TO Home Page
    Open Browser    ${baseUrl}   chrome 
    Maximize Browser Window
    Wait Until Element Is Visible    ${contryFlagAR}