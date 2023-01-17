<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.stockbond_type_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.type_group" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.form_exist')>
	<cfscript>
	getCredit_=createobject("component","V16.credit.cfc.credit");
	getCredit_.dsn3=#dsn3#;
	getStockbond = getCredit_.getStockbond(
		keyword : attributes.keyword ,
		stockbond_type_id : attributes.stockbond_type_id ,
		startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
		maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
		type_group : '#iif(len(attributes.type_group),"attributes.type_group",DE(""))#'
	);
</cfscript>
<cfif not len(attributes.type_group)>
	<cfparam name="attributes.totalrecords" default='#getStockbond.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='#getStockbond.recordcount#'>
</cfif>
<cfset adres = "">
<cfelse>
	<cfset getStockbond.recordcount = 0>
    <cfparam name="attributes.totalrecords" default='0'>	
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_stockbond" method="post" action="#request.self#?fuseaction=credit.list_stockbonds">
			<cf_box_search more="0">
				<input type="hidden" name="form_exist" id="form_exist" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre','57460')#​">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="text"><cf_get_lang dictionary_id='51415.Menkul Kıymet Tipi'></cfsavecontent>
							<cf_wrk_combo
							name="stockbond_type_id"
							query_name="GET_STOCKBOND_TYPE"
							option_name="stockbond_type"
							option_value="stockbond_type_id"
							value="#iif(isdefined("attributes.stockbond_type_id"),'attributes.stockbond_type_id',DE(''))#"
							option_text="#text#"
							width=120>
					</div>
				</div>
				<div class="form-group">
					<select name="type_group" id="type_group">
						<option value=""><cf_get_lang dictionary_id='36815.Grupla'></option>
						<option value="1" <cfif attributes.type_group eq 1> selected</cfif>><cf_get_lang dictionary_id='37087.Koda Göre'><cf_get_lang dictionary_id='36815.Grupla'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Menkul Kıymetler','58240')#" hide_table_column="1"  uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
				<cfif not len(attributes.type_group)>		
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
				</cfif>
					<th><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='51408.Stok Miktarı'></th>
					<th><cf_get_lang dictionary_id='51409.Nominal Değer'></th>	
					<th><cf_get_lang dictionary_id='51410.Nominal Değer Döviz'></th>	
					<th><cf_get_lang dictionary_id='51411.Alış Değer'></th>	
					<th><cf_get_lang dictionary_id='51412.Alış Değer Döviz'></th>	
					<th><cf_get_lang dictionary_id='51413.Güncel Değer'></th>	
					<th><cf_get_lang dictionary_id='51414.Güncel Değer Döviz'></th>
					<th><cf_get_lang dictionary_id='58603.Toplam Değer'></th>
					<th><cf_get_lang dictionary_id='58603.Toplam Değer'><cf_get_lang dictionary_id='57677.Döviz'></th>
				<cfif not len(attributes.type_group)>
					<!-- sil --><th width="20" class="header_icn_none" title="<cf_get_lang dictionary_id='51413.Güncel Değer'>"><cf_get_lang dictionary_id='64473.G.D'></th><!-- sil -->
					<!-- sil --><th class="header_icn_none text-center " title="<cf_get_lang dictionary_id='61042.Hesaba Geçiş Listesi'>"><cf_get_lang dictionary_id='64474.H.G'></th><!-- sil -->
					<!-- sil --><th width="20" class="header_icn_none text-center" title="<cf_get_lang dictionary_id='57771.Detay'>"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>" alt="<cf_get_lang dictionary_id='57771.Detay'>"></i></th><!-- sil -->
				</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_exist") and getStockbond.RECORDCOUNT>
				<cfoutput query="getStockbond" >
					<tr>
						<td>#currentrow#</td>
						<cfif not len(attributes.type_group)>
							<td>
								<a href="#request.self#?fuseaction=credit.list_stockbonds&event=det&stockbond_id=#stockbond_id#">#STOCKBOND_TYPE_#</a>
							</td>
						</cfif>
						<td>
							<cfif not len(attributes.type_group)>
								<a href="#request.self#?fuseaction=credit.list_stockbonds&event=det&stockbond_id=#stockbond_id#">#STOCKBOND_CODE#</a>
							<cfelse>
								#STOCKBOND_CODE#
							</cfif>
						</td>
						<td style="text-align:right;">#ReplaceNoCase(NET_QUANTITY,'.',',','all')#</td>
						<td style="text-align:right;">#TLFormat(NOMINAL_VALUE,session.ep.our_company_info.rate_round_num)#</td>
						<td style="text-align:right;">#TLFormat(OTHER_NOMINAL_VALUE,session.ep.our_company_info.rate_round_num)#</td>
						<td style="text-align:right;">#TLFormat(PURCHASE_VALUE,session.ep.our_company_info.rate_round_num)#</td>
						<td style="text-align:right;">#TLFormat(OTHER_PURCHASE_VALUE,session.ep.our_company_info.rate_round_num)#</td>
						<td style="text-align:right;">#TLFormat(ACTUAL_VALUE,session.ep.our_company_info.rate_round_num)#</td>
						<td style="text-align:right;">#TLFormat(OTHER_ACTUAL_VALUE,session.ep.our_company_info.rate_round_num)#</td>
						<td style="text-align:right;">#TLFormat(TOTAL_PURCHASE,session.ep.our_company_info.rate_round_num)#</td>
						<td style="text-align:right;">#TLFormat(OTHER_TOTAL_PURCHASE,session.ep.our_company_info.rate_round_num)#</td>
						<cfif not len(attributes.type_group)>
							<td class="iconL">
								<a onclick="connectAjax('#currentrow#','#stockbond_id#');" id="stockbond_plus_detail#currentrow#" title="<cf_get_lang dictionary_id='51413.Güncel Değer'>"><i class="catalyst-graph"></i></a>
							</td>
							<td>
								<cfif YIELD_TYPE eq 1> 
									<a href="#request.self#?fuseaction=credit.list_stockbonds&event=yieldPayment&stockbond_id=#stockbond_id#" target="_blank" title="<cf_get_lang dictionary_id='48731.Hesaba Geçiş'>"><i class="fa fa-compress"></i></a>
								</cfif>
							</td>
							<td><a href="#request.self#?fuseaction=credit.list_stockbonds&event=det&stockbond_id=#stockbond_id#" title="<cf_get_lang dictionary_id='57771.Detay'>"><i class="icon-detail"></i></a></td>
						</cfif>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="17" class="color-row" height="20"><cfif isdefined("attributes.form_exist")><cf_get_lang_main no='72.Kayıt Yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>	
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres="form_exist=1">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.type_group)>
				<cfset adres = "#adres#&type_group=#attributes.type_group#">
			</cfif>
			<cfif isdefined('attributes.stockbond_type_id') and len(attributes.stockbond_type_id)>
				<cfset adres = "#adres#&stockbond_type_id=#attributes.stockbond_type_id#" >
			</cfif>
			<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="credit.list_stockbonds&#adres#">
		</cfif>
	</cf_box>
</div>


<script type="application/javascript">

	function connectAjax(crtrow,stockbond_id)
	{
		cfmodal('<cfoutput>#request.self#?fuseaction=credit.ajax_stockbond_value_currently</cfoutput>&stockbond_id='+stockbond_id, 'warning_modal');
	}

	$('#keyword').focus();
	function kontrol()
	{
		if(!$("#maxrows").val().length)
		{
		alertObject({message: "<cfoutput><cf_get_lang_main no='125.Sayı_Hatası_Mesaj'></cfoutput>"})    
		return false;
		}
		return true;
	}
</script>
