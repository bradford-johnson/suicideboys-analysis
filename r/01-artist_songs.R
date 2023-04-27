# load packages
  pacman::p_load(
    geniusr,
    tidyverse
  )

# set client access token
  genius_token(force = FALSE)

# get "$uicideboy$" artist_id...
  search_artist(
    "$uicideboy$",
    n_results = 5,
    access_token = genius_token()
  )

  sb_id <- 213444

# df of all songs
  songs <- get_artist_songs_df(
            sb_id,
            sort = c("title", "popularity"),
            include_features = FALSE,
            access_token = genius_token()
          )
  
  # save df as .csv
    write_csv(songs, "data/songs.csv")