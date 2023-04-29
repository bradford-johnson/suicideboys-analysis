# load packages
  pacman::p_load(tidyverse,
                 spotifyr)

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