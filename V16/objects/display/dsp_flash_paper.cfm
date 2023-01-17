<cfsetting showdebugoutput="no">
<!---
Description :
   convert html pages to xls,do,csv,sxw formats
Parameters : none
syntax1 : #request.self#?fuseaction=objects.popup_documenter
Note1 : Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
--->
<!-- sil -->
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr class="color-border">
		<td>
		<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
			<tr height="35" class="color-list">
				<td class="headbold">Flash Paper Yap</td>
			</tr>
			<tr valign="top" class="color-row">
				<td>
				<form name="process" id="process" action="<cfoutput>#request.self#?fuseaction=objects.popup_send_flash_paper_action</cfoutput>" method="post">
				<input type="hidden" name="icerik" id="icerik" value="">
				<cfif isdefined("attributes.trail") and attributes.trail>
					<input type="hidden" name="trail" id="trail" value="1">
				<cfelse>
					<input type="hidden" name="trail" id="trail" value="0">
				</cfif>			
				<table>
					<tr>
						<td></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='60062.Print Et'></cfsavecontent>
							<cf_workcube_buttons is_upd='0' is_cancel='0' insert_alert='' insert_info='#message#'>
						</td>
					</tr> 
				</table>		
				</form>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<!-- sil -->
<script type="text/javascript">
if(findObj("<cfoutput>#attributes.module#</cfoutput>",opener.document))
{
	process.icerik.value = window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML;
}
else
	process.icerik.value = window.opener.document.body.innerHTML;
	process.submit();
</script>
