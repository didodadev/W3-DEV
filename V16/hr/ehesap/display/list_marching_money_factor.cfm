<cfif isdefined('attributes.is_submit')>
	<cfinclude template="../query/get_marching_money_factor.cfm">
<cfelse>
	<cfset get_marching_money.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_marching_money.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="47119.Harcırah Katsayıları"></cfsavecontent>
<cf_box title="#message#" uidrop="1" hide_table_column="1" responsive_table="1">
	<cfform name="filter_list_money_factor" action="#request.self#?fuseaction=ehesap.list_marching_money_factor" method="post">			
		<cf_box_search>
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</div>
			<div class="form-group"><cf_wrk_search_button></div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id="58053.Başlangıç Tarih"></th>
				<th><cf_get_lang dictionary_id="57700.Bitiş Tarih"></th>
				<th><cf_get_lang dictionary_id="43121.Kayıt Eden"></th>
				<th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
				<!-- sil -->
				<th><a href="JAVASCRIPT://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=ehesap.popup_add_marching_money_factor</cfoutput>','medium')"><span class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span></a></th>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif get_marching_money.recordcount>
				<cfoutput QUERY="get_marching_money" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td align="center">#currentrow#</td>
						<td>#dateformat(start_date,dateformat_style)#</td>
						<td>#dateformat(finish_date,dateformat_style)#</td>
						<td>#get_emp_info(record_emp,0,0)#</td>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<!-- sil --><td align="center"><a href="JAVASCRIPT://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_marching_money_factor&money_main_id=#MARCHING_MONEY_MAIN_ID#','medium')"><span class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></span></a></td><!-- sil -->						
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
<cfset url_str = "">            
<cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
	<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
</cfif>            
<cf_paging page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="ehesap.list_marching_money_factor#url_str#">
