<cfquery name="GET_DUTY_UNIT_CAT" datasource="#DSN#">
	SELECT 
	    DUTY_UNIT_CAT_ID, 
        DUTY_UNIT_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_DUTY_UNIT_CAT 
    WHERE 
	    DUTY_UNIT_CAT_ID = #url.id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
		<td class="headbold"><cf_get_lang_main no='52.Guncelle'><cf_get_lang no='1625.Hizmet Birim'> <cf_get_lang no='1624.Kategorisi'> </td>
		<td align="right" class="headbold" style="text-align:right;">
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_crm_contracts_history&id=#url.id#&duty_unit_cat=1</cfoutput>','list','popup_customer_type_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_duty_unit_cat"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
		</td>
  	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_duty_unit_cat.cfm"></td>
		<td valign="top">
		<table>
		<cfform name="upd_duty_unit_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_duty_unit_cat">
			<input type="hidden" name="duty_unit_cat_id" id="duty_unit_cat_id" value="<cfoutput>#url.id#</cfoutput>">
			<input type="hidden" name="old_duty_unit_cat" id="old_duty_unit_cat" value="<cfoutput>#get_duty_unit_cat.duty_unit_cat#</cfoutput>">
			<input type="hidden" name="old_detail" id="old_detail" value="<cfoutput>#get_duty_unit_cat.detail#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang_main no='74.Kategori'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="duty_unit_cat" value="#get_duty_unit_cat.duty_unit_cat#" maxlength="25" required="Yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:150px;height:60px;"><cfoutput>#get_duty_unit_cat.detail#</cfoutput></textarea></td>
			</tr>			
			<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
			</tr>
			<tr>
				<td colspan="2">
					<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_duty_unit_cat.record_emp,0,0)# - #dateformat(get_duty_unit_cat.record_date,dateformat_style)#<br/>
					<cfif len(get_duty_unit_cat.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_duty_unit_cat.update_emp,0,0)# - #dateformat(get_duty_unit_cat.update_date,dateformat_style)#
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
	if(document.upd_duty_unit_cat.detail.value.length>100)
	{
		alert("Açıklama 100 Karakterden Uzun Olamaz !");
		return false;
	}
	return true;
}
</script>
