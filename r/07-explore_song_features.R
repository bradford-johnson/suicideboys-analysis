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

# check which songs have lyrics
  songs_with_lyrics <- read_csv("data/genius_lyrics.csv")
  song_keys <- read_csv("data/song_keys.csv")
  
  songs_with_lyrics <- songs_with_lyrics |>
    group_by(genius_id) |>
    count()
  
  songs_with_lyrics <- songs_with_lyrics |>
    inner_join(song_keys, by = c("genius_id" = "genius_id")) |>
    distinct(genius_id, .keep_all = TRUE)

  songs_with_lyrics <- tracks_and_features_joined |>
    inner_join(songs_with_lyrics, by = c("track_id" = "spotify_id"))
  
  songs_with_lyrics <- songs_with_lyrics |>
    arrange(desc(release_date), track_number)
  
  #-----------------------------------------#
  # 79 songs with lyrics total--------------#
  # no full albums, only partial -----------#
  # more of the most popular songs ---------#
  # 15 partial albums present --------------#
  #-----------------------------------------#

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