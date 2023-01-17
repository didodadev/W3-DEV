<cf_get_lang_set module_name="hr">
<!--- Yetki sorumluluklar ASK 20101112 --->
<cfquery name="GET_AUTHORITY" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_AUTHORITY WHERE AUTHORITY_ID = #attributes.action_id#
</cfquery>
<cfquery name="POSITIONCATEGORIES" datasource="#dsn#">
	SELECT * FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfquery name="GET_NAMES" datasource="#dsn#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS_AUTHORITY WHERE AUTHORITY_ID = #attributes.action_id#
</cfquery>

<table border="0" cellspacing="0" cellpadding="0" style="width:300mm;">
	<tr>
		<td style="width:3mm;" rowspan="40">&nbsp;</td>
		<td style="height:15mm;">&nbsp;</td>
	</tr>
	<tr align="center" style="height:15mm;" valign="top">
		<td class="txtbold"><big><cf_get_lang no="84.Yetki ve Sorumluluklar"></big></td>
	</tr>
	<tr valign="top">
		<td valign="top">
			<table border="0" cellspacing="0" cellpadding="2" width="100%">
				<cfoutput>
				<tr align="left">
					<td style="width:30mm;" class="txtbold"><cf_get_lang_main no='68.Konu'></td>
					<td>#GET_AUTHORITY.AUTHORITY_HEAD#</td>
				</tr>
				<tr>
					<td style="width:30mm;" class="txtbold" valign="top"><cf_get_lang_main no='359.Detay'></td>
					<td>#get_authority.AUTHORITY_DETAIL# </td>
				</tr>
				<tr>
					<td style="width:30mm;" class="txtbold" valign="top"><cf_get_lang_main no='367.Pozisyon Tipleri'></td>
						<cfset pos_cat_list=''>
						<cfloop query="GET_NAMES">
							<cfif LEN(pos_cat_list)>
								<cfset pos_cat_list='#pos_cat_list#,#POSITION_CAT_ID#'>
							<cfelse>
								<cfset pos_cat_list='#POSITION_CAT_ID#'>
							</cfif>
						</cfloop><cfdump var="#pos_cat_list#"><cfabort>
					<td>
					<cfif positionCategories.recordcount>
						<cfloop query="positionCategories">
							<cfif Listfind(pos_cat_list,POSITION_CAT_ID)>#position_cat#<cfif Listlast(pos_cat_list,',') neq POSITION_CAT_ID>,<cfelse>.</cfif></cfif>
						</cfloop>
					</cfif>
					</td>
				</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<table>
				<tr>
					<td colspan="2"class="txtbold">
						<cf_get_lang_main no='71.Kayıt'>: <cfoutput>#get_emp_info(get_authority.record_member,0,0)# - #dateformat(get_authority.record_date,dateformat_style)#</cfoutput>
						<cfif len(get_authority.update_member)>
							<br/><cf_get_lang_main no='291.Güncelleme'>: <cfoutput>#get_emp_info(get_authority.update_member,0,0)# - #dateformat(get_authority.update_date,dateformat_style)#</cfoutput>
						</cfif>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
