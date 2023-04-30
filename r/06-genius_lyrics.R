# load packages
  pacman::p_load(
    geniusr,
    tidyverse
  )

# set client access token
  genius_token(force = FALSE)

# load song keys
  song_keys <- read_csv("data/song_keys.csv")
  
# get song lyrics
  song_ids <- as.vector(song_keys$genius_id)

# function for get_lyrics_id
  get_lyrics_for_songs <- function(song_ids) {
    df_list <- lapply(song_ids, function(id) {
      res <- tryCatch(
        geniusr::get_lyrics_id(id, access_token = genius_token()),
        error = function(e) NULL
      )
      if (!is.null(res) && all(!sapply(res, is.null)) &&
          all(sapply(res, function(x) length(x) > 0))) {
        res %>% as_tibble()
      } else {
        NULL
      }
    })
    df_list <- Filter(Negate(is.null), df_list)
    if (length(df_list) == 0) {
      return(NULL)
    } else if (length(df_list) == 1) {
      return(df_list[[1]])
    } else {
      cols <- intersect(names(df_list[[1]]), names(df_list[[2]]))
      for (i in 3:length(df_list)) {
        cols <- intersect(cols, names(df_list[[i]]))
      }
      combined_df <- bind_rows(df_list)
      combined_df <- combined_df[,cols]
      return(combined_df)
    }
  }
  
# run function and get lyrics
  lyrics <- get_lyrics_for_songs(song_ids)
  
# clean and organize lyrics data
  lyrics <- lyrics |>
    mutate(genius_id = song_id) |>
    select(genius_id, section_name, section_artist, line)

# write .csv
  write_excel_csv(lyrics, "data/genius_lyrics.csv")
  