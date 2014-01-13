/**
 * Adobe Edge: symbol definitions
 */
(function($, Edge, compId){
//images folder
var im='images/';

var fonts = {};


var resources = [
];
var symbols = {
"stage": {
   version: "2.0.1",
   minimumCompatibleVersion: "2.0.0",
   build: "2.0.1.268",
   baseState: "Base State",
   initialState: "Base State",
   gpuAccelerate: false,
   resizeInstances: false,
   content: {
         dom: [
         {
            id:'Rectangle',
            type:'rect',
            rect:['0px','0px','1920px','1080px','auto','auto'],
            fill:["rgba(0,0,0,1.00)"],
            stroke:[0,"rgba(0,0,0,1)","none"]
         },
         {
            id:'But_ALPHA',
            type:'image',
            rect:['-574px','-159px','2374px','1994px','auto','auto'],
            fill:["rgba(0,0,0,0)",'Medias/But_ALPHA.png','0px','0px'],
            transform:[[],['-9']]
         },
         {
            id:'Logo_AiglesALPHA',
            type:'image',
            rect:['638px','-1000px','1643px','925px','auto','auto'],
            fill:["rgba(0,0,0,0)",'Medias/Logo%20AiglesALPHA.png','0px','0px'],
            transform:[[],['15']]
         },
         {
            id:'Text5',
            type:'text',
            rect:['586px','495px','691px','208px','auto','auto'],
            text:"Click anywhere<br>to start animation",
            align:"center",
            font:['Arial, Helvetica, sans-serif',53,"rgba(255,255,255,1)","normal","none","normal"]
         }],
         symbolInstances: [

         ]
      },
   states: {
      "Base State": {
         "${_Logo_AiglesALPHA}": [
            ["style", "top", '-1256px'],
            ["transform", "rotateZ", '21deg'],
            ["style", "height", '1116px'],
            ["style", "left", '696px'],
            ["style", "width", '1855px']
         ],
         "${_Text4}": [
            ["style", "left", '503px'],
            ["style", "top", '339px']
         ],
         "${_Stage}": [
            ["color", "background-color", 'rgba(255,255,255,1)'],
            ["style", "width", '1920px'],
            ["style", "height", '1080px'],
            ["style", "overflow", 'hidden']
         ],
         "${_Rectangle}": [
            ["style", "top", '0px'],
            ["style", "height", '1080px'],
            ["color", "background-color", 'rgba(0,0,0,1.00)'],
            ["style", "left", '0px'],
            ["style", "width", '1920px']
         ],
         "${_Text5}": [
            ["style", "top", '495px'],
            ["style", "height", '208px'],
            ["style", "opacity", '1'],
            ["style", "left", '586px'],
            ["style", "width", '691px']
         ],
         "${_But_ALPHA}": [
            ["style", "top", '-417px'],
            ["style", "overflow", 'visible'],
            ["transform", "rotateZ", '-29deg'],
            ["style", "height", '1996px'],
            ["style", "opacity", '0'],
            ["style", "left", '-292px'],
            ["style", "width", '2393px']
         ]
      }
   },
   timelines: {
      "Default Timeline": {
         fromState: "Base State",
         toState: "",
         duration: 17065,
         autoPlay: false,
         labels: {
            "Preroll": 9000,
            "Loop": 10000
         },
         timeline: [
            { id: "eid154", tween: [ "style", "${_But_ALPHA}", "top", '-291px', { fromValue: '-417px'}], position: 9500, duration: 500 },
            { id: "eid110", tween: [ "style", "${_But_ALPHA}", "top", '74px', { fromValue: '-291px'}], position: 10000, duration: 1405 },
            { id: "eid111", tween: [ "style", "${_But_ALPHA}", "top", '48px', { fromValue: '74px'}], position: 11405, duration: 639 },
            { id: "eid112", tween: [ "style", "${_But_ALPHA}", "top", '367px', { fromValue: '48px'}], position: 12044, duration: 1159 },
            { id: "eid113", tween: [ "style", "${_But_ALPHA}", "top", '415px', { fromValue: '367px'}], position: 13203, duration: 238 },
            { id: "eid114", tween: [ "style", "${_But_ALPHA}", "top", '35px', { fromValue: '415px'}], position: 13441, duration: 1226 },
            { id: "eid115", tween: [ "style", "${_But_ALPHA}", "top", '238px', { fromValue: '35px'}], position: 14667, duration: 935 },
            { id: "eid116", tween: [ "style", "${_But_ALPHA}", "top", '-291px', { fromValue: '238px'}], position: 15602, duration: 938 },
            { id: "eid117", tween: [ "style", "${_But_ALPHA}", "top", '-291px', { fromValue: '-291px'}], position: 17065, duration: 0 },
            { id: "eid152", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '-17deg', { fromValue: '-29deg'}], position: 9500, duration: 500 },
            { id: "eid118", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '33deg', { fromValue: '-17deg'}], position: 10000, duration: 1405 },
            { id: "eid119", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '52deg', { fromValue: '33deg'}], position: 11405, duration: 639 },
            { id: "eid120", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '-11deg', { fromValue: '52deg'}], position: 12044, duration: 1159 },
            { id: "eid121", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '15deg', { fromValue: '-11deg'}], position: 13203, duration: 238 },
            { id: "eid122", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '52deg', { fromValue: '15deg'}], position: 13441, duration: 1226 },
            { id: "eid123", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '-36deg', { fromValue: '52deg'}], position: 14667, duration: 935 },
            { id: "eid124", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '26deg', { fromValue: '-36deg'}], position: 15602, duration: 938 },
            { id: "eid125", tween: [ "transform", "${_But_ALPHA}", "rotateZ", '-17deg', { fromValue: '26deg'}], position: 16540, duration: 525 },
            { id: "eid156", tween: [ "style", "${_But_ALPHA}", "width", '2270px', { fromValue: '2393px'}], position: 9500, duration: 500 },
            { id: "eid142", tween: [ "style", "${_But_ALPHA}", "width", '1241px', { fromValue: '2270px'}], position: 10000, duration: 1405 },
            { id: "eid143", tween: [ "style", "${_But_ALPHA}", "width", '1395px', { fromValue: '1241px'}], position: 11405, duration: 639 },
            { id: "eid144", tween: [ "style", "${_But_ALPHA}", "width", '916px', { fromValue: '1395px'}], position: 12044, duration: 1159 },
            { id: "eid145", tween: [ "style", "${_But_ALPHA}", "width", '859px', { fromValue: '916px'}], position: 13203, duration: 238 },
            { id: "eid146", tween: [ "style", "${_But_ALPHA}", "width", '1394px', { fromValue: '859px'}], position: 13441, duration: 1226 },
            { id: "eid147", tween: [ "style", "${_But_ALPHA}", "width", '1013px', { fromValue: '1394px'}], position: 14667, duration: 935 },
            { id: "eid148", tween: [ "style", "${_But_ALPHA}", "width", '1206px', { fromValue: '1013px'}], position: 15602, duration: 938 },
            { id: "eid149", tween: [ "style", "${_But_ALPHA}", "width", '2270px', { fromValue: '1206px'}], position: 16540, duration: 525 },
            { id: "eid206", tween: [ "style", "${_Logo_AiglesALPHA}", "top", '409px', { fromValue: '-1256px'}], position: 13000, duration: 1424 },
            { id: "eid214", tween: [ "style", "${_Logo_AiglesALPHA}", "top", '32px', { fromValue: '409px'}], position: 14424, duration: 936 },
            { id: "eid220", tween: [ "style", "${_Logo_AiglesALPHA}", "top", '25px', { fromValue: '32px'}], position: 15360, duration: 450 },
            { id: "eid224", tween: [ "style", "${_Logo_AiglesALPHA}", "top", '82px', { fromValue: '25px'}], position: 15810, duration: 941 },
            { id: "eid229", tween: [ "style", "${_Logo_AiglesALPHA}", "top", '-1209px', { fromValue: '82px'}], position: 16751, duration: 314 },
            { id: "eid155", tween: [ "style", "${_But_ALPHA}", "left", '-260px', { fromValue: '-292px'}], position: 9500, duration: 500 },
            { id: "eid134", tween: [ "style", "${_But_ALPHA}", "left", '442px', { fromValue: '-260px'}], position: 10000, duration: 1405 },
            { id: "eid135", tween: [ "style", "${_But_ALPHA}", "left", '124px', { fromValue: '442px'}], position: 11405, duration: 639 },
            { id: "eid136", tween: [ "style", "${_But_ALPHA}", "left", '944px', { fromValue: '124px'}], position: 12044, duration: 1159 },
            { id: "eid137", tween: [ "style", "${_But_ALPHA}", "left", '1095px', { fromValue: '944px'}], position: 13203, duration: 238 },
            { id: "eid138", tween: [ "style", "${_But_ALPHA}", "left", '296px', { fromValue: '1095px'}], position: 13441, duration: 1226 },
            { id: "eid139", tween: [ "style", "${_But_ALPHA}", "left", '739px', { fromValue: '296px'}], position: 14667, duration: 935 },
            { id: "eid140", tween: [ "style", "${_But_ALPHA}", "left", '-260px', { fromValue: '739px'}], position: 15602, duration: 938 },
            { id: "eid141", tween: [ "style", "${_But_ALPHA}", "left", '-260px', { fromValue: '-260px'}], position: 17065, duration: 0 },
            { id: "eid210", tween: [ "style", "${_Logo_AiglesALPHA}", "height", '400px', { fromValue: '1116px'}], position: 13000, duration: 1424 },
            { id: "eid213", tween: [ "style", "${_Logo_AiglesALPHA}", "height", '654px', { fromValue: '400px'}], position: 14424, duration: 936 },
            { id: "eid219", tween: [ "style", "${_Logo_AiglesALPHA}", "height", '902px', { fromValue: '654px'}], position: 15360, duration: 450 },
            { id: "eid226", tween: [ "style", "${_Logo_AiglesALPHA}", "height", '941px', { fromValue: '902px'}], position: 15810, duration: 941 },
            { id: "eid230", tween: [ "style", "${_Logo_AiglesALPHA}", "height", '1060px', { fromValue: '941px'}], position: 16751, duration: 314 },
            { id: "eid158", tween: [ "style", "${_But_ALPHA}", "opacity", '1', { fromValue: '0'}], position: 9500, duration: 500 },
            { id: "eid211", tween: [ "style", "${_Logo_AiglesALPHA}", "width", '665px', { fromValue: '1855px'}], position: 13000, duration: 1424 },
            { id: "eid216", tween: [ "style", "${_Logo_AiglesALPHA}", "width", '1087px', { fromValue: '665px'}], position: 14424, duration: 936 },
            { id: "eid222", tween: [ "style", "${_Logo_AiglesALPHA}", "width", '1499px', { fromValue: '1087px'}], position: 15360, duration: 450 },
            { id: "eid227", tween: [ "style", "${_Logo_AiglesALPHA}", "width", '1564px', { fromValue: '1499px'}], position: 15810, duration: 941 },
            { id: "eid231", tween: [ "style", "${_Logo_AiglesALPHA}", "width", '1761px', { fromValue: '1564px'}], position: 16751, duration: 314 },
            { id: "eid153", tween: [ "style", "${_But_ALPHA}", "height", '1894px', { fromValue: '1996px'}], position: 9500, duration: 500 },
            { id: "eid126", tween: [ "style", "${_But_ALPHA}", "height", '1035px', { fromValue: '1894px'}], position: 10000, duration: 1405 },
            { id: "eid127", tween: [ "style", "${_But_ALPHA}", "height", '1009px', { fromValue: '1035px'}], position: 11405, duration: 639 },
            { id: "eid128", tween: [ "style", "${_But_ALPHA}", "height", '663px', { fromValue: '1009px'}], position: 12044, duration: 1159 },
            { id: "eid129", tween: [ "style", "${_But_ALPHA}", "height", '622px', { fromValue: '663px'}], position: 13203, duration: 238 },
            { id: "eid130", tween: [ "style", "${_But_ALPHA}", "height", '1010px', { fromValue: '622px'}], position: 13441, duration: 1226 },
            { id: "eid131", tween: [ "style", "${_But_ALPHA}", "height", '733px', { fromValue: '1010px'}], position: 14667, duration: 935 },
            { id: "eid132", tween: [ "style", "${_But_ALPHA}", "height", '873px', { fromValue: '733px'}], position: 15602, duration: 938 },
            { id: "eid133", tween: [ "style", "${_But_ALPHA}", "height", '1894px', { fromValue: '873px'}], position: 16540, duration: 525 },
            { id: "eid236", tween: [ "style", "${_Text5}", "opacity", '0', { fromValue: '1'}], position: 9000, duration: 500 },
            { id: "eid212", tween: [ "transform", "${_Logo_AiglesALPHA}", "rotateZ", '-14deg', { fromValue: '21deg'}], position: 13000, duration: 1424 },
            { id: "eid217", tween: [ "transform", "${_Logo_AiglesALPHA}", "rotateZ", '11deg', { fromValue: '-14deg'}], position: 14424, duration: 936 },
            { id: "eid218", tween: [ "transform", "${_Logo_AiglesALPHA}", "rotateZ", '0deg', { fromValue: '11deg'}], position: 15360, duration: 450 },
            { id: "eid225", tween: [ "transform", "${_Logo_AiglesALPHA}", "rotateZ", '1deg', { fromValue: '0deg'}], position: 15810, duration: 941 },
            { id: "eid232", tween: [ "transform", "${_Logo_AiglesALPHA}", "rotateZ", '17deg', { fromValue: '1deg'}], position: 16751, duration: 314 },
            { id: "eid205", tween: [ "style", "${_Logo_AiglesALPHA}", "left", '149px', { fromValue: '696px'}], position: 13000, duration: 1424 },
            { id: "eid215", tween: [ "style", "${_Logo_AiglesALPHA}", "left", '501px', { fromValue: '149px'}], position: 14424, duration: 936 },
            { id: "eid221", tween: [ "style", "${_Logo_AiglesALPHA}", "left", '187px', { fromValue: '501px'}], position: 15360, duration: 450 },
            { id: "eid223", tween: [ "style", "${_Logo_AiglesALPHA}", "left", '192px', { fromValue: '187px'}], position: 15810, duration: 941 },
            { id: "eid228", tween: [ "style", "${_Logo_AiglesALPHA}", "left", '619px', { fromValue: '192px'}], position: 16751, duration: 314 }         ]
      }
   }
}
};


Edge.registerCompositionDefn(compId, symbols, fonts, resources);

/**
 * Adobe Edge DOM Ready Event Handler
 */
$(window).ready(function() {
     Edge.launchComposition(compId);
});
})(jQuery, AdobeEdge, "EDGE-404308");
