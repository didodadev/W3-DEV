// JavaScript Document
function IEVersion_compatibility(){
	var _n=navigator,_w=window,_d=document;
	var version="NA";
	var na=_n.userAgent;
	var ieDocMode="NA";
	var ie8BrowserMode="NA";
	// Look for msie and make sure its not opera in disguise
	if(/msie/i.test(na) && (!_w.opera)){
		// also check for spoofers by checking known IE objects
		if(_w.attachEvent && _w.ActiveXObject){		
			// Get version displayed in UA although if its IE 8 running in 7 or compat mode it will appear as 7
			version = (na.match( /.+ie\s([\d.]+)/i ) || [])[1];
			// Its IE 8 pretending to be IE 7 or in compat mode		
			if(parseInt(version)==7){				
				// documentMode is only supported in IE 8 so we know if its here its really IE 8
				if(_d.documentMode){
					version = 8; //reset? change if you need to
					// IE in Compat mode will mention Trident in the useragent
					if(/trident\/\d/i.test(na)){
						document.getElementById('IE_compatibility').style.display = '';
					// if it doesn't then its running in IE 7 mode
					}
				}
			}
		}
	}
}