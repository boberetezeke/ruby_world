function periodic_updater(url, div_id, period, ending_status, spinner_id) {
  //console.log("url is")
  //console.log(url)
  //console.log("div_id is")
  //console.log(div_id)

  return function() {
    new PeriodicalExecuter(
      function(pe) {
        //console.log("PeriodicalExecuter function: begin")
        $(spinner_id).show();
        new Ajax.Request(
          url, {
            method: 'get',
            onSuccess: function(transport) {
              //console.log("Ajax.Request: onSuccess")
              //r = transport.responseJSON;

              r = eval( '(' + transport.responseText + ')' )
              status = r['status'];
              html = r['html'];

              //console.log("status:" + status)
              ////console.log("html:" + html)

              $(div_id).innerHTML = html;
              if (status == ending_status) {
                $(spinner_id).hide();
                //console.log("Ajax.Request: stopping updates")
                pe.stop();
              }
            } // end onSuccess function
          } // end options hash
        ) // new Ajax.Request()
      }, period
    ) // new Ajax.PeriodicUpdater()
  } // anonymous function
} // periodic_updater
