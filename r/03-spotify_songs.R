# load packages
  pacman::p_load(tidyverse,
                 spotifyr)

# set up spotify api
  Sys.getenv("SPOTIFY_CLIENT_ID")
  Sys.getenv("SPOTIFY_CLIENT_SECRET")
  
  access_token <- get_spotify_access_token()
  
# get albums data
  albums <- get_artist_albums('1VPmR4DJC1PlOtd0IADAO0')
  
  album_ids <- albums$id
  
# clean up albums data
  albums <- albums |>
    select(id, name, release_date, total_tracks, artists, images)
  
  albums <- albums |>
    mutate(artist_1 = sapply(artists, function(x) x[[3]][1]),
           artist_2 = sapply(artists, function(x) x[[3]][2]),
           images = sapply(images, function(x) x[[2]][2])) |>
    select(-artists)
  
# function to get all tracks into one df
  get_track_df <- function(id_vec) {
    df_list <- lapply(id_vec, function(ids) {
      album_tracks <- get_album_tracks(ids)
      album_tracks %>% 
        mutate(album_id = ids)
    })
    combined_df <- do.call(rbind, df_list)
    return(combined_df)
  }
  
# get all tracks data
  tracks <- get_track_df(album_ids)
  
# clean up tracks data
  tracks <- tracks |>
    select(album_id, track_number, name, id, explicit, duration_ms, artists)

  tracks <- tracks |>
    mutate(artist_1 = sapply(artists, function(x) x[[3]][1]),
           artist_2 = sapply(artists, function(x) x[[3]][2]),
           artist_3 = sapply(artists, function(x) x[[3]][3]),
           artist_4 = sapply(artists, function(x) x[[3]][4])) |>
    select(-artists)
  
# save data frames as csv
  write_excel_csv(albums, "data/album_data_spotify.csv")
  
  write_excel_csv(tracks, "data/tracks_data_spotify.csv")
  