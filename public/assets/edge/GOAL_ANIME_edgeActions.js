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
      Symbol.bindTriggerAction(compId, symbolName, "Default Timeline", 17065, function(sym, e) {
         // play the timeline from the given position (ms or label)
         sym.play("Loop");
      });
      //Edge binding end
   })("stage");
   //Edge symbol end:'stage'

})(jQuery, AdobeEdge, "EDGE-404308");
