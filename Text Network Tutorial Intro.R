################################################################################
#                                                                              #
#   Text Network Tutorial                                                      #
#   Jonathan D. Ware                                                           #
#   June 29, 2021                                                              #
#                                                                              #
################################################################################

# In R, most analysis can be done via the textnets package

library(devtools)
install_github("cbail/textnets")
library(textnets)

# Import state of the union data from textnet package

data('sotu')

# For this exercise, comparing the first state of the union address from each 
# president

sotu_first_speeches <- sotu %>% group_by(president) %>% slice(1L)

# The code below preps the text data and creates an object that can be converted
# into an adjacency matrix or square matrix

prepped_sotu <- PrepText(sotu_first_speeches, groupvar = "president", textvar = 
                "sotu_text", node_type = "groups", tokenizer = "words", pos = 
                "nouns", remove_stop_words = TRUE, compound_nouns = TRUE)

# Create text network object

sotu_text_network <- CreateTextnet(prepped_sotu)

# To visualize the network

VisTextNet(sotu_text_network, label_degree_cut = 0)

# Alternatively, can use VisTextNetD3 for an interactive visualization

VisTextNetD3(sotu_text_network)

# To save this, we can use the 'htmlwidgets' package

library(htmlwidgets)
vis <- VisTextNetD3(sotu_text_network, 
                    height=1000,
                    width=1400,
                    bound=FALSE,
                    zoom=TRUE,
                    charge=-30)
saveWidget(vis, "sotu_textnet.html")
 
# Get some basic measures of data

sotu_communities <- TextCommunities(sotu_text_network)
head(sotu_communities)

top_words_modularity_classes <- InterpretText(sotu_text_network, prepped_sotu)
head(top_words_modularity_classes)