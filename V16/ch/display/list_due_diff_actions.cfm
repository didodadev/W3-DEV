<cfparam name="attributes.act_type" default="">
<cfparam name="attributes.listing_type" default="1">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = ''>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = ''>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_actions" datasource="#dsn2#">
		SELECT
			*
		FROM
			CARI_DUE_DIFF_ACTIONS
			<cfif attributes.listing_type eq 2>
				JOIN CARI_DUE_DIFF_ACTIONS_ROW CR ON CR.DUE_DIFF_ID = CARI_DUE_DIFF_ACTIONS.DUE_DIFF_ID 
			</cfif>
		WHERE
			1 = 1
			<cfif len(attributes.act_type)>
				AND ACTION_TYPE = #attributes.act_type#
			</cfif>
			<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
				AND ACTION_DATE >= #attributes.start_date#
			<cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
				AND ACTION_DATE <= #attributes.finish_date#
			<cfelseif isdate(attributes.start_date) and  isdate(attributes.finish_date)>
				AND ACTION_DATE >= #attributes.start_date#
				AND ACTION_DATE <= #attributes.finish_date#
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_actions.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_actions.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_actions" method="post" action="#request.self#?fuseaction=ch.list_due_diff_actions">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" placeholder="#getLang("","",58053)#" style="width:65px;" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" placeholder="#getLang("","",57700)#" style="width:65px;" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group" id="form_ul_listing_type">
					<select name="listing_type" id="listing_type">
						<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
						<option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="act_type" id="act_type">
						<option value=""><cf_get_lang dictionary_id='50016.Hareket Tipi'></option>
						<option value="1" <cfif attributes.act_type eq 1>selected</cfif>><cf_get_lang dictionary_id='50015.Cari Dekont'></option>
						<option value="2" <cfif attributes.act_type eq 2>selected</cfif>><cf_get_lang dictionary_id='50014.Sistem Ödeme Planı'></option>
						<option value="3" <cfif attributes.act_type eq 3>selected</cfif>><cf_get_lang dictionary_id='50012.Fatura Kontrol Satırı'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function="kontrol()" button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(67,'Vade Farkı İşlemleri',50040)#" uidrop="1" hide_table_column="1">
		<cf_grid_list sort="1">
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
					<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
					<th><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>
					<!-- sil -->
					<th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ch.list_due_diff_actions&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id="57582.Ekle">" title="<cf_get_lang dictionary_id="57582.Ekle">"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_actions.recordcount>
					<cfset record_emp_list = "">
					<cfoutput query="get_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(record_emp) and not listfind(record_emp_list, record_emp)>
							<cfset record_emp_list=listappend(record_emp_list, record_emp)>
						</cfif>
					</cfoutput>
					<cfif len(record_emp_list)>
						<cfset record_emp_list = listsort(record_emp_list,"numeric","ASC",",")>
						<cfquery name="get_record_detail" datasource="#dsn#">
							SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_record_detail.employee_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#dateformat(action_date,dateformat_style)#</td>
							<td><cfif action_type eq 1><cf_get_lang dictionary_id='50015.Cari Dekont'><cfelseif action_type eq 2><cf_get_lang dictionary_id='50014.Sistem Ödeme Planı'><cfelse><cf_get_lang dictionary_id='50012.Fatura Kontrol Satırı'></cfif></td>
							<td>
								<cfif len(record_emp)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">
										#get_record_detail.employee_name[listfind(record_emp_list,record_emp,',')]# #get_record_detail.employee_surname[listfind(record_emp_list,record_emp,',')]#
									</a>
								</cfif>
							</td>
							<!-- sil -->
							<td align="center"><a href="#request.self#?fuseaction=ch.list_due_diff_actions&event=upd&due_diff_id=#due_diff_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="57464.Güncelle">" alt="<cf_get_lang dictionary_id="57464.Güncelle">"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres = 'ch.list_due_diff_actions'>
		<cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
			<cfset adres = '#adres#&form_submitted=#attributes.form_submitted#'>
		</cfif>
		<cfif isDefined('attributes.act_type') and len(attributes.act_type)>
			<cfset adres = '#adres#&act_type=#attributes.act_type#'>
		</cfif>
		<cfif isdate(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
		</cfif>
		<cfif isdate(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script>
	document.getElementById('start_date').focus();
	function kontrol()
	{
		if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;	
	}
</script> 
