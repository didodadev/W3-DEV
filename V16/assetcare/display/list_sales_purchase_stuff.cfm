<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.department_id" default="">
<cfquery name="GET_ASSET_CAT" datasource="#dsn#">
	SELECT ASSETP_CAT, ASSETP_CATID FROM  ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery> 
<cfquery name="get_branch" datasource="#dsn#"> 
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME 
</cfquery>
<cfif len(attributes.form_submitted)>
<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_care_calender")>
<cfset login_act.dsn = dsn />
<cfset GET_SOLDS = login_act.GET_SELL_BUY_FNC( 
								keyword : '#iif(isdefined("attributes.keyword") and len(attributes.keyword),"attributes.keyword",DE(""))#',    
                                asset_cat : '#iif(isdefined("attributes.asset_cat") and len(attributes.asset_cat),"attributes.asset_cat",DE(""))#', 
								branch :'#iif(isdefined("attributes.branch") and len(attributes.branch),"attributes.branch",DE(""))#', 
                               branch_id :  '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#'                               
								)>
<cfparam name="attributes.totalrecords" default='#get_solds.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default='1'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.list_sales_purchase_stuff">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0"> 
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#place#" maxlength="50" value="#attributes.keyword#">			
				</div>     
				<div class="form-group" id="item-asset_cat">
					<div class="input-group">
						<select name="asset_cat" id="asset_cat">
							<option value=""><cf_get_lang dictionary_id='58480.Araç'> <cf_get_lang dictionary_id='58639.Tipleri'></option>
							<cfoutput query="get_asset_cat">
							<option value="#assetp_catid#" <cfif attributes.asset_cat eq assetp_catid>selected</cfif>>#assetp_cat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-asset_cat">
					<div class="input-group">
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
						<input type="text" name="branch"  placeholder="<cfoutput><cf_get_lang dictionary_id='57453.Şube'></cfoutput>"  id="branch" value="<cfoutput>#attributes.branch#</cfoutput>"> 
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_asset.branch&field_branch_id=search_asset.branch_id','list','popup_list_branches')"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search> 	
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='58176.Alış'> - <cf_get_lang dictionary_id='57448.Satış'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>	             
					<th><cf_get_lang dictionary_id='58480.Araç'></th>	
					<th><cf_get_lang dictionary_id='47973.Araç Tipi'></th>
					<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
					<th><cf_get_lang dictionary_id='58733.Alıcı'></th>
					<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
					<th><cf_get_lang dictionary_id='48168.Min Fiyat'></th>
					<th><cf_get_lang dictionary_id='48169.Max Fiyat'></th>
					<th><cf_get_lang dictionary_id='48183.Satış Fiyatı'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th><cf_get_lang dictionary_id='48417.Satış Durumu'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='48170.Araç Satış Güncelle'>" title="<cf_get_lang dictionary_id='48170.Araç Satış Güncelle'>"></i></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif len(attributes.form_submitted)>
					<cfif get_solds.recordcount>
						<cfoutput query="get_solds" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td width="20">#currentrow#</td>
								<td>#assetp#</td>		
								<td>#assetp_cat#</td>
								<td>#branch_name#-#department_head#</td>
								<td>#name_buyer#</td>
								<td>#tax_num#</td>
								<td style="text-align:right;">#tlformat(min_price)# #min_money#</td>
								<td style="text-align:right;">#tlformat(max_price)# #max_money#</td>
								<td style="text-align:right;">#tlformat(sale_currency)# #sale_currency_money#</td>
								<td>#dateformat(record_date,dateformat_style)#</td>
								<td><cfif is_transfered><font color="red"><cf_get_lang dictionary_id='48409.Satışı Yapıldı'></font><cfelse><cf_get_lang dictionary_id='48032.Satış Talebi'></cfif></td>
								<!-- sil -->		
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_sales_purchase_stuff&sold_id=#get_solds.asset_p_sold_id#','medium','popup_upd_sales_purchase_stuff');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='48170.Araç Satış Güncelle'>" title="<cf_get_lang dictionary_id='48170.Araç Satış Güncelle'>"></i></a></td>
								<!-- sil -->
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
						</tr>
					</cfif>
					<cfelse>
					<tr>
						<td colspan="12"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_string = "">
		<cfif len(attributes.keyword)>
		<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
		<cfset url_string = "#url_string#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.asset_cat)>
		<cfset url_string = "#url_string#&asset_cat=#attributes.asset_cat#">
		</cfif>
		<cfif len(attributes.branch_id)>
		<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.branch)>
		<cfset url_string = "#url_string#&branch=#attributes.branch#">
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="assetcare.list_sales_purchase_stuff#url_string#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
</script>
