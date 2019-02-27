provider "google" {
  region  = "us-west1"
  project = "battlesnake-io"
}

terraform {
  backend "gcs" {
    bucket = "terraform-battlesnake-io"
    prefix = "battlesnake/bigquery"
  }

  required_version = "= 0.11.7"
}

resource "google_bigquery_dataset" "battlesnake_games" {
  dataset_id                  = "battlesnake_games"
  location                    = "US"
}

resource "google_bigquery_table" "games" {
  dataset_id = "${google_bigquery_dataset.battlesnake_games.dataset_id}"
  table_id   = "games"

  schema = "${file("games.json")}"
}

resource "google_bigquery_table" "snakes" {
  dataset_id = "${google_bigquery_dataset.battlesnake_games.dataset_id}"
  table_id   = "snakes"

  schema = "${file("snakes.json")}"
}