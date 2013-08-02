$(function() {
  var timeLoaded = Date.now();

  function to_hms(d) {
    d = Number(d);
    var h = Math.floor(d / 3600);
    var m = Math.floor(d % 3600 / 60);
    var s = Math.floor(d % 3600 % 60);
    return ((h > 0 ? h + "h" : "") + (m > 0 ? (h > 0 && m < 10 ? "0" : "") + m + "m" : "0m") + (s < 10 ? "0" : "") + s + "s");
  }

  if ($(".timer").length > 0) {
    setInterval(function() {
      $(".timer").each(function(index, elem) {
        var elapsed = Number($(elem).attr("data-elapsed-time")) + ((Date.now() - timeLoaded) / 1000);
        $(elem).text(to_hms(elapsed));
      });
    }, 1000);
  }
});
