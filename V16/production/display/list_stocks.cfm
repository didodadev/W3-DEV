<!--- Stoklarım --->
<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
<cfparam name="authority_station_id_list" default="0">
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
		STATION_ID,
		EXIT_DEP_ID 
	FROM 
		#dsn3_alias#.WORKSTATIONS W
	WHERE 
		W.ACTIVE = 1 AND
		W.EXIT_DEP_ID IS NOT NULL AND
		W.EMP_ID LIKE '%,#session.ep.userid#,%'
	ORDER BY 
		STATION_NAME
</cfquery>
<cfset authority_station_id_list = ValueList(get_w.station_id,',')>
<cfset exit_dep_id_list = ValueList(get_w.exit_dep_id,',')>
<cfif isdefined("attributes.is_form_submitted") and len(exit_dep_id_list)>
	<cfquery name="get_stocks" datasource="#dsn3#">
		SELECT
			PU.MAIN_UNIT,
			S.PRODUCT_ID,
			S.STOCK_CODE_2,
			S.PRODUCT_NAME,
			S.STOCK_ID,
			S.BARCOD,
			S.STOCK_CODE,
			S.PROPERTY,
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK
		FROM 
			STOCKS S,
			PRODUCT_UNIT PU,
			#dsn2_alias#.STOCKS_ROW SR
		WHERE
			S.PRODUCT_STATUS = 1 AND 
			S.IS_INVENTORY = 1 AND 
			PU.IS_MAIN = 1 AND
			S.STOCK_STATUS = 1 AND
			SR.STOCK_ID = S.STOCK_ID AND
			S.PRODUCT_ID = PU.PRODUCT_ID AND
			SR.STORE IN (#exit_dep_id_list#)
		GROUP BY
			PU.MAIN_UNIT,
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			S.STOCK_CODE_2,
			S.STOCK_ID,
			S.BARCOD,
			S.STOCK_CODE,
			S.PROPERTY
		ORDER BY S.PRODUCT_NAME, S.PROPERTY
	</cfquery>
<cfelse>
	<cfset get_stocks.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif get_stocks.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_stocks.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfscript>wrkUrlStrings('url_str','is_form_submitted');</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_list" action="#request.self#?fuseaction=production.#fuseaction_#" method="post">
			<cf_box_search more="0">
				<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel='0'>
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray2" href="javascript:history.go(-1);"><i class="fa fa-arrow-left"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="box_head"><cf_get_lang dictionary_id='38096.Stoklarım'></cfsavecontent>
	<cf_box title="#box_head#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<th><cf_get_lang dictionary_id='57633.Barkod'></th>
				<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
			</thead>
			<cfif get_stocks.recordcount>
				<cfoutput query="get_stocks" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tbody>
						<td>&nbsp;#currentrow#</td>
						<td>&nbsp;#STOCK_CODE#</td>
						<td>&nbsp;#BARCOD#</td>
						<td>&nbsp;#STOCK_CODE_2#</td>
						<td>&nbsp;#PRODUCT_NAME#</td>
						<td>&nbsp;#PRODUCT_STOCK#</td>
						<td>&nbsp;#MAIN_UNIT#</td>
					</tbody>
				</cfoutput>
			<cfelse>
				<tr height="30" class="color-row"><td colspan="7"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td></tr>
			</cfif>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#get_stocks.recordcount#" 
				startrow="#attributes.startrow#" 
				adres="production.#fuseaction_##url_str#">
				<!-- sil -->
				<td align="right" style="text-align:right;font-size:14px"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
		</cfif>
	</cf_box>
</div>
