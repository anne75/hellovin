load("wine")
load("map_df")
load("bkgd_map")
library("ggmap")
library("tree")
library("mapproj")

f.whichwine<-function(spice, aroma,tannin){
  vin<-wine[,c(1,4,7,17)]
  names(vin)<-c("label","aroma","spice", "tannin")
  levels(vin$label)<-c("Saumur","Bourgueil", "Chinon") #fix a syntax error
  vintree<-tree(label~., data=vin, control=tree.control(minsize = 1, nobs=21) )
  f.scale<-function(x,y) {
    x<-(min(y)+x*(max(y)-min(y))/10)
    return(x)
  }
  newdata<-data.frame("spice"=f.scale(spice,vin$spice),"aroma"=f.scale(aroma,vin$aroma),
                      "tannin"=f.scale(tannin,vin$tannin))
  return(as.character(predict(vintree,newdata, type="class")))
}

shinyServer(
    
  function(input, output) {
    
    temp1<-reactive(f.whichwine(input$spice, input$aroma, input$tannin))
    
    output$aoc <- renderPrint({temp1()
    })
    output$graph <- renderPlot({ 
      data<-aoc_list[[temp1()]]
      bkgd + geom_polygon(data =data, aes(x = long, y = lat, group = group),
                  colour = 'red', fill = 'red', alpha = .4, size = .3)
    })
  }
)
