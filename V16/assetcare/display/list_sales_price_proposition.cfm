<cfparam name="attributes.branch" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_cat" default="">
<cfquery name="GET_ASSET_CAT" datasource="#DSN#">
	SELECT ASSETP_CAT, ASSETP_CATID FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE= 1 ORDER BY ASSETP_CAT
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_ASSET_P_SOLD" datasource="#DSN#">
		SELECT
			ASSET_P.ASSETP,
			ASSET_P_SOLD.ASSETP_ID,
			ASSET_P_CAT.ASSETP_CAT,
			ASSET_P_SOLD.MIN_PRICE,
			ASSET_P_SOLD.MAX_PRICE,
			ASSET_P_SOLD.RECORD_DATE,
			ASSET_P_SOLD.ASSET_P_SOLD_ID,
			ASSET_P_SOLD.IS_TRANSFERED,
			ASSET_P_SOLD.MIN_MONEY,
			ASSET_P_SOLD.MAX_MONEY,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD
		FROM
			ASSET_P_SOLD, 
			ASSET_P,
			ASSET_P_CAT,
			BRANCH,
			DEPARTMENT
		WHERE
			ASSET_P_SOLD.ASSETP_ID = ASSET_P.ASSETP_ID AND
			ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
			<!--- Sadece yetkili olunan şubeler gözüksün.  --->
			BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
			<cfif len(attributes.keyword)>AND ASSET_P.ASSETP LIKE '%#attributes.keyword#%'</cfif>
			<cfif len(attributes.asset_cat)>AND ASSET_P.ASSETP_CATID = #attributes.asset_cat#</cfif>
			<cfif len(attributes.branch_id)and len(attributes.branch)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
		ORDER BY
			ASSET_P.ASSETP
	</cfquery>
<cfelse>
	<cfset get_asset_p_sold.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_asset_p_sold.recordcount#'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default='1'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_price_proposition" method="post" action="#request.self#?fuseaction=assetcare.list_sales_price_proposition">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword"  placeholder="#place#" value="#attributes.keyword#" maxlength="50" style="width:100px;">
				</div>
				<div class="form-group">
					<select name="asset_cat" id="asset_cat">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_asset_cat">
							<option value="#assetp_catid#" <cfif attributes.asset_cat eq assetp_catid>selected</cfif>>#assetp_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
						<input type="text" name="branch" id="branch" placeholder="<cfoutput>#place#</cfoutput>" value="<cfoutput>#attributes.branch#</cfoutput>" style="width:155px;"> 
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_price_proposition.branch&field_branch_id=search_price_proposition.branch_id','list','popup_list_branches')"><img src="/images/plus_thin.gif"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('assetcare',537)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58480.Araç'></th>
					<th><cf_get_lang dictionary_id='47973.Araç Tipi'></th>
					<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
					<th><cf_get_lang dictionary_id='48168.Min Fiyat'></th>
					<th><cf_get_lang dictionary_id='48169.Max Fiyat'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_sales_price_proposition','small','popup_add_sales_price_proposition');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_asset_p_sold.recordcount>
					<cfoutput query="get_asset_p_sold" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="20">#currentrow#</td>
							<td>#assetp#</td>
							<td>#assetp_cat#</td>
							<td>#branch_name#-#department_head#</td>
							<td style="text-align:right;">#tlformat(min_price)# #min_money#</td>
							<td style="text-align:right;">#tlformat(max_price)# #max_money#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil -->
							<td><cfif not is_transfered><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_sales_price_proposition&sold_id=#get_asset_p_sold.asset_p_sold_id#','small');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfif></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
						<tr>
							<td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
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
		<cfif len(attributes.branch)>
		<cfset url_string = "#url_string#&branch=#attributes.branch#">
		</cfif>
		<cfif len(attributes.branch_id)>
		<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="assetcare.list_sales_price_proposition#url_string#">
	</cf_box>
</div>
