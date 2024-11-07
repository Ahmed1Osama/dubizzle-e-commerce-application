*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    random
Library    FakerLibrary
Library    ${CURDIR}/../../pages/homepage.py


Resource    ${CURDIR}/../common/commonKeywords.resource

*** Variables ***
${baseUrl}    https://www.dubizzle.com.eg/en/
${searchBarFieldPath}     xpath=//div[@class="_5aeede43"]//input[@type="search"]
${dubizzleLogoPath}        xpath=//div[@class="b6da2e8f"]
${searchbuttonpath}    xpath=//button[@aria-label="Search"]
${searchResultPath}    xpath=//div[@class="e53698e2"]//ul//li
${suggestionsListPath}    xpath=//div[@class="_8185b4e8"]//button
${minPricePath}          xpath=//input[@placeholder='Min']     #xpath=//div[@class="_4532be3c"]//div[@class="_4fe2dfc1"]//div[@class="_5aeede43 a3b3711b"]//input[@placeholder="Min"]
${maxPricePath}    xpath=//div[@class="_5aeede43 a3b3711b"]//input[@placeholder="Max"]
${sortBybtnPath}    xpath=//div[@class="_948d9e0a dee7163c _371e9918"]
${sortByList}    xpath=//div[@class="_948d9e0a dee7163c _371e9918"]//ul//li
${categoryPath}    xpath=//div[@class="_948d9e0a d7383df5 e1c7c3d4"]

*** Keywords ***
Open Browser and Maximize
    Open Browser    ${baseUrl}   chrome
    Maximize Browser Window
    Wait Until Element Is Visible    ${dubizzleLogoPath}

Search For Product
    [Arguments]    ${productName}
    Input Text    ${searchBarFieldPath}    ${productName}
    Click Element    ${searchbuttonpath}
    Wait Until Element Is Visible    ${searchResultPath}
    @{searchResult}=    Get WebElements    ${searchResultPath}
    ${listSize} =    Get Length    ${searchResult}
    Log    Number of search results: ${listSize}
    FOR    ${element}    IN    @{searchResult}
        ${element_text}=    Get Text    ${element}
        Log    Product Name: ${element_text}
    END

Search with Suggestions
    [Arguments]    ${productName}
    Input Text    ${searchBarFieldPath}    ${productName}
    Wait Until Element Is Visible    ${suggestionsListPath}
    @{suggestionsList}=    Get WebElements    ${suggestionsListPath}
    ${listSize} =    Get Length    ${suggestionsList}
    Log    Number of suggestions: ${listSize}
    Should Be True    ${listSize} > 0    Expected suggestions to be present but none found.

    Clear Element Text    ${searchBarFieldPath}
    Press Keys    ${searchBarFieldPath}    ENTER

    Wait Until Element Is Not Visible    ${suggestionsListPath}
    ${isVisible}=    Run Keyword And Return Status    Element Should Not Be Visible    ${suggestionsListPath}
    Should Be True    ${isVisible}    Expected suggestions to disappear but they are still visible.

Search with Multiple Filters
    [Arguments]    ${productName}    ${minPrice}    ${maxPrice}
    Input Text    ${searchBarFieldPath}    ${productName}
    Click Element    ${searchbuttonpath}
    Wait Until Element Is Visible    ${searchResultPath}
    #Sleep    20s      
    Scroll Element Into View    ${minPricePath}
      
    Input Text    ${minPricePath}    ${minPrice}
    Input Text    ${maxPricePath}    ${maxPrice}
    Press Keys    ${maxPricePath}    ENTER

              #sorting by section 
    Click Element    ${sortBybtnPath}
    Wait Until Element Is Visible    ${sortByList}
    @{sortResultList}=    Get WebElements    ${sortByList}
    ${listSize} =    Get Length    ${sortResultList}
    Log    Number of sort options: ${listSize}
    ${randomIndex} =    Evaluate    random.randint(0, ${listSize} - 1)    random
    ${randomElement} =    Get From List    ${sortResultList}    ${randomIndex}
    ${randomElementText} =    Get Text    ${randomElement}
    Log    Random element text: ${randomElementText}
    Click Element    ${randomElement}
        #search result log
   @{searchResult}=    Get WebElements    ${searchResultPath}
   ${listSize} =    Get Length    ${searchResult}
   Log    Number of search results: ${listSize}
        #verify  Filters remain applied after page reload.
    Reload Page
    Wait Until Page Contains Element     xpath=//span[@class='_8206696c']
    ${displayedSortOption} =    Get Text    //span[@class='_8206696c']
    Should Be Equal As Strings    ${displayedSortOption}    ${randomElementText}
    Log    Verified that the displayed sort option is: ${displayedSortOption}


Real Time Filter
    [Arguments]    ${category}
    
    # Step 1: Retrieve the List of Categories
    @{categoryList}=    Get WebElements    ${categoryPath}
    
    # Step 2: Loop through Category List to Find and Click the Target Category
    ${found} =    Set Variable    False
    FOR    ${element}    IN    @{categoryList}
        ${elementText}=    Get Text    ${element}
        # Trim the whitespace to handle any hidden spaces or line breaks
        ${trimmedText}=    Trim Whitespace    ${elementText}
        Run Keyword If    '${trimmedText}' == '${category}'    Click Element    ${element}
        Run Keyword If    '${trimmedText}' == '${category}'    Set Variable    ${found}    True
        Run Keyword If    '${found}' == True    Exit For Loop
    END

    # Step 3: Verify that Category Was Found and Clicked
    Run Keyword If    '${found}' == False    Fail    Category '${category}' not found in the list.

