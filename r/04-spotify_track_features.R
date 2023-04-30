# load packages
  pacman::p_load(
    tidyverse,
    spotifyr
  )

# set up spotify api
  Sys.getenv("SPOTIFY_CLIENT_ID")
  Sys.getenv("SPOTIFY_CLIENT_SECRET")

  access_token <- get_spotify_access_token()
  
# load track data
  tracks <- read_csv("data/tracks_data_spotify.csv")
  
# wrangle tracks data
  tracks_expl <- tracks |>
    filter(explicit == "TRUE")

# split df into 2 halfs for respectful API requests
  half_1 <- head(tracks_expl$id, 91)
  half_2 <- tail(tracks_expl$id, 91)
  
# get audio features
  feat_half_1 <- get_track_audio_features(half_1)
  feat_half_2 <- get_track_audio_features(half_2) 
  # Clouds as Witnesses | 7s7q9dpsSCMEnDR3WhExZy | returns NA
  # instead of 182 songs total will be -> 181
  
# combine both halfs
  track_features <- rbind(feat_half_1, feat_half_2)
  
# clean and organize track_features
  track_features <- track_features |>
    select(id, time_signature, danceability,
           energy, key, loudness, mode,
           speechiness, acousticness, instrumentalness,
           liveness, valence, tempo, duration_ms) |>
    drop_na()
  
# write .csv
  write_excel_csv(track_features, "data/spotify_track_features.csv")