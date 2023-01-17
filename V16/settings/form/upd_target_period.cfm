<cfquery name="GET_TARGET_PERIOD" datasource="#DSN#">
	SELECT 
	    TARGET_PERIOD_ID, 
        TARGET_PERIOD, 
        COEFFICIENT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP,
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_TARGET_PERIOD 
    WHERE 
	    TARGET_PERIOD_ID = #url.id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
		<td class="headbold"><cf_get_lang_main no='52.Guncelle'><cf_get_lang no='1277.Hedef Dönem'></td>
		<td align="right" class="headbold" style="text-align:right;">
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_crm_contracts_history&id=#url.id#&target_period=1</cfoutput>','list','popup_customer_type_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_target_period"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
		</td>
  	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_target_period.cfm"></td>
		<td valign="top">
		<table>
		<cfform name="upd_target_period" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_target_period">
			<input type="hidden" name="target_period_id" id="target_period_id" value="<cfoutput>#url.id#</cfoutput>">
			<input type="hidden" name="old_target_period" id="old_target_period" value="<cfoutput>#get_target_period.target_period#</cfoutput>">
			<input type="hidden" name="old_detail" id="old_detail" value="<cfoutput>#get_target_period.detail#</cfoutput>">
			<input type="hidden" name="old_coefficient" id="old_coefficient" value="<cfoutput>#get_target_period.coefficient#</cfoutput>">			
			<tr>
				<td width="100"><cf_get_lang_main no='1060.Dönem'>*</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no ='1878.Dönem Girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="target_period" value="#get_target_period.target_period#" maxlength="25" required="Yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='1698 .Ay Katsayısı'>*</td>
				<td>
					<select name="coefficient" id="coefficient" style="width:150px;">
						<option value=""><cf_get_lang_main no='322.Seciniz'></option>
						<option value="1" <cfif get_target_period.coefficient eq 1> selected</cfif>>1</option>
						<option value="3" <cfif get_target_period.coefficient eq 3> selected</cfif>>3</option>
						<option value="6" <cfif get_target_period.coefficient eq 6> selected</cfif>>6</option>
						<option value="9" <cfif get_target_period.coefficient eq 9> selected</cfif>>9</option>
						<option value="12" <cfif get_target_period.coefficient eq 12> selected</cfif>>12</option>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:150px;height:60px;"><cfoutput>#get_target_period.detail#</cfoutput></textarea></td>
			</tr>			
			<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
			</tr>
			<tr>
				<td colspan="2">
					<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_target_period.record_emp,0,0)# - #dateformat(get_target_period.record_date,dateformat_style)#<br/>
					<cfif len(get_target_period.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_target_period.update_emp,0,0)# - #dateformat(get_target_period.update_date,dateformat_style)#
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
	if(document.upd_target_period.detail.value.length>100)
	{
		alert("<cf_get_lang no ='1792.Açıklama 100 Karakterden Uzun Olamaz'>!");
		return false;
	}
	
	if(document.upd_target_period.coefficient.value=="")
	{
		alert("<cf_get_lang no ='1879.Ay Katsayısı Seçmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
