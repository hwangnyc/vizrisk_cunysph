/*
 * This script performs some small functions for the vizrisk cunysph group
 * Created by: Cody Boppert
 * Date: 10/27/2014
 * */

window.onload = function() {
   $( window ).resize( function() {
      location.reload();
      window.location.href = window.location.href;
   });

   var geoChart = document.getElementById("geotab").children;
   console.log(geoChart);
}


