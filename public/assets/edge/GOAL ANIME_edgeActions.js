/***********************
* Adobe Edge Animate Composition Actions
*
* Edit this file with caution, being careful to preserve 
* function signatures and comments starting with 'Edge' to maintain the 
* ability to interact with these actions from within Adobe Edge Animate
*
***********************/
(function($, Edge, compId){
var Composition = Edge.Composition, Symbol = Edge.Symbol; // aliases for commonly used Edge classes

   //Edge symbol: 'stage'
   (function(symbolName) {
      
      
      Symbol.bindTriggerAction(compId, symbolName, "Default Timeline", 10000, function(sym, e) {
         EC.Sound.play("horn")

      });
      //Edge binding end

      Symbol.bindTriggerAction(compId, symbolName, "Default Timeline", 17065, function(sym, e) {
         // play the timeline from the given position (ms or label)
         sym.play("Loop");
         
         
         

      });
      //Edge binding end

      Symbol.bindTriggerAction(compId, symbolName, "Default Timeline", 10000, function(sym, e) {
         
         
         
         
         
         

      });
      //Edge binding end

      Symbol.bindSymbolAction(compId, symbolName, "creationComplete", function(sym, e) {
         yepnope({
             load: ['http://www.edgehero.com/edgehero.js/0.2/edgehero-0.2-min.js', 'http://cdn.edgecommons.org/an/1.0.0/js/min/EdgeCommons.js'],
         	complete: function() {
         		EC.debug("Ready to go!");
         
         		var assetsPath = "Alarms/";
         EC.Sound.setup(
             [
                 {src: assetsPath + "Dallas_Stars_Horn.mp3|" , id: "horn"}
             ],
             function(){ EC.info("Sound setup finished", "Sound test"); }
         
         
         );
         	}
         });
         

      });
      //Edge binding end

      Symbol.bindElementAction(compId, symbolName, "${_But_ALPHA}", "click", function(sym, e) {
         
         sym.play("Preroll");
         
         

      });
      //Edge binding end

   })("stage");
   //Edge symbol end:'stage'

})(jQuery, AdobeEdge, "EDGE-404308");