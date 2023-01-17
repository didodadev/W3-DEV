<cfsetting showdebugoutput="no">
<!--- 
	Description :	prints html contents
	Parameters :	
		module		==> Module directory path name for page
		faction		==> fuseaction
	syntax1 :		#request.self#?fuseaction=objects.popup_send_print&module=<module name>&faction=<fuseaction>#page_code#
	Note1 :			For sub modules , we should  arrange 'module' that syntax : <parent file structure>/<child file structure>
	Note2 :			Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
	Note3 :			'#page_code#' statement is important at the end
	<cfsavecontent variable="cont">
		<cfmodule template="../../index.cfm" fuseaction="#attributes.module#.#attributes.faction#" popup_for_files='1'>
	</cfsavecontent>
--->

<style>
	@media print
	{    
		.no-print, .no-print *
		{
			display: none !important;
		}
	}

	.no-print, .no-print *
	{
		display: none !important;
	}
</style>
<cfset attributes.icerik = wrk_content_clear(attributes.icerik)> 
<cfif isdefined("attributes.trail") and attributes.trail eq 1>
	<cfsavecontent variable="logo"><cfinclude template="view_company_logo.cfm"></cfsavecontent>
	<cfsavecontent variable="address"><cfinclude template="view_company_info.cfm"></cfsavecontent>	
<cfelseif isdefined("attributes.is_logo") and attributes.is_logo eq 1>
	<cfsavecontent variable="logo"><cfinclude template="view_company_logo.cfm"></cfsavecontent>
</cfif>
<cfif isdefined('attributes.trail') and attributes.trail eq 1>
	<cfoutput>
	<table width="100%">
		<tr>
			<td><center>#logo#</center></td>
		</tr>
		<tr>
			<td><center>#attributes.icerik#</center></td>
		</tr>
		<tr>
			<td><center>#address#</center></td>
		</tr>
	</table>
	</cfoutput>
<cfelse>
	<cfif isdefined("attributes.is_logo") and attributes.is_logo eq 1>
		<cfoutput>
			<table width="100%">
				<tr>
					<td><center>#logo#</center></td>
				</tr>
				<tr>
					<td valign="top"><center>#attributes.icerik#</center></td>
				</tr>
			</table>
		</cfoutput>
	<cfelse>
		
		<cfoutput>#attributes.icerik#</cfoutput>
	</cfif>
</cfif>
<script type="text/javascript">
	function waitfor(){
	<cfif isDefined("attributes.is_pop") and (attributes.is_pop EQ 1)>
		window.opener.close();
	</cfif>	
		//window.close();
		}
		setTimeout("waitfor()",3000);
		window.print();
</script>
<cfset attributes.icerik = ''> 

