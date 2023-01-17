<cfsetting showdebugoutput="no">
<cfquery name="get_emp" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM	
		EMPLOYEES E,
		EMPLOYEES_IN_OUT EIO
	WHERE
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EIO.IN_OUT_ID = #attributes.in_out_id#
</cfquery>
<cfquery name="get_info" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEE_DAILY_IN_OUT_SHIFT
	WHERE
		IN_OUT_ID = #attributes.in_out_id# AND
		SAL_YEAR = #attributes.yil# AND
		SAL_MON = #attributes.ay# AND
		SAL_DAY = #attributes.gun# AND
		<cfif attributes.tip is 'ng'>
			DAY_OR_EXTRA_TIME = 0
		<cfelseif attributes.tip is 'ngfm'>
			DAY_OR_EXTRA_TIME = 1 AND
			DAY_TYPE IS NULL
		<cfelseif attributes.tip is 'htfm'>
			DAY_OR_EXTRA_TIME = 1 AND
			DAY_TYPE = 0
		<cfelseif attributes.tip is 'gtfm'>
			DAY_OR_EXTRA_TIME = 1 AND
			(DAY_TYPE = 2 OR DAY_TYPE = 1)
		<cfelseif attributes.tip is 'gcfm'>
			DAY_OR_EXTRA_TIME = 1 AND
			DAY_TYPE = 4
		</cfif>
</cfquery>
<cfif get_info.recordcount>
<table class="ajax_list">
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id="30368.Çalışan"></td>
		<td><cfoutput>#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#</cfoutput></td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id="57742.Tarih"></td>
		<td><cfoutput>#gun#/#ay#/#yil#</cfoutput></td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id="57800.İşlem Tipi"></td>
		<td>
			<cfif attributes.tip is 'ng'>
				<cfif not len(get_info.DAY_TYPE)>
					<cf_get_lang dictionary_id="31474.Normal Gün">
				<cfelseif get_info.DAY_TYPE eq 0>
					<cf_get_lang dictionary_id="58867.Hafta Tatili">
				<cfelseif get_info.DAY_TYPE eq 1>
					<cf_get_lang dictionary_id="29482.Genel Tatil">
				<cfelseif get_info.DAY_TYPE eq 2>
					<cf_get_lang dictionary_id="29482.Genel Tatil">/<cf_get_lang dictionary_id="58867.Hafta Tatili">
				</cfif>
			<cfelseif attributes.tip is 'ngfm'>
				<cf_get_lang dictionary_id="41003.Normal Gün Fazla Mesaisi">
			<cfelseif attributes.tip is 'htfm'>
				<cf_get_lang dictionary_id="41002.Hafta Tatili Fazla Mesaisi">
			<cfelseif attributes.tip is 'gtfm' and get_info.DAY_TYPE eq 1>
				<cf_get_lang dictionary_id="41001.Genel Tatil Fazla Mesaisi">
			<cfelseif attributes.tip is 'gtfm' and get_info.DAY_TYPE eq 2>
				<cf_get_lang dictionary_id="41000.Genel Tatil Hafta Tatili Fazla Mesaisi">
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id="29513.Süre"></td>
		<td>
			<cfset deger_ = get_info.row_minute>
			<cfset dk_ = deger_ mod 60>
			<cfset st_ = int(deger_/60)>
			<select name="shift_hour" id="shift_hour">
				<cfoutput>
				<cfloop from="0" to="23" index="ccm">
					<option value="#ccm#"<cfif ccm eq st_>selected</cfif>>#ccm#</option>
				</cfloop>
				</cfoutput>
			</select>
			<select name="shift_minute" id="shift_minute">
				<cfoutput>
				<cfloop from="0" to="59" index="ccm">
					<option value="#ccm#" <cfif ccm eq dk_>selected</cfif>>#ccm#</option>
				</cfloop>
				</cfoutput>
			</select>
		</td>
	</tr>
	<cfif attributes.upd_status eq 1>
	<tr>
		<td colspan="2" style="color:red;"><cf_get_lang dictionary_id="29724.Güncellendi">!</td>
	</tr>
	</cfif>
	<tr>
		<td colspan="2" style="text-align:right;"><input type="button" value="Kaydet" onclick="update_shift_info();" /></td>
	</tr>
</table>
<script>
function update_shift_info()
{
	upd_adress_ = '<cfoutput>#request.self#?fuseaction=hr.upd_shift_info</cfoutput>';
	
	upd_adress_ += '&row_id=';
	upd_adress_ += '<cfoutput>#get_info.row_id#</cfoutput>';
	
	upd_adress_ += '&shift_hour=';
	upd_adress_ += document.getElementById('shift_hour').value;
	
	upd_adress_ += '&shift_minute=';
	upd_adress_ += document.getElementById('shift_minute').value;
	
	upd_adress_ += '&in_out_id=<cfoutput>#attributes.in_out_id#</cfoutput>';
	
	upd_adress_ += '&gun=<cfoutput>#attributes.gun#</cfoutput>';
	
	upd_adress_ += '&ay=<cfoutput>#attributes.ay#</cfoutput>';
	
	upd_adress_ += '&yil=<cfoutput>#attributes.yil#</cfoutput>';
	
	upd_adress_ += '&tip=<cfoutput>#attributes.tip#</cfoutput>';
	
	AjaxPageLoad(upd_adress_,'body_shift_div',1);
}
</script>
<cfelse>
	<cf_get_lang dictionary_id="40999.Bu Tarihe Ait Kayıt Bulunamadı">
</cfif>
