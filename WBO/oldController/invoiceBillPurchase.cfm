<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and listfindnocase('add,upd',attributes.event))>
	<cfinclude template="../invoice/query/get_session_cash_all.cfm">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>
		<cf_xml_page_edit fuseact="invoice.form_add_bill_purchase">
		<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
        <cfset kontrol_status = 1>
        <cfinclude template="../invoice/query/control_bill_no.cfm">
        <cfparam name="attributes.partner_name" default="">
        <cfparam name="attributes.consumer_id" default="">
        <cfparam name="attributes.partner_id" default="">
		<cfparam name="attributes.consumer_reference_code" default="">
		<cfparam name="attributes.partner_reference_code" default="">
		<cfparam name="attributes.company_id" default="">
		<cfparam name="attributes.employee_id" default="">
		<cfparam name="attributes.company" default="">
		<cfparam name="attributes.member_account_code" default="">
		<cfparam name="attributes.ref_no" default="">
		<cfparam name="attributes.note" default="">
		<!--- üye bilgileri sayfasından gelince kullanılıyor --->  
		<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
            <cfset attributes.company_id = attributes.company_id>
            <cfset attributes.company = get_par_info(attributes.company_id,1,1,0)>
            <cfif len(attributes.partner_id)>
                <cfset attributes.partner_id = attributes.partner_id>
                <cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
            <cfelse>
                <cfquery name="get_manager_partner" datasource="#dsn#">
                    SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
                </cfquery>
                <cfset attributes.partner_id = get_manager_partner.manager_partner_id>
                <cfset attributes.partner_name = get_par_info(get_manager_partner.manager_partner_id,0,-1,0)>
            </cfif>
            <cfset attributes.member_account_code = GET_COMPANY_PERIOD(attributes.company_id)>
        <cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
            <cfset attributes.consumer_id = attributes.consumer_id>
            <cfset attributes.partner_name = get_cons_info(attributes.consumer_id,0,0)>
            <cfset attributes.member_account_code = GET_CONSUMER_PERIOD(attributes.consumer_id)>
        <cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
            <cfquery name="get_project_info" datasource="#dsn#">
                SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID =#attributes.project_id#
            </cfquery>
            <cfif len(get_project_info.partner_id)>
                <cfset attributes.company_id = get_project_info.company_id>
                <cfset attributes.partner_id = get_project_info.partner_id>
                <cfset attributes.partner_name = get_par_info(get_project_info.partner_id,0,-1,0)>
                <cfset attributes.company =get_par_info(get_project_info.company_id,1,0,0)>
                <cfset attributes.member_account_code = GET_COMPANY_PERIOD(get_project_info.company_id)>
            <cfelseif len(get_project_info.consumer_id)>
                <cfset attributes.consumer_id = get_project_info.consumer_id>
                <cfset attributes.partner_name = get_cons_info(get_project_info.consumer_id,0,0)>
                <cfset attributes.company =get_cons_info(get_project_info.consumer_id,2,0)>
                <cfset attributes.member_account_code = GET_CONSUMER_PERIOD(get_project_info.consumer_id)>
            </cfif>
        </cfif>
		<cfset invoice_date = now()>
		<cfset serial_no = ''>
		<cfset serial_number = ''>
		<cfif isdefined("attributes.receiving_detail_id")>
            <!--- Gelen e-fatura sayfasindaki xml degerleri aliniyor. --->
            <cf_xml_page_edit fuseact="objects.popup_dsp_efatura_detail">
            <cfquery name="GET_INV_DET" datasource="#DSN2#">
                SELECT ISSUE_DATE,EINVOICE_ID FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> 
            </cfquery>
            <cfif get_inv_det.recordcount>
                <cfset invoice_date = get_inv_det.issue_date>
                <cfif xml_separate_serial_number>
                    <cfset serial_no = right(get_inv_det.einvoice_id,13)>
                    <cfset serial_number = left(get_inv_det.einvoice_id,3)>
                <cfelse>
                    <cfset serial_no = get_inv_det.einvoice_id>
                </cfif>
                <script type="text/javascript">
                    try{
                        window.onload = function () { change_money_info('form_basket','invoice_date');}
                    }
                    catch(e){}
                </script>
            </cfif>
        </cfif>
        <cfif xml_show_ship_address eq 1>
         <!--- Uye Bilgilerinden gelindiginde teslim yeri alaninin dolu gelmesi icin eklendi --->
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                <cfquery name="get_ship_address" datasource="#dsn#">
                    SELECT
                        TOP 1 *
                    FROM
                        (	SELECT 0 AS TYPE,COMPBRANCH_ID,COMPBRANCH_ADDRESS AS ADDRESS,POS_CODE,SEMT,COUNTY_ID AS COUNTY,CITY_ID AS CITY,COUNTRY_ID AS COUNTRY FROM COMPANY_BRANCH WHERE IS_SHIP_ADDRESS = 1 AND COMPANY_ID = #attributes.company_id# 
                            UNION
                            SELECT 1 AS TYPE,-1 COMPBRANCH_ID,COMPANY_ADDRESS AS ADDRESS,POS_CODE,SEMT,COUNTY,CITY,COUNTRY FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
                        ) AS TYPE
                    ORDER BY
                        TYPE 
                </cfquery>
                <cfset address_ = get_ship_address.address>
                <cfset attributes.ship_address_id_ = get_ship_address.COMPBRANCH_ID>
                <cfif len(get_ship_address.pos_code) and len(get_ship_address.semt)>
                    <cfset address_ = "#address_# #get_ship_address.pos_code# #get_ship_address.semt#">
                </cfif>
                <cfif len(get_ship_address.county)>
                    <cfquery name="get_county_name" datasource="#dsn#">
                        SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_ship_address.county#
                    </cfquery>
                    <cfset attributes.ship_address_county_id = get_county_name.county_id>
                    <cfset address_ = "#address_# #get_county_name.county_name#">
                </cfif>
                <cfif len(get_ship_address.city)>
                    <cfquery name="get_city_name" datasource="#dsn#">
                        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_ship_address.city#
                    </cfquery>
                    <cfset attributes.ship_city_id = get_city_name.city_id>
                    <cfset address_ = "#address_# #get_city_name.city_name#">
                </cfif>
                <cfif len(get_ship_address.country)>
                    <cfquery name="get_country_name" datasource="#dsn#">
                        SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_ship_address.country#
                    </cfquery>
                    <cfset address_ = "#address_# #get_country_name.country_name#">
                </cfif>
            </cfif>
		 <!--- //Uye Bilgilerinden gelindiginde teslim yeri alaninin dolu gelmesi icin eklendi ---> 
         </cfif>
         <cfif isdefined('attributes.contract_id') and len(attributes.contract_id)>
            <cfquery name="getContract" datasource="#dsn3#">
                SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
            </cfquery> 
		 </cfif>	
     </cfif>
     <cfif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfsetting showdebugoutput="yes">
        <cf_xml_page_edit fuseact="invoice.detail_invoice_purchase">
        <cfif isnumeric(attributes.iid)>
            <cfinclude template="../invoice/query/get_purchase_det.cfm">
        <cfelse>
            <cfset get_sale_det.recordcount = 0>
        </cfif>
        <cfif not get_sale_det.recordcount>
            <cfset hata  = 11>
            <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'>  <cf_get_lang_main no='587.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
            <cfset hata_mesaj  = message>
            <cfinclude template="../dsp_hata.cfm">
            <cfabort>
        <cfelse>
            <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
            <!--- subeden cagırılıyorsa alıs faturası sube basket sablonunu kullansın--->
                <cfset attributes.basket_id = 20> 
            <cfelse>
                <cfset attributes.basket_id = 1>
            </cfif>
            <cfinclude template="../objects/query/paper_closed_control.cfm">
            <cfinclude template="../invoice/query/get_inv_cancel_types.cfm">
            <cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
            <cfscript>session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);</cfscript>
            <cfparam name="attributes.invoice_number" default="#get_sale_det.invoice_number#">
		</cfif> 
        <cfquery name="get_contract_comp" datasource="#dsn2#">
            SELECT RELATED_ACTION_ID FROM INVOICE_ROW WHERE INVOICE_ID = #attributes.iid# AND RELATED_ACTION_TABLE = 'INVOICE_CONTRACT_COMPARISON'
        </cfquery>
		<cfif len(get_sale_det.company_id)>
            <cfset member_account_code = get_company_period(get_sale_det.company_id)>
        <cfelseif len(get_sale_det.consumer_id)>
            <cfset member_account_code = get_consumer_period(get_sale_det.consumer_id)>
        <cfelse>
            <cfset member_account_code = get_employee_period(get_sale_det.employee_id)>
        </cfif>
     </cfif>	
</cfif>
<!--- kopyalama için birleştirme işlemleri düzenlenecek smh24032016--->
<cfif isdefined("attributes.event") and attributes.event is 'copy'>
	<cf_xml_page_edit fuseact="invoice.form_add_bill_purchase">
    <cfinclude template="../invoice/query/get_purchase_det.cfm">
    <cfif not get_sale_det.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='587.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfinclude template="../invoice/query/get_session_cash_all.cfm">
    <cfinclude template="../invoice/query/get_moneys.cfm">
    <cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
    <cfparam name="attributes.process_cat" default="#get_sale_det.process_cat#">
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfparam name="attributes.invoice_number" default="">
    <cfif len(get_sale_det.pay_method)>
		<cfset attributes.paymethod_id = get_sale_det.pay_method>
        <cfinclude template="../invoice/query/get_paymethod.cfm">
    <cfelseif len(get_sale_det.card_paymethod_id)>
        <cfquery name="GET_CARD_PAYMETHOD" datasource="#DSN3#">
            SELECT 
                CARD_NO
                <cfif get_sale_det.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi, (siparisin commethod_id si faturaya tasınıyor) --->
                ,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
                <cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
                ,COMMISSION_MULTIPLIER 
                </cfif>
            FROM 
                CREDITCARD_PAYMENT_TYPE 
            WHERE 
                PAYMENT_TYPE_ID= #get_sale_det.card_paymethod_id#
        </cfquery>  
	</cfif>
    <cfset attributes.department_id = get_sale_det.department_id>
    <cfinclude template="../invoice/query/get_dept_name.cfm">
    <cfset txt_department_name = get_dept_name.department_head>
    <cfset branch_id=get_dept_name.branch_id>
    <cfif len(get_sale_det.department_location)>
		<cfset attributes.location_id = get_sale_det.department_location>
        <cfinclude template="../invoice/query/get_location_name.cfm">
        <cfset txt_department_name = txt_department_name & "-" & get_location_name.comment>
    </cfif>
    <script type="text/javascript">
		$( document ).ready(function() {
			change_money_info('form_basket','invoice_date');
			change_paper_duedate('invoice_date');
			kontrol_yurtdisi();	
			check_process_is_sale();
		});
		function add_order()
		{	
			if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
			{	
				str_irslink = '&is_from_invoice=1&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=1&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif fusebox.circuit eq "store">+'&is_sale_store='+1</cfif>; 
				<cfif session.ep.our_company_info.project_followup eq 1>
					if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
						str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
				</cfif>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
				return true;
			}
			else (form_basket.company_id.value =="")
			{
				alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
		}
		function add_irsaliye()
		{
			if (confirm("<cf_get_lang no ='355.İrsaliye Seçerseniz Ürünler Silinecek, Emin misiniz'> ?"))
				del_rows();
			str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=purchase_upd&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value;
			<cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			</cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship' + str_irslink , 'page');
			return true;
		}
			
		function kontrol_ithalat()
		{
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
			if(deger != "")
			{
				var fis_no = eval("form_basket.ct_process_type_" + deger);
				if (fis_no.value == 591)
				{
					if(form_basket.cash != undefined && form_basket.cash.checked)
					{
						/* Talep Uzerine Kaldirildi, Sorun Olmaz ise 100 Gune Silinebilir FBS 20110601
						kasa_para_birimi = eval("form_basket.str_kasa_parasi" + form_basket.kasa.options[form_basket.kasa.selectedIndex].value);
						if(document.all.basket_money.value != kasa_para_birimi.value)
						{
							alert("<cf_get_lang no ='32.Sistem Para Birimi ile Kasanizin Para Birimi Aynı Değil'>!");
							return false;
						}
						*/
					}
					else
					{
						if(sistem_para_birimi==document.all.basket_money.value)
						{
							alert("<cf_get_lang no ='120.Sistem Para Birimi ile Fatura Para Birimi İthalat Faturası İçin Aynı'>!");
						}
					}
					$( document ).ready(function() {
						reset_basket_kdv_rates();
					});
				}
			}
			return true;
		}
		
		function check_form_info()
		{
			if(!paper_control(form_basket.serial_no,'INVOICE','false',0,'',form_basket.company_id.value,form_basket.consumer_id.value,'','',1,form_basket.serial_number)) return false;
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
				apply_deliver_date('','project_head','');
			</cfif>
			if (!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
			if (!check_accounts('form_basket')) return false;
			if (!kontrol_ithalat()) return false;
			if (!check_product_accounts()) return false;
			change_paper_duedate('invoice_date');
			saveForm();
			return false;
		}
		function kontrol2()
		{
			if (!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
			return true;	
		}
		
		function kontrol_yurtdisi()
		{
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			if(deger != "")
			{
				var fis_no = eval("form_basket.ct_process_type_" + deger);
				if(fis_no.value == 591)
				{
					$( document ).ready(function() {	
						reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
					});
				}
			}
		}
		
	</script>          
</cfif>
<!--- kopyalama için birleştirme işlemleri düzenlenecek smh24032016--->
<script type="text/javascript">
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and listfindnocase('add,upd',attributes.event))>
	function add_adress()
	{
		if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
		{
			if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					document.getElementById('deliver_cons_id').value = '';
					return true;
				}
			else
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id'; 
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					document.getElementById('deliver_comp_id').value = '';
					return true;
				}
		}
		else
		{
			<!---alert("<cf_get_lang no ='508.Cari Hesap Seçiniz'>");--->
			return false;
		}
	}
	function kontrol_yurtdisi()
		{
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			if(deger != "")
			{
				var fis_no = eval("form_basket.ct_process_type_" + deger);
				if(fis_no.value == 591)
				{		
					<cfif xml_show_cash_checkbox eq 1>
						kasa_sec.style.display = 'none';
						<cfif not IsDefined("attributes.event") and (isdefined("attributes.event") and attributes.event is 'add')>
							cash_.style.display = 'none';
						<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
							not.style.display = 'none';
						</cfif>
						if(form_basket.cash != undefined)
							form_basket.cash.checked=false;
					</cfif>
					$( document ).ready(function() 
						{
							reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
						});
				}
				else
				{
					<cfif xml_show_cash_checkbox eq 1>
						kasa_sec.style.display = '';
					</cfif>
				}
			}
		}
		function add_order()
		{	
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			if(deger == '')
			{
				alert("<cf_get_lang_main no='1358.İşlem Tipi Seçmelisiniz'> !");
				return false;
			}	
			if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
			{	
				if(eval("form_basket.ct_process_type_" + deger).value == 54 || eval("form_basket.ct_process_type_" + deger).value == 55)
				{
					is_purchase = 0;
					is_return = 1;
				}
				else
				{
					is_purchase = 1;
					is_return = 0;
				}
				str_irslink = '&is_from_invoice=1&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase='+is_purchase+'&is_return='+is_return+'&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif fusebox.circuit eq "store">+'&is_sale_store='+1</cfif>; 
				<cfif session.ep.our_company_info.project_followup eq 1>
					if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
						str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
				</cfif>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
				return true;
			}
			else (form_basket.company_id.value =="")
			{
				alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
		}
	<cfif not IsDefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>		
		function add_irsaliye()
		{
			if(form_basket.company_id.value.length || form_basket.consumer_id.value.length || form_basket.employee_id.value.length)
			{ 
				str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=purchase&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value + '&invoice_date='+form_basket.invoice_date.value<cfif fusebox.circuit eq "store">+'&is_store='+1</cfif>;
				<cfif session.ep.our_company_info.project_followup eq 1>
					if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
						str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
				 </cfif>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship' + str_irslink , 'page');
				return true;
			}
			else
			{
				alert("<cf_get_lang_main no='303.Önce Üye Seçiniz'>!");
				return false;
			}
		}
		function kontrol_ithalat()
		{
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			sistem_para_birimi = "<cfoutput>#session.ep.money#</cfoutput>";	
			if(deger != "")
			{
				var fis_no = eval("form_basket.ct_process_type_" + deger);
			
				if (fis_no.value == 591)
				{
					if(form_basket.cash != undefined && form_basket.cash.checked)
					{
					}
					else
					{
						if(sistem_para_birimi==document.all.basket_money.value)
						{
							alert("<cf_get_lang no='120.Sistem Para Birimi ile Fatura Para Birimi İthalat Faturası İçin Aynı'>!");
						}
					}
					$( document ).ready(function() 
						{
							reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
						});
				}
			}
			return true;
		}
		function kontrol()
		{
			if(!paper_control(form_basket.serial_no,'INVOICE',false,0,'',form_basket.company_id.value,form_basket.consumer_id.value,'','','',form_basket.serial_number)) return false;
			if(!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
			if(!kontrol_ithalat()) return false;
			if(!check_accounts('form_basket')) return false;
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
				apply_deliver_date('','project_head','');
			</cfif>
			if(!check_product_accounts()) return false;
			try
			{
				try{a=form_basket.row_ship_id[0].value;}catch(e){a=form_basket.row_ship_id.value;}
				if (a=="" || a=="0")
				{
					if(form_basket.department_id.value=="")
					{
						alert("<cf_get_lang no='184.Depo Seçmelisiniz'>!");
						return false;
					}
					if(form_basket.deliver_get.value=="")
					{
						alert("<cf_get_lang no='31.Teslim Alan Seçiniz'>!");
						return false;		
					}
				}
		
			}
			catch(e)
			{
				if(form_basket.department_id.value=="")
				{
					alert("<cf_get_lang no='184.Depo Seçmelisiniz'>!");
					return false;
				}
				if(form_basket.deliver_get.value=="")
				{
					alert("<cf_get_lang no='31.Teslim Alan Seçiniz'>!");
					return false;			
				}		
			}		
			
			if (document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "" && document.form_basket.employee_id.value == "")
			{ 
				alert ("<cf_get_lang no='181.Cari Hesap Seçmelisiniz !'>");
				return false;
			}
			
			<cfif xml_control_ship_date eq 1>
				var irsaliye_deger_list = document.form_basket.irsaliye_date_listesi.value;
				if(irsaliye_deger_list != '')
					{
						var liste_uzunlugu = list_len(irsaliye_deger_list);
						for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
							{
								var tarih_ = list_getat(irsaliye_deger_list,str_i_row,',');
								var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
								if(sonuc_ > 0)
									{
										alert('Fatura Tarihi İrsaliye Tarihinden Önce Olamaz!');
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
								var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
								if(sonuc_ > 0)
									{
										alert('Fatura Tarihi Sipariş Tarihinden Önce Olamaz!');
										return false;
									}
							}
					}
			</cfif>
			
			<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
			<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
					debugger;
					if(form_basket.product_id != undefined && form_basket.product_id.length != undefined && form_basket.product_id.length >1)
					{
						var bsk_rowCount_ = form_basket.product_id.length;
						prod_name_list = '';
						for(var str_i_r=0; str_i_r < bsk_rowCount_; str_i_r++)
						{
							if(document.form_basket.product_id[str_i_r].value != '')
							{
								wrk_row_id_ = document.form_basket.wrk_row_id[str_i_r].value;
								amount_ = filterNum(document.form_basket.amount[str_i_r].value);
								product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, document.form_basket.product_id[str_i_r].value);	
								/*$.ajax({
									url: '/V16/invoice/cfc/get_bill.cfc?method=get_serial_func',
									type : "get",
									async: false,
									data : {wrk_row_id :wrk_row_id_ },
									success: function(read_data) {
										data_ = $.parseJSON(read_data.replace('//',''));
										if(data_.DATA.length != 0)
										{
											console.log('aaa');
										$.each(data_.DATA,function(i){
											
											//query deki alan sırasına göre datalarınızı alabilir ve daha sonra istediğiniz kontrolü yapabilirsiniz
											get_serial_control= data_.DATA[i][0];
										   
											
										});
		
										}
									}
								});	*/
								str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
								var get_serial_control = wrk_query(str1_,'dsn3');
								if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_)
								{
									prod_name_list = prod_name_list + eval(str_i_r +1) + '.Satır : ' + document.form_basket.product_name[str_i_r].value + '\n';
								}
							}
						}
						if(prod_name_list!='')
						{
							alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
							return false;
						}
					}
					else if(document.all.product_id != undefined && document.all.product_id.value != '')
					{
						prod_id_ = document.all.product_id.value;
						wrk_row_id_ = document.all.wrk_row_id.value;
						amount_ = filterNum(document.all.amount.value);
						product_serial_control_ = wrk_safe_query("chk_product_serial1",'dsn3',0,prod_id_);
						str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
						get_serial_control_ = wrk_query(str1_,'dsn3');
						if(product_serial_control_.IS_SERIAL_NO == 1 && get_serial_control_.recordcount != amount_)
						{
							alert( '1.Satır : ' +document.all.product_name.value +" Adlı Ürün İçin Seri Numarası Girmelisiniz!");
							return false;
						}
					}
				
				</cfif>
			<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
			<cfif isdefined("xml_control_ship_amount") and xml_control_ship_amount eq 1>
			<cfoutput>
				var ship_product_list = '';
				var wrk_row_id_list_new = '';
				var amount_list_new = '';
				if(window.basket.items.length != undefined && window.basket.items.length >1)
				{
					var bsk_rowCount = window.basket.items.length; 
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
					{
						if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
						{
							if(list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID ))
							{
								row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID );
								amount_info = list_getat(amount_list_new,row_info);
								amount_info = parseFloat(amount_info) + parseFloat(filterNum(window.basket.items[str_i_row].AMOUNT));
								amount_list_new = list_setat(amount_list_new,row_info,amount_info);
							}
							else
							{
								wrk_row_id_list_new = wrk_row_id_list_new + ',' + window.basket.items[str_i_row].WRK_ROW_RELATION_ID;
								amount_list_new = amount_list_new + ',' + filterNum(window.basket.items[str_i_row].AMOUNT);
							}
						}
					}
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
					{
						if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
						{
							var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	
							if(list_len(window.basket.items[str_i_row].ROW_SHIP_ID,';') > 1)
							{
								new_period = list_getat(window.basket.items[str_i_row].ROW_SHIP_ID,2,';');
								var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period );
								new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
							}
							else
								new_dsn2 = "#dsn2#";
							var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,window.basket.items[str_i_row].WRK_ROW_REALTION_ID);
							var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,window.basket.items[str_i_row].WRK_ROW_REALTION_ID);
							
							ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
							row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_REALTION_ID);
							amount_info = list_getat(amount_list_new,row_info);
							var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
							if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
							{
								if(total_inv_amount > ship_amount_)
									ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
							}
						}
					}
				}	
				else if(window.basket.items[0].PRODUCT_ID != undefined && window.basket.items[0].PRODUCT_ID!='')
				{
					if(window.basket.items[0].PRODUCT_ID != '' && window.basket.items[0].WRK_ROW_RELATION_ID != '' && window.basket.items[0].ROW_SHIP_ID != '')
					{
						var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id[0].value);	
						if(list_len(document.form_basket.row_ship_id[0].value,';') > 1)
						{
							new_period = list_getat(window.basket.items[0].ROW_SHIP_ID ,2,';');
							var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
							new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}
						else
							new_dsn2 = "#dsn2#";
						var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,window.basket.items[0].WRK_ROW_RELATION_ID);
						var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,window.basket.items[0].WRK_ROW_RELATION_ID);
						ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
						var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(window.basket.items[0].AMOUNT));
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
						{
							if(total_inv_amount > ship_amount_)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[0].value + '\n';
						}
					}
				}
				else if(document.all.product_id != undefined && document.all.product_id.value != '')
				{
					if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != '')
					{
						var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0, document.form_basket.wrk_row_relation_id.value);	
						if(list_len(document.form_basket.row_ship_id.value,';') > 1)
						{
							new_period = list_getat(document.form_basket.row_ship_id.value,2,';');
							var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
							new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}
						else
							new_dsn2 = "#dsn2#";
						var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,document.form_basket.wrk_row_relation_id.value);	
						var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,document.form_basket.wrk_row_relation_id.value);
						ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
						var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value));
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
						{
							if(total_inv_amount > ship_amount_)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
						}
					}
				}
				if(ship_product_list != '')
				{
					alert("Aşağıda Belirtilen Ürünler İçin Toplam Fatura Miktarı İrsaliye Miktarından Fazla ! Lütfen Ürünleri Kontrol Ediniz ! \n\n" + ship_product_list);
					return false;
				}
			</cfoutput>
			</cfif>
			//irsaliye satır kontrolü
			<cfif xml_control_ship_row eq 1>
				ship_list_ = document.getElementById('irsaliye_id_listesi').value; 
				if(ship_list_ != '')
				{
					var ship_row_list = '';
					if(window.basket.items.length != undefined && window.basket.items.length >1)
					{
						var bsk_rowCount = window.basket.items.length; 
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID == '')
							{
								ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
							}
						}
						
					}	
					else if(window.basket.items[0].PRODUCT_ID != undefined && window.basket.items[0].PRODUCT_ID!='')
					{
						if(window.basket.items[0].PRODUCT_ID != '' && window.basket.items[0].WRK_ROW_RELATION_ID == '')
						{
							ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[0].PRODUCT_ID + '\n';
						}
					}
					else if(document.all.product_id != undefined && document.all.product_id.value != '')
					{
						if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value == '' )
						{
							ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
						}
					}
					if(ship_row_list != '')
					{
						alert("Aşağıda Belirtilen Ürünler İlişkili İrsaliye Dışında Eklenmiştir.  ! Lütfen Ürünleri Kontrol Ediniz ! \n\n" + ship_row_list);
						return false;
					}
				}
			</cfif>
			change_paper_duedate('invoice_date');
			saveForm();
			return false;
		}
		function ayarla_gizle_goster()
		{
			if(form_basket.cash != undefined &&  form_basket.cash.checked)
				cash_.style.display = '';
			else
				cash_.style.display = 'none';
		}
	</cfif>
	<cfif isdefined("attributes.event") and attributes.event is 'upd'>
		function openVoucher()
		{
			window.open('<cfoutput>#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=#attributes.iid#&inv_order_id=#get_order.ORDER_ID#&str_table=INVOICE&rate_round_num='+window.basket.hidden_values.basket_rate_round_number_+'&round_number='+window.basket.hidden_values.basket_total_round_number_.value+'&branch_id='+document.form_basket.branch_id.value</cfoutput>,'page','detail_invoice_purchase');		
		}
		function add_irsaliye()
		{
			var irs_list='';
			if(window.basket.items.length)
			{
				for(i=0;i<window.basket.items.length;i++)
				{
					if(!list_find(irs_list,window.basket.items[i].ROW_SHIP_ID,','))
					{
						if(i!=0)
							irs_list = irs_list + ',' ;
						irs_list = irs_list + window.basket.items[i].ROW_SHIP_ID;
					}
				}
			}
			else
				irs_list = irs_list + 0;
		
			str_irslink = '&ship_id_liste=' + irs_list + '&id=purchase_upd&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value<cfif fusebox.circuit eq "store">+'&is_store='+1</cfif>;
			<cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			</cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship' + str_irslink , 'wide');
			return true;
		}
		function kontrol_ithalat()
			{
				deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
				sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
				if(deger != "")
				{
					var fis_no = eval("form_basket.ct_process_type_" + deger);
					if (fis_no.value == 591)
					{
						if(form_basket.cash != undefined && form_basket.cash.checked)
						{
						}
						else
						{
							if(sistem_para_birimi==document.all.basket_money.value)
							{
								alert("<cf_get_lang no='120.Sistem Para Birimi ile Fatura Para Birimi İthalat Faturası İçin Aynı'>!");
							}
						}
						$( document ).ready(function() 
						{
							reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
						});
					}
				}
				return true;
			}
			function kontrol()
			{
				var is_invoice_cost = true;
				if (!paper_control(form_basket.serial_no,'INVOICE',false,<cfoutput>'#attributes.iid#','#get_sale_det.serial_no#'</cfoutput>,form_basket.company_id.value,form_basket.consumer_id.value,'','',1,form_basket.serial_number)) return false;
				if(document.form_basket.is_cost.value==0) is_invoice_cost = false;
				
				//Odeme Plani Guncelleme Kontrolleri
				if (document.form_basket.invoice_cari_action_type.value == 5 && document.form_basket.old_pay_method.value != "")
				{
					if (confirm("<cf_get_lang_main no='1663.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'>!"))
						document.form_basket.invoice_payment_plan.value = 1;
					else
					{
						document.form_basket.invoice_payment_plan.value = 0;
						<cfif xml_control_payment_plan_status eq 1>
							return false;
						</cfif>
					}
				}
				if (document.getElementById('fatura_iptal') != undefined && document.getElementById('fatura_iptal').checked == false && document.form_basket.invoice_payment_plan.value == 0)
				{
					var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>" ;
					var payment_plan_info = wrk_safe_query("inv_payment_plan",'dsn3',0,listParam);
					if(payment_plan_info.recordcount)
					{
						if((document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || document.form_basket.old_net_total.value != wrk_round(document.all.basket_net_total.value,document.form_basket.basket_total_round_number_.value) || (payment_plan_info.COMPANY_ID != '' && payment_plan_info.COMPANY_ID != form_basket.company_id.value) || (form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + temp_process_cat).value))
						{
							alert("Ödeme Planı Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez!");
							return false;
						}				
					}
				}
				
				
				if (is_invoice_cost && !confirm("<cf_get_lang no='269.Güncellediğiniz Faturanın Masraf Gelir Dağıtımı Yapılmış,Devam Ederseniz Bu Dağıtım Silinecektir'>!")) return false;
				if(form_basket.department_id.value=="")
				{
					alert("<cf_get_lang no='184.Depo Seçmelisiniz'>!");
					return false;
				}
				if (!chk_process_cat('form_basket')) return false;
				if (!check_display_files('form_basket')) return false;
				if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
				if (!check_accounts('form_basket')) return false;
				if (!kontrol_ithalat()) return false;
				<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
					apply_deliver_date('','project_head','');
				</cfif>
				if(!check_product_accounts()) return false;
				change_paper_duedate('invoice_date');	
				<cfif not get_module_power_user(20)>
					var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value ;
					var closed_info = wrk_safe_query("inv_closed_info",'dsn2',0,listParam);
					if(closed_info.recordcount)
						if((document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || (document.form_basket.old_net_total.value != wrk_round(document.all.basket_net_total.value,document.form_basket.basket_total_round_number_.value)) || (closed_info.COMPANY_ID != '' && closed_info.COMPANY_ID != form_basket.company_id.value) || (closed_info.CONSUMER_ID != '' && closed_info.CONSUMER_ID != form_basket.consumer_id.value) || (form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + deger).value))
						{
							alert("Belge Kapama,Talep veya Emir Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez!");
							return false;
						}
				</cfif>
				<cfif xml_control_ship_date eq 1>
					var irsaliye_deger_list = document.form_basket.irsaliye_date_listesi.value;
						if(irsaliye_deger_list != '')
							{
								var liste_uzunlugu = list_len(irsaliye_deger_list);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
									{
										var tarih_ = list_getat(irsaliye_deger_list,str_i_row,',');
										var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
										if(sonuc_ > 0)
											{
												alert('Fatura Tarihi İrsaliye Tarihinden Önce Olamaz!');
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
									var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
									if(sonuc_ > 0)
										{
											alert('Fatura Tarihi Sipariş Tarihinden Önce Olamaz!');
											return false;
										}
								}
						}
				</cfif>
				<cfoutput>
				<cfif isdefined("xml_control_ship_amount") and xml_control_ship_amount eq 1>
					var ship_product_list = '';
					var wrk_row_id_list_new = '';
					var amount_list_new = '';
					console.log(window.basket.items);
					if(window.basket.items.length != undefined && window.basket.items.length >1)
					{
						var bsk_rowCount =  window.basket.items.length; 
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
							{
								if(list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID))
								{
									row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
									amount_info = list_getat(amount_list_new,row_info);
									amount_info = parseFloat(amount_info) + parseFloat(filterNum(window.basket.items[str_i_row].AMOUNT));
									amount_list_new = list_setat(amount_list_new,row_info,amount_info);
								}
								else
								{
									wrk_row_id_list_new = wrk_row_id_list_new + ',' + window.basket.items[str_i_row].WRK_ROW_RELATION_ID;
									amount_list_new = amount_list_new + ',' + filterNum(window.basket.items[str_i_row].AMOUNT,4);
								}
							}
						}
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID!= '')
							{
								var listParam = document.form_basket.invoice_id.value + "*" + window.basket.items[str_i_row].WRK_ROW_RELATION_ID;
								var get_inv_control = wrk_safe_query("inv_get_inv_control_2","dsn2",0,listParam);	
								if(list_len(window.basket.items[str_i_row].ROW_SHIP_ID,';') > 1)
								{
									new_period = list_getat(window.basket.items[str_i_row].ROW_SHIP_ID,2,';');
									var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
									new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
								}
								else
									new_dsn2 = "#dsn2#";
								var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
								var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
								ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
								row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
								amount_info = list_getat(amount_list_new,row_info);
								var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
								
								if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
								{
									if(total_inv_amount > ship_amount_)
										ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
								}
							}
						}
					}	
					else if(window.basket.items[0].PRODUCT_ID != undefined && window.basket.items[0].PRODUCT_ID!='')
					{
						if(window.basket.items[0].PRODUCT_ID != '' && window.basket.items[0].WRK_ROW_RELATION_ID != '' && window.basket.items[0].ROW_SHIP_ID != '')
						{
							var listParam = document.form_basket.invoice_id.value + "*" + window.basket.items[0].WRK_ROW_RELATION_ID ;
							var get_inv_control = wrk_safe_query("inv_get_inv_control_2","dsn2",0,listParam);	
							if(list_len(document.form_basket.row_ship_id[0].value,';') > 1)
							{
								new_period = list_getat(window.basket.items[0].ROW_SHIP_ID,2,';');
								var get_period = wrk_safe_query("inv_get_period","dsn",0, new_period);
								new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
							}
							else
								new_dsn2 = "#dsn2#";
							var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,window.basket.items[0].WRK_ROW_RELATION_ID);
							var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,window.basket.items[0].WRK_ROW_RELATION_ID);
							ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
							var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(window.basket.items[0].AMOUNT,4));
							if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_>0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
							{
								if(total_inv_amount > ship_amount_)
									ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[0].PRODUCT_NAME + '\n';
							}
						}
					}
					else if(document.all.product_id != undefined && document.all.product_id.value != '')
					{
						if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != '')
						{
							var listParam = document.form_basket.invoice_id.value + "*" + document.form_basket.wrk_row_relation_id.value ;
							var get_inv_control = wrk_safe_query("inv_get_inv_control_2","dsn2",0,listParam);	
							if(list_len(document.form_basket.row_ship_id.value,';') > 1)
							{
								new_period = list_getat(document.form_basket.row_ship_id.value,2,';');
								var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
								new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
							}
							else
								new_dsn2 = "#dsn2#";
							var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,document.form_basket.wrk_row_relation_id.value);	
							var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,document.form_basket.wrk_row_relation_id.value);
							ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
							var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(document.form_basket.amount.value,4));
							if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
							{
								if(total_inv_amount > ship_amount_)
									ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
							}
						}
					}
					if(ship_product_list != '')
					{
						alert("Aşağıda Belirtilen Ürünler İçin Toplam Fatura Miktarı İrsaliye Miktarından Fazla ! Lütfen Ürünleri Kontrol Ediniz ! \n\n" + ship_product_list);
						return false;
					}
				</cfif>
				</cfoutput>
				//irsaliye satır kontrolü
				<cfif xml_control_ship_row eq 1>
				ship_list_ = document.getElementById('irsaliye_id_listesi').value; 
				if(ship_list_ != '')
				{
					var ship_row_list = '';
					if( window.basket.items.length != undefined &&  window.basket.items.length >1)
					{
						var bsk_rowCount =  window.basket.items.length; 
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value == '')
							{
								ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name[str_i_row].value + '\n';
							}
						}
						
					}	
					else if(window.basket.items[0].PRODUCT_ID != undefined && window.basket.items[0].PRODUCT_ID!='')
					{
						if(window.basket.items[0].PRODUCT_ID != '' && window.basket.items[0].WRK_ROW_RELATION_ID == '')
						{
							ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[0].PRODUCT_NAME + '\n';
						}
					}
					else if(document.all.product_id != undefined && document.all.product_id.value != '')
					{
						if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value == '' )
						{
							ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + document.all.product_name.value + '\n';
						}
					}
					if(ship_row_list != '')
					{
						alert("Aşağıda Belirtilen Ürünler İlişkili İrsaliye Dışında Eklenmiştir.  ! Lütfen Ürünleri Kontrol Ediniz ! \n\n" + ship_row_list);
						return false;
					}
				}
				</cfif>
				return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm());
			}
			function kontrol2()
			{
				<cfif session.ep.our_company_info.is_efatura and isdefined("get_efatura_det") and get_efatura_det.recordcount>
					alert("Fatura ile İlişkili e-Fatura Olduğu için Silinemez !");
					return false;
				</cfif>
				form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
				if (!chk_process_cat('form_basket')) return false;
				if (!check_display_files('form_basket')) return false;
				if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
				var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value;
				<cfif not get_module_power_user(20)>
					var closed_info = wrk_safe_query("inv_closed_info_2",'dsn2',0,listParam);
					if(closed_info.recordcount)
					{
						alert("Faturayla İlişkili Ödeme Talebi Olduğu İçin Silinemez ! Talep ID :"+closed_info.CLOSED_ID);
						return false;
					}
				</cfif>
				return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm()); 
			}
			$( document ).ready(function() {
    			kontrol_yurtdisi();	
				check_process_is_sale();
				change_paper_duedate('invoice_date');
			});
					
	</cfif>	
</cfif>		
</script>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.form_add_bill_purchase';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'invoice/display/add_bill_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'invoice/query/add_invoice_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.form_add_bill_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_bill_purchase)";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.detail_invoice_purchase';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'invoice/display/upd_bill_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'invoice/query/upd_invoice_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.form_add_bill_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'iid=##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_purchase)";
	
	WOStruct['#attributes.fuseaction#']['copy'] = structNew();
	WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'invoice.detail_invoice_purchase';
	WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'invoice/form/copy_bill_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'invoice/query/add_invoice_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'invoice.form_add_bill_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['copy']['parameters'] = 'iid=##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['copy']['Identity'] = '##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['copy']['js'] = "javascript:gizle_goster_basket(copy_purchase)";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invoice.emptypopup_upd_bill_purchase&invoice_id=#attributes.iid#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'invoice/query/upd_invoice_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'invoice/query/upd_invoice_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#fusebox.circuit#.list_bill';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&old_process_type&del_invoice_id&invoice_number';
	}
	
	
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.detail_invoice_purchase&action_name=iid&action_id=#attributes.iid#&relation_papers_type=INVOICE_ID','list');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[258]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders&invoice_id=#url.iid#&is_purchase=1','list')";
					
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[217]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.iid#&page_type=1&basket_id=#attributes.basket_id#','horizantal');";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[264]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_expensecenter_invoice&id=#url.iid#&sale_partner=#get_sale_det.SALE_PARTNER#&sales_emp=#get_sale_det.SALE_EMP#','horizantal')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[1339]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onclick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_get_contract_comparison&iid=#url.iid#&type=0','wwide')";
		
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[2577]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill')";
	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array.item[323]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_pursuits_documents_plus&action_id=#attributes.iid#&pursuit_type=is_sale_invoice','medium')";
	
		i = 7;
		if(session.ep.our_company_info.guaranty_followup)
		{			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[305]#';
			if(fusebox.circuit is 'store')
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=store.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
			else
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
			i = i + 1;
		}
       
		if(len(get_sale_det.consumer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[397]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = '#request.self#?fuseaction=ch.list_extre&member_type=consumer&member_id=#get_sale_det.consumer_id#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
		else if(len(get_sale_det.company_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[397]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = '#request.self#?fuseaction=ch.list_extre&member_type=partner&member_id=#get_sale_det.company_id#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
		if(listfind('48,49,50,51,58,63',get_sale_det.invoice_cat,','))	
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[322]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_add_product_cost_invoice&invoice_id=#url.iid#','horizantal')";
			i = i + 1;
		}

		if(get_sale_det.invoice_cat eq 591)
		{						
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1791]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_imports_invoice_comparison_list&invoice_id=#url.iid#','list')";
			i = i + 1;
		}	
		
		 if(len(get_sale_det.pay_method))
		 {	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[324]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "openVoucher()";
		 }
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['customTag'] = '<cf_np dsn_var="dsn2" tablename="INVOICE" primary_key = "INVOICE_ID" where="PURCHASE_SALES=0"  pointer = "iid=#url.iid#,event=upd">';

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array.item[262]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase&event=copy&iid=#attributes.iid#";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase";				
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'invoiceBillPurchase';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVOICE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_stage','item-comp_name','item-partner_name','item-serial_no','item-invoice_date','item-location_info_']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
