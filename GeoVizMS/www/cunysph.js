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

   var legend = $("img.legend");
   $("ul.nav-tabs").click(function() {
      console.log($(this).find("li.active > a").attr('data-value'));
      if ($(this).find("li.active > a").attr("data-value") !== "about") {
         $(legend).hide();
      } else {
         $(legend).show();
      }
   });

}


