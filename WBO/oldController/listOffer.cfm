<cf_get_lang_set module_name="sales">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact ="sales.list_offer" default_value="1">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword_offerno" default="">
    <cfparam name="attributes.offer_status_cat_id" default="">
    <cfparam name="attributes.offer_zone" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.member_type" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.form_varmi" default="">
    <cfparam name="attributes.sales_partner" default="">
    <cfparam name="attributes.sales_partner_id" default="">
    <cfparam name="attributes.offer_stage" default="">
    <cfparam name="attributes.sale_add_option" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.listing_type" default="1">
    <cfparam name="attributes.status" default="1">
    <cfparam name="attributes.sort_type" default="4">
    <cfparam name="attributes.probability" default="">
    <cfif not isdefined("attributes.sales_emp_id") and attributes.form_varmi neq 1 and is_show_sales_emp eq 1>
        <cfset attributes.sales_emp_id = "#session.ep.userid#">
    </cfif>
    <cfif not isdefined("attributes.sales_emp") and attributes.form_varmi neq 1 and is_show_sales_emp eq 1>
        <cfset attributes.sales_emp = "#session.ep.name# #session.ep.surname#">
    </cfif>
    <cfif len(attributes.form_varmi)>
        <cfif len(attributes.start_date)>
            <cf_date tarih="attributes.start_date">
        </cfif>
        <cfif len(attributes.finish_date)>
            <cf_date tarih="attributes.finish_date">
        </cfif>
        <cfscript>
            get_offer_list_action = createObject("component", "sales.cfc.get_offer_list");
            get_offer_list_action.dsn3 = dsn3;
            get_offer_list_action.dsn_alias = dsn_alias;
            get_offer_list = get_offer_list_action.get_offer_list_fnc
                (
                    product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                    product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
                    listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
                    offer_zone : '#IIf(IsDefined("form.offer_zone"),"form.offer_zone",DE(""))#',
                    keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                    keyword_offerno : '#IIf(IsDefined("attributes.keyword_offerno"),"attributes.keyword_offerno",DE(""))#',
                    xml_offer_revision : '#IIf(IsDefined("xml_offer_revision"),"xml_offer_revision",DE(""))#',
                    OFFER_STATUS_CAT_ID : '#IIf(IsDefined("OFFER_STATUS_CAT_ID"),"OFFER_STATUS_CAT_ID",DE(""))#',
                    status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(""))#',
                    member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
                    member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
                    company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                    consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                    sales_emp_id : '#IIf(IsDefined("attributes.sales_emp_id"),"attributes.sales_emp_id",DE(""))#',
                    start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                    finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                    sales_partner : '#IIf(IsDefined("attributes.sales_partner"),"attributes.sales_partner",DE(""))#',
                    sales_partner_id : '#IIf(IsDefined("attributes.sales_partner_id"),"attributes.sales_partner_id",DE(""))#',
                    sale_add_option : '#IIf(IsDefined("attributes.sale_add_option"),"attributes.sale_add_option",DE(""))#',
                    offer_stage : '#IIf(IsDefined("attributes.offer_stage"),"attributes.offer_stage",DE(""))#',
                    project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                    project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                    x_control_ims : '#IIf(IsDefined("x_control_ims"),"x_control_ims",DE(""))#',
                    x_multiple_filters : '#IIf(IsDefined("x_multiple_filters"),"x_multiple_filters",DE("0"))#',
                    sales_emp= '#IIf(IsDefined("attributes.sales_emp"),"attributes.sales_emp",DE(""))#',
                    sort_type : '#IIf(IsDefined("attributes.sort_type"),"attributes.sort_type",DE("4"))#',
                    probability : '#IIf(IsDefined("attributes.probability"),"attributes.probability",DE("4"))#'
                    );
        </cfscript>
    <cfelse>
        <cfset get_offer_list.recordcount = 0>
    </cfif>
    <cfinclude template="../sales/query/get_sale_add_option.cfm">
    <cfinclude template="../sales/query/get_commethod.cfm">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfparam name="attributes.totalrecords" default="#get_offer_list.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_offer%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cf_xml_page_edit>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cf_xml_page_edit fuseact ="sales.form_add_offer" default_value="1">
    <cfinclude template="../sales/query/get_commethod_cats.cfm">
    <cfinclude template="../sales/query/get_moneys.cfm">
    <cfinclude template="../sales/query/get_taxes.cfm">
    
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfif isdefined("attributes.offer_id") and len(attributes.offer_id)>
        <!--- Ayni belge donusumlerinde buna gerek yok <cfscript>session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:attributes.offer_id);</cfscript> --->
        <cfinclude template="../sales/query/get_offer.cfm">
        <cfinclude template="../sales/query/get_offer_currencies.cfm">
        <cfset attributes.subject = get_offer.offer_head>
        <cfif Len(get_offer.company_id)>
            <cfset attributes.company_id = get_offer.company_id>
            <cfset attributes.partner_id = get_offer.partner_id>
        <cfelseif ListLen(get_offer.offer_to_partner) eq 1>
            <cfset attributes.company_id = ListDeleteDuplicates(get_offer.offer_to)>
            <cfset attributes.partner_id = ListDeleteDuplicates(get_offer.offer_to_partner)>
        <cfelseif Len(get_offer.consumer_id)>
            <cfset attributes.consumer_id = get_offer.consumer_id>
        <cfelse>
            <cfset attributes.company_id = "">
            <cfset attributes.partner_id = "">
            <cfset attributes.consumer_id = "">
        </cfif>
        <cfset attributes.paymethod_id = get_offer.paymethod>
        <cfset attributes.card_paymethod_id = get_offer.card_paymethod_id>
        <cfset attributes.commission_rate = get_offer.card_paymethod_rate>
        <cfset attributes.ship_method = get_offer.ship_method>
        <cfset attributes.ship_address = get_offer.ship_address>
        <cfset attributes.ship_address_id_ = get_offer.ship_address_id>
        <cfset attributes.ship_date = get_offer.ship_date>
        <cfset attributes.deliverdate = get_offer.deliverdate>
        <cfset attributes.finishdate = get_offer.finishdate>
        <cfset attributes.city_id = get_offer.city_id>
        <cfset attributes.county_id = get_offer.county_id>
        <cfset attributes.sales_partner_id = get_offer.sales_partner_id>
        <cfset attributes.sales_consumer_id = get_offer.sales_consumer_id>
        <cfset attributes.is_public_zone = get_offer.is_public_zone>
        <cfset attributes.is_partner_zone = get_offer.is_partner_zone>
        <cfset attributes.project_id = get_offer.project_id>
        <cfset attributes.ref_no = get_offer.ref_no>
        <cfset attributes.sales_add_option_id = get_offer.sales_add_option_id>
        <cfset attributes.ref_company_id = get_offer.ref_company_id>
        <cfset attributes.ref_partner_id = get_offer.ref_partner_id>
        <cfset attributes.ref_consumer_id = get_offer.ref_consumer_id>
        <cfset attributes.rel_opp_id = get_offer.opp_id>
        <cfif xml_offer_revision eq 1>
            <cfif len(get_offer.relation_offer_id)>
                <cfset attributes.rel_offer_id = get_offer.relation_offer_id>
            <cfelse>
                <cfset attributes.rel_offer_id = attributes.offer_id>
            </cfif>
        </cfif>
        <cfset attributes.country_id = get_offer.country_id>
    <cfelseif isdefined("attributes.opp_id") and len(attributes.opp_id)>
        <!---Fırsat - teklif ilişkisi --->
        <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
        <cfset attributes.purchase_sales = 1>	
        <cfquery name="get_opportunities" datasource="#DSN3#">
            SELECT * FROM OPPORTUNITIES WHERE OPP_ID = #attributes.opp_id#
        </cfquery>
        <cfset attributes.subject = get_opportunities.opp_head>
        <cfset attributes.company_id = get_opportunities.company_id>
        <cfset attributes.partner_id = get_opportunities.partner_id>
        <cfset attributes.consumer_id = get_opportunities.consumer_id>
        <cfset attributes.sales_partner_id = get_opportunities.sales_partner_id>
        <cfset attributes.sales_consumer_id = get_opportunities.sales_consumer_id>
        <cfset attributes.ship_date = "">
        <cfset attributes.deliverdate = "">
        <cfset attributes.finishdate = "">
        <cfset attributes.project_id = get_opportunities.project_id>
        <cfset attributes.sales_add_option_id = get_opportunities.sale_add_option_id>
        <cfset attributes.sales_emp_id = get_opportunities.sales_emp_id>
        <cfset attributes.ref_company_id = get_opportunities.ref_company_id>
        <cfset attributes.ref_partner_id = get_opportunities.ref_partner_id>
        <cfset attributes.ref_consumer_id = get_opportunities.ref_consumer_id>
        <cfset attributes.country_id=get_opportunities.country_id>
        <cfset attributes.sz_id=get_opportunities.sz_id>
        <cfset attributes.ref_no=get_opportunities.opp_no>
    <cfelse>
        <cfset attributes.subject = "Teklifimiz">
        <cfset attributes.ship_date = "">
        <cfset attributes.deliverdate = "">
        <cfset attributes.finishdate = "">
    </cfif>
    <cfif xml_country eq 1>
        <cfset cmp = createObject("component","settings.cfc.setupCountry") />
        <cfset GET_COUNTRY = cmp.getCountry()>
        <cfquery name="GET_SALE_ZONES" datasource="#DSN#">
            SELECT SZ_ID,SZ_NAME FROM SALES_ZONES
        </cfquery>
    </cfif>  
    <cfset attributes.basket_id = 3>
    <cfif isdefined("attributes.offer_id") and len(attributes.offer_id)>
        <cfset attributes.is_copy = 1>
    <cfelseif not isdefined("attributes.file_format") and not isdefined('attributes.from_add_order_report')>
        <cfset attributes.form_add = 1>
    <cfelse>
        <cfset attributes.basket_sub_id = 21>
    </cfif>
    <!--- add_offer_noeditor.cfm dosyasından gelen kodlar--->
    <cfif (xml_member_info_from_project eq 1 or not isdefined("attributes.offer_id")) and isdefined("attributes.project_id") and len(attributes.project_id)>
	<!--- FBS proje aksiyonlardan eklendiginde standart proje ve uye bilgilerin gelmesi icin eklendi --->
        <cfquery name="get_project_info" datasource="#dsn#">
            SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
        </cfquery>
        <cfif len(get_project_info.company_id)>
            <cfset attributes.company_id = get_project_info.company_id>
            <cfset attributes.partner_id = get_project_info.partner_id>
        <cfelseif len(get_project_info.consumer_id)>
            <cfset attributes.consumer_id = get_project_info.consumer_id>
        </cfif>
    </cfif>
    <cf_xml_page_edit> 
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
    <cf_xml_page_edit fuseact="sales.form_add_offer">
    <cfscript>session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:attributes.OFFER_ID);</cfscript>
    <cfset attributes.purchase_sales = 1>
    <cfinclude template="../sales/query/get_offer.cfm">
    <cfif not get_offer.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> Şirketinizde Böyle Bir Teklif Bulunamadı !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
        <cfexit method="exittemplate">
    </cfif>
    <cfinclude template="../sales/query/get_moneys.cfm">
    <cfinclude template="../sales/query/get_taxes.cfm">
    <cfinclude template="../sales/query/get_commethod_cats.cfm">
    <cfinclude template="../sales/query/get_offer_currencies.cfm">
    <cfif len(get_offer.consumer_id)>
        <cfset contact_type = "c">
        <cfset contact_id = get_offer.consumer_id>
        <cfset dsp_account=1>
    <cfelseif len(get_offer.partner_id)>
        <cfset contact_type = "p">
        <cfset contact_id = get_offer.partner_id>
        <cfset dsp_account = 1>  
    <cfelseif len(get_offer.company_id)>
        <cfset contact_type = "comp">
        <cfset contact_id = get_offer.company_id>
        <cfset dsp_account = 1>
    <cfelseif len(get_offer.employee_id)>
        <cfset contact_type = "e">
        <cfset contact_id = get_offer.employee_id>
        <cfset dsp_account=0>
    <cfelseif len(listsort(get_offer.offer_to_partner,"numeric"))>
        <cfset contact_type = "p" >
        <cfset contact_id = listfirst(listsort(get_offer.offer_to_partner,"numeric"))>
        <cfset dsp_account=1>  
    <cfelse>
        <cfset contact_type = "" >
        <cfset contact_id = ''>
        <cfset dsp_account=0> 
    </cfif>
    <cfset attributes.basket_id = 3>
    <cfif xml_country eq 1>
        <cfset cmp = createObject("component","settings.cfc.setupCountry") />
        <cfset GET_COUNTRY = cmp.getCountry()>
        <cfquery name="GET_SALE_ZONES" datasource="#DSN#">
            SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
        </cfquery>
    </cfif>
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	$('#keyword').focus();
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	function kontrol(ship_address,limit)
		{
			Strlen = ship_address.value.length;
			if (Strlen > limit)
			{
				alert("<cf_get_lang no='518.Teslim Yeri En Fazla 200 Karakter Girilebilir'>!");
				return false;
			}
		}
		function check()
		{
			if (form_basket.member_name.value == "" && form_basket.partner_name.value == "") 
			{
				alert("<cf_get_lang no='254.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
			<cfif xml_camp_id eq 2>
				if( document.form_basket.camp_id.value == '' || document.form_basket.camp_name.value == '')
				{
					alert("<cf_get_lang no ='642.Lütfen Kampanya Seçiniz'>!");
					return false;
				}
			</cfif>
			if(form_basket.deliverdate.value == "")
			{
				alert("<cf_get_lang no='185.Teklif Tarihi Girmelisiniz'>!");
				return false;
			}
			else
			{
				if (!date_check(form_basket.offer_date,form_basket.deliverdate,"Teklif Teslim Tarihi Teklif Tarihinden Önce Olamaz !"))
					return false;
			}
			<cfif xml_ship_address eq 1>
				if(document.getElementById('ship_address').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1037.Teslim Yeri'>");
					return false;
				}
			</cfif>
			<cfif xml_finishdate eq 1>
				if(document.getElementById('finishdate').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1212.Geçerlilik Tarihi'>");
					return false;
				}
			</cfif>
			<cfif xml_ship_method_name eq 1>
				if(document.getElementById('ship_method_name').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1703.Sevk Yöntemi'>");
					return false;
				}
			</cfif>
			<cfif xml_pay_method eq 1>
				if(document.getElementById('pay_method').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1104.Ödeme Yöntemi'>");
					return false;
				}
			</cfif>
			<cfif xml_sales_add_option eq 1>
				if(document.getElementById('sales_add_option').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='340.Özel Tanım'>");
					return false;
				}
			</cfif>
			return (process_cat_control && saveForm());
		}
		function add_adress()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					member_type_='partner';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&company_id='+form_basket.company_id.value+'&member_name='+form_basket.member_name.value+'&member_type='+member_type_+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					member_type_='consumer';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&consumer_id='+form_basket.consumer_id.value+'&member_name='+form_basket.partner_name.value+'&member_type='+member_type_+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='254.Cari Hesap Seçmelisiniz'>!");
				return false;
			}
		}	
		function calc_deliver_date()
		{
			stock_id_list = '';
			var row_c = document.getElementsByName('stock_id').length;
			if(row_c != 0)
			{
				if(row_c > 1)
				{//1den fazla satır varsa
					for(var ii=0;ii<row_c;ii++)
					{
						var n_stock_id =document.all.stock_id[ii].value;
						var n_amount = filterNum(document.all.amount[ii].value,6);
						var n_spect_id = document.all.spect_id[ii].value;
						var n_is_production = document.all.is_production[ii].value;
						if(n_spect_id == "") n_spect_id =0;
						if(n_stock_id != "")//ürün silinmemiş ise
							stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
					}
				}
				else if(row_c == 1){
					var n_stock_id =document.all.stock_id.value;
					var n_amount = filterNum(document.all.amount.value,6);
					var n_spect_id = document.all.spect_id.value;
					var n_is_production = document.all.is_production.value;
					if(n_spect_id == "") n_spect_id =0;
					if(n_stock_id != "")
					stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
				}
				document.getElementById('deliver_date_info').style.display='';
				AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=objects.popup_ajax_deliver_date_calc&offer_date='+document.getElementById('offer_date').value+'&stock_id_list='+stock_id_list+''</cfoutput>,'deliver_date_info',1,"<cf_get_lang no ='362.Teslim Tarihi Hesaplanıyor'>");
			}
			else
			alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>");	
		}
		function fill_country(member_id,type)
		{
			<cfif xml_country eq 1>
				document.getElementById('country_id').value='';
				document.getElementById('sales_zone_id').value='';
				if(type==1)
				{
			url_= '/V16/sales/cfc/get_offer_list.cfc?method=get_info_sales_func';			
			$.ajax({
				type: "get",
				url: url_,
				data: {member_id_: member_id},
				cache: false,
				async: false,
				success: function(read_data){
					data_ = jQuery.parseJSON(read_data.replace('//',''));
					if(data_.DATA.length != 0)
					{
						$.each(data_.DATA,function(i){
							if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
								document.getElementById('country_id').value=data_.DATA[i][0];
							if(data_.DATA[i][1]!='' && data_.DATA[i][1]!='undefined')
								document.getElementById('sales_zone_id').value=data_.DATA[i][1];						
							});
					}
				}
			});
				}
				else if(type==2)
				{
						url_= '/V16/sales/cfc/get_offer_list.cfc?method=getconsumer';
						
						$.ajax({
							type: "get",
							url: url_,
							data: {member_id_: member_id},
							cache: false,
							async: false,
							success: function(read_data){
								data_ = jQuery.parseJSON(read_data.replace('//',''));
								if(data_.DATA.length != 0)
								{
									$.each(data_.DATA,function(i){
										if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
											document.getElementById('country_id').value=data_.DATA[i][0];
										if(data_.DATA[i][1]!='' && data_.DATA[i][1]!='undefined')
											document.getElementById('sales_zone_id').value=data_.DATA[i][1];						
										});
								}
							}
						});					
				}
			</cfif>
		}
		function auto_sales_zone()
		{
				url_= '/V16/sales/cfc/get_offer_list.cfc?method=SalesZone';
				
				$.ajax({
					type: "get",
					url: url_,
					data: {country_id_: document.getElementById('country_id').value},
					cache: false,
					async: false,
					success: function(read_data){
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
								if(data_.DATA.length == 1)
								{
									$.each(data_.DATA,function(i){
										if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
										document.getElementById('sales_zone_id').value = data_.DATA[i][0];
										});
								}
											}
								else if(data_.DATA.length == 0)
								{
									alert('Ülke ile İlişkili Satış Bölgesi Bulunamadı !');
									return false;
								}
								else if(data_.DATA.length > 1)
								{
									alert('Ülke ile İlişkili Birden Fazla Satış Bölgesi Bulunmaktadır !');
									return false;
								}

						}
						});					
							return false;
		}
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	function kontrol (ship_address,limit)
		{
			StrLen = ship_address.value.length;
			if (StrLen > limit)
			{
				alert("<cf_get_lang no ='518.Teslim Yeri En Fazla 200 Karakter Girilebilir'>!");
				return false;
			}
		}
		
		function check()
		{
			<cfif xml_camp_id eq 2>
				if( document.form_basket.camp_id.value == '' || document.form_basket.camp_name.value == '')
				{
					alert("<cf_get_lang no ='642.Lütfen Kampanya Seçiniz'>!");
					return false;
				}
			</cfif>
			if(form_basket.deliverdate.value == "")
			{
				alert("<cf_get_lang no='185.Teklif Tarihi Girmelisiniz'>!");
				return false;
			}
			else
			{
				if (!date_check(form_basket.offer_date,form_basket.deliverdate,"Teklif Teslim Tarihi Teklif Tarihinden Önce Olamaz !"))
					return false;
			}
			<cfif xml_ship_address eq 1>
				if(document.getElementById('ship_address').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1037.Teslim Yeri'>");
					return false;
				}
			</cfif>
			<cfif xml_finishdate eq 1>
				if(document.getElementById('finishdate').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1212.Geçerlilik Tarihi'>");
					return false;
				}
			</cfif>
			<cfif xml_ship_method_name eq 1>
				if(document.getElementById('ship_method_name').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1703.Sevk Yöntemi'>");
					return false;
				}
			</cfif>
			<cfif xml_pay_method eq 1>
				if(document.getElementById('pay_method').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1104.Ödeme Yöntemi'>");
					return false;
				}
			</cfif>
			<cfif xml_sales_add_option eq 1>
				if(document.getElementById('sales_add_option').value=='')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='340.Özel Tanım'>");
					return false;
				}
			</cfif>
			return (process_cat_control() && saveForm()); 
		}
		function add_adress()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.member_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					member_type_='partner';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&company_id='+form_basket.company_id.value+'&member_name='+form_basket.company_name.value+'&member_type='+member_type_+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id'; 
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					member_type_='consumer';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&consumer_id='+form_basket.consumer_id.value+'&member_name='+form_basket.consumer.value+'&member_type='+member_type_+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='254.Cari Hesap Seçmelisiniz'>!");
				return false;
			}
		}
		function calc_deliver_date()
		{
			stock_id_list = '';
			var row_c = document.getElementsByName('stock_id').length;
			if(row_c != 0)
			{
				if(row_c > 1)
				{//1den fazla satır varsa
					for(var ii=0;ii<row_c;ii++)
					{
						var n_stock_id =document.all.stock_id[ii].value;
						var n_amount = filterNum(document.all.amount[ii].value,6);
						var n_spect_id = document.all.spect_id[ii].value;
						var n_is_production = document.all.is_production[ii].value;
						if(n_spect_id == "") n_spect_id =0;
						if(n_stock_id != "" && n_is_production ==1)//ürün silinmemiş ise
							stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
					}
				}
				else if(row_c == 1){
					var n_stock_id =document.all.stock_id.value;
					var n_amount = filterNum(document.all.amount.value,6);
					var n_spect_id = document.all.spect_id.value;
					var n_is_production = document.all.is_production.value;
					if(n_spect_id == "") n_spect_id =0;
					if(n_stock_id != "" && n_is_production ==1)
					stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
				}
				document.getElementById('deliver_date_info').style.display='';
				AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=objects.popup_ajax_deliver_date_calc&stock_id_list='+stock_id_list+''</cfoutput>,'deliver_date_info',1,"<cf_get_lang no ='362.Teslim Tarihi Hesaplanıyor'>");
			}
			else
			alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>");	
		}
		function fill_country(member_id,type)
		{
				<cfif xml_country eq 1>
					document.getElementById('country_id').value='';
					document.getElementById('sales_zone_id').value='';
					if(type==1)
					{
						url_= '/V16/sales/cfc/get_offer_list.cfc?method=getcountry';
						
						$.ajax({
							type: "get",
							url: url_,
							data: {member_id_: member_id},
							cache: false,
							async: false,
							success: function(read_data){
								data_ = jQuery.parseJSON(read_data.replace('//',''));
								if(data_.DATA.length != 0)
								{
									$.each(data_.DATA,function(i){
										if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
											document.getElementById('country_id').value=data_.DATA[i][0];
										if(data_.DATA[i][1]!='' && data_.DATA[i][1]!='undefined')
											document.getElementById('sales_zone_id').value=data_.DATA[i][1];						
										});
								}
							}
						});
					}
					else if(type==2)
					{
						url_= '/sales/cfc/get_offer_list.cfc?method=getconsumer';
						
						$.ajax({
							type: "get",
							url: url_,
							data: {member_id_: member_id},
							cache: false,
							async: false,
							success: function(read_data){
								data_ = jQuery.parseJSON(read_data.replace('//',''));
								if(data_.DATA.length != 0)
								{
									$.each(data_.DATA,function(i){
										if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
											document.getElementById('country_id').value=data_.DATA[i][0];
										if(data_.DATA[i][1]!='' && data_.DATA[i][1]!='undefined')
											document.getElementById('sales_zone_id').value=data_.DATA[i][1];						
										});
								}
							}
						});					
					}
				</cfif>
		}
		function auto_sales_zone()
		{
				url_= '/V16/sales/cfc/get_offer_list.cfc?method=SalesZone';
				
				$.ajax({
					type: "get",
					url: url_,
					data: {country_id_: document.getElementById('country_id').value},
					cache: false,
					async: false,
					success: function(read_data){
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
								if(data_.DATA.length == 1)
								{
									$.each(data_.DATA,function(i){
										if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
										document.getElementById('sales_zone_id').value = data_.DATA[i][0];
										});
								}
											}
								else if(data_.DATA.length == 0)
								{
									alert('Ülke ile İlişkili Satış Bölgesi Bulunamadı !');
									return false;
								}
								else if(data_.DATA.length > 1)
								{
									alert('Ülke ile İlişkili Birden Fazla Satış Bölgesi Bulunmaktadır !');
									return false;
								}

						}
						});					
							return false;
		}
</cfif>
</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_offer';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'sales/display/list_offer.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_offer';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'sales/form/add_offer.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'sales/query/add_offer.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_offer&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_offer);";

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.form_add_offer';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'sales/form/detail_offer_tv.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'sales/query/upd_offer_tv.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_offer&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'offer_id=##attributes.offer_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.offer_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(detail_offer);";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=sales.emptypopup_del_offer&offer_id=#attributes.offer_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'sales/query/del_offer.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'sales/query/del_offer.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_offer';
	}
		
		
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Add //	
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = 'PHL';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=objects.add_order_from_file&from_where=5";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=sales.detail_offer_tv&action_name=offer_id&action_id=#attributes.offer_id#&relation_papers_type=OFFER_ID','list');";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_offer_history&offer_id=#url.offer_id#&portal_type=employee','project');";
			
		//tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[398]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.offer_id#&type_id=-9','list');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = 'Proje Mailleri';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_mail_relation&relation_type=OFFER_ID&relation_type_id=#url.offer_id#','wide');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[60]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=sales.popup_form_add_page&offer_id=#offer_id#','page');return false;";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[656]# #lang_array_main.item[795]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['href'] = "#request.self#?fuseaction=sales.list_order&event=add&offer_id=#attributes.offer_id#";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[656]# #lang_array_main.item[796]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=sales.list_order_instalment&event=add&offer_id=#attributes.offer_id#&company_id=#get_offer.company_id#";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array.item[368]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.offer_id#&page_type=3&basket_id=#attributes.basket_id#','page_horizantal');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['onClick'] = "windowopen('#request.self#?fuseaction=sales.popup_list_pluses&offer_id=#attributes.offer_id#','medium');";
		if (len(get_offer.company_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['text'] = '#lang_array_main.item[163]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_offer.company_id#','medium');";
		}
		else if(len(get_offer.consumer_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['text'] = '#lang_array_main.item[163]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_offer.consumer_id#','medium');";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['text'] = '#lang_array_main.item[359]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][9]['onClick'] = "gizle_goster_img(document.getElementById('adr1'),document.getElementById('adr2'),other_details);gizle_goster(basket_main_div);";

		if (session.ep.our_company_info.workcube_sector is 'tersane')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][10]['text'] = 'PBS Kodları';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][10]['href'] = "#request.self#?fuseaction=sales.form_add_relation_pbs&offer_id=#url.offer_id#";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = '#request.self#?fuseaction=sales.list_offer&event=add';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array.item[517]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=sales.list_offer&event=add&offer_id=#offer_id#&active_company_id=#session.ep.company_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.offer_id#&print_type=70','page');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['customTag'] = '<cf_np tablename="offer" primary_key="offer_id" pointer="offer_id=#url.offer_id#" where="purchase_sales=1 and offer_zone=0 and offer_status = 1" dsn_var ="dsn3">';


		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listOffer';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'OFFER';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-offer_head','item-partner_id','item-offer_date']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>