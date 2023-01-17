<cf_get_lang_set module_name="prod">
<cf_xml_page_edit fuseact="prod.add_prod_order">
<cfif not isnumeric(attributes.party_id)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfquery name="get_tree_xml_amount" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session_base.company_id# AND
		FUSEACTION_NAME = 'prod.add_product_tree' AND
		PROPERTY_NAME = 'is_show_prod_amount'
</cfquery>
<cfif get_tree_xml_amount.recordcount>
	<cfset is_show_prod_amount = get_tree_xml_amount.PROPERTY_VALUE>
<cfelse>
	<cfset is_show_prod_amount = 1>
</cfif>

<cfquery name="GET_DET_PO" datasource="#DSN3#">
	SELECT
		P.IS_PRODUCTION,
		P.IS_PROTOTYPE,
		PO.P_ORDER_ID,
		PO.PARTY_ID,
		POM.PARTY_NO,
		TEXTILE_SAMPLE_REQUEST.COMPANY_ID,
		POM.REQ_ID,
		PO.STOCK_ID,
		PO.STATION_ID,
		PO.DEMAND_NO,
		PO.PO_RELATED_ID,
		PO.ORDER_ID,
		PO.QUANTITY,
		PO.P_ORDER_NO,
		PO.START_DATE,
		PO.FINISH_DATE,
		PO.STATUS,
		PO.IS_STOCK_RESERVED,
		PO.IS_DEMONTAJ,
		PO.PROD_ORDER_STAGE,
		PO.LOT_NO,
		PO.PROJECT_ID,
		PO.REFERENCE_NO,
		PO.SPEC_MAIN_ID,
		PO.SPECT_VAR_ID,
		PO.SPECT_VAR_NAME,
		PO.DETAIL,
		PO.DP_ORDER_ID,
		PO.RECORD_EMP,
		PO.RECORD_DATE,
		PO.UPDATE_EMP,
		PO.UPDATE_DATE,
		PO.PRINT_COUNT,
		PO.IS_STAGE,
		PO.WORK_ID,
		S.PROPERTY,
		P.PRODUCT_NAME,
		P.PRODUCT_ID,
		S.STOCK_ID,
		S.STOCK_CODE,
		ISNULL(PO.RESULT_AMOUNT,0) ROW_RESULT_AMOUNT2,
		ISNULL((SELECT SUM(POR_.AMOUNT) ORDER_AMOUNT
		FROM
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND 
			POR_.P_ORDER_ID = PO.P_ORDER_ID AND 
			POR_.TYPE = 1 <!---AND 
			POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)--->
		),0) ROW_RESULT_AMOUNT,
		ISNULL((SELECT SUM(POR_.AMOUNT) ORDER_AMOUNT
		FROM
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND 
			POO.P_ORDER_ID = PO.P_ORDER_ID AND 
			POR_.TYPE = 1 AND 
			POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
		),0) RESULT_AMOUNT
	FROM
		TEXTILE_PRODUCTION_ORDERS_MAIN POM
		LEFT JOIN TEXTILE_SAMPLE_REQUEST ON TEXTILE_SAMPLE_REQUEST.REQ_ID=POM.REQ_ID,
		PRODUCTION_ORDERS PO,
		STOCKS S,
		PRODUCT P
		WHERE
		POM.PARTY_ID=PO.PARTY_ID AND
		POM.PARTY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.party_id#"> AND
		PO.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>
<cfif len(GET_DET_PO.req_id)>
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	attributes.req_id=GET_DET_PO.req_id;
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>
<cfelse>
		<cfset getAsset.recordcount=0>
</cfif>
<cfquery name="GET_DET_PO_party" dbtype="query">
	select 
		SUM(QUANTITY) QUANTITY,
		SUM(ROW_RESULT_AMOUNT) ROW_RESULT_AMOUNT 
	from GET_DET_PO 
</cfquery>
<cfif not get_det_po.recordcount>
	<cfset hata  = 10>
	Hata!
    <cfabort>
</cfif>
<cfscript>
	attributes.stock_id = get_det_po.stock_id;
</cfscript>
<cfinclude template="/V16/production_plan/query/get_station_infos.cfm">
<!---cfinclude template="../query/get_pr_order_id.cfm">--->
<cfquery name="get_p_order_result" datasource="#DSN3#">
SELECT
	PR_ORDER_ID
FROM
	PRODUCTION_ORDER_RESULTS_MAIN PORM,
	PRODUCTION_ORDER_RESULTS POR
WHERE
	PORM.PARTY_ID=POR.PARTY_ID and
	POR.PARTY_ID=#attributes.party_id#
</cfquery>
<cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
	SELECT 
		DISTINCT
		ORDERS.ORDER_ID,
		ORDERS.ORDER_NUMBER,
		COMPANY.FULLNAME,
		<!---ORDER_ROW.WRK_ROW_ID,--->
		ORDER_ROW.PRODUCT_ID
	FROM
		ORDERS
		LEFT JOIN #dsn_alias#.COMPANY on COMPANY.COMPANY_ID=ORDERS.COMPANY_ID,
		ORDER_ROW,
		PRODUCTION_ORDERS,
		PRODUCTION_ORDERS_ROW
	WHERE
		PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
		<!---PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND--->
		PRODUCTION_ORDERS.PARTY_ID=#attributes.party_id# and
		PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID and
		ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID AND
		PRODUCTION_ORDERS_ROW.ORDER_ROW_ID=ORDER_ROW.ORDER_ROW_ID
</cfquery>
<cfif GET_ORDER_ROW.RECORDCOUNT>
	<cfquery name="GET_ORDER_ROW_1" datasource="#DSN3#">
		SELECT
			ORDER_ROW_ID,
			SPECT_VAR_ID,
			SPECT_VAR_NAME
		FROM
			ORDER_ROW
		WHERE
			ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row.order_id#"> AND
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> 
	</cfquery>
</cfif>
<cfquery name="GET_ORDER_RESULT" datasource="#DSN3#"><!--- Sonuç girilip girilmediğini kontrolü için kullanılıyor. --->
    SELECT
        POR.PR_ORDER_ID,
        POR.START_DATE,
        POR.FINISH_DATE,
        POR.RESULT_NO,
        POR.POSITION_ID,
        POR.STATION_ID
    FROM
		<!---PRODUCTION_ORDER_RESULTS_MAIN PORM,--->
        PRODUCTION_ORDER_RESULTS POR,
		PRODUCTION_ORDER_RESULTS_ROW PORR,
		PRODUCTION_ORDERS PO
    WHERE
		<!---PORM.PARTY_ID=POR.PARTY_ID AND--->
		POR.PR_ORDER_ID=PORR.PR_ORDER_ID AND
		PO.P_ORDER_ID=PORR.P_ORDER_ID AND 
		POR.PARTY_ID=#attributes.party_id#
        <!---PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">--->
</cfquery>
<!--- Üretimin altında ilişkili olan üretim emri varmı diye bakıyoru,eğer varsa üretim içinde ürün ve spec değişimlerini yaptırmayacağız.Şimdilik böyle yapıyoruz eğer istek olursa
üretim emri ekleme sayfasında olduğu gibi bir ajax ile alt bileşenlerini gösterip ona göre üretim emrini silip seçilen yeni ürün ve spec'e göre üretim emrini güncelliyeceğiz..! M.ER 24102008
 --->
<cfset prod_and_spec_disp = ''>
<cfquery name="GET_PRODUCTION_ORDERS_RELATED" datasource="#DSN3#">
	SELECT TOP 1 P_ORDER_ID FROM PRODUCTION_ORDERS 
	WHERE PO_RELATED_ID IS NOT NULL  AND PARTY_ID=#attributes.party_id#
	<!---= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">--->
</cfquery>
<cfif GET_PRODUCTION_ORDERS_RELATED.recordcount>
	<cfset prod_and_spec_disp = 'style="display:none;"'>
</cfif>
<cfif len(GET_DET_PO.DEMAND_NO) and GET_DET_PO.IS_STAGE eq -1 and GET_DET_PO.IS_STOCK_RESERVED eq 0><cfset is_demand = 1></cfif>

<cfif isdate(get_det_po.START_DATE) and IsDate(get_det_po.FINISH_DATE)><cfset date_control = 1><cfelse><cfset date_control =0></cfif>
<cf_catalystHeader>

<div class="row">
<!-------ürün kunyesi-------->
<cfinclude template="../../sales/query/get_req.cfm">
<div class="col col-12">
	<cf_box id="sample_request" closable="1" unload_body = "1"  title="Numune Özet" >
		<div class="col col-10 col-xs-12 ">
				<cfinclude template="../../common/get_opportunity_type.cfm">
				<cfinclude template="../../sales/display/dsp_sample_request.cfm">
		</div>
		<div class="col col-2 col-xs-2">
			<cfinclude template="../../objects/display/asset_image.cfm">
		</div>
	</cf_box>
</div>
<!-------ürün kunyesi-------->
<div class="row">		
	<div class="col col-9 col-xs-12 uniqueRow">
		<div class="row formContent">
            <cfform name="add_production_order" method="post" action="#request.self#?fuseaction=textile.order&event=updquery">
   	 		<input name="is_generate_serial_nos" id="is_generate_serial_nos" type="hidden" value="<cfoutput>#is_generate_serial_nos#</cfoutput>">
            <input name="po_related_id" id="po_related_id" type="hidden" value="<cfoutput>#get_det_po.po_related_id#</cfoutput>">
			<cfinclude template="../display/production_orders_main.cfm"> <!--- Üretim Emirleri ekranı birinci kısım --->
			
			<cfsavecontent variable="message">Üretim Emri Verilen Ürünler</cfsavecontent>
					<cf_seperator title="#message#" id="REL_ORD_LIST" is_closed="1">
					<cfset _ajax_str_ = "&party_id=#attributes.party_id#&IS_DEMONTAJ=#GET_DET_PO.IS_DEMONTAJ#&SPECT_VAR_ID=#GET_DET_PO.SPECT_VAR_ID#&IS_PRODUCTION=#GET_DET_PO.IS_PRODUCTION#&IS_PROTOTYPE=#GET_DET_PO.IS_PROTOTYPE#&urun_carpan=#GET_DET_PO.quantity#&STOCK_ID=#GET_DET_PO.STOCK_ID#&start_date=#GET_DET_PO.start_date#&finish_date=#GET_DET_PO.finish_date#&project_id=#GET_DET_PO.project_id#&order_idd=#GET_ORDER_ROW.ORDER_ID#&row_id=&fuse=#attributes.fuseaction#&rbproductid=#GET_ORDER_ROW.PRODUCT_ID#&party_no=#GET_DET_PO.PARTY_NO#">
					<div id="REL_ORD_LIST" style="display:none;">
						<cfinclude template="../display/list_related_p_orders.cfm"> <!--- Üretim Emirleri ekranı üretim emri verilen ürünler kısmı --->
					</div>
			
			<cfinclude template="sub_product_fire.cfm">

            <div class="row formContentFooter">
	            <div class="col col-6 col-xs-12">
	                <cfif len(get_det_po.record_emp)>
	                    <cf_get_lang_main no='71.Kayıt'>: <cfoutput>#get_emp_info(get_det_po.record_emp,0,0)# - #dateFormat(get_det_po.record_date,'dd/mm/yyyy')# #timeformat(date_add('h',session.ep.time_zone, get_det_po.record_date),'HH:MM')#</cfoutput> 
	                </cfif>
	                <cfif len(get_det_po.update_emp)>
	                    <cf_get_lang_main no='291.Güncelleme'>: <cfoutput>#get_emp_info(get_det_po.update_emp,0,0)# - #dateFormat(get_det_po.update_date,'dd/mm/yyyy')# #timeformat(date_add('h',session.ep.time_zone, get_det_po.update_date),'HH:MM')#</cfoutput> 
	                </cfif>
	                <cf_get_lang no="479.Print Sayısı"> :<cfoutput>#get_det_po.print_count#</cfoutput>
	            </div>
	            <div class="col col-6 col-xs-12">
						 		 <cfif is_result_control eq 1 and get_order_result.recordcount eq 0><!--- sonuclari kontrol et denildiğinde sonuc yoksa bu emir icin islem yapilabilir--->
                                    <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' type_format="1" is_delete='1' delete_page_url='#request.self#?fuseaction=textile.order&event=del&party_id=#attributes.party_id#&name=#get_det_po.p_order_no#&PO_RELATED_ID=#GET_DET_PO.PO_RELATED_ID#'>
                                <cfelseif is_result_control eq 1 and get_order_result.recordcount gt 0><!--- sonuclari kontrol et denildiğinde sonuc varsa bu emir icin islem yapilamaz--->
                                <cfelseif is_result_control eq 0 and get_order_result.recordcount eq 0><!--- sonuclari kontrol etme denildiğinde sonuc yoksa bu emir icin islem yapilabilir--->
                                    <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' type_format="1" is_delete='1' delete_page_url='#request.self#?fuseaction=textile.order&event=del&party_id=#attributes.party_id#&name=#get_det_po.p_order_no#&PO_RELATED_ID=#GET_DET_PO.PO_RELATED_ID#'>
                                <cfelseif is_result_control eq 0 and get_order_result.recordcount gt 0><!--- sonuclari kontrol etme denildiğinde sonuc varsa bu emir icin sadece güncelleme yapilabilir--->
                                    <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' type_format="1" is_delete='0'>
                                </cfif>              
	        	</div>
	    	</div>
	        </cfform>  
		</div> 
        <div class="row">
				<!---ilişkili parti emirleri---->
				<br />
			<cfset _ajax_str_ = "&party_id=#attributes.party_id#&IS_DEMONTAJ=#GET_DET_PO.IS_DEMONTAJ#&SPECT_VAR_ID=#GET_DET_PO.SPECT_VAR_ID#&IS_PRODUCTION=#GET_DET_PO.IS_PRODUCTION#&IS_PROTOTYPE=#GET_DET_PO.IS_PROTOTYPE#&urun_carpan=#GET_DET_PO.quantity#&STOCK_ID=#GET_DET_PO.STOCK_ID#&start_date=#GET_DET_PO.start_date#&finish_date=#GET_DET_PO.finish_date#&project_id=#GET_DET_PO.project_id#&order_idd=#GET_ORDER_ROW.ORDER_ID#&row_id=&fuse=#attributes.fuseaction#&rbproductid=#GET_ORDER_ROW.PRODUCT_ID#&party_no=#GET_DET_PO.PARTY_NO#">
		<!---	<cfsavecontent variable="message">İlişkili Parti Emirleri</cfsavecontent>
            <cf_box 
				id="REL_PRT_LIST"  
				title="#message#" 
				unload_body="1" 
				closable="0"  
				style="width:100%;" 
				box_page="#request.self#?fuseaction=textile.popup_ajax_list_related_party#_ajax_str_#">
            </cf_box>--->
			<!---
			<cfif is_show_prod_amount eq 1>
				<cfsavecontent variable="message"><cf_get_lang no ='79.Malzeme ihtiyaç Tablosu'></cfsavecontent>
				<cfset this_production_amount = GET_DET_PO.QUANTITY><!--- Bu değişken malzeme ihtiyaçları sayfasına bakarken bu üretimden kaynaklanan üretim rezervelerini yani sarf ürünleri için üretim rezervelerini göstermesin diye eklendi..Malzeme ihtiyaçları sayfasında sarf ürünlerin Satılabilir Stok miktarından düşülecek! --->
				<cf_box 
					id="DET_MET"  
					title="#message#" 
					unload_body="1" 
					closable="0"  
					style="width:100%;" 
					box_page="#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&p_order_id=#attributes.upd#&p_order_no=#GET_DET_PO.p_order_no#&stock_id=#GET_DET_PO.STOCK_ID#&order_amount=#GET_DET_PO.quantity#&spect_main_id=#GET_DET_PO.SPEC_MAIN_ID#&spect_var_id=#GET_DET_PO.SPECT_VAR_ID#&from_upd_production_page=1&this_production_amount=#this_production_amount#&is_zero_amount_kontrol=#is_zero_amount_kontrol#&is_real_stock_from_dept=#is_real_stock_from_dept#&is_prod_real_stock=#is_prod_real_stock#&prod_finish_date=#GET_DET_PO.FINISH_DATE#">
				</cf_box>            
			</cfif>--->
			<cfif is_show_prod_amount eq 1>
				<cfsavecontent variable="message"><cf_get_lang no ='79.Malzeme ihtiyaç Tablosu'></cfsavecontent>
				<cfset this_production_amount = GET_DET_PO.QUANTITY><!--- Bu değişken malzeme ihtiyaçları sayfasına bakarken bu üretimden kaynaklanan üretim rezervelerini yani sarf ürünleri için üretim rezervelerini göstermesin diye eklendi..Malzeme ihtiyaçları sayfasında sarf ürünlerin Satılabilir Stok miktarından düşülecek! --->
				<!---<cf_box 
					id="DET_MET"  
					title="#message#" 
					unload_body="1" 
					closable="0"  
					style="width:100%;" 
					box_page="#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&p_order_id=#attributes.upd#&p_order_no=#GET_DET_PO.p_order_no#&stock_id=#GET_DET_PO.STOCK_ID#&order_amount=#GET_DET_PO.quantity#&spect_main_id=#GET_DET_PO.SPEC_MAIN_ID#&spect_var_id=#GET_DET_PO.SPECT_VAR_ID#&from_upd_production_page=1&this_production_amount=#this_production_amount#&is_zero_amount_kontrol=#is_zero_amount_kontrol#&is_real_stock_from_dept=#is_real_stock_from_dept#">
				</cf_box>--->        
			</cfif>
                <cfsavecontent variable="message">Üretim Sonuçları</cfsavecontent>
                <cf_box 
                    id="REL_ORD"  
                    title="#message#" 
                    unload_body="1" 
                    closable="0"  
                    style="width:100%;" 
                    box_page="#request.self#?fuseaction=textile.popup_ajax_related_order_results&date_control=#date_control##_ajax_str_#">
				</cf_box> 
				<cf_get_textile_labor_critics company_id='#GET_DET_PO.company_id#' action_section='TEXTILE_SAMPLE_REQUEST' action_id='#GET_DET_PO.REQ_ID#'>
</div>        
    </div>
	<div class="col col-3 col-xs-12 uniqueRow">
			<!----
			<cfif getAsset.recordcount>
			<cf_box title="Numune Resim">
				<cfset attributes.is_saveimage=0>
				<cfinclude template="../../objects/display/asset_image.cfm">
			</cf_box>
			</cfif>
			----->
			<!--- Varlıklar --->
			<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='35' action_section='P_ORDER_ID' action_id='#attributes.party_id#'>
			<!--- Notlar --->
			<cf_get_workcube_note company_id="#session.ep.company_id#" action_section='P_ORDER_ID' action_id='#attributes.party_id#'><br/>
    </div>
</div>
<form name="aktar_form" method="post">
			<input type="hidden" name="list_price" id="list_price" value="0">
			<input type="hidden" name="price_cat" id="price_cat" value="">
			<input type="hidden" name="CATALOG_ID" id="CATALOG_ID" value="">
			<input type="hidden" name="NUMBER_OF_INSTALLMENT" id="NUMBER_OF_INSTALLMENT" value="">
			<input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
			<input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
			<input type="hidden" name="convert_price" id="convert_price" value="">
			<input type="hidden" name="convert_price_other" id="convert_price_other" value="">
			<input type="hidden" name="convert_money" id="convert_money" value="">
		    <input type="hidden" name="convert_relation_id" id="convert_relation_id" value="">
			<input type="hidden" name="convert_row_detail" id="convert_row_detail" value="">
			<!---<input type="hidden" name="convert_action_id" id="convert_action_id" value="">--->
		</form>
<script type="text/javascript">
	function pencere_ac_spect(no,type)
	{
		if(type==2)
		{	
			form_stock = document.getElementById("stock_id_exit"+no);
			<cfif GET_DET_PO.IS_DEMONTAJ eq 1>
				url_str='&field_main_id=add_production_order.spec_main_id_exit'+no+'&field_var_id=add_production_order.spect_id_exit'+no+'&field_id=add_production_order.spect_id_exit'+no+'&field_name=add_production_order.spect_name_exit' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&is_demontaj=1&p_order_id=<cfoutput>#attributes.upd#</cfoutput>';
			<cfelse>
				url_str='&field_main_id=add_production_order.spec_main_id_exit'+no+'&field_var_id=add_production_order.spect_id_exit'+no+'&field_id=add_production_order.spect_id_exit'+no+'&field_name=add_production_order.spect_name_exit' + no + '&stock_id=' + form_stock.value+'&create_main_spect_and_add_new_spect_id=1';
			</cfif>
			
		}
		else if(type==3)
		{
			form_stock = document.getElementById("stock_id_outage"+no);
			<cfif GET_DET_PO.IS_DEMONTAJ eq 1>
				url_str='&field_main_id=add_production_order.spec_main_id_outage'+no+'&field_id=add_production_order.spect_id_outage'+no+'&field_name=add_production_order.spect_name_outage' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&is_demontaj=1&p_order_id=<cfoutput>#attributes.upd#</cfoutput>&field_var_id=add_production_order.spect_id_outage'+no;
			<cfelse>
				url_str='&field_main_id=add_production_order.spec_main_id_outage'+no+'&field_id=add_production_order.spect_id_outage'+no+'&field_name=add_production_order.spect_name_outage' + no + '&stock_id=' + form_stock.value+'&create_main_spect_and_add_new_spect_id=1&field_var_id=add_production_order.spect_id_outage'+no;
			</cfif>
		}
		if(form_stock.value == "")
			alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'>**");
		else
			 windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1' + url_str,'list');
	}

	function date_control()
	{   
		if($('#start_date').val() != "" && $('#finish_date').val() != "")
			return time_check(document.getElementById('start_date'), document.getElementById('start_h'), document.getElementById('start_m'), document.getElementById('finish_date'),  document.getElementById('finish_h'), document.getElementById('finish_m'), "<cf_get_lang no ='605.Üretim Başlama Tarihi,Bitiş Tarihinden Önce Olmalıdır'>!");
		else
			{alert("<cf_get_lang no ='553.Başlangıç ve Bitiş Tarihini Düzgün Giriniz'>");return false;}
	}
	
	function unformat_fields()
	{
		_kontol_ = date_control();
		if(_kontol_ == true)
		{
		/*	if($('#stock_id').val() == "")
			{
				alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'> !");
				return false;
			}
			*/
			if(add_production_order.product_id.value == "")
			{
				alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'> !");
				return false;
			}
			
			if($('#station_id').val() == "")// && (add_production_order.route_id.value == "")
			{
				alert("<cf_get_lang no='477.İstasyon Seçmek Zorundasınız'> !");
				return false;
			}
			<cfif is_station_amount_kontrol eq 1>
				var listParam = add_production_order.stock_id.value + "*" +  add_production_order.station_id.value
				var get_station = wrk_safe_query("prdp_get_station_2",'dsn3',0,listParam);
				if(get_station.recordcount > 0 && get_station.MIN_PRODUCT_AMOUNT > 0)
				{
					if(filterNum(document.getElementById('quantity').value) < get_station.MIN_PRODUCT_AMOUNT)
					{
						alert("İstasyon Tanımlarındaki Minimum Üretim Miktarından Az Üretim Emri Veremezsiniz !");
						return false;
					}
				}
			</cfif>
			if($('#p_order_no'))
			{
				var listParam = $('#p_order_no').val() + "*" + "<cfoutput>#attributes.party_id#</cfoutput>";
				var paper_number= wrk_safe_query("prdp_paper_number",'dsn3',0,listParam);
				if(paper_number.recordcount) // ayni uretim varsa uyari ver FB20080704
				{
					alert("<cf_get_lang no ='554.Bu Üretim Numarasına Ait Kayıt Vardır Lütfen Kontrol Ediniz'> !");
					return false;
				}
			}
		/*	var stock_id_exit_list = "";
			for (var k=1;k<=row_count_exit;k++)
			{
				if($('#row_kontrol_exit'+k).val() == 1)
				{
					stock_id_exit_list+=$('#stock_id_exit'+k).val()+",";
				}
			}
			var stock_id_outage_list = "";
			for (var k=1;k<=row_count_outage;k++)
			{
				if($('#row_kontrol_outage'+k).val() == 1)
				{
					stock_id_outage_list+=$('#stock_id_outage'+k).val()+",";
				}
			}*/
			return process_cat_control();
		}
		else
		return false;
	}
	function calc_deliver_date()
	{
		stock_id_list = '';
		var row_c = $('#stock_id').length;
		if(row_c != 0)
		{
			if($('#quantity').val() == "")
			{
				alert("<cf_get_lang no ='73.Miktar Giriniz'>!");
				return false;
			}
			else
			{
				var n_stock_id = $('#stock_id').val();
				var n_amount = filterNum($('#quantity').val(),6);
				var n_spect_id = $('#spect_var_id').val();
				var n_is_production = 1;
				if(n_spect_id == "") n_spect_id =0;
				if(n_stock_id != "" && n_is_production ==1)//ürün silinmemiş ise
					stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
				$('#deliver_date_info').show();
				//document.getElementById('deliver_date_info').style.display='';
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_ajax_deliver_date_calc&is_from_order=1&from_p_order_list=1&stock_id_list='+stock_id_list+'','deliver_date_info',1,"<cf_get_lang no ='170.Tarih Hesaplanıyor'>");
			}
		}
		else
			alert("<cf_get_lang no ='364.Ürün Seçmelisiniz'> ");	
	}
	function aktar()
	{
		var sarf_uzunluk = $('#product_sarf_recordcount').val();
		if(sarf_uzunluk>0)
		{
			for (i=1;i<=sarf_uzunluk;i++)
			{
				if($('#is_free_amount_exit'+i).val() == 0)// && eval("document.getElementById('spect_main_row_exit'+i)").value != ''
				{
					<cfif get_det_po.is_demontaj eq 0>
						var x=parseInt($('#quantity').val());
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
						{
							$('#amount_exit'+i).val( (filterNum($('#amount_exit_'+i).val(),8))/(filterNum($('#quantity_').val(),8))*(filterNum($('#quantity').val(),8)) );
							var a = $('#amount_exit'+i).val();
							var b=commaSplit(a,8);
							$('#amount_exit'+i).val(b);
						}	
					</cfif>
				}
				<cfif get_det_po.is_demontaj eq 1>
					var x=parseInt($('#amount_exit'+1).val());
					if(x>0)/*Demontaj yapılacak ürün miktarı 1 den fazla ise*/
						{
							var get_det_po_quantity = "<cfoutput>#get_det_po.QUANTITY#</cfoutput>";
							$('#quantity').val( (filterNum($('#quantity_').val(),8)/parseFloat(get_det_po_quantity))*filterNum($('#amount_exit'+1).val(),8) );
							var a = $('#quantity').val();
							//var a=document.getElementById('quantity').value=(filterNum(document.getElementById('quantity_').value,8)/parseFloat(<cfoutput>#get_det_po.QUANTITY#</cfoutput>))*filterNum(eval("document.getElementById('amount_exit'+1)").value,8);
							var b=commaSplit(a,8);
							$('#quantity').val(b);
						}
				</cfif>
			}
		}
		var fire_uzunluk = $('#product_fire_recordcount').val();
		if(fire_uzunluk>0)
		{
			for (i=1;i<=fire_uzunluk;i++)
			{
				if($('#is_free_amount_outage'+i).val() == 0)// && eval("document.getElementById('spect_main_row_outage'+i)").value != ''
				{
					<cfif get_det_po.is_demontaj eq 0>
						var x=parseInt($('#quantity').val());
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
						{
							$('#amount_outage'+i).val( (filterNum($('#amount_outage_'+i).val(),8))/(filterNum($('#quantity_').val(),8))*(filterNum($('#quantity').val(),8)) );
							var a = $('#amount_outage'+i).val();
							var b=commaSplit(a,8);
							$('#amount_outage'+i).val(b);
						}	
					</cfif>
				}
			}
		}
	}
	function aktar2(type,crnt)
	{
		if(type == 2)
		{
			if($('#amount_exit'+crnt).val() != '')
				$('#amount_exit_'+crnt).val($('#amount_exit'+crnt).val());
			else
			{
				$('#amount_exit'+crnt).val(1);
				$('#amount_exit_'+crnt).val(1);
			}
		}	
		if(type == 3)
		{
			if($('#amount_outage'+crnt).val() != '')
				$('#amount_outage_'+crnt).val($('#amount_outage'+crnt).val());
			else
			{
				$('#amount_outage'+crnt).val(1);
				$('#amount_outage_'+crnt).val(1);
			}
		}	
	}
	function pencere_ac_alternative(no,pid,sid,main_stock_id)//sarf ürünlerin alternatiflerini açıyor
	{
		form_stock = eval('add_production_order.stock_id_exit'+no);
		<cfif is_add_alternative_product eq 1>
			//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
			url_str='&tree_info_null_=1&product_id=add_production_order.product_id_exit'+no+'&call_function=calc_amount_exit&call_function_paremeter='+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_name=add_production_order.product_name_exit' + no + '&field_amount=add_production_order.amount_exit' + no + '&field_unit=add_production_order.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
		<cfelse>
			sqlstr = 'SELECT TOP 1 P.STOCK_ID FROM SPECT_MAIN_ROW SR,ALTERNATIVE_PRODUCTS AP,PRODUCT_TREE P,SPECT_MAIN WHERE SR.PRODUCT_ID = AP.PRODUCT_ID AND SR.RELATED_TREE_ID = P.PRODUCT_TREE_ID AND AP.TREE_STOCK_ID = P.STOCK_ID AND AP.PRODUCT_ID = '+ pid +' AND AP.QUESTION_ID <> 0 AND AP.TREE_STOCK_ID = '+ main_stock_id +' AND P.RELATED_ID = SR.STOCK_ID AND SR.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID';
			my_query = wrk_query(sqlstr,'dsn3');
			if(my_query.recordcount)
			sid = my_query.STOCK_ID;

			url_str='&tree_stock_id='+sid+'&product_id=add_production_order.product_id_exit'+no+'&call_function=calc_amount_exit&call_function_paremeter='+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_name=add_production_order.product_name_exit' + no + '&field_amount=add_production_order.amount_exit' + no + '&field_unit=add_production_order.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=0';
		</cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}
	function pencere_ac_alternative_outage(no,pid,sid,main_stock_id)//fire ürünlerin alternatiflerini açıyor
	{
		form_stock = eval('add_production_order.stock_id_outage'+no);
		<cfif is_add_alternative_product eq 1>
			//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
			url_str='&tree_info_null_=1&product_id=add_production_order.product_id_outage'+no+'&call_function=calc_amount_outage&call_function_paremeter='+no+'&run_function=alternative_product_cost_outage&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_name=add_production_order.product_name_outage' + no + '&field_unit=add_production_order.unit_id_outage'+no+'&field_amount=add_production_order.amount_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
		<cfelse>
			sqlstr = 'SELECT TOP 1 P.STOCK_ID FROM SPECT_MAIN_ROW SR,ALTERNATIVE_PRODUCTS AP,PRODUCT_TREE P,SPECT_MAIN WHERE SR.PRODUCT_ID = AP.PRODUCT_ID AND SR.RELATED_TREE_ID = P.PRODUCT_TREE_ID AND AP.TREE_STOCK_ID = P.STOCK_ID AND AP.PRODUCT_ID = '+ pid +' AND AP.QUESTION_ID <> 0 AND AP.TREE_STOCK_ID = '+ main_stock_id +' AND P.RELATED_ID = SR.STOCK_ID AND SR.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID';
			my_query = wrk_query(sqlstr,'dsn3');
			if(my_query.recordcount)
			sid = my_query.STOCK_ID;
			url_str='&tree_stock_id='+sid+'&product_id=add_production_order.product_id_outage'+no+'&call_function=calc_amount_outage&call_function_paremeter='+no+'&run_function=alternative_product_cost_outage&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_name=add_production_order.product_name_outage' + no + '&field_unit=add_production_order.unit_id_outage'+no+'&field_amount=add_production_order.amount_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=0';
		</cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}
	
	function alternative_product_cost(pid,no)
	{
		//ürün değiştiği için spectler sıfırlanıyor
		$('#spec_main_id_exit'+no).val("");
		$('#spect_name_exit'+no).val("");
	}
	function alternative_product_cost_outage(pid,no)
	{
		//ürün değiştiği için spectler sıfırlanıyor
		$('#spec_main_id_outage'+no).val("");
		$('#spect_name_outage'+no).val("");
	}
	function get_stok_spec_detail_ajax(product_id)
	{
		goster(prod_stock_and_spec_detail_div);
		tempX = event.clientX + document.body.scrollLeft;
		tempY = event.clientY + document.body.scrollTop;
		document.getElementById('prod_stock_and_spec_detail_div').style.left = tempX+10;
		document.getElementById('prod_stock_and_spec_detail_div').style.top = tempY;
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&from_production_result_detail=1&pid='+product_id+'</cfoutput>','prod_stock_and_spec_detail_div',1)	
	}	
	function get_stok_spec_detail_ajax_outage(product_id)
	{
		goster(prod_stock_and_spec_detail_div);
		tempX = event.clientX + document.body.scrollLeft;
		tempY = event.clientY + document.body.scrollTop;
		document.getElementById('prod_stock_and_spec_detail_div').style.left = tempX+10;
		document.getElementById('prod_stock_and_spec_detail_div').style.top = tempY;
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&from_production_result_detail=1&pid='+product_id+'</cfoutput>','prod_stock_and_spec_detail_div',1)	
	}	
	function sil_exit(sy)
	{
		var my_element=document.getElementById("row_kontrol_exit"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_exit"+sy);
		my_element.style.display="none";	
	}
	function sil_outage(sy)
	{
		var my_element=document.getElementById("row_kontrol_outage"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_outage"+sy);
		my_element.style.display="none";
	}
	row_count_exit = <cfoutput>#deger_value_row#</cfoutput>;
	satir_sarf = document.getElementById("table2").rows.length;
	
	function add_row_exit(is_add_info_,row_kontrol_exit,is_phantom_exit,is_sevk_exit,is_property_exit,is_free_amount_exit,stock_code_exit,product_id_exit,stock_id_exit,product_name_exit,stock_code_exit,spec_main_id_exit,spect_name_exit,lot_no_exit,amount_exit,unit_id_exit,unit_exit,spect_id_exit)
	{
		if(is_add_info_==undefined) is_add_info_=1;
		if(row_kontrol_exit==undefined) row_kontrol_exit="";
		if(is_phantom_exit==undefined) is_phantom_exit="";
		if(is_sevk_exit==undefined) is_sevk_exit="";
		if(is_property_exit==undefined) is_property_exit="";
		if(is_free_amount_exit==undefined) is_free_amount_exit="";
		if(stock_code_exit==undefined) stock_code_exit="";
		if(product_id_exit==undefined) product_id_exit="";
		if(stock_id_exit==undefined) stock_id_exit="";
		if(product_name_exit==undefined) product_name_exit="";
		if(stock_code_exit==undefined) stock_code_exit="";
		if(spec_main_id_exit==undefined) spec_main_id_exit="";
		if(spect_name_exit==undefined) spect_name_exit="";
		if(lot_no_exit==undefined) lot_no_exit="";
		if(amount_exit==undefined) amount_exit=1;
		if(unit_id_exit==undefined) unit_id_exit="";
		if(unit_exit==undefined) unit_exit="";
		if(spect_id_exit==undefined) spect_id_exit="";
		
		row_count_exit++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row_exit" + row_count_exit);
		newRow.setAttribute("id","frm_row_exit" + row_count_exit);
		newRow.setAttribute("NAME","frm_row_exit" + row_count_exit);
		newRow.setAttribute("ID","frm_row_exit" + row_count_exit);
		newRow.className = 'color-row';
		document.add_production_order.record_num_exit.value = row_count_exit;
		<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="copy_row_exit('+row_count_exit+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a><a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="'+is_add_info_+'"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="is_phantom_exit' + row_count_exit +'" id="is_phantom_exit' + row_count_exit +'" value="'+ is_phantom_exit+'"><input type="hidden" name="is_sevk_exit' + row_count_exit +'" id="is_sevk_exit' + row_count_exit +'" value="'+ is_sevk_exit+'"><input type="hidden" name="is_property_exit' + row_count_exit +'" id="is_property_exit' + row_count_exit +'" value="'+ is_property_exit+'"><input type="hidden" name="is_free_amount_exit' + row_count_exit +'" id="is_free_amount_exit' + row_count_exit +'" value="'+ is_free_amount_exit+'"><input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="'+stock_code_exit+'" readonly style="width:150px; border:none;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'"  value="'+ product_id_exit+'"><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value="'+ stock_id_exit+'"><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'" readonly style="width:280px; border:none;" value="'+ product_name_exit+'"><a href="javascript://" onClick="pencere_ac_product('+ row_count_exit +');"> <img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'" readonly style="width:40px; border:none;" value="'+ spec_main_id_exit+'"><input type="hidden" name="spect_id_exit' + row_count_exit +'" id="spect_id_exit' + row_count_exit +'" value="'+ spect_id_exit+'"> <input name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" value="'+ spect_name_exit+'" readonly style="width:200px; border:none;"> <input type="hidden" name="spect_main_row_exit#currentrow#" id="spect_main_row_exit#currentrow#" value="#SPECT_MAIN_ROW_ID#"> <a href="javascript://" onclick="pencere_ac_spect(\'#currentrow#\',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>';
		<cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="lot_no_exit' + row_count_exit +'" id="lot_no_exit' + row_count_exit +'" value="'+ lot_no_exit +'" onKeyup="lotno_control(' + row_count_exit +',2);" style="width:100px; border:none;"/> <a href="javascript://" onclick="pencere_ac_list_product(' + row_count_exit +',2);"> <img src="/images/plus_thin.gif" style="cursor:pointer; border:none;" align="absbottom" border="0"></a> ';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="'+amount_exit+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px; border:none;"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="'+amount_exit+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px; border:none;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value="'+ unit_id_exit+'"><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'"  value="'+ unit_exit+'" readonly style="width:60px; border:none;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" name="sec' + row_count_exit +'"><input type="hidden" name="old_stock_id' + row_count_exit +'" id="old_stock_id' + row_count_exit +'" value="">';

		<!---newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a href="javascript://" onClick="open_product_sarf(' + row_count_exit +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="Alternatif Ürünler"></a>';--->
	}
	
	
	function copy_row_exit(no_info)
	{
		if ($("#is_add_info_" + no_info) == undefined) is_add_info_ =""; else is_add_info_ = $("#is_add_info_" + no_info).val();
		if ($("#row_kontrol_exit" + no_info) == undefined) row_kontrol_exit =""; else row_kontrol_exit = $("#row_kontrol_exit" + no_info).val();
		if ($("#is_phantom_exit" + no_info) == undefined) is_phantom_exit =""; else is_phantom_exit = $("#is_phantom_exit" + no_info).val();
		if ($("#is_sevk_exit" + no_info) == undefined) is_sevk_exit =""; else is_sevk_exit = $("#is_sevk_exit" + no_info).val();
		if ($("#is_property_exit" + no_info) == undefined) is_property_exit =""; else is_property_exit = $("#is_property_exit" + no_info).val();
		if ($("#is_free_amount_exit" + no_info) == undefined) is_free_amount_exit =""; else is_free_amount_exit = $("#is_free_amount_exit" + no_info).val();
		if ($("#stock_code_exit" + no_info) == undefined) stock_code_exit =""; else stock_code_exit = $("#stock_code_exit" + no_info).val();
		if ($("#product_id_exit" + no_info) == undefined) product_id_exit =""; else product_id_exit = $("#product_id_exit" + no_info).val();
		if ($("#stock_id_exit" + no_info) == undefined) stock_id_exit =""; else stock_id_exit = $("#stock_id_exit" + no_info).val();
		if ($("#product_name_exit" + no_info) == undefined) product_name_exit =""; else product_name_exit = $("#product_name_exit" + no_info).val();
		if ($("#stock_code_exit" + no_info) == undefined) stock_code_exit =""; else stock_code_exit = $("#stock_code_exit" + no_info).val();
		if ($("#spec_main_id_exit" + no_info) == undefined) spec_main_id_exit =""; else spec_main_id_exit = $("#spec_main_id_exit" + no_info).val();
		if ($("#spect_name_exit" + no_info) == undefined) spect_name_exit =""; else spect_name_exit = $("#spect_name_exit" + no_info).val();
		if ($("#lot_no_exit" + no_info) == undefined) lot_no_exit =""; else lot_no_exit = $("#lot_no_exit" + no_info).val();
		if ($("#amount_exit" + no_info) == undefined) amount_exit =""; else amount_exit = $("#amount_exit" + no_info).val();
		if ($("#unit_id_exit" + no_info) == undefined) unit_id_exit =""; else unit_id_exit = $("#unit_id_exit" + no_info).val();
		if ($("#unit_exit" + no_info) == undefined) unit_exit =""; else unit_exit = $("#unit_exit" + no_info).val();
		if ($("#spect_id_exit" + no_info) == undefined) spect_id_exit =""; else spect_id_exit = $("#spect_id_exit" + no_info).val();
		add_row_exit(is_add_info_,row_kontrol_exit,is_phantom_exit,is_sevk_exit,is_property_exit,is_free_amount_exit,stock_code_exit,product_id_exit,stock_id_exit,product_name_exit,stock_code_exit,spec_main_id_exit,spect_name_exit,lot_no_exit,amount_exit,unit_id_exit,unit_exit,spect_id_exit);
 }
	
	function pencere_ac_product(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&call_function=calc_amount_exit&call_function_paremeter='+no+'&stock_and_spect=1&product_id=add_production_order.product_id_exit'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_name=add_production_order.product_name_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_spect_main_id=add_production_order.spec_main_id_exit'+no+'&field_spect_main_name=add_production_order.spect_name_exit'+no+'&field_unit=add_production_order.unit_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_amount=add_production_order.amount_exit'+no,'list');
	}
	function calc_amount_exit(no)
	{
		$("#amount_exit" + no).val( filterNum($("#amount_exit" + no).val()) * filterNum($("#amount_exit_" + no).val()));
	}

	row_count_outage = <cfoutput>#deger_value_row_fire#</cfoutput>;
	function add_row_outage(is_add_info_,row_kontrol_outage,is_phantom_outage,is_sevk_outage,is_property_outage,is_free_amount_outage,stock_code_outage,product_id_outage,stock_id_outage,product_name_outage,stock_code_outage,spec_main_id_outage,spect_name_outage,lot_no_outage,amount_outage,unit_id_outage,unit_outage,spect_id_outage)
	{
		if(is_add_info_==undefined) is_add_info_=1;
		if(row_kontrol_outage==undefined) row_kontrol_outage="";
		if(is_phantom_outage==undefined) is_phantom_outage=0;
		if(is_sevk_outage==undefined) is_sevk_outage=0;
		if(is_property_outage==undefined) is_property_outage=4;
		if(is_free_amount_outage==undefined) is_free_amount_outage="";
		if(stock_code_outage==undefined) stock_code_outage="";
		if(product_id_outage==undefined) product_id_outage="";
		if(stock_id_outage==undefined) stock_id_outage="";
		if(product_name_outage==undefined) product_name_outage="";
		if(stock_code_outage==undefined) stock_code_outage="";
		if(spec_main_id_outage==undefined) spec_main_id_outage="";
		if(spect_name_outage==undefined) spect_name_outage="";
		if(lot_no_outage==undefined) lot_no_outage="";
		if(amount_outage==undefined) amount_outage=1;
		if(unit_id_outage==undefined) unit_id_outage="";
		if(unit_outage==undefined) unit_outage="";
		if(spect_id_outage==undefined) spect_id_outage="";

		row_count_outage++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);
		newRow.setAttribute("name","frm_row_outage" + row_count_outage);
		newRow.setAttribute("id","frm_row_outage" + row_count_outage);
		newRow.setAttribute("NAME","frm_row_outage" + row_count_outage);
		newRow.setAttribute("ID","frm_row_outage" + row_count_outage);
		newRow.className = 'color-row';
		document.add_production_order.record_num_outage.value = row_count_outage;
		<cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="copy_row_outage('+row_count_exit+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a><a style="cursor:pointer" onclick="sil_outage(' + row_count_outage + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="is_add_info_' + row_count_outage +'" id="is_add_info_' + row_count_outage +'" value="'+is_add_info_+'"><input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="is_phantom_outage' + row_count_outage +'" id="is_phantom_outage' + row_count_outage +'" value="'+is_phantom_outage+'"><input type="hidden" name="is_sevk_outage' + row_count_outage +'" id="is_sevk_outage' + row_count_outage +'" value="'+is_sevk_outage+'"><input type="hidden" name="is_property_outage' + row_count_outage +'" id="is_property_outage' + row_count_outage +'" value="'+is_property_outage+'"><input type="hidden" name="is_free_amount_outage' + row_count_outage +'" id="is_free_amount_outage' + row_count_outage +'" value="'+is_free_amount_outage+'"><input type="text" name="stock_code_outage' + row_count_outage +'" id="stock_code_outage' + row_count_outage +'"  value="'+stock_code_outage+'" readonly style="width:150px; border:none;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_outage' + row_count_outage +'" id="product_id_outage' + row_count_outage +'" value="'+product_id_outage+'"><input type="hidden" name="stock_id_outage' + row_count_outage +'" id="stock_id_outage' + row_count_outage +'"  value="'+stock_id_outage+'"><input type="text" name="product_name_outage' + row_count_outage +'" id="product_name_outage' + row_count_outage +'" value="'+product_name_outage+'" readonly style="width:280px; border:none;"><a href="javascript://" onClick="pencere_ac_product_outage('+ row_count_outage +');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="spec_main_id_outage' + row_count_outage +'" id="spec_main_id_outage' + row_count_outage +'" value="'+spec_main_id_outage+'" readonly style="width:40px; border:none;"><input type="hidden" name="spect_id_outage' + row_count_outage +'" id="spect_id_outage' + row_count_outage +'" value="'+spect_id_outage+'"> <input name="spect_name_outage' + row_count_outage +'" id="spect_name_outage' + row_count_outage +'" value="'+spect_name_outage+'" readonly style="width:200px; border:none;"> <a href="javascript://" onclick="pencere_ac_spect(\'#currentrow#\',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>';
		<cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="lot_no_outage' + row_count_outage +'" id="lot_no_outage' + row_count_outage +'" value="'+ lot_no_outage +'" onKeyup="lotno_control(' + row_count_outage +',3);" style="width:100px; border:none;"/> <a href="javascript://" onclick="pencere_ac_list_product(' + row_count_outage +',3);"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a> ';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_outage' + row_count_outage +'" id="amount_outage' + row_count_outage +'" value="'+amount_outage+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px; border:none;"><input type="hidden" name="amount_outage_' + row_count_outage +'" id="amount_outage_' + row_count_outage +'" value="'+amount_outage+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px; border:none;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id_outage' + row_count_outage +'" id="unit_id_outage' + row_count_outage +'"  value="'+unit_id_outage+'"><input type="text" name="unit_outage' + row_count_outage +'" id="unit_outage' + row_count_outage +'" value="'+unit_outage+'" readonly style="width:60px; border:none;">';
	
		
			
	
	}
	
	function copy_row_outage(no_info)
	{
		if ($("#is_add_info_" + no_info) == undefined) is_add_info_ =""; else is_add_info_ = $("#is_add_info_" + no_info).val();
		if ($("#row_kontrol_outage" + no_info) == undefined) row_kontrol_outage =""; else row_kontrol_outage = $("#row_kontrol_outage" + no_info).val();
		if ($("#is_phantom_outage" + no_info) == undefined) is_phantom_outage =""; else is_phantom_outage = $("#is_phantom_outage" + no_info).val();
		if ($("#is_sevk_outage" + no_info) == undefined) is_sevk_outage =""; else is_sevk_outage = $("#is_sevk_outage" + no_info).val();
		if ($("#is_property_outage" + no_info) == undefined) is_property_outage =""; else is_property_outage = $("#is_property_outage" + no_info).val();
		if ($("#is_free_amount_outage" + no_info) == undefined) is_free_amount_outage =""; else is_free_amount_outage = $("#is_free_amount_outage" + no_info).val();
		if ($("#stock_code_outage" + no_info) == undefined) stock_code_outage =""; else stock_code_outage = $("#stock_code_outage" + no_info).val();
		if ($("#product_id_outage" + no_info) == undefined) product_id_outage =""; else product_id_outage = $("#product_id_outage" + no_info).val();
		if ($("#stock_id_outage" + no_info) == undefined) stock_id_outage =""; else stock_id_outage = $("#stock_id_outage" + no_info).val();
		if ($("#product_name_outage" + no_info) == undefined) product_name_outage =""; else product_name_outage = $("#product_name_outage" + no_info).val();
		if ($("#stock_code_outage" + no_info) == undefined) stock_code_outage =""; else stock_code_outage = $("#stock_code_outage" + no_info).val();
		if ($("#spec_main_id_outage" + no_info) == undefined) spec_main_id_outage =""; else spec_main_id_outage = $("#spec_main_id_outage" + no_info).val();
		if ($("#spect_name_outage" + no_info) == undefined) spect_name_outage =""; else spect_name_outage = $("#spect_name_outage" + no_info).val();
		if ($("#lot_no_outage" + no_info) == undefined) lot_no_outage =""; else lot_no_outage = $("#lot_no_outage" + no_info).val();
		if ($("#amount_outage" + no_info) == undefined) amount_outage =""; else amount_outage = $("#amount_outage" + no_info).val();
		if ($("#unit_id_outage" + no_info) == undefined) unit_id_outage =""; else unit_id_outage = $("#unit_id_outage" + no_info).val();
		if ($("#unit_outage" + no_info) == undefined) unit_outage =""; else unit_outage = $("#unit_outage" + no_info).val();
		if ($("#spect_id_outage" + no_info) == undefined) spect_id_outage =""; else spect_id_outage = $("#spect_id_outage" + no_info).val();
		add_row_outage(is_add_info_,row_kontrol_outage,is_phantom_outage,is_sevk_outage,is_property_outage,is_free_amount_outage,stock_code_outage,product_id_outage,stock_id_outage,product_name_outage,stock_code_outage,spec_main_id_outage,spect_name_outage,lot_no_outage,amount_outage,unit_id_outage,unit_outage,spect_id_outage);
 	}
	
	function pencere_ac_product_outage(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&call_function=calc_amount_outage&call_function_paremeter='+no+'&stock_and_spect=1&product_id=add_production_order.product_id_outage'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_name=add_production_order.product_name_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_spect_main_id=add_production_order.spec_main_id_outage'+no+'&field_spect_main_name=add_production_order.spect_name_outage'+no+'&field_unit=add_production_order.unit_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no+'&field_amount=add_production_order.amount_outage'+no,'list');
	}
	function calc_amount_outage(no)
	{
		$("#amount_outage" + no).val( filterNum($("#amount_outage" + no).val()) * filterNum($("#amount_outage_" + no).val()));
	}
	function pencere_ac_list_product(no,type)//ürünlere lot_no ekliyor
	{
		if(type == 2)
		{//sarf ise type 2
			form_stock_code = $("#stock_code_exit"+no).val();
			if(form_stock_code!= undefined && form_stock_code!='')
			{
				url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=add_production_order.lot_no_exit'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
			}
			else
				alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
		}
		else if(type == 3)
		{//fire ise type 3
			form_stock_code = $("#stock_code_outage"+no).val();
			if(form_stock_code!= undefined && form_stock_code!='')
			{
				url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=add_production_order.lot_no_outage'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
			}
			else
				alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
		}
	}
	function lotno_control(crntrow,type)
	{
		//var prohibited=' [space] , ",    #,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], `, {, |,   }, , «, ';
		var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
		if(type == 2)
			lot_no = document.getElementById('lot_no_exit'+crntrow);
		else if(type ==3)
			lot_no = document.getElementById('lot_no_outage'+crntrow);
		toplam_ = lot_no.value.length;
		deger_ = lot_no.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],\"\,#,$,%,&,',(,),*,+,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!");
					lot_no.value = '';
					break;
				}
			}
		}
	}
		function open_product_sarf(no)
						{			
						
							eval('add_production_order.old_stock_id'+no).value=eval("add_production_order.stock_id_exit"+no).value;
							windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&field_code=add_production_order.stock_code_exit'+no+'&field_spect_main_id=add_production_order.spec_main_id_exit'+no+'&field_spect_main_name=add_production_order.spect_name_exit'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_name=add_production_order.product_name_exit'+no+'&product_id=add_production_order.product_id_exit'+no+'&field_unit=add_production_order.unit_id_exit'+no,'page');
						}
	function gondertalep(tip)
	{
		//İç Talep Oluştur
	
		var convert_list ="";
		var convert_list_amount ="";
		var convert_list_price ="";
		var convert_list_price_other="";
		var convert_list_money ="";
		var convert_date_list="";
		var convert_relation_id="";
		var convert_row_detail = "";
		var dep_="";
		var to_emp="<cfoutput>#session.ep.userid#</cfoutput>";
		
		for(var i=1;i<="<cfoutput>#get_product_sarf.recordcount#</cfoutput>";i++)
		{
			var chk=eval('document.all.sec'+i);
				if(chk.checked==true)
				{
					var stock_id=eval('document.all.stock_id_exit'+i).value;
					var amount=filterNum(eval('document.all.amount_exit'+i).value);
					convert_list +=stock_id+',';;
					convert_list_amount += amount+',';
					convert_list_price +='0'+',';
						convert_list_price_other +='0'+',';
					convert_list_money +='TL,';
					convert_row_detail += ' '+','; 
				}
		}
		
		
		konu='';
				
		document.getElementById('convert_stocks_id').value=convert_list;
		document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
		document.getElementById('convert_price').value=convert_list_price;
		document.getElementById('convert_price_other').value=convert_list_price_other;
		document.getElementById('convert_money').value=convert_list_money;
		document.getElementById('convert_relation_id').value=convert_relation_id;
		document.getElementById('convert_row_detail').value = convert_row_detail;
		
	
		
		if(convert_list)//Ürün Seçili ise
			{
				dep_id="";
				loc_id="";
				 windowopen('','wide','cc_paym');
				 if(tip==1)
				 {
				 
					konu=konu +' <cfoutput>#GET_ORDER_ROW.FULLNAME#</cfoutput> /'+' <cfoutput>#GET_ORDER_ROW.order_number#</cfoutput>';
				 
				 
				    url="<cfoutput>#request.self#?fuseaction=purchase.list_internaldemand&event=add&type=convert";
					url+='&ref_no=#GET_DET_PO.party_no# / #GET_ORDER_ROW.order_number#</cfoutput>&to_position_code='+to_emp+'&stage=-2&subject='+encodeURI(konu);
				 }
				 else if(tip==2)
				 {
					url="<cfoutput>#request.self#?fuseaction=stock.form_add_fis&type=convert&ref_no=#GET_DET_PO.party_no# / #GET_ORDER_ROW.order_number#</cfoutput>";
				 }

					
				aktar_form.action=url;
				aktar_form.target='cc_paym';
				aktar_form.submit();
			}
			else
				alert("<cf_get_lang_main no ='313.Lütfen ürün seçiniz'>.");
	}
</script>
