# load packages
  pacman::p_load(
    geniusr,
    tidyverse
)

# set client access token
  genius_token(force = FALSE)

# load songs.csv
  songs <- read_csv("data/songs.csv")

# get_songs function that applies a vector to get_song_df() and
# returns a combined df
  get_songs <- function(id_vec) {
    df_list <- lapply(id_vec, function(id) {
      get_song_df(id, access_token = genius_token())
    })
    combined_df <- do.call(rbind, df_list)
    return(combined_df)
  }

# create song_id vector as song_vector
  song_vector <- as.vector(songs$song_id)

# run get_songs function with song_vector
  df <- get_songs(song_vector)

# write csv
  write_excel_csv(df, "data/song_data.csv")