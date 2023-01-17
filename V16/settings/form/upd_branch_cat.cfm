<cfquery name="GET_BRANCH_CAT" datasource="#DSN#">
	SELECT 
    	BRANCH_CAT_ID, 
        BRANCH_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_BRANCH_CAT 
    WHERE 
	    BRANCH_CAT_ID = #url.id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
		<td class="headbold"><cf_get_lang no ='2414.Şube Tipi Güncelle '></td>
  	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_branch_cat.cfm"></td>
		<td valign="top">
		<table>
		<cfform name="upd_branch_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_branch_cat">
		<input type="hidden" name="branch_cat_id" id="branch_cat_id" value="<cfoutput>#url.id#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang_main no='218.Tip'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no ='1755.Tip Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="branch_cat" value="#get_branch_cat.branch_cat#" maxlength="25" required="Yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:150px;height:60px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfoutput>#get_branch_cat.detail#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
			</tr>
			<tr>
				<td colspan="2">
					<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_branch_cat.record_emp,0,0)# - #dateformat(get_branch_cat.record_date,dateformat_style)#<br/>
					<cfif len(get_branch_cat.update_emp)>
						<cf_get_lang_main no='291.Güncelleyen'> : #get_emp_info(get_branch_cat.update_emp,0,0)# - #dateformat(get_branch_cat.update_date,dateformat_style)#
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
	if(document.upd_branch_cat.detail.value.length>100)
	{
		alert("<cf_get_lang no ='1792.Açıklama 100 Karakterden Uzun Olamaz'> !");
		return false;
	}
	return true;
}
</script>
