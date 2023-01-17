<table border="0" cellspacing="0" cellpadding="0" align="center" height="35" width="98%">
	<tr>
		<td class="headbold">Aksesuar Güncelleme</td>
		<td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_service_accessory"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" class="color-border" width="100%">
	<tr class="color-row" valign="top">
		<td width="200">
			<cfquery name="GET_SERVICE_ACCESSORY" datasource="#dsn3#">
				SELECT ACCESSORY_ID,ACCESSORY FROM SERVICE_ACCESSORY
			</cfquery>
			<cfquery name="SERVICE_ACC" dbtype="query">
				SELECT * FROM get_service_accessory WHERE ACCESSORY_ID = #attributes.acc_id#
			</cfquery>
			<table width="200" cellpadding="0" cellspacing="0" border="0">
				<tr> 
					<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;Servis Aksesuarları</td>
				</tr>
				<cfif get_service_accessory.recordcount>
					<cfoutput query="get_service_accessory">
						<tr>
							<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
							<td width="180"><a href="#request.self#?fuseaction=settings.form_upd_service_accessory&acc_id=#accessory_id#" class="tableyazi">#accessory#</a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
						<td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
					</tr>
				</cfif>
			</table>
		</td>
		<td>
			<table border="0">
				<cfform name="service_accessory" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_service_accessory&acc_id=#attributes.acc_id#">
					<tr>
						<td width="100">Aksesuar Adı *</td>
						<td>
							<cfsavecontent variable="message">Aksesuar Adı Girmelisiniz</cfsavecontent>
							<cfinput type="text" name="accessory_name" id="accessory_name" value="#service_acc.accessory#" required="Yes" maxlength="150" size="60" message="#message#" style="width:150px;">
						</td>
					</tr>
					<tr height="35">
						<td colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons delete_page_url='#request.self#?fuseaction=settings.emptypopup_upd_service_accessory&acc_id=#attributes.acc_id#&del=1' is_upd='1' is_delete='1'></td>
					</tr>
				</cfform>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	document.getElementById('accessory_name').focus();
</script>
