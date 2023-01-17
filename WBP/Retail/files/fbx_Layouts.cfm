<cfscript>
	if (isdefined("session.ep.userid") and fusebox.circuit is "extra") fusebox.layoutFile = "display/layout_extra.cfm";
	else fusebox.layoutFile = "";
 </cfscript>