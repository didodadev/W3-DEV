<cfquery name="GET_CONTROL_TYPE" datasource="#DSN3#">
	SELECT
		*
	FROM
		QUALITY_CONTROL_TYPE
</cfquery>

<cfquery name="GET_QUALITY_CONTROL_ROW_ID" datasource="#DSN3#">
	SELECT
		*
	FROM
		QUALITY_CONTROL_ROW
	WHERE	
		QUALITY_CONTROL_ROW_ID = #url.quality_control_row_id#
</cfquery>

<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  	<tr>
    	<td class="headbold"><cf_get_lang no='732.Kalite Kontrol Tipi Maddeleri'></td>
    	<td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_quality_type_variation"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td width="200"><cfinclude template="../display/list_quality_type_variation.cfm"></td>
	  	<td>
		<table border="0">
		<cfform action="#request.self#?fuseaction=settings.emptypopup_upd_quality_type_variation" method="post" name="upd_quality_type_variation">
		<input type="hidden" name="id" id="id" value="<cfoutput>#url.quality_control_row_id#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang_main no='74.Kontrol Tipi'><font color=black>*</font></td>
			  	<td>
					<select name="quality_control_type_id" id="quality_control_type_id" style="width:150;">
				  	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				  	<cfoutput query="get_control_type">
				  		<option value="#type_id#" <cfif type_id eq get_quality_control_row_id.quality_control_type_id>selected</cfif>>#quality_control_type#</option>
				  	</cfoutput>
					</select>
			  	</td>
			  </tr>
			  <tr>
			  	<td><cf_get_lang_main no='68.Başlık'><font color=black>*</font></td>
			  	<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık Girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="quality_control_row" style="width:150px;" value="#get_quality_control_row_id.quality_control_row#" maxlength="20" required="Yes" message="#message#">
			  	</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1646.Tolarans'></td>
				<td>
					<cfif len(get_quality_control_row_id.tolerance)>
						<cfinput type="Text" name="tolerance" style="width:150px;" value="#get_quality_control_row_id.tolerance#" maxlength="20">
					<cfelse>
						<cfinput type="Text" name="tolerance" style="width:150px;" value="" maxlength="20">
					</cfif>
				</td>
			</tr>
			<tr height="35">
            	<td>
			  	<td>
			  		<cf_workcube_buttons 
				  	is_upd='1' 
					add_function='control()'
					delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_quality_type_variation&id=#url.quality_control_row_id#'>
			  	</td>
			</tr>
			<tr>
				<td colspan="2"><p><br/>
				<cfoutput>
				<cfif len(get_quality_control_row_id.record_emp)>
					<cf_get_lang_main no='71.Kayit'> : #get_emp_info(get_quality_control_row_id.record_emp,0,0)# - #dateformat(get_quality_control_row_id.RECORD_DATE,dateformat_style)#
				</cfif><br/>
				<cfif len(get_quality_control_row_id.update_emp)>
					<cf_get_lang_main no='291.Son Gncelleme'> : #get_emp_info(get_quality_control_row_id.update_emp,0,0)# - #dateformat(get_quality_control_row_id.UPDATE_DATE,dateformat_style)#
				</cfif>
				</cfoutput>
				</td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>
<br />
<script type="text/javascript">
function control()
{
	x = document.upd_quality_type_variation.quality_control_type_id.selectedIndex;
	if (document.upd_quality_type_variation.quality_control_type_id[x].value == "")
	{ 
		alert ("<cf_get_lang no='1192.Kontrol Tipi Seçmediniz'> !");
		return false;
	}
	return true;
}
</script>
