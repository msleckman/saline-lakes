fetch_all_lake_basin_flowlines <- function(lakes_shp, gpkg_file_out,
                                           lake_buffer = 10^5,
                                           lake_w_state_col='lake_w_state',
                                           geom_col = 'geometry'){
  
  #' @name fetch_all_lake_basin_flowlines function to pull flowlines around a lake. Seeking to pull all relevant flowlines as much as possible in order to later identify all upstream sources of each lake
  #' @param lakes_shp lake shapefile with which we scope surrounding flowlines
  #' @param gpkg_file_out out path for the generated flowlines sf output. Recomment gpkg format. ex: '1_fetch/out/p1_all_flowlines_basin.gpkg'
  #' @param lake_buffer buffer of lake area. The larger the buffer, the larger the extent of flowline query
  #' @param lake_w_state_col lake_shp col called lake_w_state 
  #' @param geom_col name of geometry col in lake_shp. Typically geom    
  
  ## buffering lakes wide to get large scope for fetch relevant flowlines
  buffered_lakes <- p2_saline_lakes_sf %>% sf::st_buffer(lake_buffer) %>%
    select(all_of(c(lake_w_state_col,geom_col)))
           
  ## Turn buffer_lakes df into a itemized list in order to extract flowlines for each of the lakes
  buffered_lakes_lst <- split(buffered_lakes, seq(nrow(buffered_lakes)))
  
  ## Iterate through each item of a given lake to pull flowlines            
  all_flowlines <- purrr::map(.x = buffered_lakes_lst,
                              .f = ~ nhdplusTools::get_nhdplus(AOI = .x,
                                                               realization = 'flowline'))
  
  ## combine map output into a singular sf df and remove duplicate reaches (id duplicates by comid)
  all_flowlines <- all_flowlines %>% bind_rows(.) %>% distinct(comid, .keep_all = TRUE)         
  
  # write to output folder
  st_write(obj = all_flowlines, gpkg_file_out)
  
  return(all_flowlines)
}

fetch_all_lake_basin_flowlines(p2_saline_lakes_sf, gpkg_file_out = '1_fetch/out/p1_all_flowlines.gpkg')
