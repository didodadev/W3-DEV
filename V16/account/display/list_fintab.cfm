<cfif isdefined('attributes.date1') and isdefined('attributes.date2') and isdate(attributes.date1) and isdate(attributes.date2)>
	<cfset tarih_1=attributes.date1 >
	<cfset tarih_2=attributes.date2 >
<cfelse>
	<cfset tarih_1="01/01/#session.ep.period_year#">
	<cfset tarih_2="31/12/#session.ep.period_year#">
</cfif>
<cf_date tarih='tarih_1'>
<cf_date tarih='tarih_2'>
<cfinclude template="../query/get_fin_tables.cfm">
<cfset date_1 = dateformat(tarih_1,dateformat_style)>
<cfset date_2 = dateformat(tarih_2,dateformat_style)>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#GET_FIN_TABLES.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="header_">
	<cfif attributes.fuseaction is 'account.list_scale_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_scale_record'>
		<cf_get_lang dictionary_id='47275.mizan tabloları'>
	<cfelseif attributes.fuseaction is 'account.list_income_table_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_income_table_record'>
		<cf_get_lang dictionary_id='47276.gelir tabloları'>
	<cfelseif attributes.fuseaction is 'account.list_cost_table_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_cost_table_record'>
		<cf_get_lang dictionary_id='47285.Satis maliyet tabloları'>
	<cfelseif attributes.fuseaction is 'account.list_balance_sheet_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_balance_sheet_record'>
		<cf_get_lang dictionary_id='47298.Bilançolar'>
	<cfelseif attributes.fuseaction is 'account.list_cash_flow_records' or attributes.fuseaction is 'account.autoexcelpopuppage_list_cash_flow_records'>
		<cf_get_lang dictionary_id='47267.Nakit Akım Tablosu'>
	<cfelseif attributes.fuseaction is 'account.list_fund_flow_records' or attributes.fuseaction is 'account.autoexcelpopuppage_list_fund_flow_records'>
		<cf_get_lang dictionary_id='47272.Fon Akım Tablosu'>
	</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen İşlem Başlangıç Tarihini Giriniz !'></cfsavecontent>
						<cfinput type="text" name="date1" id="date1" value="#date_1#" validate="#validate_style#" maxlength="10" required="Yes" message="#message#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message1"><cf_get_lang dictionary_id='47293.Lütfen İşlem Bitiş Tarihini Giriniz !'></cfsavecontent>
						<cfinput type="text" name="date2" id="date2" value="#date_2#" validate="#validate_style#" maxlength="10" required="Yes" message="#message1#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="1" search_function="kontrol()">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#header_#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead> 
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='47353.Tablo Adı'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><i class="fa fa-minus" alt="Sil" title="Sil"></i></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif GET_FIN_TABLES.RECORDCOUNT>
					<cfoutput query="GET_FIN_TABLES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a class="tableyazi" href="#request.self#?fuseaction=account.detail_fintab&id=#SAVE_ID#"> #USER_GIVEN_NAME# </a> </td>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57533.eminmisiniz'></cfsavecontent>
							<!-- sil --><td><a href="javascript://" onClick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=account.emptypopup_del_fintab&SAVE_ID=#SAVE_ID#','small'); else return false;"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction#&date1=#date_1#&date2=#date_2#">
	</cf_box>
</div>
<script>
	function kontrol()
	{
		if( !date_check(document.getElementById('date1'),document.getElementById('date2'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	}
</script>
