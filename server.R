#--------------------------------------------------------#
# ID: 11910062 Rajasekhar Matam                          #
# ID: 11910073 Piyush Kumar jain                         #
# ID: 11910086 Pavan Kumar Battula                       #
#--------------------------------------------------------#

#--------------------------------------------------------#
# Server.R UDPipe APP                                    #
#--------------------------------------------------------#


# get data first
require(stringr)

shinyServer(function(input, output) {
  
  Dataset <- reactive({
    
    if (is.null(input$file)) {# locate 'file1' from ui.R
      return(NULL) } 
    else{
      Data <- readLines(input$file$datapath)
      Data  =  str_replace_all(Data, "<.*?>", "") # get rid of html junk 
      Data = Data[Data!= ""]
      str(Data)
      return(Data)
    }
  })
  
  english_model = reactive({
    # load english model for annotation from working dir
    english_model = udpipe_load_model("F:\\ISB\\Residency\\Residency2\\TA\\Session 5 Files-20180418\\TA_Assignment2\\english-ud-2.0-170801.udpipe")  # file_model only needed
    return(english_model)
  })
  
  annot.obj = reactive({
    x <- udpipe_annotate(english_model(),x=Dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  output$downloadData <- downloadHandler(
    filename = function(){
      "annotated_data.csv"
    },
    content = function(file){
      write.csv(annot.obj()[,-4],file,row.names = FALSE)
    }
  )
  
  output$datatableOutput = renderDataTable({
    if(is.null(input$file)){return(NULL)}
    else{
      out = annot.obj()[,-4]
      return(out)
    }
  })
  
  output$wcplot1 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_nouns = x %>% subset(., upos %in% "NOUN") 
      top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
      
      wordcloud(top_nouns$key,top_nouns$freq, min.freq = 3,colors = 1:10 )
    }
  })
  
  output$wcplot2 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_verbs = x %>% subset(., upos %in% "VERB") 
      top_verbs = txt_freq(all_verbs$lemma)
      
      wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10 )
    }
  })
  
  output$coocplot3 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      nokia_cooc <- cooccurrence(   	# try `?cooccurrence` for parm options
        x = subset(annot.obj(), upos %in% input$upos), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
      
      wordnetwork <- head(nokia_cooc, 50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 6) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Cooccurrences within 3 words distance", subtitle = "Select the check boxes in the left pane")
    }
  })
})
