function addonloadevent(func) 
{
    var oldonload = window.onload;
    if (typeof window.onload != 'function') 
	{
     	func;
    } 
	else 
	{
       window.onload = function() {
           if (oldonload) {
                  oldonload()
          }
       	 func;
       }
   }
} 
function wrk_opener_reload()
{   
	if(window.opener.location.hash == '' || window.opener.location.hash == '#')
		window.opener.location.reload();
	else
	{
		window.opener.location = 'index.cfm?fuseaction=' + window.opener.location.hash.replace("#","");
	}	
}
function wrk_opener_reload2()
{   
alert(window.opener.location.hash);
	if(window.opener.location.hash == '' || window.opener.location.hash == '#')
		window.opener.location.reload();
	else
	{
		window.opener.location = 'index.cfm?fuseaction=' + window.opener.location.hash.replace("#","");
	}	
}

function window_opener_reload()
{   
	window.close();
	window.opener.location.reload();
}