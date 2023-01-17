<cfif not isdefined("attributes.event") or attributes.event is 'add'>
        <cf_xml_page_edit fuseact="stock.form_add_purchase">
        <cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
        <cfscript>
        		if(isdefined('attributes.is_ship_copy'))
						session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
					else
						session_basket_kur_ekle(process_type:0);
        </cfscript>
        <cfset get_date_bugun = dateformat(now(),'dd/mm/yyyy')>
        <cfif isdefined('attributes.service_id') and len(attributes.service_id)>
            <cfquery name="GET_SERVICE" datasource="#DSN3#">
                SELECT
                    SERVICE_PARTNER_ID,
                    SERVICE_COMPANY_ID,
                    SERVICE_CONSUMER_ID,
                    PRO_SERIAL_NO,
                    SERVICE_NO,
                    PROJECT_ID,
                    SHIP_METHOD,
                    STOCK_ID
                FROM
                    SERVICE
                WHERE
                    SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
            </cfquery>
            <cfscript>
                attributes.company_id = get_service.service_company_id;
                attributes.comp_name= get_par_info(get_service.service_company_id,1,1,0);
                attributes.consumer_id = get_service.service_consumer_id;
                attributes.partner_id = get_service.service_partner_id;
                if(len(get_service.service_partner_id) and get_service.service_partner_id neq 0)
                    attributes.partner_name=get_par_info(get_service.service_partner_id,0,-1,0);
                else
                    attributes.partner_name=get_cons_info(get_service.service_consumer_id,0,0);
                    
                service_serial_no = get_service.pro_serial_no;
                service_stock_id =get_service.stock_id;
                attributes.deliver_date =  dateformat(now(),'dd/mm/yyyy');
                attributes.ship_date = dateformat(now(),'dd/mm/yyyy');
                attributes.service_paper_no =get_service.service_no;
                attributes.ship_method_id = get_service.ship_method;
                attributes.project_id = get_service.project_id;
            </cfscript>
        </cfif>
        <cfif isdefined('attributes.is_ship_copy')>
            <cfinclude template="../stock/query/get_upd_purchase.cfm">
            <cfset attributes.ship_type = get_upd_purchase.ship_type>
            <cfscript>
                location_info_ = get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in,1,1);
                attributes.location_id = get_upd_purchase.location_in;
                attributes.branch_id = listlast(location_info_,',');
                attributes.department_id = get_upd_purchase.department_in;
                attributes.txt_departman_ =listfirst(location_info_,',');
                attributes.company_id =get_upd_purchase.company_id;
                attributes.comp_name =get_par_info(get_upd_purchase.company_id,1,0,0);
                attributes.partner_id = get_upd_purchase.partner_id;
                attributes.consumer_id=get_upd_purchase.consumer_id;
                if(len(get_upd_purchase.partner_id) and get_upd_purchase.partner_id neq 0)
                    attributes.partner_name=get_par_info(get_upd_purchase.partner_id,0,-1,0);
                else
                    attributes.partner_name=get_cons_info(get_upd_purchase.consumer_id,0,0);
                attributes.project_id = get_upd_purchase.project_id;
                attributes.ship_method_name ='';
                attributes.ship_method_id=get_upd_purchase.ship_method;
                attributes.deliver_emp_id=get_upd_purchase.deliver_emp_id;	
                attributes.deliver_par_id=get_upd_purchase.deliver_par_id;
                attributes.deliver_date = dateformat(get_upd_purchase.deliver_date,'dd/mm/yyyy');
                attributes.ship_date =dateformat(get_upd_purchase.ship_date,'dd/mm/yyyy');
            </cfscript>
        </cfif>
        <cfparam name="attributes.ship_date" default="#get_date_bugun#">
        <cfif not isdefined("attributes.ship_id") and isdefined("attributes.project_id") and len(attributes.project_id)>
            <cfquery name="get_project_info" datasource="#dsn#">
                SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID =#attributes.project_id#
            </cfquery>
            <cfif len(get_project_info.partner_id)>
                <cfset attributes.company_id = get_project_info.company_id>
                <cfset attributes.partner_id = get_project_info.partner_id>
                <cfset attributes.partner_name = get_par_info(get_project_info.partner_id,0,-1,0)>
                <cfset attributes.comp_name =get_par_info(get_project_info.company_id,1,0,0)>
            <cfelseif len(get_project_info.consumer_id)>
                <cfset attributes.consumer_id = get_project_info.consumer_id>
                <cfset attributes.partner_name = get_cons_info(get_project_info.consumer_id,0,0)>
                <cfset attributes.comp_name =get_cons_info(get_project_info.consumer_id,2,0)>
            </cfif>
        </cfif>
        <cfif isdefined("attributes.return_row_ids") and not isdefined("attributes.subscription_id")>
            <cfif attributes.member_type is 'partner'>
                <cfset partner_list = listsort(listdeleteduplicates(attributes.return_partner_ids),'numeric','ASC',',')>
                <cfif listlen(partner_list)>
                    <cfset attributes.partner_id = listfirst(partner_list)>
                    <cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
                </cfif>
                <cfset attributes.comp_name = "#attributes.member_name#">
            <cfelse>
                <cfset attributes.partner_name = "#attributes.member_name#">
            </cfif>
        </cfif>
        <cfif isdefined("attributes.return_row_ids") and isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
            <cfquery name="get_subs_" datasource="#dsn3#">
                SELECT
                    PARTNER_ID,
                    COMPANY_ID,
                    PROJECT_ID
                FROM
                    SUBSCRIPTION_CONTRACT
                WHERE
                    SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
            </cfquery>
            <cfif len(get_subs_.PARTNER_ID)>
                <cfset attributes.member_type = "partner">
                <cfset attributes.partner_id = get_subs_.PARTNER_ID>
                <cfset attributes.company_id = get_subs_.COMPANY_ID>
                <cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
                <cfset attributes.comp_name = get_par_info(attributes.company_id,1,0,0)>
                <cfif not isdefined("attributes.project_id")>
                    <cfset attributes.project_id = get_subs_.PROJECT_ID>
                </cfif>
            </cfif>
        </cfif>
        <cfif (isdefined("attributes.invent_return_row_ids") or isdefined("attributes.kons_row_ids")) and isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
            <cfquery name="get_subs_" datasource="#dsn3#">
                SELECT
                    PARTNER_ID,
                    COMPANY_ID,
                    PROJECT_ID
                FROM
                    SUBSCRIPTION_CONTRACT
                WHERE
                    SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
            </cfquery>
            <cfif len(get_subs_.PARTNER_ID)>
                <cfset attributes.member_type = "partner">
                <cfset attributes.partner_id = get_subs_.PARTNER_ID>
                <cfset attributes.company_id = get_subs_.COMPANY_ID>
                <cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
                <cfset attributes.comp_name = get_par_info(attributes.company_id,1,0,0)>
                <cfif not isdefined("attributes.project_id")>
                    <cfset attributes.project_id = get_subs_.PROJECT_ID>
                </cfif>
            </cfif>
        </cfif>
        <cfset attributes.paymethod_id = "">
        <cfset attributes.card_paymethod_id = "">
        <cfset attributes.commission_rate = "">
        <cfset attributes.commethod_id = "">
        <cfif isdefined('attributes.order_id') and len(attributes.order_id)>
            <cfinclude template="../stock/query/get_det_order.cfm">
            <cfscript>
            attributes.company_id = get_upd_purchase.company_id;
            attributes.comp_name= get_par_info(get_upd_purchase.company_id,1,1,0);
            attributes.partner_id = get_upd_purchase.partner_id;
            attributes.consumer_id = get_upd_purchase.consumer_id;
            if(len(get_upd_purchase.partner_id))
                    attributes.partner_name=get_par_info(get_upd_purchase.partner_id,0,-1,0);
                else
                    attributes.partner_name=get_cons_info(get_upd_purchase.consumer_id,0,0);
            attributes.order_number = get_upd_purchase.order_number;
            attributes.ref_no = get_upd_purchase.ref_no;
            attributes.ship_date = dateformat(now(),'dd/mm/yyyy');
            attributes.sale_emp = get_upd_purchase.order_employee_id;
            attributes.location_id = get_upd_purchase.location_id;
            attributes.department_id = get_upd_purchase.DELIVER_DEPT_ID;
            location_info_ = get_location_info(get_upd_purchase.DELIVER_DEPT_ID,get_upd_purchase.location_id,1,1);
            attributes.branch_id = listlast(location_info_,',');
            attributes.txt_departman_ =listfirst(location_info_,',');
            attributes.city_id = get_upd_purchase.city_id;
            attributes.county_id = get_upd_purchase.county_id;
            attributes.deliver_comp_id = get_upd_purchase.deliver_comp_id;
            attributes.deliver_cons_id = get_upd_purchase.deliver_cons_id;
            attributes.adres = trim(get_upd_purchase.ship_address);
            attributes.ship_method_id = get_upd_purchase.ship_method;
            attributes.detail = get_upd_purchase.order_detail;
            attributes.project_id = get_upd_purchase.project_id;
            attributes.subscription_id = get_upd_purchase.subscription_id;
            attributes.paymethod_id = get_upd_purchase.paymethod;
            attributes.card_paymethod_id = get_upd_purchase.card_paymethod_id;
            attributes.commethod_id = get_upd_purchase.commethod_id;
            </cfscript>
</cfif>
              <cfif isdefined('attributes.service_id') and len(attributes.service_id)> <!--- servis modulunden cagırılıyorsa --->
                    <cfset attributes.basket_id = 47> 
                <cfelseif isdefined('attributes.order_id') and len(attributes.order_id)> <!--- stock - emirlerden cagırılıyorsa --->
                    <cfset attributes.basket_id = 15> 
                <cfelseif session.ep.isBranchAuthorization eq 1><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
                    <cfset attributes.basket_id = 17> 
                <cfelse>
                    <cfset attributes.basket_id = 11>
                </cfif>
                <cfif not isdefined('attributes.is_ship_copy') and not isdefined('attributes.service_id') and not isdefined('attributes.order_id')>
                    <cfif not isdefined("attributes.file_format") and not isdefined("attributes.return_row_ids") and not isdefined("attributes.invent_return_row_ids") and not isdefined("attributes.kons_row_ids")>
                        <cfset attributes.form_add = 1>
                    <cfelse>
                        <cfif isdefined("attributes.return_row_ids") and not isdefined("attributes.subscription_id")>
                            <cfset attributes.basket_sub_id = 8>
                        <cfelseif isdefined("attributes.invent_return_row_ids") and isdefined("attributes.subscription_id")>
                            <cfset attributes.basket_sub_id = '8_2'>
                        <cfelseif isdefined("attributes.kons_row_ids") and isdefined("attributes.subscription_id")>
                            <cfset attributes.basket_sub_id = '8_2'>
                        <cfelse>
                            <cfset is_from_ship = 1>
                            <cfset attributes.basket_sub_id = 4>
                        </cfif>
                    </cfif>
                </cfif>
                <cfif isDefined("attributes.service_app_id") and Len(attributes.service_app_id)>
                    <cfquery name="get_service" datasource="#dsn3#">
                        SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_app_id#">
                    </cfquery>
                </cfif>
                 <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
                    <cfquery name="ct_get_subs" datasource="#DSN3#">
                        SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subscription_id# 
                    </cfquery>
                 </cfif>
                   <cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>
                        <cfinclude template="../stock/query/get_ship_method.cfm">
                        <cfset attributes.ship_method_name =get_ship_method.ship_method>
                    </cfif>
                    <cfif isdefined("attributes.kons_return_type") and attributes.kons_return_type eq 1>
                        <cfset process_type_info = 75>
                    <cfelseif isdefined("attributes.kons_return_type") and attributes.kons_return_type eq 2>
                        <cfset process_type_info = '73,74'>
                    <cfelse>
                        <cfset process_type_info = ''>
                    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
    <cf_xml_page_edit fuseact="stock.form_add_purchase">
    <cfif isnumeric(attributes.ship_id)>
        <cfset attributes.upd_id = url.ship_id>
        <cfset attributes.cat = "">
        <cfinclude template="../stock/query/get_upd_purchase.cfm">
        <cfscript>
        if(get_upd_purchase.is_with_ship eq 1 and GET_INV_SHIPS.recordcount neq 0)
            session_basket_kur_ekle(action_id=GET_INV_SHIPS.INVOICE_ID,table_type_id:1,process_type:1);
        else
            session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
        </cfscript>
        <cfset attributes.ship_type = get_upd_purchase.ship_type>
    <cfelse>
        <cfset get_upd_purchase.recordcount = 0>
    </cfif>
    <cfif len(get_upd_purchase.SHIP_ID)>
        <cfquery name="GET_SF" datasource="#dsn2#">
            SELECT FIS_ID FROM STOCK_FIS WHERE RELATED_SHIP_ID = #get_upd_purchase.SHIP_ID# AND FIS_TYPE = 1182
        </cfquery>
    </cfif>
    <cfif not get_upd_purchase.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    </cfif>
        <cfset attributes.company_id = get_upd_purchase.company_id>
        <cfset company_id = get_upd_purchase.company_id>
          <cfquery name="get_ship_services" datasource="#dsn2#">
            SELECT DISTINCT SERVICE_ID FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND SERVICE_ID IS NOT NULL
        </cfquery>
        <cfif get_ship_services.recordcount><cfset attributes.service_id = get_ship_services.service_id></cfif>
        <cfif len(get_upd_purchase.consumer_id) and get_upd_purchase.consumer_id neq 0>
            <cfquery name="GET_CONS_NAME_UPD" datasource="#DSN#">
                SELECT
                    CONSUMER_NAME,
                    CONSUMER_SURNAME,
                    COMPANY,
                    CONSUMER_ID
                FROM
                    CONSUMER 
                 WHERE 
                 	CONSUMER_ID=#get_upd_purchase.consumer_id#
            </cfquery>
        </cfif>
          <cfif xml_disable_system_change eq 0 and GET_SF.recordcount and len(get_upd_purchase.subscription_id)>
                    <cfquery name="ct_get_subs" datasource="#DSN3#">
                        SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #get_upd_purchase.subscription_id# 
                    </cfquery>
          </cfif>
           <cfif Len(get_upd_purchase.service_id)>
                <cfquery name="get_service" datasource="#dsn3#">
                    SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.service_id#">
                </cfquery>
            </cfif>
             <cfset order_date_list = ''>
			<cfif isdefined("get_order")>
                <cfoutput query="get_order">
                    <cfset order_date_list = listappend(order_date_list,dateformat(get_order.ORDER_DATE,'dd/mm/yyyy'))>
                </cfoutput>
            </cfif>
			<cfif isdefined('get_upd_purchase.SHIP_METHOD') and len(get_upd_purchase.SHIP_METHOD)>
				<cfset attributes.ship_method_id = get_upd_purchase.SHIP_METHOD>
                <cfinclude template="../stock/query/get_ship_method.cfm">
                <cfset attributes.ship_method_name =get_ship_method.ship_method>
            </cfif>
             <cfif len(get_upd_purchase.paymethod_id)>
				<cfset attributes.paymethod_id = get_upd_purchase.paymethod_id>
                <cfinclude template="../stock/query/get_paymethod.cfm">
            <cfelseif len(get_upd_purchase.card_paymethod_id)>
                <cfquery name="get_card_paymethod" datasource="#dsn3#">
                    SELECT 
                        CARD_NO
                    <cfif get_upd_purchase.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi, (siparisin commethod_id si irsaliyeye tasınıyor) --->
                        ,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
                    <cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
                        ,COMMISSION_MULTIPLIER 
                    </cfif>
                    FROM 
                        CREDITCARD_PAYMENT_TYPE 
                    WHERE 
                        PAYMENT_TYPE_ID=#get_upd_purchase.card_paymethod_id#
                </cfquery>
             </cfif>
			 <!--- Irsaliyenin bulundugu donem ile birlikte sonraki donemlerde de kullanilmis olabilir, hepsi gelmelidir, bu sekilde yeniden duzenledim FBS 20120316 --->
            <cfquery name="Get_Ship_Period" datasource="#dsn#">
                SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> ORDER BY PERIOD_YEAR ASC
            </cfquery>
            <cfif Get_Ship_Period.RecordCount>
                <cfquery name="get_inv" datasource="#dsn2#">
                    <cfloop query="Get_Ship_Period">
                        <cfset new_period_dsn = '#dsn#_#Get_Ship_Period.Period_Year#_#Get_Ship_Period.Our_Company_Id#'>
                        SELECT INVOICE_NUMBER,SHIP_NUMBER,IS_WITH_SHIP FROM #new_period_dsn#.INVOICE_SHIPS WHERE SHIP_ID = #get_upd_purchase.ship_id# AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                        <cfif Get_Ship_Period.currentrow neq Get_Ship_Period.recordcount>UNION ALL</cfif>
                    </cfloop>
                </cfquery>
            </cfif>
            <cfquery name="get_our_comp_inf" datasource="#dsn#">
                SELECT IS_SHIP_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
            </cfquery>
            <cfquery name="delivered_control" datasource="#dsn2#"><!--- ürünlerin irsaliye dağıtımı bulunuyorsa irsaliyeyi silemesin. --->
                SELECT
                    SHIP_ROW.WRK_ROW_ID
                FROM 	
                    SHIP WITH (NOLOCK),
                    SHIP_ROW WITH (NOLOCK)
                WHERE 
                    SHIP.SHIP_TYPE = 76 
                    AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
                    AND SHIP_ROW.DELIVER_DEPT IS NOT NULL
                    AND SHIP.SHIP_ID = #attributes.ship_id#
                    AND SHIP_ROW.WRK_ROW_ID IN (SELECT SHR.WRK_ROW_RELATION_ID FROM SHIP_ROW SHR,SHIP SH WHERE SHR.SHIP_ID=SH.SHIP_ID AND SH.SHIP_TYPE = 81)
            </cfquery>
			<cfif listgetat(attributes.fuseaction,1,'.') is 'service'>
                 <cfset attributes.basket_id = 47>
            <cfelseif session.ep.isBranchAuthorization eq 1>
            <!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
                <cfset attributes.basket_id = 17> 
            <cfelse>
                <cfset attributes.basket_id = 11>
            </cfif>
</cfif>
<script type="text/javascript">
	$(document).ready(function(){
		 <cfif not isdefined("attributes.event") or attributes.event is 'add'>
				<cfif isdefined('attributes.service_id') and len(attributes.service_id)>	mal_alimi_sec();</cfif>

		 <cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
				<cfif (xml_disable_change eq 1 and GET_SF.recordcount) or (xml_return_disable_change eq 1 and isdefined("get_upd_purchase") and get_upd_purchase.is_from_return eq 1)>
					if(document.form_basket.amount.length != undefined && document.form_basket.amount.length >1)
					{
						var bsk_rowCount = form_basket.amount.length;
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							document.form_basket.amount[str_i_row].setAttribute('disabled','yes');
						}
					}
					else if(document.form_basket.amount != undefined && document.form_basket.amount.value != '')
					{
						document.form_basket.amount.setAttribute('disabled','yes');
					}
					gizle(stock_order_add_btn);
					gizle(basket_header_add);
					gizle(sepetim_search);
					<cfloop from="1" to="#ArrayLen(sepet.satir)#" index="ccc">
						<cfoutput>gizle(basket_row_add_#ccc#);</cfoutput>
					</cfloop>
				</cfif>
		 </cfif>
		});

		function add_adress()
			{
				if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
				{
					if(form_basket.company_id.value!="")
						{
							str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
							if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
							if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif session.ep.isBranchAuthorization eq 1>+'&is_store_module='+1</cfif>;
							windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
							document.getElementById('deliver_cons_id').value = '';
							return true;
						}
					else
						{
							str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id'; 
							if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
							if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif session.ep.isBranchAuthorization eq 1>+'&is_store_module='+1</cfif>;
							windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
							document.getElementById('deliver_comp_id').value = '';
							return true;
						}
				}
				else
				{
					alert("<cf_get_lang no='131.Cari Hesap Secmelisiniz'>");
					return false;
				}
			}
			function control_consignment()
			{
				var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				if(deger.length)
				{
					var fis_no = eval("document.form_basket.ct_process_type_" + deger);
					if(list_find('73,74,75',fis_no.value))
					{ 
						td_ship_text_.style.display = '';
						td_ship_id_.style.display='';
					}
					else
					{
						td_ship_text_.style.display = 'none';
						td_ship_id_.style.display = 'none';
					}
				}
				<cfif xml_kontrol_inv_process_type eq 1 and isdefined("GET_SF") and GET_SF.recordcount>
					alert("Demirbaş Stok İade Fişi Olan İrsaliyenin İşlem Tipini Değiştiremezsiniz !");
					return false;
				<cfelseif xml_kontrol_inv_process_type eq 1 and isdefined("GET_SF") and GET_SF.recordcount eq 0>
					var get_inv_control = wrk_safe_query("obj_get_process_cat","dsn3",0,deger);
					if(get_inv_control.IS_ADD_INVENTORY == 1)
					{
						alert("Demirbaş Stok İade Fişi Kaydeden İşlem Tipini Seçemezsiniz !");
						return false;
					}
				</cfif>
			}
			function add_irsaliye()
	{
		if(form_basket.company_id.value.length || form_basket.consumer_id.value.length || form_basket.employee_id.value.length)
		{ 
			str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=sale&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization eq 1>+'&is_store='+1</cfif>;
			<cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			</cfif>
			<cfif xml_control_process_type eq 1>
				if(document.form_basket.process_cat.value == '')
				{
					alert("İşlem Tipi Seçmelisiniz !");
					return false;
				}
				str_irslink = str_irslink+'&process_cat='+form_basket.process_cat.value;
			</cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&from_ship=1&ship_project_liste=1' + str_irslink,'page');
			return true;
		}
		else
		{
			alert("<cf_get_lang no='303.Önce Üye Seçiniz'>!");
			return false;
		}
	
	}
	function add_order()
	{
		if((form_basket.company_id.value.length && form_basket.company_id.value!="") &&(form_basket.department_id.value.length && form_basket.department_id.value!=""))
		{	
			str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&order_date_liste=' + form_basket.siparis_date_listesi.value + '&is_purchase=1&dept_id='+form_basket.department_id.value +'&company_id='+form_basket.company_id.value<cfif session.ep.isBranchAuthorization eq 1>+'&is_sale_store='+1</cfif>; //&id=purchase&sale_product=0
			<cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			 </cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
			return true;
		}
		else if (form_basket.company_id.value =="")
		{
			alert("<cf_get_lang no='303.Önce Üye Seçiniz'>!");
			return false;
		}
		else if (form_basket.department_id.value =="")
		{
			alert("<cf_get_lang no='195.Depo Seçiniz'>!");
			return false;
		}
	}
	
		function kontrol()
			{
				<cfif not isdefined("attributes.event") or attributes.event is 'add'>
				if(!paper_control(form_basket.ship_number,'SHIP',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value)) return false;
				<cfelseif attributes.event is 'upd'>
				if(!paper_control(form_basket.ship_number,'SHIP',false,<cfoutput>#attributes.UPD_ID#,'#get_upd_purchase.ship_number#'</cfoutput>,form_basket.company_id.value,form_basket.consumer_id.value)) return false;
				</cfif>
				if(!chk_period(form_basket.ship_date)) return false;
				if(form_basket.deliver_date_frm.value.length)
					if(!chk_period(form_basket.deliver_date_frm)) return false;
				if(!chk_process_cat('form_basket')) return false;
				if (!check_display_files('form_basket')) return false;
				if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="" && form_basket.employee_id.value =="")
				{
					alert("<cf_get_lang no='131.Cari Hesap Seçmelisiniz'>! \ <cf_get_lang no='271.Eğer Cari Hesap Seçili İse Üye Şirkete Çalışan Ekleyiniz'>!");
					return false;
				}
				<cfif not isdefined("attributes.event") or attributes.event is 'add'>
					if(document.form_basket.txt_departman_.value=="" || document.form_basket.department_id.value=="")
					{
						alert("<cf_get_lang no='507.Depo Seçmelisiniz'>!");
						return false;
					}
				<cfelseif  isdefined("attributes.event") and attributes.event is 'upd'>
					if(document.form_basket.department_name.value=="" || document.form_basket.department_id.value=="")
						{
							alert("<cf_get_lang no ='507.Depo Seçmelisiniz'>!");
							return false;
						}
					</cfif>
				
				var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var fis_no = eval("document.form_basket.ct_process_type_" + deger).value;
				<cfif isdefined("attributes.event") and attributes.event is 'upd'>
				if(deger != "<cfoutput>#get_upd_purchase.process_cat#</cfoutput>")
				{
					<cfif xml_kontrol_inv_process_type eq 1 and GET_SF.recordcount>
						alert("Demirbaş Stok İade Fişi Olan İrsaliyenin İşlem Tipini Değiştiremezsiniz !");
						return false;
					<cfelseif xml_kontrol_inv_process_type eq 1 and GET_SF.recordcount eq 0>
						var get_inv_control = wrk_safe_query("obj_get_process_cat","dsn3",0,deger);
						if(get_inv_control.IS_ADD_INVENTORY == 1)
						{
							alert("Demirbaş Stok İade Fişi Kaydeden İşlem Tipini Seçemezsiniz !");
							return false;
						}
					</cfif>
				}
				</cfif>
				<cfif xml_save_konsinye_iade eq 1>
					if(fis_no == 75)//konsinye irsaliye ise iliskili irsaliye kontrolu yapar
					{
						if(form_basket.product_id.length != undefined && form_basket.product_id.length >1)
						{
							var bsk_rowCount = form_basket.product_id.length;
							for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
							{
								if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '')
								{
									var get_inv_control  = wrk_safe_query("inv_get_ship_control2","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value);	//ilişkili irsaliyeler
									if(get_inv_control.recordcount == 0)
									{
										alert("<cf_get_lang no='115.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang_main no='818.Satır No'>: "+(str_i_row+1));
										return false;
									}
								}
								else if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value == '')
								{
									alert("<cf_get_lang no='115.İlişkili Konsinye Çıkışı Yok'>! <cf_get_lang_main no='818.Satır No'>: "+(str_i_row+1));
									return false;
								}
							}
						}	
						else if(document.form_basket.product_id != undefined && document.form_basket.product_id.value != '')
						{
							if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '')
							{
								var get_inv_control =  wrk_safe_query("inv_get_ship_control2","dsn2",0,document.form_basket.wrk_row_relation_id.value);	//ilişkili irsaliyeler
								if(get_inv_control.recordcount == 0)
								{
									alert("<cf_get_lang no='115.İlişkili Konsinye Çıkışı Yok'>!");
									return false;
								}
							}
							else if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value == '')
							{
								alert("<cf_get_lang no='115.İlişkili Konsinye Çıkışı Yok'>!");
								return false;
							}
						}
					}
				</cfif>
				<cfif  not isdefined("attributes.event") or  attributes.event is 'add'>
					<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
					<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
						prod_name_list = '';
						for(var str=0; str < window.basket.items.length; str++)
						{
							if(window.basket.items[str].PRODUCT_ID != '')
							{
								wrk_row_id_ = window.basket.items[str].WRK_ROW_ID;
								amount_ = window.basket.items[str].AMOUNT;
								product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, window.basket.items[str].PRODUCT_ID);
								get_serial_control = wrk_safe_query('obj_get_seri_row_id','dsn3',0,wrk_row_id_);
								if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_)
								{
									prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
								}
							}
						}
						if(prod_name_list!='')
						{
							alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
							return false;
						}
					</cfif>
				</cfif>
				
				<cfif xml_control_process_type eq 1>
					<cfoutput>
						if(fis_no == 75)//konsinye irsaliye ise kontrol yapacak
						{
							var ship_product_list = '';
							var wrk_row_id_list_new = '';
							var amount_list_new = '';
							if(form_basket.product_id.length != undefined && form_basket.product_id.length >1)
							{
								var bsk_rowCount = form_basket.product_id.length;
								for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
								{
									if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
									{
										if(list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value))
										{
											row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
											amount_info = list_getat(amount_list_new,row_info);
											amount_info = parseFloat(amount_info) + parseFloat(filterNum(document.form_basket.amount[str_i_row].value));
											amount_list_new = list_setat(amount_list_new,row_info,amount_info);
										}
										else
										{
											wrk_row_id_list_new = wrk_row_id_list_new + ',' + document.form_basket.wrk_row_relation_id[str_i_row].value;
											amount_list_new = amount_list_new + ',' + filterNum(document.form_basket.amount[str_i_row].value);


										}
									}
								}
								for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
								{
									if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
									{
										var get_inv_control  = wrk_safe_query("inv_get_ship_control2","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value);	//ilişkili irsaliyeler
										var get_inv_control2 = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value);	// ilişkili faturalar	
										if(list_len(document.form_basket.row_ship_id[str_i_row].value,';') > 1)
										{
											new_period = list_getat(document.form_basket.row_ship_id[str_i_row].value,2,';');
											var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
											new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
										}
										else
											new_dsn2 = "#dsn2#";
										var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, document.form_basket.wrk_row_relation_id[str_i_row].value );
										
										row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
										amount_info = list_getat(amount_list_new,row_info);
										var total_inv_amount =parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
										if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
										{
											if(total_inv_amount > get_ship_control.AMOUNT)
												ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
										}
									}
								}
							}	
							else if(document.form_basket.product_id != undefined && document.form_basket.product_id.value != '')
							{
								if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != '')
								{
									var get_inv_control =  wrk_safe_query("inv_get_ship_control2","dsn2",0,document.form_basket.wrk_row_relation_id.value);	//ilişkili irsaliyeler
									var get_inv_control2 = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id.value); // ilişkili faturalar	
									if(list_len(document.form_basket.row_ship_id.value,';') > 1)
									{
										new_period = list_getat(document.form_basket.row_ship_id.value,2,';');
										var get_period =wrk_safe_query("stk_get_period","dsn",0,new_period);
										new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
									}
									else
										new_dsn2 = "#dsn2#";
									var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, document.form_basket.wrk_row_relation_id.value);//seçilen irsaliye miktarı
									var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value));
									if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
									{
										if(total_inv_amount > get_ship_control.AMOUNT)
											ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
									}
								}
							}
							if(ship_product_list != '')
							{
								alert("<cf_get_lang no='106.Aşağıda Belirtilen Ürünler İçin İade Miktarı Konsinye Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
								return false;
							}
						}
						else if(fis_no == 74)//toptan satis iade irsaliye ise kontrol yapacak
						{
							var ship_product_list = '';
							var wrk_row_id_list_new = '';
							var amount_list_new = '';
							if(form_basket.product_id.length != undefined && form_basket.product_id.length >1)
							{
								var bsk_rowCount = form_basket.product_id.length;
								for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
								{
									if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
									{
										if(list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value))
										{
											row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
											amount_info = list_getat(amount_list_new,row_info);
											amount_info = parseFloat(amount_info) + parseFloat(filterNum(document.form_basket.amount[str_i_row].value));
											amount_list_new = list_setat(amount_list_new,row_info,amount_info);
										}
										else
										{
											wrk_row_id_list_new = wrk_row_id_list_new + ',' + document.form_basket.wrk_row_relation_id[str_i_row].value;
											amount_list_new = amount_list_new + ',' + filterNum(document.form_basket.amount[str_i_row].value);
										}
									}
								}
								for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
								{
									if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
									{
										var get_inv_control  = wrk_safe_query("inv_get_ship_control3","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value);	//ilişkili irsaliyeler
										//var get_inv_control2 = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id[str_i_row].value);	// ilişkili faturalar	
										if(list_len(document.form_basket.row_ship_id[str_i_row].value,';') > 1)
										{
											new_period = list_getat(document.form_basket.row_ship_id[str_i_row].value,2,';');
											var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
											new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
										}
										else
											new_dsn2 = "#dsn2#";
										var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, document.form_basket.wrk_row_relation_id[str_i_row].value );
										
										row_info = list_find(wrk_row_id_list_new,document.form_basket.wrk_row_relation_id[str_i_row].value);
										amount_info = list_getat(amount_list_new,row_info);
										//var total_inv_amount =parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
										var total_inv_amount =parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
										if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
										{
											if(total_inv_amount > get_ship_control.AMOUNT)
												ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
										}
									}
								}
							}	
							else if(document.form_basket.product_id != undefined && document.form_basket.product_id.value != '')
							{
								if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != '')
								{
									var get_inv_control =  wrk_safe_query("inv_get_ship_control3","dsn2",0,document.form_basket.wrk_row_relation_id.value);	//ilişkili irsaliyeler
									//var get_inv_control2 = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id.value); // ilişkili faturalar	
									if(list_len(document.form_basket.row_ship_id.value,';') > 1)
									{
										new_period = list_getat(document.form_basket.row_ship_id.value,2,';');
										var get_period =wrk_safe_query("stk_get_period","dsn",0,new_period);
										new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
									}
									else
										new_dsn2 = "#dsn2#";
									var get_ship_control = wrk_safe_query("stk_get_ship_control",new_dsn2,0, document.form_basket.wrk_row_relation_id.value);//seçilen irsaliye miktarı
									//var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value));
									var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value));
									if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
									{
										if(total_inv_amount > get_ship_control.AMOUNT)
											ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
									}
								}
							}
							if(ship_product_list != '')
							{
								alert("<cf_get_lang no='119.Aşağıda Belirtilen Ürünler İçin İade Miktarı Toptan Satış Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
								return false;
							}
						}
					</cfoutput>
				</cfif>
				// xml de proje kontrolleri yapılsın seçilmişse
				<cfif xml_control_project eq 1>
					var irsaliye_deger_list = document.form_basket.irsaliye_project_id_listesi.value;
					if(irsaliye_deger_list != '')
						{
							var liste_uzunlugu = list_len(irsaliye_deger_list);
							for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var project_id_ = list_getat(irsaliye_deger_list,str_i_row,',');
									if(document.form_basket.project_id.value != '' && document.form_basket.project_head.value != '')
										var sonuc_ = document.form_basket.project_id.value;
									else
										var sonuc_ = 0;
									if(project_id_ != sonuc_)
										{
											alert('İlgili İrsaliyeye Bağlı İrsaliyelerin Projeleri İle İrsaliyede Seçilen Proje Aynı Olmalıdır!');
											return false;
										}
								}
						}
				</cfif>
				<cfif xml_control_order_date eq 1>
					var siparis_deger_list = document.form_basket.siparis_date_listesi.value;
					if(siparis_deger_list != '')
						{
							var liste_uzunlugu = list_len(siparis_deger_list);
							for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(siparis_deger_list,str_i_row,',');
									var sonuc_ = datediff(document.form_basket.ship_date.value,tarih_,0);
									if(sonuc_ > 0)
										{
											alert('<cf_get_lang no="126.İrsaliye Tarihi Sipariş Tarihinden Önce Olamaz">!');
											return false;
										}
								}
						}
				</cfif>
			<cfif not isdefined("attributes.event") or attributes.event is 'add'>
					<cfif (xml_disable_change eq 1 and isdefined("attributes.invent_return_row_ids") and isdefined("attributes.subscription_id")) or (xml_disable_change eq 1 and isdefined("attributes.kons_row_ids"))>
						if(document.form_basket.amount.length != undefined && document.form_basket.amount.length >1)
						{
							var bsk_rowCount = form_basket.amount.length;
							for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
								{
									document.form_basket.amount[str_i_row].removeAttribute('disabled');
								}
						}
						else if(document.form_basket.amount != undefined && document.form_basket.amount.value != '')
						{
							document.form_basket.amount.removeAttribute('disabled');
						}
					</cfif>
				<cfelse>
					<cfif (xml_disable_change eq 1 and GET_SF.recordcount) or (xml_return_disable_change eq 1 and isdefined("get_upd_purchase") and get_upd_purchase.is_from_return eq 1)>
						if(document.form_basket.amount.length != undefined && document.form_basket.amount.length >1)
						{
							var bsk_rowCount = form_basket.amount.length;
							for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
								{
									document.form_basket.amount[str_i_row].removeAttribute('disabled');
								}
						}
						else if(document.form_basket.amount != undefined && document.form_basket.amount.value != '')
						{
							document.form_basket.amount.removeAttribute('disabled');
						}
					</cfif>
				</cfif>
				saveForm();
				return false;
			}
	<cfif not isdefined("attributes.event") or attributes.event is 'add'>
				<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
				function mal_alimi_sec()
				{
					max_sel = form_basket.process_cat.options.length;
					for(my_i=0;my_i<=max_sel;my_i++)
					{
						deger = form_basket.process_cat.options[my_i].value;
						if(deger!="")
						{
							var fis_no = eval("form_basket.ct_process_type_" + deger );
							if(fis_no.value == 140)
							{
								form_basket.process_cat.options[my_i].selected = true;
								my_i = max_sel + 1;
							}
						}
					}
				}
			</cfif>
			function change_deliver_date()
			{//eklemede,irsaliye tarihi değiştiğinde fiili sevk tarihi de değişir
				document.form_basket.deliver_date_frm.value = document.form_basket.ship_date.value;
			}
			
			<cfif (xml_disable_change eq 1 and isdefined("attributes.invent_return_row_ids") and isdefined("attributes.subscription_id")) or (xml_disable_change eq 1 and isdefined("attributes.kons_row_ids"))>
				if(document.form_basket.amount.length != undefined && document.form_basket.amount.length >1)
				{
					var bsk_rowCount = form_basket.amount.length;
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
					{
						document.form_basket.amount[str_i_row].setAttribute('disabled','yes');
					}
				}
				else if(document.form_basket.amount != undefined && document.form_basket.amount.value != '')
				{
					document.form_basket.amount.setAttribute('disabled','yes');
				}
				gizle(stock_order_add_btn);
				gizle(basket_header_add);
				gizle(sepetim_search);
				<cfif isdefined("attributes.invent_return_row_ids")>
					<cfloop from="1" to="#listlen(attributes.invent_return_row_ids)#" index="ccc">
						<cfoutput>gizle(basket_row_add_#ccc#);</cfoutput>
					</cfloop>
				<cfelse>
					<cfloop from="1" to="#listlen(attributes.kons_row_ids)#" index="ccc">
						<cfoutput>gizle(basket_row_add_#ccc#);</cfoutput>
					</cfloop>
				</cfif>
			</cfif>
		
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	function cagir()
	{
		<cfoutput>
		<cfquery name="GET_SERIALS" datasource="#DSN2#">
        	SELECT SERIAL_NO FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #url.ship_id# AND PROCESS_CAT = #attributes.SHIP_TYPE#
        </cfquery>
        <cfif GET_SERIALS.recordcount>
            <cfquery name="get_out_serials" datasource="#dsn2#"><!---çıkışı yapılmış serisi varmı? py 092014 --->
                SELECT SERIAL_NO FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE SERIAL_NO IN ('#valuelist(GET_SERIALS.SERIAL_NO)#') AND IN_OUT = 0
            </cfquery>
            <cfif get_out_serials.recordcount>
				if(!confirm("Çıkışı Yapılmış Seriler Bulunmaktadır. Silmek İstediğinize Emin Misiniz?")) return false;
            </cfif>
        </cfif>
        </cfoutput>
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chck_zero_stock(1)) return false; //sadece silme işleminden cagrılırken 1 gönderiliyor
		<cfif len(get_inv.invoice_number)>
			if(!confirm("<cf_get_lang no='260.Bu irsaliye fatura ile ilişkilendirilmiş silmek istediğinizden emin misiniz'>?")) return false;
		</cfif>
		form_basket.del.value=1;
		saveForm();
		return false;
	}
	function chck_zero_stock(is_del)
	{ 
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value,0,is_del)) return false;
			}
		}
		return true;
	}

	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_purchase';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/form_add_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_purchase)";

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_add_purchase';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/form_upd_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'upd_id=##attributes.upd_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.upd_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(form_upd_purchase);";
	
	if(attributes.event is 'add')
	{
		if(listgetat(attributes.fuseaction,1,'.') is not 'service')
			{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
					i=0;
					if(workcube_mode eq 0){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[2402]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_workxml_data_service','small')";
					i=i+1;
					}
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['text'] = "PHL'den İrsaliye Oluştur";
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_from_file&from_where=2";
					tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

			}
	}
	else if(attributes.event is 'upd')       
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.form_upd_purchase&action_name=ship_id&action_id=#attributes.ship_id#&relation_papers_type=SHIP_ID','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[268]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_ship_receive_rate&ship_id=#attributes.ship_id#&is_purchase=1','list','popup_list_ship_receive_rate');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = 'İrsaliye Dağıtım';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_list_ship_delivery&ship_id=#url.ship_id#','wwide');";
		if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is not 'service')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[305]# #lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
		}
		else if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is 'service')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[305]# #lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "window.opener.location.href='#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#';self.close();";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = 'Ek Bilgi';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.ship_id#&type_id=-14','list');";	
		i=5;
		if(session.ep.our_company_info.workcube_sector eq 'it'){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = 'Stok Hareketleri';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.UPD_ID#&in_or_out=1','list');";
		i=i+1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = 'İlişkili Belge ve Notlar';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='SHIP_ID' action_id='#url.ship_id#'>";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		if(listgetat(attributes.fuseaction,1,'.') is not 'service'){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_purchase&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=stock.form_add_purchase&event=add&is_ship_copy=1&ship_id=#attributes.UPD_ID#";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30<cfif fuseaction contains 'service'>&keyword=service</cfif>','page','workcube_print');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockPurchase';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SHIP';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	if(attributes.event is 'upd'){
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-comp_name','item-ship_number','item-ship_date','item-department_name','item-deliver_date_frm','item-project_head']";
	}
	else if(attributes.event is 'add'){
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-comp_name','item-ship_number','item-ship_date','item-txt_departman_','item-deliver_date_frm','item-project_head']";
	}
</cfscript>
