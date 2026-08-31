Feature: gestion des employees 

Background:
    * def Faker = Java.type('com.github.javafaker.Faker')
    * def faker = new Faker()
    * def randomEmail = faker.internet().emailAddress()
    * print("===================>" + randomEmail)
    * url "https://api.efi-academy.com"
    Given path 'auth/login'
    * def user = 
    """
    {
  "username": "admin",
  "password": "admin123"
    }
    """
    And request user
    When method post
    Then status 200 
    * def token = response.accessToken


@CreationEmp
Scenario: creer un employee 
    * url "https://api.efi-academy.com"
    Given path 'public/employees'
    * def body = 
    """
    {
        "firstName": "Alice",
        "lastName": "Dupont",
        "email": "#(randomEmail)",
        "position": "Software Engineer",
        "salary": 55000,
        "hireDate": "2022-01-15",
        "status": "ACTIVE"
        }
    """
    And request body
    When method post 
    Then status 201
    Then match response.message == "Employee created."
    Then match response.data.firstName == body.firstName
    Then match response.data.lastName == body.lastName
    Then match response.data.email == body.email
    Then match response.data.position == body.position
    * def id = response.data.id
    Given path 'public/employees' , id
    * def body2 = 
    """
    {
        "firstName": "farid",
    }
    """
    And request body2
    When method put 
    Then status 200
    Then match response.data.firstName == body2.firstName
    Given path 'public/employees' , id
    When method delete
    Then match response.message == "Employee " + id + " deleted."
    Then status 200

@CreationEmpToken
Scenario: creer un employee 
    * url "https://api.efi-academy.com"
    Given path 'api/employees'
    * def body = 
    """
    {
        "firstName": "Alice",
        "lastName": "Dupont",
        "email": "#(randomEmail)",
        "position": "Software Engineer",
        "salary": 55000,
        "hireDate": "2022-01-15",
        "status": "ACTIVE"
        }
    """
    And request body
    And header Authorization = 'Bearer ' + token
    When method post 
    Then status 201
    Then match response.message == "Employee created."
    Then match response.data.firstName == body.firstName
    Then match response.data.lastName == body.lastName
    Then match response.data.email == body.email
    Then match response.data.position == body.position
    * def id = response.data.id
    Given path 'api/employees' , id
    * def body2 = 
    """
    {
        "firstName": "farid",
    }
    """
    And request body2
    And header Authorization = 'Bearer ' + token
    When method put 
    Then status 200
    Then match response.data.firstName == body2.firstName
    Given path 'api/employees' , id
    And header Authorization = 'Bearer ' + token
    When method delete
    Then match response.message == "Employee " + id + " deleted."
    Then status 200





