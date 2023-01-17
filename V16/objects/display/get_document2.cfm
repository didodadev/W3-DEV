<cfif isDefined("attributes.html_content")>
<cfsetting showdebugoutput="no">
<cfsetting enablecfoutputonly="Yes">
<!---
Description :
   convert html pages to xls,do,csv,sxw formats
Parameters :
	module       ==> Module directory path name for page
	file         ==> file name of the page

syntax1 : #request.self#?fuseaction=objects.popup_documenter&module=<module name>&file=<file name>#page_code#
sample1 : #request.self#?fuseaction=objects.popup_documenter&module=finance/ch&file=list_emps_extre#page_code#
Note1 : For sub modules , we should  arrange 'module' that syntax : <parent file structure>/<child file structure>
Note2 : Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
Note3 : '#page_code#' statement is important at the end
--->	
	<cfset cont = attributes.html_content>
	<cfset cont = wrk_content_clear(cont)>
	<cfif attributes.name eq ''>
		<cfset filename = "#createuuid()#">
	<cfelse>
		<cfset filename = "#attributes.name#">	
	</cfif>
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.#attributes.extension#">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfoutput>#trim(cont)#</cfoutput>
<cfsetting enablecfoutputonly="no">
<cfelse>
	<form method="post" name="send">
		<textarea name="html_content" id="html_content" style="display:none;"></textarea>
	</form>
	<script type="text/javascript">
		document.send.html_content.value = opener.send.html_content.value;
		document.send.submit();
	</script>
</cfif>
