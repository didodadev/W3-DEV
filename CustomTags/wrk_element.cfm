<!---
Created by PY 1019
Description :
   returns a string masked

Parameters :
	mask_type ==> 1:Converts data into a single expression
	output ==> Output Text Exit  
	value ==> 
	GDPR_type   ==> 
	static ==>  
Syntax :
   <cf_wrk_element mask_type="1" value="#value#" static="#phrase#" output = "Output_Text">
--->
<cfparam name="attributes.value" default="">
<cfparam name="attributes.mask_type" default="1">
<cfparam name="attributes.output" default="">
<cfparam name="attributes.static" default="">
<cfparam name="attributes.GDPR_type" default="">
<cfscript>
	if(attributes.mask_type == 1){
		sendedValue = attributes.static;
		if(len(attributes.output))
		"caller.#attributes.output#" = sendedValue;
		else
		writeoutput(sendedValue);
	}
</cfscript>