load("wine")
load("map_df")
load("bkgd_map")
library("ggmap")
library("tree")
library("mapproj")

f.whichwine<-function(odor, aroma,tannin){
  vin<-wine[,c(1,3,4,17)]
  names(vin)<-c("label","odor","aroma","tannin")
  levels(vin$label)<-c("Saumur","Bourgueil", "Chinon") #fix a syntax error
  vintree<-tree(label~., data=vin)
  f.scale<-function(x,y) {
    x<-(min(y)+x*(max(y)-min(y))/10)
    return(x)
  }
  newdata<-data.frame("odor"=f.scale(odor,vin$odor),"aroma"=f.scale(aroma,vin$aroma),
                      "tannin"=f.scale(tannin,vin$tannin))
  return(as.character(predict(vintree,newdata, type="class")))
}

shinyServer(
    
  function(input, output) {
    
    temp1<-reactive(f.whichwine(input$odor, input$aroma, input$tannin))
    
    output$aoc <- renderPrint({temp1()
    })
    output$graph <- renderPlot({ 
      data<-aoc_list[[temp1()]]
      bkgd + geom_polygon(data =data, aes(x = long, y = lat, group = group),
                  colour = 'red', fill = 'red', alpha = .4, size = .3)
    })
  }
)
