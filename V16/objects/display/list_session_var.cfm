<cfif isdefined("lang_auto_control") and lang_auto_control eq 1>
	<br /><br />
	<a href="<cfoutput>#request.self#?fuseaction=home.emptypopup_set_lang_change_action</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='60133.Set Languages'></a>
</cfif>
<cfdump var="#GetHttpRequestData().headers#">
<cfif not workcube_mode>
	<br/>
	<H3 style="font-face:verdana,geneva;"><cf_get_lang dictionary_id='60134.Real IP'></H3>
	<cfif StructKeyExists(GetHttpRequestData().headers, "X-Forwarded-For")>
		   <cfset request.remote_addr = GetHttpRequestData().headers["X-Forwarded-For"]>
	<cfelse>
		   <cfset request.remote_addr = CGI.REMOTE_ADDR>
	</cfif>
<cfoutput>#request.remote_addr# using proxy : (#StructKeyExists(GetHttpRequestData().headers, "X-Forwarded-For")#)</cfoutput>
	<font face="Verdana,geneva" size="2">
	<H3 style="font-face:verdana,geneva;"><cf_get_lang dictionary_id='60135.Browser Info'></H3>
	<cfdump var="#browserdetect()#" expand="yes">
	
	<!---<font face="Verdana,geneva" size="2">
	<H3 style="font-face:verdana,geneva;">Application Variables</H3>
	<cfdump var="#application#" expand="yes">--->
	
	<font face="Verdana,geneva" size="2">
	<H3 style="font-face:verdana,geneva;"><cf_get_lang dictionary_id='60136.Session Variables'></H3>
	<cfdump var="#session#" expand="yes">
	<!--- 
	<font face="Verdana,geneva" size="2">
	<H3 style="font-face:verdana,geneva;">Fusebox Variables</H3>
	<cfdump var="#fusebox#" expand="yes"> --->
	
	<font face="Verdana,geneva" size="2">
	<H3 style="font-face:verdana,geneva;"><cf_get_lang dictionary_id='60137.Server Variables'></H3>
	<cfdump var="#server#" expand="yes">
	
	<font face="Verdana,geneva" size="2">
	<H3 style="font-face:verdana,geneva;"><cf_get_lang dictionary_id='60138.CGI Variables'></H3>
	<cfdump var="#cgi#" expand="yes">
	
	<font face="Verdana,geneva" size="2">
	<H3 style="font-face:verdana,geneva;"><cf_get_lang dictionary_id='60139.Java Variables'></H3>
	<cfset system = CreateObject("java", "java.lang.System")>
	<cfdump var="#system.getProperties()#">
	
	<!--- <font face="Verdana,geneva" size="2">
	<H3 style="font-face:verdana,geneva;">Variables</H3>
	<cfdump var="#variables#" expand="yes"> --->
</cfif>
