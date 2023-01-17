<cfquery name="GET_MAIN_LOCATION_CAT" datasource="#DSN#">
	SELECT 
	    MAIN_LOCATION_CAT_ID, 
        MAIN_LOCATION_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_MAIN_LOCATION_CAT 
    WHERE 
	    MAIN_LOCATION_CAT_ID = #url.id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
		<td class="headbold"><cf_get_lang no='1620.Ana Konum'> <cf_get_lang no='1624.Kategorisi'> <cf_get_lang_main no='52.Guncelle'></td>
		<td align="right" class="headbold" style="text-align:right;">
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_crm_contracts_history&id=#url.id#&main_location_cat=1</cfoutput>','list','popup_customer_type_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_main_location_cat"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
		</td>
  	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_main_location_cat.cfm"></td>
		<td valign="top">
		<table>
		<cfform name="upd_main_location_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_main_location_cat">
		<input type="hidden" name="main_location_cat_id" id="main_location_cat_id" value="<cfoutput>#url.id#</cfoutput>">
		<input type="hidden" name="old_main_location_cat" id="old_main_location_cat" value="<cfoutput>#get_main_location_cat.main_location_cat#</cfoutput>">
		<input type="hidden" name="old_detail" id="old_detail" value="<cfoutput>#get_main_location_cat.detail#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang_main no='74.Kategori'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="main_location_cat" value="#get_main_location_cat.main_location_cat#" maxlength="25" required="Yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:150px;height:60px;"><cfoutput>#get_main_location_cat.detail#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
			</tr>
			<tr>
				<td colspan="2">
					<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_main_location_cat.record_emp,0,0)# - #dateformat(get_main_location_cat.record_date,dateformat_style)#<br/>
					<cfif len(get_main_location_cat.update_emp)>
						<cf_get_lang_main no='291.Güncelleyen'> : #get_emp_info(get_main_location_cat.update_emp,0,0)# - #dateformat(get_main_location_cat.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				</td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function kontrol()
{
	if(document.upd_main_location_cat.detail.value.length>100)
	{
		alert("<cf_get_lang no ='1792.Açıklama 100 Karakterden Uzun Olamaz'> !");
		return false;
	}
	return true;
}
</script>
