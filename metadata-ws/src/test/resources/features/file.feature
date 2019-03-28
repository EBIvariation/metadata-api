Feature: file object

  Scenario: register a file successfully
    When I request POST /files with JSON payload:
    """
    {
      "accessionVersionId": {
        "accession": "EGAF0001",
        "version": 1
        },
      "hash": "asd123",
      "name": "file1",
      "size": 100,
      "type": "TSV"
    }
    """
    Then set the URL to TEST_FILE
    And the response code should be 201
    And the Location header should be present with value of TEST_FILE
    When I request GET with value of TEST_FILE
    Then the response code should be 200
    And the result json should be:
    """
    {
      "accessionVersionId": {
        "accession": "EGAF0001",
        "version": 1
        },
      "hash": "asd123",
      "name": "file1",
      "size": 100,
      "type": "TSV"
    }
    """
    When I request GET /files
    Then the result should contain 1 files