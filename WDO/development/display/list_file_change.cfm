<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.page" default="1">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
	<cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif not isdefined("form_varmi")>
	<cfset attributes.start_date = date_add('d',-1,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif not isdefined("form_varmi")>
	<cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_files" datasource="fileaudit">
		SELECT
			FileName,
			EventTime,
			UserAccount,
			(SELECT COUNT(F2.RecordNumber) FROM FA_Events F2 WHERE F2.FileName = FA_Events.FileName) CHANGE_COUNT
		FROM
			FA_Events
		WHERE
			UserAccount <> 'ep'
			AND UserAccount <> 'administrator'
			AND RecordNumber = (SELECT MAX(F3.RecordNumber) FROM FA_Events F3 WHERE F3.FileName = FA_Events.FileName)
			<cfif len(attributes.keyword)>
				AND FileName LIKE '%#attributes.keyword#%'
			</cfif>
			<cfif len(attributes.emp_name)>
				AND UserAccount LIKE '%#attributes.emp_name#%'
			</cfif>
			<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
                AND EventTime BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
            <cfelseif isdate(attributes.start_date)>
                AND EventTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
            <cfelseif isdate(attributes.finish_date)>
                AND EventTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
            </cfif>
		ORDER BY
			EventTime DESC
	</cfquery>	
<cfelse>
	<cfset get_files.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_files.recordcount#'>
<cfform name="search_file" method="post" action="#request.self#?fuseaction=dev.list_file_change">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
	<cf_big_list_search title="Dosya Değişimleri">
		<cf_big_list_search_area>
			<table>
				<tr>
					<td>Dosya Adı</td>
					<td><cfinput type="text" name="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="50" message="Dosya Adı Girmelisiniz !"></td>
					<td>İşlemi Yapan</td>
					<td><cfinput type="text" name="emp_name" style="width:90px;" value="#attributes.emp_name#" maxlength="50"></td>
					<td>Tarih</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='326.başlama girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, 'dd/mm/yyyy')#"  style="width:65px;" validate="eurodate" required="yes" maxlength="10" message="#message#">
						<cf_wrk_date_image date_field="start_date">
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='327.bitiş tarihi girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, 'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" required="yes" message="#message#">			
						<cf_wrk_date_image date_field="finish_date">
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35">No</th>
			<th>Dosya Adı</th>
			<th style="text-align:right" width="150">Değişiklik Sayısı</th>
			<th>Son Değiştirilme Tarihi</th>
			<th>İşlemi Yapan</th>
		</tr>
	</thead>
	<tbody>
		<cfif get_files.recordcount>
			<cfoutput query="get_files" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr> 
					<td align="center" nowrap id="file_row#currentrow#" class="color-row" onClick="gizle_goster(file_row_detail#currentrow#);connectAjax('#currentrow#','#URLEncodedFormat(FileName)#');">
						#currentrow#
						<img id="file_goster#currentrow#" src="/images/listele.gif" title="<cf_get_lang_main no ='1184.Göster'>">
					</td>
					<td>#FileName#</td>
					<td style="text-align:right">#change_count#</td>
					<td>#dateformat(dateadd('h',session.ep.time_zone,EventTime),'DD/MM/YYYY')# #Timeformat(dateadd('h',session.ep.time_zone,EventTime),'HH:MM')#</td>
					<td>#UserAccount#</td>
				</tr>
				<!-- sil -->
				<tr id="file_row_detail#currentrow#" class="nohover" style="display:none">
					<td colspan="5">
						<div align="left" id="file_row_div#currentrow#"></div>
					</td>
				</tr>
				<!-- sil -->
			</cfoutput>
		<cfelse>
			<tr> 
				<td colspan="5" height="20"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	
			<cfset adres = 'dev.list_file_change'>
			<cfset adres = '#adres#&keyword=#URLEncodedFormat(attributes.keyword)#'>
			<cfset adres = '#adres#&emp_name=#URLEncodedFormat(attributes.emp_name)#'>
			<cfif isdate(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
			</cfif>
			<cfif isdate(attributes.finish_date)>
				<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
			</cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#&is_form_submitted=1">
		
</cfif>
<script language="javascript">
	function connectAjax(crtrow,file_name)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=dev.emptypopup_ajax_list_file_change_row</cfoutput>&file_name='+ file_name;
		AjaxPageLoad(bb,'file_row_div'+crtrow,1);
	}
</script>
