<CF_DATE tarih="attributes.aktif_gun">
<cfquery name="get_in_out" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		EMPLOYEE_DAILY_IN_OUT_MAILS 
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id# AND
		ACTION_DATE = #attributes.aktif_gun#
</cfquery>

<cfquery name="upd_in_out" datasource="#dsn#">
	UPDATE
		EMPLOYEE_DAILY_IN_OUT_MAILS 
	SET
		<cfif len(get_in_out.FIRST_READ_DATE)>
			LAST_READ_DATE = #now()#
		<cfelse>
			FIRST_READ_DATE = #now()#
		</cfif>
	WHERE 
		ROW_ID = #get_in_out.row_id#
</cfquery>

<cfquery name="get_protest" datasource="#dsn#">
	SELECT PROTEST_DETAIL FROM EMPLOYEE_DAILY_IN_OUT_PROTESTS WHERE EMPLOYEE_ID = #attributes.employee_id# AND ACTION_DATE = #attributes.aktif_gun#
</cfquery>

<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
	<cfform name="add_note" action="#request.self#?fuseaction=myhome.emptypopup_edit_daily_in_mail" method="post">
	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
	<tr class="color-list">
		<td height="35" class="headbold"><cf_get_lang dictionary_id='32320.PDKS Notu Gir'></td>
	</tr>
	<tr class="color-row" valign="top">
		<td>
			<table width="250">
				<tr>
					<td class="txtbold" width="75"><cf_get_lang dictionary_id='57490.Gün'></td>
					<td><input type="text" readonly name="aktif_gun" id="aktif_gun" value="<cfoutput>#dateformat(get_in_out.ACTION_DATE,dateformat_style)#</cfoutput>"></td>
				</tr>
				<tr>
					<td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				</tr>
				<tr>
					<td colspan="2">
						<textarea name="detail" id="detail" style="width:300px;height:60px;"><cfoutput>#get_protest.PROTEST_DETAIL#</cfoutput></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2"  style="text-align:right;">
						<cf_workcube_buttons is_upd='0'>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</cfform>
</table>
