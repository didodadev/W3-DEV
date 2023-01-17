<cfparam name="attributes.module_id_control" default="35">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.pause_cat_id" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfif len(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
	</cfif>
	
	<cfquery name="get_prod_result" datasource="#dsn3#">
		SELECT 
			POR.STATION_ID,
			POR.FINISH_DATE,
			POR.RESULT_NO,
			POR.PR_ORDER_ID,
			PORR.STOCK_ID,
			PORR.NAME_PRODUCT,
			PORR.PRODUCT_ID,
			PORR.TYPE,
			(SELECT TOP 1 SUM(AMOUNT) AS AMOUNT FROM PRODUCTION_ORDER_RESULTS_ROW WHERE TYPE = 1 AND PR_ORDER_ID = PORR.PR_ORDER_ID) AMOUNT,
			(SELECT TOP 1 STOCK_CODE FROM STOCKS WHERE STOCKS.STOCK_ID = PORR.STOCK_ID) AS STOCK_CODE,
			(SELECT TOP 1 BRAND_ID FROM STOCKS WHERE STOCKS.STOCK_ID = PORR.STOCK_ID) AS BRAND_ID,
			SPP.PROD_PAUSE_TYPE_ID,
			ISNULL(SPP.PROD_DURATION,0) PROD_DURATION,
			SPP.PR_ORDER_ID,
			SPT.PROD_PAUSE_CAT_ID
		FROM
			PRODUCTION_ORDER_RESULTS POR,
			PRODUCTION_ORDER_RESULTS_ROW PORR,
			SETUP_PROD_PAUSE SPP,
			SETUP_PROD_PAUSE_TYPE SPT
		WHERE
			POR.PR_ORDER_ID = PORR.PR_ORDER_ID
			AND PORR.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
			AND POR.PR_ORDER_ID = SPP.PR_ORDER_ID
			AND SPP.PROD_PAUSE_TYPE_ID = SPT.PROD_PAUSE_TYPE_ID
            <cfif isdefined("attributes.pause_cat_id") and len(attributes.pause_cat_id)>
				AND  SPT.PROD_PAUSE_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pause_cat_id#" list="yes">)
			</cfif> 
			<cfif isdefined("attributes.station_id") and len(attributes.station_id)>
				AND POR.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#" list="yes">)
			</cfif> 
			<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
				AND PORR.STOCK_ID IN 
					(SELECT STOCK_ID FROM STOCKS WHERE BRAND_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#" list="yes">))
			</cfif>
			<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.stock_id) and len(attributes.product_name)>
				AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
			</cfif>
			<cfif len(attributes.start_date)>
				AND POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			</cfif>
			<cfif len(attributes.finish_date)>
				AND POR.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.finish_date)#">
			</cfif>
	</cfquery> 
	<cfquery name="get_prod" dbtype="query">
		SELECT 
			STATION_ID,
			FINISH_DATE,
			RESULT_NO,
			PR_ORDER_ID,
			STOCK_ID,
			STOCK_CODE,
			PRODUCT_ID,
			NAME_PRODUCT,
			AMOUNT,
			SUM(PROD_DURATION) TOT_DURATION
		FROM
			get_prod_result
		GROUP BY
			STATION_ID,
			FINISH_DATE,
			RESULT_NO,
			PR_ORDER_ID,
			STOCK_ID,
			STOCK_CODE,
			PRODUCT_ID,
			AMOUNT,
			NAME_PRODUCT
	</cfquery>
<cfelse>
	<cfset get_prod_result.recordcount = 0>
	<cfset get_prod.recordcount = 0>
</cfif>
<cfquery name="GET_W" datasource="#dsn3#">
	SELECT STATION_ID,STATION_NAME FROM	WORKSTATIONS WHERE ACTIVE = 1 ORDER BY STATION_NAME
</cfquery>
<cfquery name="get_Brand" datasource="#dsn1#">
	SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS ORDER BY BRAND_NAME
</cfquery>
<cfquery name="get_pause_cat" datasource="#dsn3#">
	SELECT PROD_PAUSE_CAT_ID,PROD_PAUSE_CAT FROM SETUP_PROD_PAUSE_CAT
</cfquery>
<cfquery name="get_pause_type" datasource="#dsn3#">
	SELECT 
		PROD_PAUSE_TYPE_ID,
		PROD_PAUSE_TYPE,
		PROD_PAUSE_TYPE_CODE,
		PROD_PAUSE_CAT_ID 
	FROM
		SETUP_PROD_PAUSE_TYPE 
	WHERE
		IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
		<cfif len(attributes.pause_cat_id)>
			AND PROD_PAUSE_CAT_ID NOT IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pause_cat_id#" list="yes">) 
		</cfif>
</cfquery>
<cfif get_prod.recordcount>
	<cfset station_id_list=''>
	<cfset pr_order_id_list=''>
	<cfoutput query="get_prod">
		<cfif isdefined('station_id') and len(station_id) and not listfind(station_id_list,station_id)>
			<cfset station_id_list=listappend(station_id_list,station_id)>
		</cfif>
		<cfif isdefined('PR_ORDER_ID') and len(PR_ORDER_ID) and not listfind(pr_order_id_list,PR_ORDER_ID)>
			<cfset pr_order_id_list=listappend(pr_order_id_list,PR_ORDER_ID)>
		</cfif>
	</cfoutput>
	<cfif listlen(station_id_list)>
		<cfset station_id_list=listsort(station_id_list,"numeric","ASC",",")>
		<cfquery name="get_station" datasource="#DSN3#">
			SELECT STATION_ID,STATION_NAME FROM	WORKSTATIONS WHERE STATION_ID IN (#station_id_list#) ORDER BY STATION_ID
		</cfquery>
		<cfset station_id_list = listsort(listdeleteduplicates(valuelist(get_station.STATION_ID,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_prod.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif get_prod_result.recordcount>
	<cfquery name="get_prod_result_" dbtype="query">
		SELECT * FROM get_prod_result WHERE PR_ORDER_ID IN(#pr_order_id_list#)
	</cfquery>
	<cfoutput query="get_prod_result_">
		<cfif isdefined('duraklama_tipi_#pr_order_id#_#PROD_PAUSE_TYPE_ID#')>
			<cfset 'duraklama_tipi_#pr_order_id#_#PROD_PAUSE_TYPE_ID#' = evaluate('duraklama_tipi_#pr_order_id#_#PROD_PAUSE_TYPE_ID#') + PROD_DURATION>
		<cfelse>
			<cfset 'duraklama_tipi_#pr_order_id#_#PROD_PAUSE_TYPE_ID#' = PROD_DURATION>
		</cfif>
	</cfoutput>
</cfif>
<cfform name="prod_pause" action="" method="post">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40721.Duraklama Raporu'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58834.İstasyon'></label>	
									<div class="col col-12">			
										<select name="station_id" id="station_id" multiple="multiple" style="width:170px;height:70;">
											<cfoutput query="get_w">
												<option value="#station_id#"<cfif isdefined("attributes.station_id") and listfind(attributes.station_id,station_id)>selected</cfif>>#station_name#</option>
											</cfoutput>
										</select>
									</div>	
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>	
									<div class="col col-12">		
										<select name="brand_id" id="brand_id" multiple="multiple" style="width:170px;height:70;">
											<cfoutput query="get_Brand">
												<option value="#brand_id#"<cfif isdefined("attributes.brand_id") and listfind(attributes.brand_id,brand_id)>selected</cfif>>#brand_name#</option>
											</cfoutput>
										</select>	
									</div>									
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">							
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29475.Duraklama Kategorisi'></label>	
									<div class="col col-12">
										<select name="pause_cat_id" id="pause_cat_id" multiple="multiple" style="width:170px;height:70;">
											<cfoutput query="get_pause_cat">
												<option value="#prod_pause_cat_id#"<cfif isdefined("attributes.pause_cat_id") and listfind(attributes.pause_cat_id,prod_pause_cat_id)>selected</cfif>>#prod_pause_cat#</option>
											</cfoutput>
										</select>	
									</div>											
								</div>	
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
											<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
											<input type="text"   name="product_name" id="product_name"   value="<cfoutput>#attributes.product_name#</cfoutput>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','155');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&field_id=prod_pause.stock_id&product_id=prod_pause.product_id&field_name=prod_pause.product_name&keyword='+encodeURIComponent(document.prod_pause.product_name.value),'list');"></span>	
										</div>
									</div>	
								</div>	
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
											<cfinput type="text" name="start_date"  value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
											<span class="input-group-addon">
												<cf_wrk_date_image date_field="start_date">
											</span>		
										</div>					
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#"  message="#message#" maxlength="10">
											<span class="input-group-addon">
												<cf_wrk_date_image date_field="finish_date">
											</span>		
										</div>
									</div> 
								</div>							 
							</div>
						</div>
					</div>
				</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
						<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
						<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1"/>	  
						<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>		
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isDefined("attributes.is_form_submitted")>
    <cf_report_list>		
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
						<th><cf_get_lang dictionary_id='40730.Sonuç Tarihi'></th>
						<th><cf_get_lang dictionary_id='40731.Sonuç No'></th>
						<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
						<th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
						<th><cf_get_lang dictionary_id='40732.Sonuç Miktarı'></th>
						<cfloop query="get_pause_type">
							<th><cfoutput>#PROD_PAUSE_TYPE# (#PROD_PAUSE_TYPE_CODE#)</cfoutput></th>				
						</cfloop>
					</tr>
				</thead>
				<cfif isdefined("attributes.is_form_submitted") and get_prod_result.recordcount>
					<tbody>
					<cfoutput query="get_prod" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>
								<cfif len(station_id)>
									#get_station.STATION_NAME[listfind(station_id_list,get_prod.station_id,',')]#
								</cfif>
							</td>
							<td nowrap="nowrap">#dateformat(finish_date,dateformat_style)# (#timeformat(finish_date,timeformat_style)#)</td>
							<td>#result_no#</td>
							<td>#stock_code#</td>
							<td width="200">
								<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
									#name_product#
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','large');" class="tableyazi">#name_product#</a>
								</cfif>	
							</td>
							<td style="text-align:right;">#tlformat(AMOUNT)#</td>
							<cfloop query="get_pause_type">																		
									<cfif not isdefined("top_duraklama_#PROD_PAUSE_CAT_ID#_#PROD_PAUSE_TYPE_ID#")>
									<cfset "top_duraklama_#PROD_PAUSE_CAT_ID#_#PROD_PAUSE_TYPE_ID#" = 0>
								</cfif>
								<td style="text-align:right;">
									<cfif isdefined("duraklama_tipi_#get_prod.pr_order_id#_#PROD_PAUSE_TYPE_ID#")>
										#evaluate("duraklama_tipi_#get_prod.pr_order_id#_#PROD_PAUSE_TYPE_ID#")#					
										<cfset "top_duraklama_#PROD_PAUSE_CAT_ID#_#PROD_PAUSE_TYPE_ID#" = evaluate("top_duraklama_#PROD_PAUSE_CAT_ID#_#PROD_PAUSE_TYPE_ID#") + evaluate("duraklama_tipi_#get_prod.pr_order_id#_#PROD_PAUSE_TYPE_ID#")>	
									<cfelse>0</cfif>
								</td>					
							</cfloop>		
						</tr>
					</cfoutput>
					</tbody>
					<tfoot>
						<tr>
						<td colspan="6"></td>
							<td style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<cfloop query="get_pause_type">				
								<td style="text-align:right;">
									<cfif isdefined("top_duraklama_#PROD_PAUSE_CAT_ID#_#PROD_PAUSE_TYPE_ID#")>
										<cfoutput>#evaluate("top_duraklama_#PROD_PAUSE_CAT_ID#_#PROD_PAUSE_TYPE_ID#")#</cfoutput>
									<cfelse>
										<cfoutput>0</cfoutput>
									</cfif>
								</td>					
							</cfloop>	
						</tr>
					</tfoot>
				<cfelse>
					<cfset colspan_ = 20>
					<cfloop query="get_pause_type">
						<cfset colspan_ = colspan_ + 1>
					</cfloop>
					<tbody>
					<tr>
						<td colspan="20">
							<cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse></cfif>
						</td>
					</tr>
					</tbody>
				</cfif>			
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
	<cfset url_str = ''>
	<cfif isDefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
		<cfset url_str = '#url_str#&is_form_submitted=1'>
	</cfif>
	<cfif len(attributes.station_id)>
		<cfset url_str = '#url_str#&station_id=#attributes.station_id#'>
	</cfif>
	<cfif len(attributes.brand_id)>
		<cfset url_str = '#url_str#&brand_id=#attributes.brand_id#'>
	</cfif>
	<cfif len(attributes.pause_cat_id)>
		<cfset url_str = '#url_str#&pause_cat_id=#attributes.pause_cat_id#'>
	</cfif>
	<cfif len(attributes.product_id)>
		<cfset url_str = '#url_str#&product_id=#attributes.product_id#'>
	</cfif>
	<cfif len(attributes.stock_id)>
		<cfset url_str = '#url_str#&stock_id=#attributes.stock_id#'>
	</cfif>
	<cfif len(attributes.product_name)>
		<cfset url_str = '#url_str#&product_name=#attributes.product_name#'>
	</cfif>
	<cfif isdate(attributes.start_date)>
		<cfset url_str = '#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cfset url_str = '#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
	</cfif>
	<cf_paging
            page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="report.production_pause_report#url_str#">	
</cfif>	
<script>
    function control(){   
		if(!date_check(prod_pause.start_date,prod_pause.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}  
		if(document.prod_pause.is_excel.checked==false)
			{
				document.prod_pause.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
				return true;
			}
			else
				document.prod_pause.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_production_pause_report</cfoutput>"
	}
</script>



