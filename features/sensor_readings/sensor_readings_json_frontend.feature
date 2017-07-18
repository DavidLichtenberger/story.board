Feature: Generate sensor data as JSON for frontend
  As a frontend designer
  I want data from a sensor I select via id as json - beginning at a time I specify via query, in intervals I can also specify via query in minutes, sorted from oldest to newest
  In order to easily integrate the data in my frontend.

  Background:
    Given we have these sensor readings for sensor 95 in our database:
      | Id    | Timestamp        | Calibrated Value | Uncalibrated Value |
      | 24593 | 2017-07-18 15:09 | 39.701           | 39.701             |
      | 24581 | 2017-07-18 14:39 | 39.369           | 39.369             |
      | 24569 | 2017-07-18 14:09 | 39.459           | 39.459             |
      | 24557 | 2017-07-18 13:39 | 39.248           | 39.248             |
      | 24545 | 2017-07-18 13:09 | 38.382           | 38.382             |
      | 24527 | 2017-07-18 12:19 | 39.008           | 39.008             |
      | 24521 | 2017-07-18 12:09 | 39.068           | 39.068             |
      | 24516 | 2017-07-18 11:59 | 39.188           | 39.188             |
      | 24497 | 2017-07-18 11:09 | 39.038           | 39.038             |
      | 24588 | 2017-07-17 14:59 | 39.55            | 39.55              |
      | 24587 | 2017-07-17 14:49 | 39.429           | 39.429             |
      | 24576 | 2017-07-17 14:29 | 39.369           | 39.369             |
      | 24575 | 2017-07-17 14:19 | 39.399           | 39.399             |
      | 24564 | 2017-07-17 13:59 | 39.459           | 39.459             |
      | 24563 | 2017-07-17 13:49 | 39.429           | 39.429             |
      | 24552 | 2017-07-17 13:29 | 39.068           | 39.068             |
      | 24551 | 2017-07-17 13:19 | 38.769           | 38.769             |
      | 24540 | 2017-07-17 12:59 | 37.673           | 37.673             |
      | 24539 | 2017-07-17 12:49 | 36.016           | 36.016             |
      | 24533 | 2017-07-17 12:39 | 35.242           | 35.242             |
      | 24528 | 2017-07-17 12:29 | 39.098           | 39.098             |
      | 24515 | 2017-07-16 11:49 | 39.339           | 39.339             |
      | 24509 | 2017-07-16 11:39 | 39.278           | 39.278             |
      | 24491 | 2017-07-16 10:49 | 39.188           | 39.188             |
      | 24485 | 2017-07-16 10:39 | 39.128           | 39.128             |
      | 24479 | 2017-07-16 10:19 | 39.158           | 39.158             |
      | 24473 | 2017-07-16 10:09 | 39.128           | 39.128             |
      | 24504 | 2017-07-16 11:29 | 39.188           | 39.188             |
      | 24503 | 2017-07-16 11:19 | 39.068           | 39.068             |
      | 24467 | 2017-07-15 09:49 | 38.859           | 38.859             |
      | 24461 | 2017-07-15 09:39 | 38.62            | 38.62              |
      | 24456 | 2017-07-15 09:29 | 38.323           | 38.323             |
      | 24455 | 2017-07-15 09:19 | 37.968           | 37.968             |
      | 24443 | 2017-07-15 08:49 | 38.561           | 38.561             |
      | 24437 | 2017-07-15 08:39 | 38.353           | 38.353             |
      | 24419 | 2017-07-15 07:49 | 39.459           | 39.459             |
      | 24413 | 2017-07-15 07:39 | 39.519           | 39.519             |
      | 24408 | 2017-07-15 07:29 | 39.489           | 39.489             |
      | 24407 | 2017-07-15 07:19 | 39.489           | 39.489             |
    And I send and accept JSON

  Scenario: Prepare sensor data (use average for 'throttle', cut off at 'since') and send as json
    When I send a GET request to "reports/1/sensors/95.json?since=2017.07.17%2000:00&throttle=60"
    Then the JSON response should be:
    """
    [
      {
        "timestamp": "2017-07-17 12:00",
        "calibrated": 37.00725,
        "uncalibrated": 37.00725,
      },
      {
        "timestamp": "2017-07-17 13:00",
        "calibrated": 39.18125,
        "uncalibrated": 39.18125,
      },
      {
        "timestamp": "2017-07-17 14:00",
        "calibrated": 34.43675,
        "uncalibrated": 34.43675,
      },
      {
        "timestamp": "2017-07-18 11:00",
        "calibrated": 39.113,
        "uncalibrated": 39.113,
      },
      {
        "timestamp": "2017-07-18 12:00",
        "calibrated": 39.038,
        "uncalibrated": 39.038,
      },
      {
        "timestamp": "2017-07-18 13:00",
        "calibrated": 38.815,
        "uncalibrated": 38.815,
      },
      {
        "timestamp": "2017-07-18 14:00",
        "calibrated": 39.414,
        "uncalibrated": 39.414,
      },
      {
        "timestamp": "2017-07-18 15:00",
        "calibrated": 39.701,
        "uncalibrated": 39.701,
      }
  ]
  """
