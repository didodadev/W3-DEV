<table border="0" cellspacing="0" cellpadding="0" align="center" height="35" width="98%">
	<tr>
		<td class="headbold">Fiziksel Hasar Ekle</td>
		<td style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_service_physical_damage"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row" valign="top">
		<td width="200">
			<cfquery name="GET_SERVICE_PHYSICAL_DAMAGE" datasource="#dsn3#">
				SELECT PHYSICAL_DAMAGE_ID,PHYSICAL_DAMAGE FROM SERVICE_PHYSICAL_DAMAGE
			</cfquery>
			<cfquery name="GET_PHYSICAL_DAMAGE" dbtype="query" >
				SELECT PHYSICAL_DAMAGE FROM GET_SERVICE_PHYSICAL_DAMAGE WHERE PHYSICAL_DAMAGE_ID = #attributes.phy_id#
			</cfquery>		
			<table width="200" cellpadding="0" cellspacing="0" border="0">
				<tr> 
					<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;Fiziksel Hasarlar</td>
				</tr>
				<cfif get_service_physical_damage.recordcount>
					<cfoutput query="get_service_physical_damage">
						<tr>
							<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
							<td width="180"><a href="#request.self#?fuseaction=settings.form_upd_service_physical_damage&phy_id=#physical_damage_id#" class="tableyazi">#physical_damage#</a></td>
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
				<cfform name="physical_damage" id="physical_damage" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_physical_damage&phy_id=#attributes.phy_id#">
					<tr>
						<td width="100">Fiziksel Hasar Adı *</td>
						<td>
							<cfsavecontent variable="message">Fiziksel Hasar Adı Girmelisiniz</cfsavecontent>
							<cfinput type="text" name="physical_damage_name" id="physical_damage_name" value="#get_physical_damage.physical_damage#" required="Yes" maxlength="150" size="60" message="#message#" style="width:150px;">
						</td>
					</tr>
					<tr height="35">
						<td colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons delete_page_url='#request.self#?fuseaction=settings.emptypopup_upd_physical_damage&phy_id=#attributes.phy_id#&del=1' is_upd='1' is_delete='1'></td>
					</tr>
				</cfform>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	document.getElementById('physical_damage_name').focus();
</script>
