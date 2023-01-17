<cfquery name="GET_EMP_SCHOOL" datasource="#DSN#" maxrows="1">
	SELECT
		EDU_ID
	FROM
		EMPLOYEES_APP_EDU_INFO
	WHERE
		EDU_ID = #attributes.id#
</cfquery>
<cfquery name="GET_PART" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_SCHOOL_PART
	WHERE 
		PART_ID = #url.id#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
    	<td height="35" class="headbold"><cf_get_lang no='16. Universite Bölümlu Guncelle'></td>
	    <td align="right" style="text-align:right;">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_school_part"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a>
		</td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
	<tr class="color-row">
    	<td width="200" valign="top"><cfinclude template="../display/list_school_part.cfm"></td>
		<td valign="top">
		<table>
		<cfform name="title" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_school_part">
		<input type="Hidden" name="part_id" id="part_id" value="<cfoutput>#url.id#</cfoutput>">
			<tr>
				<td width="100"><cf_get_lang_main no='68.Başlık'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="title" size="40" value="#get_part.part_name#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" cols="75" style="width:200px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfoutput>#get_part.detail#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td align="right"></td>
				<td align="right" height="35">
					<cfif get_emp_school.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0'> 
					<cfelse>
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_school_del_part&part_id=#url.id#'>
					</cfif>
				</td>
			</tr>
			<tr>
				<td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
					<cfoutput>
					<cfif len(get_part.record_emp)>
						#get_emp_info(get_part.record_emp,0,0)#
						#dateformat(get_part.record_date,dateformat_style)#
					</cfif>
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<cfoutput>
					<cfif len(get_part.update_emp)>
						<cf_get_lang_main no='479.Güncelleyen'> : 
							#get_emp_info(get_part.update_emp,0,0)#
							#dateformat(get_part.update_date,dateformat_style)#
					</cfif>
				</cfoutput>
				</td>
			</tr>
		</cfform>
		</table>
	    </td>
	</tr>
</table>
<br/>
