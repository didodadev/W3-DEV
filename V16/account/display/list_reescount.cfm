<!--- Reeskont Listesi --->
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
	<cfquery name="get_reescounts" datasource="#dsn2#">
		SELECT
			REESCOUNT_ID,
			DUE_DATE,
			ACTION_DATE,
			TOTAL_VALUE,
			TOTAL_REESCOUNT_VALUE
		FROM
			REESCOUNT
		WHERE
			1 = 1
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
	<cfset get_reescounts.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_reescounts.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_actions" method="post" action="#request.self#?fuseaction=account.list_reescount">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" placeholder="#getLang('','Başlangıç Tarihi',58053)#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" placeholder="#getLang('','Bitiş Tarihi',57700)#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(2025,'Reeskont İşlemleri',29822)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
					<th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
					<th><cf_get_lang dictionary_id='29534.Toplam Tutar'></th>
					<th><cf_get_lang dictionary_id='47382.Reeskont Tutarı'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_reescount&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_reescounts.recordcount>
					<cfoutput query="get_reescounts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#dateformat(action_date,dateformat_style)#</td>
							<td>#dateformat(due_date,dateformat_style)#</td>
							<td class="text-right">#tlFormat(total_value,2)#</td>
							<td class="text-right">#tlFormat(total_reescount_value,2)#</td>
							<!-- sil -->
							<td class="text-center"><a href="#request.self#?fuseaction=account.list_reescount&event=upd&reescount_id=#reescount_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr class="color-row" height="20">
						<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres = ''>
		<cfif isdefined("attributes.form_submitted")>
			<cfset adres = "#adres#&form_submitted=#attributes.form_submitted#" >
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
			adres="account.list_reescount#adres#">
	</cf_box>
</div>
