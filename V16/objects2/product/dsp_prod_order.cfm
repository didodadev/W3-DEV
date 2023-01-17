<cf_xml_page_edit fuseact="prod.add_prod_order">
<cfif not isnumeric(attributes.upd)>
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
		S.PROPERTY,
		P.PRODUCT_NAME,
		P.PRODUCT_ID,
		S.STOCK_ID,
		S.STOCK_CODE,
		ISNULL((SELECT
			SUM(POR_.AMOUNT) ORDER_AMOUNT
		FROM
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID
			AND POO.P_ORDER_ID = PO.P_ORDER_ID
			AND POR_.TYPE = 1
			AND POO.IS_STOCK_FIS = 1
			AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
		),0) ROW_RESULT_AMOUNT,
		ISNULL((SELECT
			SUM(POR_.AMOUNT) ORDER_AMOUNT
		FROM
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID
			AND POO.P_ORDER_ID = PO.P_ORDER_ID
			AND POR_.TYPE = 1
			AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
		),0) RESULT_AMOUNT
	FROM
		PRODUCTION_ORDERS PO,
		STOCKS S,
		PRODUCT P
	WHERE
		PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
		PO.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>
<cfif not GET_DET_PO.RECORDCOUNT>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfscript>
	attributes.STOCK_ID = get_det_po.stock_id;
</cfscript>
<cfinclude template="../../production_plan/query/get_station_infos.cfm">
<cfinclude template="../../production_plan/query/get_pr_order_id.cfm">
<cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
	SELECT DISTINCT
		ORDERS.ORDER_ID,
		ORDERS.ORDER_NUMBER
	FROM
		ORDERS,
		PRODUCTION_ORDERS_ROW
	WHERE
		PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
		PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
</cfquery>
<cfif GET_ORDER_ROW.RECORDCOUNT>
	<cfquery name="GET_ORDER_ROW_1" datasource="#DSN3#">
		SELECT
			ORDER_ROW.ORDER_ROW_ID,
			ORDER_ROW.SPECT_VAR_ID,
			ORDER_ROW.SPECT_VAR_NAME
		FROM
			ORDER_ROW
		WHERE
			ORDER_ROW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ORDER_ROW.ORDER_ID#"> AND
			ORDER_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.STOCK_ID#"> 
	</cfquery>
</cfif>
<cfquery name="GET_ORDER_RESULT" datasource="#DSN3#"><!--- Sonuç girilip girilmediğini kontrolü için kullanılıyor. --->
    SELECT
        PR_ORDER_ID,
        START_DATE,
        FINISH_DATE,
        RESULT_NO,
        POSITION_ID,
        STATION_ID
    FROM
        PRODUCTION_ORDER_RESULTS
    WHERE
        P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
</cfquery>
<!--- Üretimin altında ilişkili olan üretim emri varmı diye bakıyoru,eğer varsa üretim içinde ürün ve spec değişimlerini yaptırmayacağız.Şimdilik böyle yapıyoruz eğer istek olursa
üretim emri ekleme sayfasında olduğu gibi bir ajax ile alt bileşenlerini gösterip ona göre üretim emrini silip seçilen yeni ürün ve spec'e göre üretim emrini güncelliyeceğiz..! M.ER 24102008
 --->
<cfset prod_and_spec_disp = ''>
<cfquery name="GET_PRODUCTION_ORDERS_RELATED" datasource="#DSN3#">
	SELECT TOP 1 P_ORDER_ID FROM PRODUCTION_ORDERS WHERE PO_RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
</cfquery>
<cfif GET_PRODUCTION_ORDERS_RELATED.recordcount>
	<cfset prod_and_spec_disp = 'style="display:none;"'>
</cfif>

<cfif len(get_det_po.demand_no) and get_det_po.is_stage eq -1 and get_det_po.is_stock_reserved eq 0><cfset is_demand = 1></cfif>
<table class="dph">
	<cfoutput>
    <tr>
        <td class="dpht" name="Header">
            Üretim Emri
        </td>
        <td class="dphb" name="butons">
            <cfif get_det_po.quantity-get_det_po.result_amount gt 0><!--- üretim sonuçları emir miktarı kadar olmalı --->
           		<a href="#request.self#?fuseaction=objects2.form_add_prod_order_result&p_order_id=#attributes.upd#"><img src="/images/forklift.gif" border="0" title="<cf_get_lang_main no='1854.Üretim Sonucu'>"></a>
            </cfif> 
        </td>
    </tr>
    </cfoutput>
</table> 
<cfif isdate(get_det_po.start_date) and IsDate(get_det_po.finish_date)><cfset date_control = 1><cfelse><cfset date_control =0></cfif>
<table class="dpm">
    <tr>
		<td valign="top" class="dpml" name="Detail Page Left">
        <cf_form_box width="100%">
            <cfform name="add_production_order" method="post" action="#request.self#?fuseaction=prod.upd_production_order_process">
   	 		<input name="po_related_id" id="po_related_id" type="hidden" value="<cfoutput>#get_det_po.po_related_id#</cfoutput>">
			<cfinclude template="production_orders_main.cfm">
			<cfinclude template="sub_product_fire.cfm">
			<cfinclude template="list_related_p_orders.cfm"><br/><br/>
			<cfinclude template="related_order_results.cfm">            
            <!---<cf_form_box_footer>
                <table width="100%">
                    <tr>
                        <td>
                            <cfif len(get_det_po.record_emp)>
                                <cf_get_lang_main no='71.Kayıt'>: <cfoutput>#get_emp_info(get_det_po.record_emp,0,0)# - #dateFormat(get_det_po.record_date,'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone, get_det_po.record_date),'HH:MM')#</cfoutput> 
                            </cfif>
                            <cfif len(get_det_po.update_emp)>
                                <cf_get_lang_main no='291.Güncelleme'>: <cfoutput>#get_emp_info(get_det_po.update_emp,0,0)# - #dateFormat(get_det_po.update_date,'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone, get_det_po.update_date),'HH:MM')#</cfoutput> 
                            </cfif>
                        <cf_get_lang no="479.Print Sayısı"> :<cfoutput>#get_det_po.print_count#</cfoutput></td>
                        <td style="text-align:right">
                            <cfif isdefined('is_demand')><!--- Talep ise ilişkili emir var mı diye kontrol ediliyor varsa silme işlemi yapamayacak --->
                                <cfquery name="get_relation" datasource="#dsn3#">
                                    SELECT
                                        P_ORDER_ID
                                    FROM
                                        PRODUCTION_ORDERS
                                    WHERE
                                        P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
                                        AND IS_STAGE <> -1
                                </cfquery>
                                <cfif get_relation.recordcount>
                                    <cfif is_result_control eq 1 and get_order_result.recordcount eq 0><!--- sonuclari kontrol et denildiğinde sonuc yoksa bu emir icin islem yapilabilir--->
                                        <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' is_delete='0' delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_production_order&p_order_id=#attributes.upd#&name=#get_det_po.p_order_no#&PO_RELATED_ID=#GET_DET_PO.PO_RELATED_ID#'>
                                    <cfelseif is_result_control eq 1 and get_order_result.recordcount gt 0><!--- sonuclari kontrol et denildiğinde sonuc varsa bu emir icin islem yapilamaz--->
                                        <!--- --->
                                    <cfelseif is_result_control eq 0 and get_order_result.recordcount eq 0><!--- sonuclari kontrol etme denildiğinde sonuc yoksa bu emir icin islem yapilabilir--->
                                        <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' is_delete='0' delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_production_order&p_order_id=#attributes.upd#&name=#get_det_po.p_order_no#&PO_RELATED_ID=#GET_DET_PO.PO_RELATED_ID#'>
                                    <cfelseif is_result_control eq 0 and get_order_result.recordcount gt 0><!--- sonuclari kontrol etme denildiğinde sonuc varsa bu emir icin sadece güncelleme yapilabilir--->
                                        <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' is_delete='0'>
                                    </cfif>
                                <cfelse>
                                    <cfif is_result_control eq 1 and get_order_result.recordcount eq 0><!--- sonuclari kontrol et denildiğinde sonuc yoksa bu emir icin islem yapilabilir--->
                                        <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' is_delete='1' delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_production_order&p_order_id=#attributes.upd#&name=#get_det_po.p_order_no#&PO_RELATED_ID=#GET_DET_PO.PO_RELATED_ID#'>
                                    <cfelseif is_result_control eq 1 and get_order_result.recordcount gt 0><!--- sonuclari kontrol et denildiğinde sonuc varsa bu emir icin islem yapilamaz--->
                                        <!--- --->
                                    <cfelseif is_result_control eq 0 and get_order_result.recordcount eq 0><!--- sonuclari kontrol etme denildiğinde sonuc yoksa bu emir icin islem yapilabilir--->
                                        <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' is_delete='1' delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_production_order&p_order_id=#attributes.upd#&name=#get_det_po.p_order_no#&PO_RELATED_ID=#GET_DET_PO.PO_RELATED_ID#'>
                                    <cfelseif is_result_control eq 0 and get_order_result.recordcount gt 0><!--- sonuclari kontrol etme denildiğinde sonuc varsa bu emir icin sadece güncelleme yapilabilir--->
                                        <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' is_delete='0'>
                                    </cfif>
                                </cfif>
                            <cfelse>
                                <cfif is_result_control eq 1 and get_order_result.recordcount eq 0><!--- sonuclari kontrol et denildiğinde sonuc yoksa bu emir icin islem yapilabilir--->
                                    <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' type_format="1" is_delete='1' delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_production_order&p_order_id=#attributes.upd#&name=#get_det_po.p_order_no#&PO_RELATED_ID=#GET_DET_PO.PO_RELATED_ID#'>
                                <cfelseif is_result_control eq 1 and get_order_result.recordcount gt 0><!--- sonuclari kontrol et denildiğinde sonuc varsa bu emir icin islem yapilamaz--->
                                    <!--- --->
                                <cfelseif is_result_control eq 0 and get_order_result.recordcount eq 0><!--- sonuclari kontrol etme denildiğinde sonuc yoksa bu emir icin islem yapilabilir--->
                                    <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' type_format="1" is_delete='1' delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_production_order&p_order_id=#attributes.upd#&name=#get_det_po.p_order_no#&PO_RELATED_ID=#GET_DET_PO.PO_RELATED_ID#'>
                                <cfelseif is_result_control eq 0 and get_order_result.recordcount gt 0><!--- sonuclari kontrol etme denildiğinde sonuc varsa bu emir icin sadece güncelleme yapilabilir--->
                                    <cf_workcube_buttons is_upd='1' add_function='unformat_fields()' type_format="1" is_delete='0'>
                                </cfif>
                            </cfif>
                         </td> 
                    </tr>
                </table>
			</cf_form_box_footer>  --->
            </cfform>          
            </cf_form_box>
			<br />
			<!---<cfset _ajax_str_ = "&upd=#attributes.upd#&IS_DEMONTAJ=#GET_DET_PO.IS_DEMONTAJ#&SPECT_VAR_ID=#GET_DET_PO.SPECT_VAR_ID#&IS_PRODUCTION=#GET_DET_PO.IS_PRODUCTION#&IS_PROTOTYPE=#GET_DET_PO.IS_PROTOTYPE#&urun_carpan=#GET_DET_PO.quantity#&STOCK_ID=#GET_DET_PO.STOCK_ID#&start_date=#GET_DET_PO.start_date#&finish_date=#GET_DET_PO.finish_date#&project_id=#GET_DET_PO.project_id#">
			<cfsavecontent variable="message"><cfif isdefined('is_demand')><cf_get_lang no ='147.İlişkili Üretim Talepleri'><cfelse><cf_get_lang no ='339.İlişkili Üretim Emirleri'></cfif></cfsavecontent>
            <cf_box 
				id="REL_ORD_LIST"  
				title="#message#" 
				unload_body="1" 
				closable="0"  
				style="width:100%;" 
				box_page="#request.self#?fuseaction=prod.popup_ajax_list_related_p_orders#_ajax_str_#">
            </cf_box>
			<cfif is_show_prod_amount eq 1>
				<cfsavecontent variable="message"><cf_get_lang no ='79.Malzeme ihtiyaç Tablosu'></cfsavecontent>
				<cfset this_production_amount = GET_DET_PO.QUANTITY><!--- Bu değişken malzeme ihtiyaçları sayfasına bakarken bu üretimden kaynaklanan üretim rezervelerini yani sarf ürünleri için üretim rezervelerini göstermesin diye eklendi..Malzeme ihtiyaçları sayfasında sarf ürünlerin Satılabilir Stok miktarından düşülecek! --->
				<cf_box 
					id="DET_MET"  
					title="#message#" 
					unload_body="1" 
					closable="0"  
					style="width:100%;" 
					box_page="#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&p_order_id=#attributes.upd#&p_order_no=#GET_DET_PO.p_order_no#&stock_id=#GET_DET_PO.STOCK_ID#&order_amount=#GET_DET_PO.quantity#&spect_main_id=#GET_DET_PO.SPEC_MAIN_ID#&spect_var_id=#GET_DET_PO.SPECT_VAR_ID#&from_upd_production_page=1&this_production_amount=#this_production_amount#&is_zero_amount_kontrol=#is_zero_amount_kontrol#">
				</cf_box>            
			</cfif>
			<cfsavecontent variable="message"><cf_get_lang no ='476.Üretim Sonuçları'></cfsavecontent>
            <cf_box 
				id="REL_ORD"  
				title="#message#" 
				unload_body="1" 
				closable="0"  
				style="width:100%;" 
				box_page="#request.self#?fuseaction=prod.popup_ajax_related_order_results&date_control=#date_control##_ajax_str_#">
            </cf_box> 
			<cfsavecontent variable="titleeee_"><cf_get_lang no ='63.Operasyonlar'></cfsavecontent>
			<cf_box 
				id="REL_OP"  
				title="#titleeee_#" 
				unload_body="1" 
				closable="0"  
				style="width:100%;" 
				box_page="#request.self#?fuseaction=prod.popup_ajax_related_operation#_ajax_str_#">
			</cf_box>  --->
		</td>
		<td valign="top" name="Detail Page Right" style="width:20%;">
		  <!--- Varlıklar --->
		 <!--- <cf_get_workcube_asset company_id="#session.pp.our_company_id#" asset_cat_id="-3" module_id='35' action_section='P_ORDER_ID' action_id='#attributes.upd#'>--->
          <cfinclude template="prod_order_relation_asset.cfm"><br/>
		  <!--- Notlar --->
		  <cf_get_workcube_note  company_id="#session.pp.our_company_id#" action_section='P_ORDER_ID' action_id='#attributes.upd#'><br>
		</td>    
	</tr>
</table> 
<script type="text/javascript">
	function open_spec()
	{
		if(add_production_order.stock_id.value.length > 0 && add_production_order.product_name.value.length>0){
			<cfoutput>
			if(add_production_order.spect_var_id.value.length==0)
				windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&create_main_spect_and_add_new_spect_id=1&field_name=add_production_order.spect_var_name&field_id=add_production_order.spect_var_id&field_main_id=add_production_order.spect_main_id&stock_id='+add_production_order.stock_id.value,'list');
			else
				windowopen('#request.self#?fuseaction=objects.popup_upd_spect&create_main_spect_and_add_new_spect_id=1&id='+add_production_order.spect_var_id.value+'&field_name=add_production_order.spect_var_name&field_main_id=add_production_order.spect_main_id&field_id=add_production_order.spect_var_id&spect_main_id=' + add_production_order.spect_main_id.value +'&stock_id='+add_production_order.stock_id.value,'list');
			</cfoutput>
		}
		else
		{
			alert("<cf_get_lang no='364.Ürün Seçmelisiniz'>!");
		}
	}
		
	function temizle_order()
	{
		document.add_production_order.order_id.value='';
		document.add_production_order.spect_var_name.value='';
		document.add_production_order.spect_var_id.value='';
		document.add_production_order.spect_main_id.value='';
		document.add_production_order.stock_code.value='';
	}
	
	function date_control()
	{
		if((document.getElementById('start_date').value != "") && (document.getElementById('finish_date').value != ""))
		return time_check(document.getElementById('start_date'), document.getElementById('start_h'), document.getElementById('start_m'), document.getElementById('finish_date'),  document.getElementById('finish_h'), document.getElementById('finish_m'), "<cf_get_lang no ='605.Üretim Başlama Tarihi,Bitiş Tarihinden Önce Olmalıdır'>!");
		else
		{alert("<cf_get_lang no ='553.Başlangıç ve Bitiş Tarihini Düzgün Giriniz'>");return false;}
	}
	
	function unformat_fields()
	{
		_kontol_ = date_control();
		if(_kontol_ == true)
		{
			if(add_production_order.stock_id.value == "")
			{
				alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'> !");
				return false;
			}
			
			if(add_production_order.station_id.value == "")// && (add_production_order.route_id.value == "")
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
			if(document.add_production_order.p_order_no)
			{
				var listParam = document.add_production_order.p_order_no.value + "*" + "<cfoutput>#attributes.upd#</cfoutput>";
				var paper_number= wrk_safe_query("prdp_paper_number",'dsn3',0,listParam);
				if(paper_number.recordcount) // ayni uretim varsa uyari ver FB20080704
				{
					alert("<cf_get_lang no ='554.Bu Üretim Numarasına Ait Kayıt Vardır Lütfen Kontrol Ediniz'> !");
					return false;
				}
			}
			add_production_order.quantity.value = filterNum(add_production_order.quantity.value,8);
			for (var k=1;k<=row_count_exit;k++)
			{
				amount_exit = filterNum(eval("document.add_production_order.amount_exit"+k).value,8);
				eval("document.add_production_order.amount_exit"+k).value = amount_exit;
			}
			for (var k=1;k<=row_count_outage;k++)
			{
				amount_outage = filterNum(eval("document.add_production_order.amount_outage"+k).value,8);
				eval("document.add_production_order.amount_outage"+k).value = amount_outage;
			}
			return true;
		}
		else
		return false;
	}
	function calc_deliver_date()
	{
		stock_id_list = '';
		var row_c = document.getElementsByName('stock_id').length;
		if(row_c != 0)
		{
			if(document.getElementById('quantity').value == "")
			{
				alert("<cf_get_lang no ='73.Miktar Giriniz'>!");
				return false;
			}
			else
			{
				var n_stock_id = document.getElementById('stock_id').value;
				var n_amount = filterNum(document.getElementById('quantity').value,6);
				var n_spect_id = document.getElementById('spect_var_id').value;
				var n_is_production = 1;
				if(n_spect_id == "") n_spect_id =0;
				if(n_stock_id != "" && n_is_production ==1)//ürün silinmemiş ise
					stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
				document.getElementById('deliver_date_info').style.display='';
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_ajax_deliver_date_calc&is_from_order=1&from_p_order_list=1&stock_id_list='+stock_id_list+'','deliver_date_info',1,"<cf_get_lang no ='170.Tarih Hesaplanıyor'>");
			}
		}
		else
			alert("<cf_get_lang no ='364.Ürün Seçmelisiniz'> ");	
	}
	function aktar()
	{
		var sarf_uzunluk = document.getElementById('product_sarf_recordcount').value;
		if(sarf_uzunluk>0)
		{
			for (i=1;i<=sarf_uzunluk;i++)
			{
				if(eval("document.getElementById('is_free_amount_exit'+i)").value == 0 && eval("document.getElementById('spect_main_row_exit'+i)").value != '')
				{
					<cfif get_det_po.is_demontaj eq 0>
						var x=parseInt(document.getElementById('quantity').value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
						{
							var a=eval("document.getElementById('amount_exit'+i)").value=(filterNum(eval("document.getElementById('amount_exit_'+i)").value,8))/(filterNum(document.getElementById('quantity_').value,8))*(filterNum(document.getElementById('quantity').value,8));
							var b=commaSplit(a,8);
							eval("document.getElementById('amount_exit'+i)").value=b;
						}	
					</cfif>
				}
				<cfif get_det_po.is_demontaj eq 1>
					var x=parseInt(eval("document.getElementById('amount_exit'+1)").value);
					if(x>0)/*Demontaj yapılacak ürün miktarı 1 den fazla ise*/
						{
							var a=document.getElementById('quantity').value=(filterNum(document.getElementById('quantity_').value,8)/parseFloat(<cfoutput>#get_det_po.QUANTITY#</cfoutput>))*filterNum(eval("document.getElementById('amount_exit'+1)").value,8);
							var b=commaSplit(a,8);
							document.getElementById('quantity').value=b;
						}
				</cfif>
			}
		}
		var fire_uzunluk = document.getElementById('product_fire_recordcount').value;
		if(fire_uzunluk>0)
		{
			for (i=1;i<=fire_uzunluk;i++)
			{
				if(eval("document.getElementById('is_free_amount_outage'+i)").value == 0 && eval("document.getElementById('spect_main_row_outage'+i)").value != '')
				{
					<cfif get_det_po.is_demontaj eq 0>
						var x=parseInt(document.getElementById('quantity').value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
						{
							var a=eval("document.getElementById('amount_outage'+i)").value=(filterNum(eval("document.getElementById('amount_outage_'+i)").value,8))/(filterNum(document.getElementById('quantity_').value,8))*(filterNum(document.getElementById('quantity').value,8));
							var b=commaSplit(a,8);
							eval("document.getElementById('amount_outage'+i)").value=b;
						}	
					</cfif>
				}
			}
		}
	}
	function pencere_ac_alternative(no,pid,sid)//sarf ürünlerin alternatiflerini açıyor
	{
		form_stock = eval('add_production_order.stock_id_exit'+no);
		<cfif is_add_alternative_product eq 1>
			//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
			url_str='&tree_info_null_=1&product_id=add_production_order.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_name=add_production_order.product_name_exit' + no + '&field_unit=add_production_order.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
		<cfelse>
			url_str='&tree_stock_id='+sid+'&product_id=add_production_order.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_name=add_production_order.product_name_exit' + no + '&field_unit=add_production_order.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
		</cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}
	function pencere_ac_alternative_outage(no,pid,sid)//fire ürünlerin alternatiflerini açıyor
	{
		form_stock = eval('add_production_order.stock_id_outage'+no);
		<cfif is_add_alternative_product eq 1>
			//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
			url_str='&tree_info_null_=1&product_id=add_production_order.product_id_outage'+no+'&run_function=alternative_product_cost_outage&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_name=add_production_order.product_name_outage' + no + '&field_unit=add_production_order.unit_id_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
		<cfelse>
			url_str='&tree_stock_id='+sid+'&product_id=add_production_order.product_id_outage'+no+'&run_function=alternative_product_cost_outage&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_name=add_production_order.product_name_outage' + no + '&field_unit=add_production_order.unit_id_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
		</cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}
	
	function alternative_product_cost(pid,no)
	{
		//ürün değiştiği için spectler sıfırlanıyor
		eval('add_production_order.spec_main_id_exit'+no).value = "";
		eval('add_production_order.spect_name_exit'+no).value = "";
	}
	function alternative_product_cost_outage(pid,no)
	{
		//ürün değiştiği için spectler sıfırlanıyor
		eval('add_production_order.spec_main_id_outage'+no).value = "";
		eval('add_production_order.spect_name_outage'+no).value = "";
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
		var my_element=eval("add_production_order.row_kontrol_exit"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_exit"+sy);
		my_element.style.display="none";
	}
	function sil_outage(sy)
	{
		var my_element=eval("add_production_order.row_kontrol_outage"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_outage"+sy);
		my_element.style.display="none";
	}
	<!---row_count_exit = <cfoutput>#deger_value_row#</cfoutput>;
	satir_sarf = document.getElementById("table2").rows.length;
	function add_row_exit()
	{
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
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="1"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="is_phantom_exit' + row_count_exit +'" id="is_phantom_exit' + row_count_exit +'"value=""><input type="hidden" name="is_sevk_exit' + row_count_exit +'" id="is_sevk_exit' + row_count_exit +'" value=""><input type="hidden" name="is_property_exit' + row_count_exit +'" id="is_property_exit' + row_count_exit +'"value=""><input type="hidden" name="is_free_amount_exit' + row_count_exit +'" id="is_free_amount_exit' + row_count_exit +'"value=""><input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="" readonly style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'" value=""><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value=""><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'"value="" readonly style="width:220px;"></a><a href="javascript://" onClick="pencere_ac_product('+ row_count_exit +');"> <img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'" value="" readonly style="width:40px;"> <input name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" value="" readonly style="width:200px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="1" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value=""><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'" value="" readonly style="width:60px;">';
		
	} 
	function pencere_ac_product(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&product_id=add_production_order.product_id_exit'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_name=add_production_order.product_name_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_spect_main_id=add_production_order.spec_main_id_exit'+no+'&field_spect_main_name=add_production_order.spect_name_exit'+no+'&field_unit=add_production_order.unit_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no,'list');
	}

	row_count_outage = <cfoutput>#deger_value_row_fire#</cfoutput>; --->
	function add_row_outage()
	{
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
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_outage(' + row_count_outage + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="is_add_info_' + row_count_outage +'" id="is_add_info_' + row_count_outage +'" value="1"><input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="is_phantom_outage' + row_count_outage +'" id="is_phantom_outage' + row_count_outage +'"value="0"><input type="hidden" name="is_sevk_outage' + row_count_outage +'" id="is_sevk_outage' + row_count_outage +'" value="0"><input type="hidden" name="is_property_outage' + row_count_outage +'" id="is_property_outage' + row_count_outage +'"value="4"><input type="hidden" name="is_free_amount_outage' + row_count_outage +'" id="is_free_amount_outage' + row_count_outage +'"value=""><input type="text" name="stock_code_outage' + row_count_outage +'" id="stock_code_outage' + row_count_outage +'" value="" readonly style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_outage' + row_count_outage +'" id="product_id_outage' + row_count_outage +'" value=""><input type="hidden" name="stock_id_outage' + row_count_outage +'" id="stock_id_outage' + row_count_outage +'" value=""><input type="text" name="product_name_outage' + row_count_outage +'" id="product_name_outage' + row_count_outage +'"value="" readonly style="width:220px;"></a><a href="javascript://" onClick="pencere_ac_product_outage('+ row_count_outage +');"> <img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="spec_main_id_outage' + row_count_outage +'" id="spec_main_id_outage' + row_count_outage +'" value="" readonly style="width:40px;"> <input name="spect_name_outage' + row_count_outage +'" id="spect_name_outage' + row_count_outage +'" value="" readonly style="width:200px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_outage' + row_count_outage +'" id="amount_outage' + row_count_outage +'" value="1" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id_outage' + row_count_outage +'" id="unit_id_outage' + row_count_outage +'" value=""><input type="text" name="unit_outage' + row_count_outage +'" id="unit_outage' + row_count_outage +'" value="" readonly style="width:60px;">';
	}
	function pencere_ac_product_outage(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&product_id=add_production_order.product_id_outage'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_name=add_production_order.product_name_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_spect_main_id=add_production_order.spec_main_id_outage'+no+'&field_spect_main_name=add_production_order.spect_name_outage'+no+'&field_unit=add_production_order.unit_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no,'list');
	}
</script> 
