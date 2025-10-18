#' Create t-SNE Interactive Visualization Widget
#'
#' @param metadata_df A data frame with columns: Model, List, CID, NameShow, PathOut
#' @return An htmltools tagList containing the interactive widget
#' @import htmltools
#' @import jsonlite
create_tsne_widget <- function(metadata_df) {
  
  # Convert to JSON for JavaScript
  metadata_json <- jsonlite::toJSON(metadata_df, dataframe = "rows", auto_unbox = TRUE)
  
  # Create the complete HTML widget
  htmltools::tagList(
    # JavaScript data
    htmltools::tags$script(htmltools::HTML(paste0("var plotMetadata = ", metadata_json, ";"))),
    
    # Dropdown container
    htmltools::div(style = "margin: 20px 0;",
                   htmltools::div(style = "display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 20px;",
                                  
                                  # Dictionary dropdown
                                  htmltools::div(
                                    htmltools::tags$label(`for` = "list-sel", style = "font-weight: bold; display: block; margin-bottom: 5px;", "Dictionary:"),
                                    htmltools::tags$select(id = "list-sel", style = "width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc;",
                                                           htmltools::tags$option(value = "", "-- Select Dictionary --")
                                    )
                                  ),
                                  
                                  # Model dropdown
                                  htmltools::div(
                                    htmltools::tags$label(`for` = "model-sel", style = "font-weight: bold; display: block; margin-bottom: 5px;", "Embedding Model:"),
                                    htmltools::tags$select(id = "model-sel", style = "width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc;",
                                                           htmltools::tags$option(value = "", "-- Select Model --")
                                    )
                                  ),
                                  
                                  # CID dropdown
                                  htmltools::div(
                                    htmltools::tags$label(`for` = "cid-sel", style = "font-weight: bold; display: block; margin-bottom: 5px;", "Concept ID:"),
                                    htmltools::tags$select(id = "cid-sel", style = "width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc;",
                                                           htmltools::tags$option(value = "", "-- Select Concept --")
                                    )
                                  )
                   )
    ),
    
    # Image container
    htmltools::div(id = "img-container", style = "text-align: center; margin-top: 30px;",
                   htmltools::tags$img(id = "plot-img", src = "", alt = "t-SNE plot", 
                                       style = "max-width: 1000px; width: 100%; display: none; border: 1px solid #ddd; border-radius: 4px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);"),
                   htmltools::p(id = "plot-caption", style = "margin-top: 10px; color: #666; font-style: italic;"),
                   htmltools::p(id = "msg", style = "color: #999;", "Select dictionary, model, and concept to view plot")
    ),
    
    # JavaScript for interactivity
    htmltools::tags$script(htmltools::HTML('
      (function() {
        var lists = [...new Set(plotMetadata.map(function(r) { return r.List; }))];
        var models = [...new Set(plotMetadata.map(function(r) { return r.Model; }))];
        
        var listSel = document.getElementById("list-sel");
        lists.forEach(function(l) {
          var opt = document.createElement("option");
          opt.value = l;
          opt.textContent = l;
          listSel.appendChild(opt);
        });
        
        var modelSel = document.getElementById("model-sel");
        models.forEach(function(m) {
          var opt = document.createElement("option");
          opt.value = m;
          opt.textContent = m;
          modelSel.appendChild(opt);
        });
        
        function updateCIDs() {
          var list = listSel.value;
          var model = modelSel.value;
          var cidSel = document.getElementById("cid-sel");
          
          cidSel.innerHTML = "<option value=\\"\\">\u002d\u002d Select Concept \u002d\u002d</option>";
          
          if (list && model) {
            var cids = plotMetadata
              .filter(function(r) { return r.List === list && r.Model === model; })
              .map(function(r) { return r.CID; })
              .sort();
            
            cids.forEach(function(c) {
              var opt = document.createElement("option");
              opt.value = c;
              opt.textContent = c;
              cidSel.appendChild(opt);
            });
            
            // Automatically select the first concept
            if (cids.length > 0) {
              cidSel.value = cids[0];
            }
          }
          updatePlot();
        }
        
        function updatePlot() {
          var list = listSel.value;
          var model = modelSel.value;
          var cid = document.getElementById("cid-sel").value;
          
          var plotImg = document.getElementById("plot-img");
          var caption = document.getElementById("plot-caption");
          var msg = document.getElementById("msg");
          
          if (list && model && cid) {
            var row = plotMetadata.find(function(r) {
              return r.List === list && r.Model === model && r.CID === cid;
            });
            
            if (row) {
              console.log("Found row:", row);
              console.log("Image path:", row.PathOut);
              
              plotImg.src = row.PathOut;
              plotImg.style.display = "block";
              caption.textContent = row.NameShow;
              msg.style.display = "none";
              
              plotImg.onerror = function() {
                console.error("Failed to load image:", row.PathOut);
                msg.textContent = "Error loading image. Path: " + row.PathOut;
                msg.style.display = "block";
                msg.style.color = "red";
                plotImg.style.display = "none";
              };
              
              plotImg.onload = function() {
                console.log("Image loaded successfully!");
              };
              return;
            }
          }
          
          plotImg.style.display = "none";
          caption.textContent = "";
          msg.style.display = "block";
          msg.style.color = "#999";
          msg.textContent = "Select dictionary, model, and concept to view plot";
        }
        
        listSel.addEventListener("change", updateCIDs);
        modelSel.addEventListener("change", updateCIDs);
        document.getElementById("cid-sel").addEventListener("change", updatePlot);
      })();
    '))
  )
}