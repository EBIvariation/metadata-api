Feature: sample object

  Scenario: register a sample successfully
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    And set the URL to TEST_TAXONOMY
    When user create a test sample with TEST_TAXONOMY for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE
    When user request GET with value of TEST_SAMPLE
    Then the response code should be 200
    Then the result should have accessionVersionId.accession with value EGAS0001
    Then the result should have name with value test_human_sample
    When user request GET for taxonomies of TEST_SAMPLE
    Then the response code should be 200
    Then the result should contain 1 taxonomies
    Then the href list of the taxonomy of taxonomies 1 contained in TEST_TAXONOMY


  Scenario: update a sample successfully
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 10090,
      "name": "Mus Musculus"
    }
    """
    And set the URL to TEST_TAXONOMY_1
    When user create a test sample with TEST_TAXONOMY_1 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE
    When user request GET with value of TEST_SAMPLE
    Then the response code should be 200
    Then the result should have accessionVersionId.accession with value EGAS0001
    Then the result should have name with value test_human_sample
    When user request GET for taxonomies of TEST_SAMPLE
    Then the response code should be 200
    Then the result should contain 1 taxonomies
    Then the href list of the taxonomy of taxonomies 0 contained in TEST_TAXONOMY_1

    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    And set the URL to TEST_TAXONOMY_2
    When user request PATCH TEST_SAMPLE with list TEST_TAXONOMY_2 for taxonomies
    And the response code should be 2xx
    When user request GET for taxonomies of TEST_SAMPLE
    Then the response code should be 200
    Then the result should contain 1 taxonomies
    Then the href list of the taxonomy of taxonomies 0 contained in  TEST_TAXONOMY_2


  Scenario Outline: post a test sample with invalid taxonomy list should fail
    When user create a test sample with <list> for taxonomy
    And the response code should be 4xx
    And the result should have exception with value uk.ac.ebi.ampt2d.metadata.exceptionhandling.SampleWithoutTaxonomyException

    Examples:
      | list |
      | NONE |
      | BLANK |

  Scenario: delete all of a sample's taxonomies should fail
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 10090,
      "name": "Mus Musculus"
    }
    """
    And set the URL to TEST_TAXONOMY_1
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    And set the URL to TEST_TAXONOMY_2
    When user create a test sample with TEST_TAXONOMY_1,TEST_TAXONOMY_2 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE
    When user request GET with value of TEST_SAMPLE
    Then the response code should be 200
    Then the result should have accessionVersionId.accession with value EGAS0001
    Then the result should have name with value test_human_sample
    When user request GET for taxonomies of TEST_SAMPLE
    Then the response code should be 200
    Then the result should contain 2 taxonomies
    Then the href list of the taxonomy of taxonomies 2 contained in TEST_TAXONOMY_1,TEST_TAXONOMY_2

    When user request DELETE for the taxonomies of TEST_TAXONOMY_1 of the TEST_SAMPLE
    And the response code should be 2xx

    When user request DELETE for the taxonomies of TEST_TAXONOMY_2 of the TEST_SAMPLE
    And the response code should be 4xx
    And the result should have exception with value uk.ac.ebi.ampt2d.metadata.exceptionhandling.SampleWithoutTaxonomyException


  Scenario Outline: update a sample with invalid taxonomies should fail
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 10090,
      "name": "Mus Musculus"
    }
    """
    And set the URL to TEST_TAXONOMY
    When user create a test sample with TEST_TAXONOMY for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE
    When user request GET with value of TEST_SAMPLE
    Then the response code should be 200
    Then the result should have accessionVersionId.accession with value EGAS0001
    Then the result should have name with value test_human_sample
    When user request GET for taxonomies of TEST_SAMPLE
    Then the response code should be 200
    Then the result should contain 1 taxonomies
    Then the href list of the taxonomy of taxonomies 0 contained in  TEST_TAXONOMY

    When user request PATCH TEST_SAMPLE with list <list> for taxonomies
    And the response code should be 4xx
    And the result should have exception with value <exception>

    Examples:
      | list | exception |
      | NONE | uk.ac.ebi.ampt2d.metadata.exceptionhandling.SampleWithoutTaxonomyException |
      | BLANK | uk.ac.ebi.ampt2d.metadata.exceptionhandling.InvalidTaxonomyException |
      | TEST_TAXONOMY,BLANK | uk.ac.ebi.ampt2d.metadata.exceptionhandling.InvalidTaxonomyException |


  Scenario Outline: find two samples by taxonomy
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 207598,
      "name": "Homininae"
    }
    """
    And set the URL to TEST_TAXONOMY_1
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    And set the URL to TEST_TAXONOMY_2
    When user create a test parameterized sample with Species1 for accession, 1 for version, Species collection1 for name and TEST_TAXONOMY_1,TEST_TAXONOMY_2 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE1
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9597,
      "name": "Pan paniscus"
    }
    """
    And set the URL to TEST_TAXONOMY_3
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9598,
      "name": "Pan troglodytes"
    }
    """
    And set the URL to TEST_TAXONOMY_4
    When user create a test parameterized sample with Species2 for accession, 1 for version, Species collection2 for name and TEST_TAXONOMY_3,TEST_TAXONOMY_4 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE2
    When user create a test parameterized sample with Species3 for accession, 1 for version, Species collection3 for name and TEST_TAXONOMY_1,TEST_TAXONOMY_3 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE3

    When user request search for the samples with the parameters: <query>
    And the response code should be 200
    And the result should contain 2 samples
    And the href list of the sample of samples 1 contained in <url>

    Examples:
      | query | url |
      | taxonomies.name=Homininae | TEST_SAMPLE1,TEST_SAMPLE3 |
      | taxonomies.name=Pan paniscus | TEST_SAMPLE2,TEST_SAMPLE3 |
      | taxonomies.taxonomyId=207598 | TEST_SAMPLE1,TEST_SAMPLE3 |
      | taxonomies.taxonomyId=9597 | TEST_SAMPLE2,TEST_SAMPLE3 |


  Scenario Outline: find one sample by taxonomy
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 207598,
      "name": "Homininae"
    }
    """
    And set the URL to TEST_TAXONOMY_1
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    And set the URL to TEST_TAXONOMY_2
    When user create a test parameterized sample with Species1 for accession, 1 for version, Species collection1 for name and TEST_TAXONOMY_1,TEST_TAXONOMY_2 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE1
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9597,
      "name": "Pan paniscus"
    }
    """
    And set the URL to TEST_TAXONOMY_3
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9598,
      "name": "Pan troglodytes"
    }
    """
    And set the URL to TEST_TAXONOMY_4
    When user create a test parameterized sample with Species2 for accession, 1 for version, Species collection2 for name and TEST_TAXONOMY_3,TEST_TAXONOMY_4 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE2

    When user request search for the samples with the parameters: <query>
    And the response code should be 200
    And the result should contain 1 samples
    And the href list of the sample of samples 0 contained in  <url1>

    Examples:
      | query | url1 |
      | taxonomies.name=Homo sapiens | TEST_SAMPLE1 |
      | taxonomies.name=Pan troglodytes | TEST_SAMPLE2 |
      | taxonomies.taxonomyId=9606 | TEST_SAMPLE1 |
      | taxonomies.taxonomyId=9598 | TEST_SAMPLE2 |


  Scenario Outline: find no sample by non-existing taxonomy
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 207598,
      "name": "Homininae"
    }
    """
    And set the URL to TEST_TAXONOMY_1
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    And set the URL to TEST_TAXONOMY_2
    When user create a test parameterized sample with Species1 for accession, 1 for version, Species collection1 for name and TEST_TAXONOMY_1,TEST_TAXONOMY_2 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE1
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9597,
      "name": "Pan paniscus"
    }
    """
    And set the URL to TEST_TAXONOMY_3
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9598,
      "name": "Pan troglodytes"
    }
    """
    And set the URL to TEST_TAXONOMY_4
    When user create a test parameterized sample with Species2 for accession, 1 for version, Species collection2 for name and TEST_TAXONOMY_3,TEST_TAXONOMY_4 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE2

    When user request search for the samples with the parameters: <query>
    And the response code should be 200
    And the result should contain 0 samples

    Examples:
      | query |
      | taxonomies.name=NonExisting |
      | taxonomies.taxonomyId=0 |


  Scenario Outline: verify various accession version with samples
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 207598,
      "name": "Homininae"
    }
    """
    And set the URL to TEST_TAXONOMY1
    Given user request POST /taxonomies with json data:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    And set the URL to TEST_TAXONOMY2

    When user create a test sample no or null accession false, Sample1 for name and TEST_TAXONOMY1,TEST_TAXONOMY2 for taxonomy
    And the response code should be 201
    And set the URL to TEST_SAMPLE
    When user request GET with value of TEST_SAMPLE
    Then the response code should be 200
    And the result should have id as number
    And the result should have accessionVersionId as null

    When user create a test sample no or null accession true, Sample1 for name and TEST_TAXONOMY1,TEST_TAXONOMY2 for taxonomy
    And the response code should be 4xx
    And the property field of errors 0 should be accessionVersionId.accession
    And the message field of errors 0 should be may not be null

    When user create a test parameterized sample with <accession> for accession, <version> for version, Sample1 for name and TEST_TAXONOMY1,TEST_TAXONOMY2 for taxonomy
    And the response code should be 4xx
    And the property field of errors 0 should be <property>
    And the message field of errors 0 should be <message>


    Examples:
    | accession | version | property | message |
    |  | 1 | accessionVersionId.accession | size must be between 1 and 255 |
    | EGAN0001 | 0 |accessionVersionId.version | must be greater than or equal to 1 |