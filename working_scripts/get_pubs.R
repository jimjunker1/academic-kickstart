get_complete_coauthors <- function (id, pubid, sleep = 3, encoding = "UTF-8"){
  httr::set_config(httr::user_agent("james.junker@montana.edu; +https://jimjunker.com"))
  auths = ""
  url_template = "http://scholar.google.com/citations?view_op=view_citation&citation_for_view=%s:%s"
  url = sprintf(url_template, id, pubid)
  Sys.sleep(sleep)
  url1 <- xml2::read_html(url, encoding = encoding)
  auths = as.character(rvest::html_node(url1, ".gsc_vcd_value") %>%
                         rvest::html_text())
  return(auths)
}
library(tidyverse)
library(scholar)
library(RefManageR)
'%ni%' <- Negate('%in%')

pubs <- scholar::get_publications("q3E1S9MAAAAJ") %>%
  slice(-(n()-3):-n()) %>%
  dplyr::mutate(author = author %>%
                  as.character %>%
                  stringr::str_trim(),
                journal = journal,
                first_author = case_when(stringr::str_starts(author, "JR Junker") ~ TRUE,
                                         TRUE ~ FALSE)) %>%
  filter(title %ni% c("Freshwater processing of terrestrial dissolved organic matter: What governs lability?","RIVERINE DISSOLVED ORGANIC MATTER DECOMPOSITION AND DYNAMICS","Trophic basis of invertebrate production in a Northern Rockies stream with recent willow recovery")) %>%
  dplyr::arrange(desc(year))

a = scholar::get_complete_authors(id = "q3E1S9MAAAAJ", pubs[1,"pubid"])
b = scholar::get_complete_authors(id = "q3E1S9MAAAAJ", pubs[2,"pubid"])
c = scholar::get_complete_authors(id = "q3E1S9MAAAAJ", pubs[3,"pubid"])
d = scholar::get_complete_authors(id = "q3E1S9MAAAAJ", pubs[4,"pubid"])
e = scholar::get_complete_authors(id = "q3E1S9MAAAAJ", pubs[5,"pubid"])
f = scholar::get_complete_authors(id = "q3E1S9MAAAAJ", pubs[6,"pubid"])
g = scholar::get_complete_authors(id = "q3E1S9MAAAAJ", pubs[7,"pubid"])
full_authors = c(a,b,c,d,e,f,g)
pubs <- pubs %>% mutate(author = full_authors)

for( i in 1:dim(pubs)[1]){
 x = get_complete_coauthors(id = "q3E1S9MAAAAJ", pubs[i,"pubid"])
 print(x)
}

jrj.bib <- RefManageR::ReadGS(scholar.id = "q3E1S9MAAAAJ", sort.by.date = TRUE, check.entries = 'warn') %>%
 rlist::list.filter(names(.) %ni% c("junker2011trophic","smith2015riverine","dandrilli2016freshwater"))
RefManageR::WriteBib(jrj.bib, file = "./content/publication/pubs.bib")
# #
# get_complete_coauthors <- function (id, pubid, sleep = 3.0){
#   auths = ""
#   url_template = "http://scholar.google.com/citations?view_op=view_citation&citation_for_view=%s:%s"
#   url = sprintf(url_template, id, pubid)
#   Sys.sleep(sleep)
#   url1 <- xml2::read_html(url)
#   auths = as.character(rvest::html_node(url1, ".gsc_vcd_value") %>%
#                          rvest::html_text())
#   return(auths)
# }
#
# pubs <- scholar::get_publications("q3E1S9MAAAAJ") %>%
#   mutate_if(is.factor, as.character) %>%
#   slice(-(n()-3):-n()) %>%
#   dplyr::mutate(author = author %>%
#                    as.character %>%
#                    stringr::str_trim(),
#                 journal = journal,
#                 first_author = case_when(stringr::str_starts(author, "JR Junker") ~ TRUE,
#                                          TRUE ~ FALSE)) %>%
#   filter(title %ni% c("Freshwater processing of terrestrial dissolved organic matter: What governs lability?","RIVERINE DISSOLVED ORGANIC MATTER DECOMPOSITION AND DYNAMICS","Trophic basis of invertebrate production in a Northern Rockies stream with recent willow recovery")) %>%
#   dplyr::arrange(desc(year))
#
# full_authors = readRDS(file = "../static/files/cv/data/full_authors.rds")
# pubs <- pubs %>% mutate(author = full_authors)
# working on automating get complete authors.
# if(file.exists("../static/files/cv/data/full_authors.rds")){
#   full_authors = readRDS(file ="../static/files/cv/data/full_authors.rds")
#   pubs <- pubs %>% mutate(author = full_authors)
# } else(full_authors <-  )
