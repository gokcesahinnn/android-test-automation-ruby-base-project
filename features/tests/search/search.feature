@feature_search
Feature: Search Feature

  Background:
    Given agree chrome terms on base page
    And refuse account sync on base page

  @search @smoke
  Scenario: Search a keyword successfully
    When search "Kloia" on home page
    Then verify search result contains searched keyword on search result page