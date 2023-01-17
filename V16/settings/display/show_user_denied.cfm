<cfquery name="get_pos_code" datasource="#DSN#">
SELECT 
	EPD.*,
	EP.EMPLOYEE_ID,
	EP.POSITION_NAME,
	EP.EMPLOYEE_NAME,
	EP.EMPLOYEE_SURNAME
FROM 
	EMPLOYEE_POSITIONS_DENIED EPD,
	EMPLOYEE_POSITIONS EP
WHERE 
	EPD.DENIED_PAGE = '#attributes.faction#' AND
	EPD.POSITION_CODE = EP.POSITION_CODE
</cfquery>
	<table cellpadding="0" cellspacing="0" width="98%" align="center">
		<tr>
			<td height="35" class="headbold"><cf_get_lang no='1611.Sayfa İçin Atanan Yetkiler'> : <cfoutput>#attributes.faction#</cfoutput></td>
		</tr>
	</table>
	<table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
	  <tr class="color-header">
		<td height="20" class="form-title" width="100"><cf_get_lang no='13.Pozisyonlar'></td>
		 <td class="form-title"><cf_get_lang_main no='1463.Çalışanlar'> </td>
		<td class="form-title" width="40"><cf_get_lang no='1312.Gör'></td>
		<td class="form-title" width="65"><cf_get_lang_main no='71.Kayıt'></td>
		<td class="form-title" width="40"><cf_get_lang_main no='51.Sil'></td>
	  </tr>
		<cfif get_pos_code.RECORDCOUNT>
			<cfoutput query="get_pos_code">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td height="20">#POSITION_NAME#</td>
					<td height="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
					<td><cfif IS_VIEW EQ 1><cfif DENIED_TYPE eq 1><cf_get_lang no='1312.Gör'><cfelse><cf_get_lang no='1316.Görme'></cfif></cfif></td>
					<td><cfif IS_INSERT EQ 1><cfif DENIED_TYPE eq 1><cf_get_lang_main no='49.Kayıt Yap'><cfelse><cf_get_lang_main no='704.Kayıt Yapma'></cfif></cfif></td>
					<td><cfif IS_DELETE EQ 1><cfif DENIED_TYPE eq 1><cf_get_lang_main no='51.Sil'><cfelse><cf_get_lang no='1317.Silme'></cfif></cfif></td>
				</tr>
			</cfoutput>
		</cfif>
	</table>
