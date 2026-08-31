Feature: gestion de publication 
Background:
    * def Faker = Java.type('com.github.javafaker.Faker')
    * def faker = new Faker()
    * def randomEmail = faker.internet().emailAddress()
    * def got = faker.name().firstName()
    * url "https://preprod.thrundrz.fr/backendpublic/public/api"
    Given path "v1/register/client"
    * def login = 
    """
    {
        "nomComplet": "Jean Dupont",
        "email": "#(randomEmail)",
        "password": "motdepasse123",
        "telephone": "0612345678",
        "fcm_token": "fcm_xxx"
    }
"""
    And request login
    When method post 
    Then status 200
    * def token = response.token



@ajoutEVent
Scenario: partage un evenement 
    Given path "v1/posts/share-event"
    * def event = 
    """
    {
    "even_id": 42,
    "titre": "Je participe à ce concert Qui vient ?",
    "contenu": "Je serai là dès 20h"
    }
    """
    And request event 
    And header Authorization = 'Bearer ' + token
    When method post 
    Then status 201
    Then match response.data.titre == event.titre
    * def id_event = response.data.id
    Given path "v1/posts" , id_event , "comments"
    * def commentaire = 
    """
      {
         "contenu": "#(got)",
         "parent_id": null
       }
    """
    And header Authorization = 'Bearer ' + token
    And request commentaire
    When method post 
    Then status 201
    Then response.success == true 
    Given path "/v1/posts" , id_event , "/like"
    And header Authorization = 'Bearer ' + token
    When method post 
    Then status 200
    Then response.success == true 
    Given path "/v1/posts" , id_event
    And header Authorization = 'Bearer ' + token
    When method delete 
    Then status 200
    Then response.success == true 







