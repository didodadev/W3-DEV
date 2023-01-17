<cfsetting showdebugoutput="no">
<!---
	Description	:	convert html pages to xls,do,csv,sxw formats
	Parameters	:	none
	syntax1		:	#request.self#?fuseaction=objects.popup_documenter
	Note1		:	Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
--->
<cfparam name="attributes.printSa" default="0">
<cfif attributes.printSa eq "1">
<div id="printHeaderContent">
	<style>body{background:white;}
	.printHeader img { height: 120px;}
	</style>
	<div class="printHeader" style="text-align:center;">
		<cfinclude template="view_company_logo.cfm">
	</div>
</div>
<div id="printFooterContent">
	<div class="printFooter" style="padding-top:10px; text-align:center;">
		<cfinclude template="view_company_info.cfm"> 
	</div>
</div>
<cfelse>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29740.Yazıcıya Gönder'></cfsavecontent>
	<cf_popup_box title="#message#">
		<table>
			<tr>
				<td>
				<form name="process" action="<cfoutput>#request.self#?fuseaction=objects.popup_send_print_action</cfoutput>" method="post">
					<!---<textarea name="icerik" style="width:450px;height:250px;"></textarea>--->
					<input type="hidden" name="icerik" id="icerik" value="">
				<cfif isdefined("attributes.no_display") and attributes.no_display eq 1>
					<input type="hidden" name="no_display" id="no_display" value="1">
				</cfif>
				<cfif isdefined("attributes.trail") and attributes.trail>
					<input type="hidden" name="trail" id="trail" value="1">
				<cfelse>
					<input type="hidden" name="trail" id="trail" value="0">
				</cfif>
				<cfif isdefined("attributes.is_logo") and attributes.is_logo>
					<input type="hidden" name="is_logo" id="is_logo" value="1">
				<cfelse>
					<input type="hidden" name="is_logo" id="is_logo" value="0">
				</cfif>
				<cfif isdefined("attributes.show_datetime") and attributes.show_datetime>
					<input type="hidden" name="show_datetime" id="show_datetime" value="1">
				<cfelse>
					<input type="hidden" name="show_datetime" id="show_datetime" value="0">
				</cfif>
				<table>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id="29820.Yazıcıya Gonderiliyor"></td>
					</tr> 
				</table>
				</form>
				</td>
			</tr>
		</table>
	</cf_popup_box>
	<script type="text/javascript">
		console.log(document.process.icerik);
</script>

</cfif>
