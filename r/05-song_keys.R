# load packages
  pacman::p_load(
    tidyverse
  )

# load songs data from genius
  genius <- read_csv("data/songs.csv")

# clean and make joinable key "table" with spotify songs
  genius <- genius |>
    select(song_id, song_name)

# gsub("\\([^()]*\\)", "", genius$song_name)
    genius$song <- gsub("\\([^()]*((\\([^()]*\\)[^()]*))?", "", genius$song_name)
    
    genius$song_1 <- gsub(")", "", genius$song)
    
    genius$song_2 <- gsub(" ", "", genius$song_1)
    
    genius$song_3 <- str_to_lower(genius$song_2)
  
  
# load songs from spotify and clean
    spotify <- read_csv("data/tracks_data_spotify.csv")
    
    spotify <- spotify |>
      select(id, name)
  
    spotify$song <- gsub("\\([^()]*((\\([^()]*\\)[^()]*))?", "", spotify$name)
    
    spotify$song_1 <- gsub(")", "", spotify$song)
    
    spotify$song_2 <- gsub(" ", "", spotify$song_1)
    
    spotify$song_3 <- str_to_lower(spotify$song_2)
    
# join data frames and clean
    genius <- genius |>
      mutate(genius_id = song_id) |>
      select(genius_id, song_3)
   
    spotify <- spotify |>
      mutate(spotify_id = id, song_name = name, song_3g = song_3) |>
      select(spotify_id, song_name, song_3g)
    
   song_keys <- spotify |>
     inner_join(genius, by = c("song_3g" = "song_3"))
   
   song_keys <- song_keys |>
     distinct(spotify_id, .keep_all = TRUE)

   song_keys <- song_keys |>
     select(song_name, spotify_id, genius_id)
   
# write as .csv
   write_excel_csv(song_keys, "data/song_keys.csv")