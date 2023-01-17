<!--- fiziki varlık detayında ,fizki varlıgn kullanıdlgı masraf satırlarını gösteren masraflar popupı. --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.expen_item_id" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfif len(attributes.search_date1)>
	<cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
	<cf_date tarih='attributes.search_date2'>
</cfif>
<cfset attributes.asset_id = (IsDefined("attributes.asset_id") and len(attributes.asset_id) ? attributes.asset_id : attributes.assetp_id)>
<cfquery name="GET_EXPENSE_ITEM_ID" datasource="#dsn2#">
	SELECT
		EXPENSE_ITEM_ID,
		EXPENSE_ITEM_NAME
	FROM
		EXPENSE_ITEMS
</cfquery>
<cfquery name="GET_ASSETP_EXPENSES" datasource="#DSN#">
	SELECT
		EXPENSE_ITEMS_ROWS.*,
		ASSET_P.ASSETP
	FROM
		<cfif fusebox.use_period>#dsn2_alias#.</cfif>EXPENSE_ITEMS_ROWS AS EXPENSE_ITEMS_ROWS,
		ASSET_P AS ASSET_P
	WHERE
		PYSCHICAL_ASSET_ID IS NOT NULL AND
		EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = <cfqueryparam value = "#attributes.asset_id#" CFSQLType = "cf_sql_integer"> AND
		ASSET_P.ASSETP_ID = EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID
	<cfif len(attributes.keyword)>
		AND ASSET_P.ASSETP LIKE '%#attributes.keyword#%' 
	</cfif>
	<cfif len(attributes.expen_item_id)>
		AND EXPENSE_ITEM_ID = #attributes.expen_item_id#
	</cfif>
	<cfif len(attributes.search_date1)>
		AND EXPENSE_DATE > #attributes.search_date1#
	</cfif>
	<cfif len(attributes.search_date2)>
		AND EXPENSE_DATE <= #attributes.search_date2#
	</cfif>
	ORDER BY EXPENSE_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_assetp_expenses.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('assetcare','Harcamalar','47900')#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form" action="" method="post">
		<cf_box_search>
			<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword"  value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre','57460')#">
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı!','57537')#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form' , #attributes.modal_id#)"),DE(""))#">
				</div>
		</cf_box_search>
		<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form' , #attributes.modal_id#)"),DE(""))#">
			<div class="col col-4 col-xs-12">
				<div class="form-group" id="item-expen_item_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54682.Gelir-Gider Kalemleri"></label>
					<div class="col col-6 col-xs-5">
						<select name="expen_item_id" id="expen_item_id">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz">...</option>
							<cfoutput query="get_expense_item_id">
								<option value="#expense_item_id#" <cfif expense_item_id eq attributes.expen_item_id>selected</cfif>>#expense_item_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
			<div class="col col-4 col-xs-12">
				<div class="form-group" id="item-search_date1">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
					<div class="col col-6 col-xs-5">
						<div class="input-group col col-xs-12">
							<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span> 
						</div>
					</div>
				</div>
			</div>
			<div class="col col-4 col-xs-12">
				<div class="form-group" id="item-search_date2">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="col col-6 col-xs-5">
						<div class="input-group col col-xs-12">
							<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span> 
						</div>
					</div>
				</div>
			</div>
		</cf_box_search_detail>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th><cf_get_lang dictionary_id='58677.Gelir'>/<cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th width="60" class="text-right"><cf_get_lang dictionary_id='48071.Harcama'></th>
			</tr>
		</thead>
		<tbody>
		<cfset toplam = 0>	
			<cfif get_assetp_expenses.recordcount>
				<cfoutput query="get_assetp_expenses" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfquery name="EXPENSE_ITEM_ID" datasource="#dsn2#">
						SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #EXPENSE_ITEM_ID#
					</cfquery>
					<tr>
						<td>#dateformat(expense_date,dateformat_style)#</td>
						<td>#expense_item_id.expense_item_name#</td>
						<td>#detail#</td>
						<td class="text-right">#tlformat(total_amount)# #session.ep.money#</td>
					</tr>
					<cfset toplam = toplam + total_amount> 
				</cfoutput>
				</tbody>
				<tfoot>
					<cfoutput> 
						<tr>
							<td><b><cf_get_lang_main no='80.Toplam'></b></td>
							<td colspan="4" class="text-right">
								#tlformat(toplam)# #session.ep.money#
							</td>
						</tr>
					</cfoutput>
				</tfoot>
			</cfif>
	</cf_grid_list>
	<cfif get_assetp_expenses.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
		</div>
	</cfif>
	<cfset url_str = "">
	<cfif len(attributes.asset_id)>
		<cfset url_str = "#url_str#&asset_id=#attributes.asset_id#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.department_ids") and len(attributes.department_ids)>
		<cfset url_str = "#url_str#&department_ids=#attributes.department_ids#">
	</cfif>
	<cfif isdefined("attributes.assetpcatid") and len(attributes.assetpcatid)>
		<cfset url_str = "#url_str#&assetpcatid=#attributes.assetpcatid#">
	</cfif>
	<cfif isdefined("attributes.search_date1") and len(attributes.search_date1)>
		<cfset url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.search_date2") and len(attributes.search_date2)>
		<cfset url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#">
	</cfif>
	<cfif (attributes.totalrecords gt attributes.maxrows)> 
		<cf_paging
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="assetcare.popup_list_asset_care_nonperiod#url_str#"></td>
	</cfif>
</cf_box>