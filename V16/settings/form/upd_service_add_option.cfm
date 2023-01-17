<cfquery name="SERVICE_OPTIONS" datasource="#DSN3#">
	SELECT 
		SERVICE_ADD_OPTION_ID,
        SERVICE_ADD_OPTION_NAME,
        DETAIL,
        RECORD_DATE,
        RECORD_EMP,
        UPDATE_DATE,
        UPDATE_EMP
	FROM 
		SETUP_SERVICE_ADD_OPTIONS
	WHERE 
		SERVICE_ADD_OPTION_ID = #attributes.service_option_id#
</cfquery><table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
	<tr>
    	<td class="headbold">Servis Özel Tanımları</td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td width="200"><cfinclude template="../display/list_service_add_options.cfm"></td>
		<td>
		<table>
		<cfform name="add_service_option" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_service_add_option&service_option_id=#attributes.service_option_id#">
			<tr>
				<td width="100">Servis Özel Tanım *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='1092.Özel Tanım Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="add_option_name" maxlength="50" value="#SERVICE_OPTIONS.SERVICE_ADD_OPTION_NAME#" required="yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="add_option_detail" id="add_option_detail" style="width:150px;height:40px;"  maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250"><cfoutput>#SERVICE_OPTIONS.DETAIL#</cfoutput></textarea>
			</td>
			</tr>
			<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='0'></td>
			</tr>
            <tr>
				<td colspan="3"><p><br/>
					<cfoutput>
					<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(SERVICE_OPTIONS.RECORD_EMP,0,0)# - #dateformat(SERVICE_OPTIONS.RECORD_DATE,dateformat_style)#<br/>
					<cfif len(SERVICE_OPTIONS.UPDATE_EMP)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(SERVICE_OPTIONS.UPDATE_EMP,0,0)# - #dateformat(SERVICE_OPTIONS.UPDATE_DATE,dateformat_style)#
					</cfif>
					</cfoutput>
				</td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>
