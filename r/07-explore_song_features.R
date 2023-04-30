# load packages
  pacman::p_load(
    tidyverse
  )
  
# load data
  tracks <- read_csv("data/spotify_track_features.csv")
  
# explore for insights
  
  tracks |>
    ggplot(aes(x = valence, y = energy)) +
    geom_point(aes(size = loudness, alpha = .5))

  tracks |>
    ggplot(aes(x = duration_ms, y = tempo)) +
    geom_point(aes(size = energy, alpha = .5))
  
  tracks |>
    ggplot(aes(x = duration_ms, y = danceability)) +
    geom_point(aes(size = energy, alpha = .5))

  # look into combining g and s and seeing popularity etc  