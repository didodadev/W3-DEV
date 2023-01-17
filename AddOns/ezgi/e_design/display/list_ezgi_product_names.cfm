<cf_get_lang_set module_name="objects">
<cf_xml_page_edit fuseact="objects.popup_product_names">
<cfparam name="attributes.is_used_rate" default="0">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.camp_start" default="">
<cfparam name="attributes.list_order_no" default="">
<cfparam name="attributes.product_cat_code" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.master" default="">
<cfparam name="attributes.eleme" default="">
<cfparam name="url_str" default="">
<cfif isdefined("attributes.is_collacted_prom") and attributes.is_collacted_prom eq 1><cfparam name="attributes.is_collacted_prom" default="0"></cfif>
<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)><cfparam name="attributes.camp_id" default="0"></cfif>
<!---
Description :
	Bu popup istenen inputlara product_id,stock_id,urun adi,stok property,birim id ve/veya seri no takip flag i atar. 20040908
Parameters :
	product_id				'urun id atilacak opener formu input adi
	special_code			'ozel kodu atilacak opener formu input adi
	field_id				'urun stock_id atilacak opener formu input adi
	field_name				'urun adi opener formu input adi
	field_code				'stok kodu opener formu input adi
	field_barcode			'barkod numarası formu input adı
	field_unit				'ilgili urun-stoga ait birim id opener formu input adi
	field_unit_name			'ilgili stoğa ait birim adı input adı
	field_service_serial	'seri no takibi yapilip yapilmadigini donduren opener formu input adi
	field_tax_purchase		'Ürünün alış kdv oranı				'
	field_is_production		'Ürünün üretilip üretilmediğini belirtiyor-1/0'
	process					'???
	process_var				'???
	is_only_anternative		'urun un sadece alternatifleri gelecekse bu parametre ile anternative_product de yollanır
	anternative_product		'urun un alternatifleri gelmesi icin urun idsi
Syntax :
	...fuseaction=objects.popup_product_names&product_id=report_special.product_id&field_name=report_special.product_name
--->
<cfparam name="is_show_product_status" default="0">
<cfparam name="attributes.is_multi_selection" default="0"><!--- Formdan 1 gonderildiginde urun coklu olarak secilebilir hale gelir--->
<cfparam name="attributes.page" default="1">
<cfif isDefined('session.ep.userid')>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelseif isDefined('session.pp.userid')>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
</cfif>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfif isdefined('attributes.expense_date') and isdate(attributes.expense_date)><cf_date tarih='attributes.expense_date'></cfif>
<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1><!--- xmlde proje filtresi secilmisse --->
	<cfif isdefined("attributes.project_id") and Len(attributes.project_id)>
		<cfset project_id_ = attributes.project_id>
		<cfset project_head_ = get_project_name(attributes.project_id)>
	<cfelse>
		<cfset project_id_ = "">
		<cfset project_head_ = "">
	</cfif>
	<cfparam name="attributes.project_id" default="#project_id_#">
	<cfparam name="attributes.project_head" default="#project_head_#">
</cfif>
<cfquery name="GET_PROPERTY_VAR" datasource="#DSN1#">
	SELECT
        PP.PROPERTY_ID,
        PP.PROPERTY,
        PPD.PROPERTY_DETAIL_ID,
        PPD.PROPERTY_DETAIL
		<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
			,PCP.PRODUCT_CAT_ID
		</cfif>
    FROM
        PRODUCT_PROPERTY PP,
        PRODUCT_PROPERTY_DETAIL PPD
		<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
			,PRODUCT_CAT_PROPERTY PCP
		</cfif>
    WHERE
        PP.PROPERTY_ID = PPD.PRPT_ID
        <cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
       		AND PP.PROPERTY_ID=PCP.PROPERTY_ID
        	AND PCP.PROPERTY_ID=PPD.PRPT_ID
        	AND PCP.PRODUCT_CAT_ID=#attributes.product_catid#
        </cfif>
    ORDER BY
        PP.PROPERTY,
        PPD.PROPERTY_DETAIL
</cfquery>
<cfif isdefined('attributes.is_form_submitted') or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfinclude template="../query/get_ezgi_product_names.cfm">
	<cfif isdefined('attributes.field_product_cost')><!--- field_product_cost tanımlı ise maliyetleri çekiyor --->
		<cfquery name="get_product_cost_all" datasource="#dsn1#">
			SELECT  
				PRODUCT_ID,
				PURCHASE_NET_SYSTEM,
				PURCHASE_EXTRA_COST_SYSTEM,
				START_DATE,
				RECORD_DATE
			FROM
				PRODUCT_COST			
			ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC
		</cfquery>
	</cfif>
<cfelse>
	<cfset PRODUCT_NAMES.recordcount=0>
</cfif>
<cfif PRODUCT_NAMES.recordcount>
	<cfparam name="attributes.totalrecords" default="#product_names.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfquery name="get_cat" datasource="#dsn3#">
	SELECT      
    	PRODUCT_CATID, 
        HIERARCHY, 
        PRODUCT_CAT
	FROM            
    	PRODUCT_CAT
   	<cfif isdefined('attributes.list_order_no') and len(attributes.list_order_no)>
        WHERE        
            LIST_ORDER_NO IN (#attributes.list_order_no#)
 	</cfif>
</cfquery>
<cfset url_string = "">
<cfif isdefined("attributes.is_collacted_prom")>
	<cfset url_string = "#url_string#&is_collacted_prom=#attributes.is_collacted_prom#">
</cfif>
<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
	<cfset url_string = "#url_string#&camp_id=#attributes.camp_id#">
</cfif>
<cfif isdefined("attributes.tree_stock_id")>
	<cfset url_string = "#url_string#&tree_stock_id=#attributes.tree_stock_id#">
</cfif>
<cfif isdefined("attributes.is_production")>
	<cfset url_string = "#url_string#&is_production=#attributes.is_production#">
</cfif>
<cfif isdefined("attributes.is_used_rate")>
	<cfset url_string = "#url_string#&is_used_rate=#attributes.is_used_rate#">
</cfif>
<cfif isdefined("attributes.field_product_cost")>
	<cfset url_string = "#url_string#&field_product_cost=#attributes.field_product_cost#">
</cfif>
<cfif isdefined("attributes.product_id")>
	<cfset url_string = "#url_string#&product_id=#attributes.product_id#">
</cfif>
<cfif isdefined("attributes.from_promotion")>
	<cfset url_string = "#url_string#&from_promotion=1">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_code")>
	<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
</cfif>
<cfif isdefined("attributes.field_code2")>
	<cfset url_string = "#url_string#&field_code2=#attributes.field_code2#">
</cfif>
<cfif isdefined("attributes.field_special_code")>
	<cfset url_string = "#url_string#&field_special_code=#attributes.field_special_code#">
</cfif>
<cfif isdefined("attributes.service_product_cat")>
	<cfset url_string = "#url_string#&service_product_cat=#attributes.service_product_cat#">
</cfif>
<cfif isdefined("attributes.field_barcode")>
	<cfset url_string = "#url_string#&field_barcode=#attributes.field_barcode#">
</cfif>
<cfif isdefined("attributes.field_tax_purchase")>
	<cfset url_string = "#url_string#&field_tax_purchase=#attributes.field_tax_purchase#">
</cfif>
<cfif isdefined("attributes.field_tax")>
	<cfset url_string = "#url_string#&field_tax=#attributes.field_tax#">
</cfif>
<cfif isdefined("attributes.field_otv")>
	<cfset url_string = "#url_string#&field_otv=#attributes.field_otv#">
</cfif>
<cfif isdefined("attributes.field_is_production")>
	<cfset url_string = "#url_string#&field_is_production=#attributes.field_is_production#">
</cfif>
<cfif isdefined("attributes.field_unit")>
	<cfset url_string = "#url_string#&field_unit=#attributes.field_unit#">
</cfif>
<cfif isdefined("attributes.field_unit_name")>
	<cfset url_string = "#url_string#&field_unit_name=#attributes.field_unit_name#">
</cfif>
<cfif isdefined("attributes.function_name")>
	<cfset url_string = "#url_string#&function_name=#attributes.function_name#">
</cfif>
<cfif isdefined("attributes.field_main_unit")>
	<cfset url_string = "#url_string#&field_main_unit=#attributes.field_main_unit#">
</cfif>
<cfif isdefined("attributes.price_calc")>
	<cfset url_string = "#url_string#&price_calc=#attributes.price_calc#">
</cfif>
<cfif isdefined("attributes.price_calc_sarf")>
	<cfset url_string = "#url_string#&price_calc_sarf=#attributes.price_calc_sarf#">
</cfif>
<cfif isdefined("attributes.process") and len(attributes.process)>
	<cfset url_string = "#url_string#&process=#attributes.process#">
</cfif>
<cfif isdefined("attributes.process_var") and len(attributes.process_var)>
	<cfset url_string = "#url_string#&process_var=#attributes.process_var#">
</cfif>
<cfif isdefined("attributes.field_profit_margin") and len(attributes.field_profit_margin)>
	<cfset url_string = "#url_string#&field_profit_margin=#attributes.field_profit_margin#">
</cfif>
<cfif isdefined("attributes.field_service_serial")>
	<cfset url_string = "#url_string#&field_service_serial=#attributes.field_service_serial#">
</cfif>
<cfif isdefined("attributes.is_hizmet")>
	<cfset url_string = "#url_string#&is_hizmet=#attributes.is_hizmet#">
</cfif>
<cfif isdefined("attributes.is_only_alternative")>
	<cfset url_string = "#url_string#&is_only_alternative=#attributes.is_only_alternative#">
</cfif>
<cfif isdefined("attributes.alternative_product")>
	<cfset url_string = "#url_string#&alternative_product=#attributes.alternative_product#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_string = "#url_string#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif isdefined("attributes.run_function")>
	<cfset url_string = "#url_string#&run_function=#attributes.run_function#">
</cfif>
<cfif isdefined("attributes.run_function_param1")>
	<cfset url_string = "#url_string#&run_function_param1=#attributes.run_function_param1#">
</cfif>
<cfif isdefined("attributes.run_function_param")>
	<cfset url_string = "#url_string#&run_function_param=#attributes.run_function_param#">
</cfif>
<cfif isDefined('attributes.expense_date') and len(attributes.expense_date)>
	<cfset url_string = "#url_string#&expense_date=#dateformat(attributes.expense_date,'dd/mm/yyyy')#">
</cfif>
<cfif isDefined('attributes.stock_and_spect') and len(attributes.stock_and_spect)>
	<cfset url_string = "#url_string#&stock_and_spect=#attributes.stock_and_spect#">
</cfif>
<cfif isDefined('attributes.field_spect_main_id') and len(attributes.field_spect_main_id)>
	<cfset url_string = "#url_string#&field_spect_main_id=#attributes.field_spect_main_id#">
</cfif>
<cfif isdefined('attributes.field_spect_main_name')>
	<cfset url_string = "#url_string#&field_spect_main_name=#attributes.field_spect_main_name#">
</cfif>
<cfif isdefined("attributes.ajax_form") and len(attributes.ajax_form)>
	<cfset url_string = '#url_string#&ajax_form=1'>
</cfif>
<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
	<cfset url_string = '#url_string#&record_num=#attributes.record_num#'>
</cfif>
<cfif isDefined('attributes.project_id') and len(attributes.project_id) and isDefined("attributes.project_head") and Len(attributes.project_head)>
	<cfset url_string = "#url_string#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
</cfif>
<cfif isdefined("attributes.field_amount")>
	<cfset url_string = "#url_string#&field_amount=#attributes.field_amount#">
</cfif>
<cfif isdefined("attributes.call_function")>
	<cfset adres = '#url_string#&call_function=#attributes.call_function#'>
</cfif>
<cfif isdefined("attributes.call_function_paremeter")>
	<cfset adres = '#url_string#&call_function_paremeter=#attributes.call_function_paremeter#'>
</cfif>
<cfif isdefined("attributes.list_order_no")>
	<cfset adres = '#url_string#&list_order_no=#attributes.list_order_no#'>
</cfif>
<cfif isdefined("attributes.master")>
	<cfset adres = '#url_string#&master=#attributes.master#'>
</cfif>
<!--- Asagida gonderiliyor, tekrar gonderilmesin, yoksa eski deger kullaniliyor fbs 20130425
<cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
	<cfset url_string = '#url_string#&list_property_id=#attributes.list_property_id#'>
</cfif>
<cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
	<cfset url_string = '#url_string#&list_variation_id=#attributes.list_variation_id#'>
</cfif>
 --->
<cfif isdefined("attributes.is_multi_selection")>
	<cfset url_string = "#url_string#&is_multi_selection=#attributes.is_multi_selection#">
</cfif>

<cfif isdefined("attributes.list_product_id")>
	<cfset url_string = "#url_string#&list_product_id=#attributes.list_product_id#">
</cfif>
<cfif isdefined("attributes.list_order_no")>
	<cfset url_string = "#url_string#&list_order_no=#attributes.list_order_no#">
</cfif>
<cfif isdefined("attributes.master")>
	<cfset url_string = "#url_string#&master=#attributes.master#">
</cfif>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.barcod" default=''>
<cfform name="search_product" method="post" action="#request.self#?fuseaction=objects.popup_ezgi_product_names#url_string#">
<!---<cf_wrk_alphabet keyword ="url_string">--->
    <cf_medium_list_search title="">
        <cf_medium_list_search_area>
			<table>
				<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
				<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
				<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
				<cfif isdefined("attributes.product_id")><input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>"></cfif>
				<cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"></cfif>
				<cfif isdefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>"></cfif>
                <cfif isdefined("attributes.service_product_cat")><input type="hidden" name="service_product_cat" id="service_product_cat" value="<cfoutput>#attributes.service_product_cat#</cfoutput>"></cfif>
				<cfif isdefined("attributes.is_multi_selection")>
				<input type="hidden" name="is_multi_selection" id="is_multi_selection" value="<cfoutput>#attributes.is_multi_selection#</cfoutput>">
				</cfif>
				<cfif isdefined("attributes.call_function")><input type="hidden" name="call_function" id="call_function" value="<cfoutput>#attributes.call_function#</cfoutput>"></cfif>
				<cfif isdefined("attributes.call_function_paremeter")><input type="hidden" name="call_function_paremeter" id="call_function_paremeter" value="<cfoutput>#attributes.call_function_paremeter#</cfoutput>"></cfif>
				<tr>
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" style="width:70px;" value="#attributes.keyword#" maxlength="200"></td>
					<td><cf_get_lang_main no='221.Barkod'></td>
					<td><cfinput type="text" name="barcod" style="width:70px;"  onKeyUp="isNumber(this);" value="#attributes.barcod#" maxlength="13"></td>
					
                    <td><cf_get_lang_main no='74.Kategori'></td>
                    <td>
                        <input type="hidden" name="form_submitted" id="form_submitted" value="">
                        <input type="hidden" name="product_cat" id="product_cat" value="">
                        <cfinput type="hidden" name="list_order_no" id="list_order_no" value="#attributes.list_order_no#">
						<cfinput type="hidden" name="master" id="master" value="#attributes.master#">
                        <cfinput type="hidden" name="eleme" id="eleme" value="#attributes.eleme#">
                        <!---<input type="text" name="product_cat" id="product_cat" style="width:150px; vertical-align:top" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_cat_code','','3','200');" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>">
                        <a href="javascript://"onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product.product_cat_code&field_name=search_product.product_cat</cfoutput>','list');"><img src="/images/plus_thin.gif"></a>--->
                        <select name="product_cat_code" id="product_cat_code" style="width:150px">
                        	<option value="" ><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfoutput query="get_cat">
                            	<option value="#HIERARCHY#" <cfif attributes.product_cat_code eq HIERARCHY>selected</cfif>>#HIERARCHY# #PRODUCT_CAT#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="Sayi_Hatasi_Mesaj" onkeyup="return(FormatCurrency(this,event,0));" style="width:25px;">
					</td>
					<td><cf_wrk_search_button search_function='input_control()'></td>
                    <cfif isDefined('session.ep.userid')>
                        <td>
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=product.form_add_product</cfoutput>','longpage','form_add_product');"><img src="/images/plus1.gif" title="<cf_get_lang_main no='1613.Urun Ekle'>"></a>
                        </td>
                    </cfif>
				</tr>
			</table>
            <table style="text-align:right;">
                <tr>
                    <td>
                        <cfinclude template="detailed_ezgi_product_search.cfm" />
                    </td>
                </tr>
            </table>
        </cf_medium_list_search_area>
       
	</cf_medium_list_search>
	</cfform> 
	<cf_medium_list>
   		<thead>
            <tr>
                <th width="100"><cf_get_lang_main no='106.Stok Kodu'></th>
				<cfif isDefined('is_show_barkod') and is_show_barkod eq 1>
					<th width="100"><cf_get_lang_main no='221.Barkod'></th>	
				</cfif>
				<cfif isDefined('is_show_product_code_2') and  is_show_product_code_2 eq 1>
					<th width="100"><cf_get_lang_main no='377.Özel Kod'></th>	
				</cfif>
                <th><cf_get_lang_main no='245.Ürün'></th>    
                <cfif isdefined('attributes.stock_and_spect')>
                <th width="50"><cf_get_lang_main no='235.Spec'></th>
                </cfif>
                <cfif isdefined('is_show_product_status') and is_show_product_status eq 1>
                <th nowrap="nowrap"><cf_get_lang no ='1546.Stok Miktarı'></th>
                </cfif>
                <th  width="60"><cf_get_lang no='615.Ana Birim'></th>
                <th  width="50"><cf_get_lang_main no='1736.Tedarikçi'></th>
                <th width="15"></th>
            </tr>
        </thead>
        <tbody>
			<cfif product_names.recordcount>
				<cfset company_id_list=''>
				<cfset stock_id_list=''>
				<cfoutput query="product_names" >
					<cfif len(product_names.company_id) and not listfind(company_id_list,company_id)>
						<cfset company_id_list=listappend(company_id_list,company_id)>
					</cfif>
					<cfif len(stock_id) and  not listfind(stock_id_list,stock_id)>
						<cfset stock_id_list=listappend(stock_id_list,stock_id)>
					</cfif>
				</cfoutput>
				<cfif len(company_id_list)>
				  <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				  <cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
					SELECT COMPANY_ID, NICKNAME, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
				  </cfquery>
				  <cfset main_company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif isdefined('is_show_product_status') and is_show_product_status eq 1>
					<cfif len(stock_id_list)>
						<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
						<cfquery name="get_product_stock" datasource="#DSN2#">
							SELECT STOCK_ID, SUM(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK FROM STOCKS_ROW WHERE STOCK_ID IN (#stock_id_list#) GROUP BY STOCK_ID ORDER BY STOCK_ID
						</cfquery>
						<cfset stock_id_list = listsort(listdeleteduplicates(valuelist(get_product_stock.STOCK_ID,',')),'numeric','ASC',',')>
					</cfif>
				</cfif>
				<cfif len(stock_id_list)>
					<cfquery name="get_product_spec_main_tree" datasource="#dsn3#">
						SELECT 
							SM.SPECT_MAIN_ID,
							T1.STOCK_ID 
						FROM 
							(SELECT 
								STOCK_ID,
								MAX(RECORD_DATE) AS RECORD_DATE
								
							FROM 
								SPECT_MAIN SM 
							WHERE 
							 STOCK_ID IN (#stock_id_list#) AND
							 IS_TREE = 1
							GROUP BY  
								STOCK_ID
							)
						T1,
						SPECT_MAIN SM
						WHERE 
							SM.STOCK_ID = T1.STOCK_ID 
							AND (SM.RECORD_DATE = T1.RECORD_DATE OR SM.UPDATE_DATE = T1.RECORD_DATE)
					</cfquery>
				<cfelse>
					<cfset get_product_spec_main_tree.recordcount = 0>
				</cfif>
				<cfif get_product_spec_main_tree.recordcount>
					<cfloop query="get_product_spec_main_tree">
					<cfset 'SPEC_MAIN_ID_#STOCK_ID#' = SPECT_MAIN_ID>
					</cfloop>
				</cfif>
              	<cfoutput query="product_names" >
					<cfif isdefined('attributes.field_product_cost')><!--- Eğer maliyet atılmak isteniyorsa açılan sayfadan... --->
						<cfquery name="get_product_cost" dbtype="query" maxrows="1"><!--- Maliyetler geliyor. --->
							SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #product_names.PRODUCT_ID# <cfif isdefined('attributes.expense_date') and isdate(attributes.expense_date)>AND START_DATE <= #attributes.expense_date#</cfif> ORDER BY START_DATE DESC,RECORD_DATE DESC
						</cfquery>
						<cfif len(get_product_cost.PURCHASE_NET_SYSTEM)><!--- maliyetleri yoksa 0 set ediliyor. --->
							<cfset PURCHASE_NET_SYSTEM = get_product_cost.PURCHASE_NET_SYSTEM>
						<cfelse>
							<cfset PURCHASE_NET_SYSTEM = 0 >
						</cfif>
						<cfif len(get_product_cost.PURCHASE_EXTRA_COST_SYSTEM)>
							<cfset PURCHASE_EXTRA_COST_SYSTEM = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM>
						<cfelse>
							<cfset PURCHASE_EXTRA_COST_SYSTEM = 0 >
						</cfif>
						<cfset product_cost = PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM>
					</cfif>
				 <tr>
					<td>#product_names.stock_code#</td>
					<cfif isDefined('is_show_barkod') and is_show_barkod eq 1>
						<td>#product_names.barcod#</td>
					</cfif>
					<cfif isDefined('is_show_product_code_2') and  is_show_product_code_2 eq 1>
						<td>#product_names.stock_code_2#</td>
					</cfif>
					<td>
						<cfif isdefined('attributes.field_product_cost')><cfset _product_cost_ = product_cost><cfelse><cfset _product_cost_ = 0 ></cfif>
						<cfif isdefined('attributes.stock_and_spect') and isdefined('SPEC_MAIN_ID_#STOCK_ID#')>
							<cfset _spec_main_id_ =Evaluate('SPEC_MAIN_ID_#STOCK_ID#')>
						<cfelse>
							<cfset _spec_main_id_ =0>
						</cfif>
						<cfscript>
							temp_prod_name=replace(trim(product_name),'"','','all');
							temp_prod_name=replace(temp_prod_name,"'","","all");
							temp_property=replace(property,'"','','all');
							temp_property=replace(temp_property,"'","","all");
						</cfscript>
						<cfif isdefined("attributes.is_collacted_prom") and attributes.is_collacted_prom eq 1>
							<a href="javascript://" class="tableyazi" onclick="gonder_prom('#product_id#','#stock_id#','#temp_prod_name#');">#temp_prod_name#&nbsp;</a>
						<cfelse>
							<a href="javascript://" class="tableyazi" onclick="gonder('#product_id#','#stock_id#','#temp_prod_name#','#stock_code#','#temp_property#','#product_unit_id#','#main_unit#','#is_serial_no#','#main_unit_id#','#product_names.barcod#','#TAX_PURCHASE#','#TAX#','#IS_PRODUCTION#','#_product_cost_#','#_spec_main_id_#','#profit_margin#','#stock_code_2#','#OTV#','#PRODUCT_CODE_2#','#PRODUCT_CATID#','#AMOUNT#');">#temp_prod_name#&nbsp;</a>
							<a href="javascript://" class="tableyazi" onClick="gonder('#product_id#','#stock_id#','#temp_prod_name#','#stock_code#','#temp_property#','#product_unit_id#','#main_unit#','#is_serial_no#','#main_unit_id#','#product_names.barcod#','#TAX_PURCHASE#','#TAX#','#IS_PRODUCTION#','#_product_cost_#','#_spec_main_id_#','#profit_margin#','#stock_code_2#','#OTV#','#PRODUCT_CODE_2#','#PRODUCT_CATID#','#AMOUNT#');">#property#</a>
						</cfif>
					</td>
					<cfif isdefined('attributes.stock_and_spect')>
						<td><cfif isdefined('SPEC_MAIN_ID_#STOCK_ID#')><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_spec&id=#Evaluate('SPEC_MAIN_ID_#STOCK_ID#')#','large');">#Evaluate('SPEC_MAIN_ID_#STOCK_ID#')#</a></cfif></td>
					</cfif>
					<cfif isdefined('is_show_product_status') and is_show_product_status eq 1><!--- Ürünün Stok Bilgileri --->
					<td  nowrap style="text-align:right;">#TLFORMAT(get_product_stock.PRODUCT_STOCK[listfind(stock_id_list,product_names.stock_id,',')],2)#</td>
					</cfif>
					<td>#product_names.main_unit#</td>
					<td><cfif len(product_names.company_id)>#get_company_detail.fullname[listfind(main_company_id_list,product_names.company_id,',')]#</cfif><!--- #get_company_name.FULLNAME# ---></td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#&sid=#STOCK_ID#<cfif isdefined("attributes.is_store_module")>&is_store_module=1</cfif>','medium');"><img src="/images/report_square2.gif" title="<cf_get_lang_main no='359.Detay'>"></a></td>
				  </tr>
				</cfoutput>
			  <cfelse>
			  <tr>
				<td colspan="9" class="color-row"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang_main no='72.Kayıt Yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
			  </tr>
			</cfif>
        </tbody>
   </cf_medium_list>
   <cf_popup_box_footer>
	    <cfif isdefined("attributes.is_collacted_prom") and attributes.is_collacted_prom eq 1>
            <form name="collacted_prom" method="post" action="">
                <input type="hidden" name="prom_product_id" id="prom_product_id" value="">
                <input type="hidden" name="prom_stock_id" id="prom_stock_id" value="">
                <input type="hidden" name="prom_product_name" id="prom_product_name" value="">
                <input type="hidden" name="prom_row_count" id="prom_row_count" value="">
                <input type="hidden" name="prom_page" id="prom_page" value="<cfoutput>#attributes.page#</cfoutput>">
                <input type="hidden" name="prom_maxrows" id="prom_maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>">
            </form>
        </cfif>
        <cfif attributes.maxrows lt attributes.totalrecords>
          <table cellpadding="2" cellspacing="0" border="0" width="99%" align="center">
            <tr height="2">
              <td>
                <cfset adres = attributes.fuseaction>
 				<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                	<cfset adres = "#adres#&keyword=#attributes.keyword#">
                </cfif>
				<cfif len(attributes.product_cat) and (isDefined('attributes.product_cat_code') and len(attributes.product_cat_code))>
                    <cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
                </cfif>
                <cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
                    <cfset adres = "#adres#&product_cat=#attributes.product_cat#">
                </cfif>
                <cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1><!---  xmlde proje filtresi secilmisse --->
                    <cfif isdefined("attributes.project_id")>
                        <cfset adres = "#adres#&project_id=#attributes.project_id#">
                    </cfif>
                    <cfif isdefined("attributes.project_head")>
                        <cfset adres = "#adres#&project_head=#attributes.project_head#">
                    </cfif>
                </cfif>
                <cfif len(url_string)>
                    <cfset adres = "#adres##url_string#">
                </cfif>
				<cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
					<cfset adres = '#adres#&list_property_id=#attributes.list_property_id#'>
				</cfif>	
				<cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
					<cfset adres = '#adres#&list_variation_id=#attributes.list_variation_id#'>
				</cfif>
				<cfif get_property_var.recordcount>
					<!--- Sayfalamada secilen varyasyonlarin secili olmasi icin --->
					<cfloop from="1" to="#get_property_var.recordcount#" index="row">
						<cfif isDefined("attributes.variation_id#row#")>
							<cfset adres = '#adres#&variation_id#row#=#Evaluate("attributes.variation_id#row#")#'>
						</cfif>
					</cfloop>
				</cfif>
                <cf_pages
                    page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#&is_form_submitted=1">
                </td>
              <!-- sil --><td style="text-align:right;"><cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
            </tr>
          </table>
        </cfif>
   </cf_popup_box_footer>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		row_count=<cfoutput>#get_property_var.recordcount#</cfoutput>;
		for(r=1;r<=row_count;r++)
		{  
			deger_variation_id = eval("document.search_product.variation_id"+r);
			if(deger_variation_id!=undefined && deger_variation_id.value != "")
			{
				deger_property_id = eval("document.search_product.property_id"+r);
				if(document.search_product.list_property_id.value.length==0) ayirac=''; else ayirac=',';
				document.search_product.list_property_id.value=document.search_product.list_property_id.value+ayirac+deger_property_id.value;
				document.search_product.list_variation_id.value=document.search_product.list_variation_id.value+ayirac+deger_variation_id.value;
			}
		}
		return true;
	}
	document.search_product.list_property_id.value="";
	document.search_product.list_variation_id.value="";
	function wrkObjV(id,op_){if(op_ == undefined) return document.getElementById(id).value; else return window.eval(op_).document.getElementById(id).value;}
	function OwrkObjV(id){return document.getElementById(id).value;}
	function gonder(p_id,id,urun,code,property,unit_id,unit_name,is_product_service,main_unit_id,barcode,tax_purchase,tax_sale,is_production,product_cost,spect_main_id,profit_margin,code2,otv,special_code,product_catid,amount)
	{
		<cfoutput>
		if(#attributes.is_used_rate# == 1 && unit_name != window.opener.document.getElementById('main_product_unit').value){
			alert("<cf_get_lang_main no='1475.% Kullanarak Ürün Ağacı Tasarlanırken Ana Ürün ün biriminden farklı bir birim ekleyemezsiniz'>!");
			return false;
		}
		<cfif isdefined('attributes.field_spect_main_id')>
			if(is_production == 1 && (spect_main_id == 0 || spect_main_id=="")){
				alert(" "+urun+"\n <cf_get_lang no ='1573.Ürünü Üretildiği Halde Bir Ağacı Yok Görünüyor Üretilen Ürünü Ağaca Eklemek İçin Önce Ürünün Kendi Ağacını Oluşturmalısınız'>!");
				return false;
			}	
			else if(spect_main_id>0 && is_production == 0){	
				alert(" "+urun+"\n <cf_get_lang_main no='1474.Ürünün Oluşmuş Spec i Olmasına Rağmen Üretilmiyor Gözüküyor Ürününüzü Kontrol Ediniz ve Daha Sonra Ağaça Ekleyiniz'>!");
					return false;
			}
			if(spect_main_id>0)
				window.opener.#attributes.field_spect_main_id#.value = spect_main_id;
			else
				window.opener.#attributes.field_spect_main_id#.value = '';
		</cfif>
		<cfif isdefined('attributes.field_spect_main_name')>
			if(spect_main_id>0)
			window.opener.#attributes.field_spect_main_name#.value = urun;
			else
			window.opener.#attributes.field_spect_main_name#.value = '';
		</cfif>
	
		<cfif isdefined("attributes.product_id") and listlen(attributes.product_id,'.') eq 2>
			 <cfif isdefined("attributes.product_id")>
				<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
					if(window.opener.document.#attributes.product_id#.value == '')
						window.opener.document.#attributes.product_id#.value = p_id;
					else
						window.opener.document.#attributes.product_id#.value = window.opener.document.#attributes.product_id#.value + ',' +p_id;
				<cfelse>		
					window.opener.document.#attributes.product_id#.value = p_id;
				</cfif>
			</cfif>
		<cfelseif isdefined("attributes.product_id") and Len(attributes.product_id)>
			window.opener.document.all.<cfoutput>#attributes.product_id#</cfoutput>.value = p_id;
		</cfif>
		<cfif isdefined('attributes.field_id') and listlen(attributes.field_id,'.') eq 2>
			 <cfif isdefined("attributes.field_id")>
				<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
					if(window.opener.document.#attributes.field_id#.value == '')
						window.opener.document.#attributes.field_id#.value = id;
					else
						window.opener.document.#attributes.field_id#.value = window.opener.document.#attributes.field_id#.value + ',' + id;
				<cfelse>
					window.opener.document.#attributes.field_id#.value = id;
				</cfif>
			 </cfif> 
			
			 <cfif isdefined("attributes.field_name")>
				<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
					if(window.opener.document.#attributes.field_name#.value == '')
						window.opener.document.#attributes.field_name#.value = urun + "-" + property;
					else
						window.opener.document.#attributes.field_name#.value = window.opener.document.#attributes.field_name#.value + ',' + urun + "-" + property;
				<cfelse>
					if(property.length > 0)
						window.opener.document.#attributes.field_name#.value = urun + "-" + property;
					else 
						window.opener.document.#attributes.field_name#.value = urun ;
				</cfif>
			</cfif> 
		<cfelse>
			 <cfif isdefined("attributes.field_id")>
				window.opener.document.all.#attributes.field_id#.value = id; 
			 </cfif> 
			 <cfif isdefined("attributes.field_name")>
			 	<cfif isdefined("attributes.field_name") and listlen(attributes.field_name,'.') eq 2>
					window.opener.document.#attributes.field_name#.value = urun + "-" + property;
				<cfelseif isdefined("attributes.field_name")>
					window.opener.document.all.#attributes.field_name#.value = urun + "-" + property;
				</cfif>
			</cfif> 
		</cfif>
		<cfif isdefined("attributes.field_code") and listlen(attributes.field_code,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_code#</cfoutput>.value = code;
		<cfelseif isdefined("attributes.field_code")>
			window.opener.document.all.<cfoutput>#attributes.field_code#</cfoutput>.value = code;
		</cfif>
		<cfif isdefined("attributes.field_code2") and listlen(attributes.field_code2,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_code2#</cfoutput>.value = code2;
		<cfelseif isdefined("attributes.field_code2")>
			window.opener.document.all.<cfoutput>#attributes.field_code2#</cfoutput>.value = code2;
		</cfif>
		<cfif isdefined("attributes.field_special_code") and listlen(attributes.field_special_code,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_special_code#</cfoutput>.value = special_code;
		<cfelseif isdefined("attributes.field_special_code")>
			window.opener.document.all.<cfoutput>#attributes.field_special_code#</cfoutput>.value = special_code;
		</cfif>
		<cfif isdefined("attributes.field_barcode") and listlen(attributes.field_barcode,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_barcode#</cfoutput>.value = barcode;
		<cfelseif isdefined("attributes.field_barcode")>
			window.opener.document.all.<cfoutput>#attributes.field_barcode#</cfoutput>.value = barcode;
		</cfif>
		<cfif isdefined("attributes.field_tax_purchase") and listlen(attributes.field_tax_purchase,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_tax_purchase#</cfoutput>.value = tax_purchase;
		<cfelseif isdefined("attributes.field_tax_purchase")>
			window.opener.document.all.<cfoutput>#attributes.field_tax_purchase#</cfoutput>.value = tax_purchase;
		</cfif>
		<cfif isdefined("attributes.field_tax") and listlen(attributes.field_tax,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_tax#</cfoutput>.value = tax_sale;
		<cfelseif isdefined("attributes.field_tax")>
			window.opener.document.all.<cfoutput>#attributes.field_tax#</cfoutput>.value = tax_sale;
		</cfif>
		<cfif isdefined("attributes.field_otv")>
			window.opener.document.<cfoutput>#attributes.field_otv#</cfoutput>.value = otv;
		</cfif>
		<cfif isdefined("attributes.field_is_production") and listlen(attributes.field_is_production,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_is_production#</cfoutput>.value = is_production;
		<cfelseif isdefined("attributes.field_is_production")>
			window.opener.document.all.<cfoutput>#attributes.field_is_production#</cfoutput>.value = is_production;
		</cfif>
		<cfif isdefined("attributes.field_unit") and listlen(attributes.field_unit,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_unit#</cfoutput>.value = unit_id;
		<cfelseif isdefined("attributes.field_unit")>
			window.opener.document.all.<cfoutput>#attributes.field_unit#</cfoutput>.value = unit_id;
		</cfif>
		<cfif isdefined("attributes.field_unit_name") and listlen(attributes.field_unit_name,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_unit_name#</cfoutput>.value = unit_name;
		<cfelseif isdefined("attributes.field_unit_name")>
			window.opener.document.all.<cfoutput>#attributes.field_unit_name#</cfoutput>.value = unit_name;
		</cfif>
		<cfif isdefined("attributes.field_main_unit") and listlen(attributes.field_main_unit,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_main_unit#</cfoutput>.value = main_unit_id;
		<cfelseif isdefined("attributes.field_main_unit")>
			window.opener.document.all.<cfoutput>#attributes.field_main_unit#</cfoutput>.value = main_unit_id;
		</cfif>
		<cfif isdefined("attributes.service_product_cat")>
			window.opener.document.all.<cfoutput>#attributes.service_product_cat#</cfoutput>.value = product_catid;
			window.opener.get_service_defect(product_catid);
		</cfif>
		<cfif isdefined("attributes.field_service_serial") and listlen(attributes.field_service_serial,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_service_serial#</cfoutput>.value = is_product_service;
		<cfelseif isdefined("attributes.field_service_serial")>
			window.opener.document.all.<cfoutput>#attributes.field_service_serial#</cfoutput>.value = is_product_service;
		</cfif>
		<cfif isdefined("attributes.field_profit_margin") and listlen(attributes.field_profit_margin,'.') eq 2>
			window.opener.document.<cfoutput>#attributes.field_profit_margin#</cfoutput>.value = commaSplit(profit_margin,2);
		<cfelseif isdefined("attributes.field_profit_margin")>
			window.opener.document.all.<cfoutput>#attributes.field_profit_margin#</cfoutput>.value = commaSplit(profit_margin,2);
		</cfif>
		<cfif isdefined('attributes.field_product_cost')>
			<cfif isdefined("attributes.field_product_cost") and listlen(attributes.field_product_cost,'.') eq 2>
				if(product_cost != 0)
					window.opener.document.#attributes.field_product_cost#.value = commaSplit(product_cost,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			<cfelse>
				if(product_cost != 0)
					window.opener.document.all.#attributes.field_product_cost#.value = commaSplit(product_cost,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			</cfif>
		</cfif>
		<cfif isdefined("attributes.process") and (attributes.process is "purchase_contract" or attributes.process is "sales_contract")>
			window.opener.findDuplicate(#attributes.process_var#);
		</cfif>
		<cfif isdefined("attributes.field_calistir")>
			window.opener.bosalt();
			window.opener.butonlari_goster();
		</cfif>
		
		<cfif isdefined("attributes.field_amount")><!--- üretimde kullanılan sarfın alternatif ürün miktarı --->
			window.opener.document.all.<cfoutput>#attributes.field_amount#</cfoutput>.value = amount;
		</cfif>
		<cfif isdefined('attributes.send_product_id')><!--- Bu kısım üretim emri için eklendi,seçilen product_id ve satırd numarasını gönderiyor. --->
			window.opener.<cfoutput>#run_function#(#attributes.send_product_id#)</cfoutput>;
		<cfelseif isdefined("attributes.run_function") and isdefined("attributes.run_function_param")><!--- Fonksiyon ve parametre varsa --->
			window.opener.<cfoutput>#run_function#(<cfif isdefined("attributes.run_function") and isdefined("attributes.run_function_param1")>"#attributes.run_function_param1#",</cfif>#attributes.run_function_param#)</cfoutput>;
		<cfelseif isdefined("attributes.run_function")><!--- Sadece fonksiyon varsa --->
			window.opener.<cfoutput>#run_function#</cfoutput>;
		</cfif>
		<cfif isdefined('attributes.price_calc')>//6 nolu spect'den fire için ürün eklenirse o sayfada bulunan js query'den liste fiyatını çekmek için kullanılıyor.Kesinlikle silmeyiniz.M.ER 20070328
			window.opener.fire_hesapla(<cfoutput>#attributes.price_calc#</cfoutput>);
		</cfif>
		<cfif isdefined('attributes.price_calc_sarf')>//sarff_ 6 nolu spect'den fire için ürün eklenirse o sayfada bulunan js query'den liste fiyatını çekmek için kullanılıyor.Kesinlikle silmeyiniz.M.ER 20070328
			window.opener.sarf_hesapla(<cfoutput>#attributes.price_calc_sarf#</cfoutput>);
		</cfif>
		<cfif isdefined('attributes.function_name')>
			window.opener.<cfoutput>#function_name#</cfoutput>;
		</cfif>
		<cfif isdefined('attributes.call_function')>
			window.opener.<cfoutput>#attributes.call_function#</cfoutput>(<cfif isdefined('attributes.call_function_paremeter')><cfoutput>#attributes.call_function_paremeter#</cfoutput></cfif>);
		</cfif>
		<cfif (isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 0) or not isdefined("attributes.is_multi_selection")>
			self.close();
		</cfif>
	}
	</cfoutput>
	<cfif isdefined("attributes.is_collacted_prom") and attributes.is_collacted_prom eq 1>
		row_count=<cfoutput>#attributes.record_num#</cfoutput>; // BURAYI UNUTMA!!!! 
		function gonder_prom(x,y,z)
		{		
			document.collacted_prom.prom_product_id.value = x;
			document.collacted_prom.prom_stock_id.value = y;
			document.collacted_prom.prom_product_name.value = z;
			document.collacted_prom.prom_row_count.value = row_count;
			document.collacted_prom.action = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_product_names<cfif isdefined("attributes.camp_id") and Len(attributes.camp_id)>&camp_id=#attributes.camp_id#</cfif>&keyword=#attributes.keyword#&barcod=#attributes.barcod#&product_cat_code=#attributes.product_cat_code#&product_cat=#attributes.product_cat#</cfoutput>';
			document.collacted_prom.submit();
		}
	</cfif>
</script>