# load packages
  pacman::p_load(
    tidyverse
  )
  
# load data
  track_features <- read_csv("data/spotify_track_features.csv")
  tracks <- read_csv("data/tracks_data_spotify.csv")
  albums <- read_csv("data/album_data_spotify.csv")
  
# join data
  tracks_joined <- albums |>
    left_join(tracks, by = c("id" = "album_id")) |>
    mutate(album_id = id, album_name = name.x, track_id = id.y,
           track_name = name.y, artist_1 = artist_1.y, artist_2 = artist_2.y) |>
    select(album_id, album_name, release_date, total_tracks,
           track_id, track_name, explicit, track_number,
           artist_1, artist_2, artist_3, artist_4)
  
  tracks_and_features_joined <- tracks_joined |>
    inner_join(track_features, by = c("track_id" = "id"))
  
# explore for insights
  
  track_features |>
    ggplot(aes(x = valence, y = energy)) +
    geom_point(aes(size = loudness, alpha = .5))

  track_features |>
    ggplot(aes(x = duration_ms, y = tempo)) +
    geom_point(aes(size = energy, alpha = .5))
  
  track_features |>
    ggplot(aes(x = duration_ms, y = danceability)) +
    geom_point(aes(size = energy, alpha = .5))

  # look into combining g and s and seeing popularity etc  