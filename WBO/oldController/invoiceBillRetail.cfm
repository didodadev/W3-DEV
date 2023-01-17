<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and listfindnocase('add,upd',attributes.event))>	
    <cfquery name="GET_CITY" datasource="#dsn#">
        SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY CITY_NAME
    </cfquery>
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>
    	<cf_xml_page_edit fuseact="invoice.add_bill_retail">
        <cfset member_ims_code_id = ''>
        <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
        <cfinclude template="../invoice/query/control_bill_no.cfm">
        <cfquery name="GET_CONSUMER_STAGE" datasource="#dsn#" maxrows="1">
            SELECT TOP 1
                PTR.STAGE,
                PTR.PROCESS_ROW_ID,
                PTR.LINE_NUMBER
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
            ORDER BY 
                PTR.LINE_NUMBER
        </cfquery>
        <cfquery name="GET_COMPANY_STAGE" datasource="#dsn#" maxrows="1">
            SELECT TOP 1
                PTR.STAGE,
                PTR.PROCESS_ROW_ID,
                PTR.LINE_NUMBER
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
            ORDER BY 
                PTR.LINE_NUMBER
        </cfquery>
        <cfparam name="attributes.member_type" default="2">
        <cfparam name="attributes.comp_member_cat" default="">
        <cfparam name="attributes.cons_member_cat" default="">
        <cfparam name="attributes.field_vocation" default="">
        <cfquery name="get_vocation_type" datasource="#dsn#">
            SELECT VOCATION_TYPE_ID, VOCATION_TYPE FROM SETUP_VOCATION_TYPE ORDER BY VOCATION_TYPE
        </cfquery>
        <cfquery name="get_consumer_cat" datasource="#dsn#">
            SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_DEFAULT = 1
        </cfquery>
        <cfset user_dep_id = listgetat(session.ep.user_location,1,'-')>
        <cfquery name="GET_DEPARTMENT_NAME" datasource="#DSN#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                DEPARTMENT.BRANCH_ID,
                STOCKS_LOCATION.LOCATION_ID,
                STOCKS_LOCATION.COMMENT
            FROM
                DEPARTMENT,
                STOCKS_LOCATION
            WHERE
                DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID AND
                DEPARTMENT.DEPARTMENT_ID = #user_dep_id# AND
                DEPARTMENT.IS_STORE <> 2 AND
                STOCKS_LOCATION.PRIORITY = 1 
        </cfquery>
		<cfif GET_DEPARTMENT_NAME.recordcount>
            <cfset dept_name=GET_DEPARTMENT_NAME.DEPARTMENT_HEAD & '-' & GET_DEPARTMENT_NAME.COMMENT>
        <cfelse>
            <cfset dept_name="">
        </cfif>
		<cfif len(member_ims_code_id)>
            <cfquery name="get_ims" datasource="#dsn#">
                SELECT * FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #member_ims_code_id#
            </cfquery>
        </cfif>	
            <cfquery name="GET_COMPANYCAT" datasource="#DSN#">
                SELECT DISTINCT	
                    COMPANYCAT_ID,
                    COMPANYCAT
                FROM
                    GET_MY_COMPANYCAT
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                ORDER BY
                    COMPANYCAT
            </cfquery>
            <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
                SELECT DISTINCT
                    CONSCAT_ID,
                    CONSCAT,
                    HIERARCHY
                FROM
                    GET_MY_CONSUMERCAT
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    AND IS_ACTIVE = 1
                ORDER BY
                    CONSCAT	
            </cfquery>			
		<cfset attributes.basket_id = 18>
        <cfset attributes.form_add = 1>
		<cfset attributes.is_retail=1>	     
     </cfif>	
     <cfif IsDefined("attributes.event") and attributes.event is 'upd'>
     	<cf_xml_page_edit fuseact="invoice.detail_invoice_retail">
		<cfif isnumeric(attributes.iid)>
            <cfinclude template="../invoice/query/get_sale_det.cfm">
        <cfelse>
            <cfset get_sale_det.recordcount = 0>
        </cfif>
		<cfif not get_sale_det.recordcount>
            <cfset hata  = 11>
            <cfsavecontent variable="message"><cf_get_lang_main no='587.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
            <cfset hata_mesaj  = message>
            <cfinclude template="../dsp_hata.cfm">
            <cfabort>
        <cfelse>
            <cfinclude template="../invoice/query/get_inv_cancel_types.cfm">
            <cfquery name="GET_CITY" datasource="#dsn#">
                SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY CITY_NAME
            </cfquery>
            <cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
            <cfparam name="attributes.invoice_number" default="#get_sale_det.invoice_number#">
            <cfparam name="attributes.other_amount" default="1">
            <cfscript>
                session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);
                if (len(GET_SALE_DET.COMPANY_ID))
                    {
                    member_tax_office=GET_SALE_DET_COMP.TAXOFFICE;
                    member_tax_no=GET_SALE_DET_COMP.TAXNO;
                    member_tel_cod=GET_SALE_DET_COMP.COMPANY_TELCODE;
                    member_tel=GET_SALE_DET_COMP.COMPANY_TEL1;
                    member_fax=GET_SALE_DET_COMP.COMPANY_FAX;											
                    member_adres=GET_SALE_DET_COMP.COMPANY_ADDRESS;
                    member_city=GET_SALE_DET_COMP.CITY;
                    member_county=GET_SALE_DET_COMP.COUNTY;
                    member_mail=GET_SALE_DET_COMP.COMPANY_EMAIL;
                    member_code=GET_SALE_DET_COMP.MEMBER_CODE;
                    ims_code_id_ = GET_SALE_DET_COMP.IMS_CODE_ID;
                    member_mobil_cod='';
                    member_mobil='';
                    member_tc_no='';
                    vocation_type='';
                    member_type=GET_SALE_DET_COMP.COMPANYCAT_ID;
                    }
                else if(len(GET_SALE_DET.CONSUMER_ID))
                    {
                    member_tax_office=GET_CONS_NAME.TAX_OFFICE;
                    member_tax_no=GET_CONS_NAME.TAX_NO;
                    member_tel_cod=GET_CONS_NAME.CONSUMER_WORKTELCODE;
                    member_tel=GET_CONS_NAME.CONSUMER_WORKTEL;
                    member_fax=GET_CONS_NAME.CONSUMER_FAX;											
                    member_adres=GET_CONS_NAME.TAX_ADRESS;
                    member_city=GET_CONS_NAME.TAX_CITY_ID;
                    member_county=GET_CONS_NAME.TAX_COUNTY_ID;
                    member_mail=GET_CONS_NAME.CONSUMER_EMAIL;
                    member_code=GET_CONS_NAME.MEMBER_CODE;
                    member_mobil_cod=GET_CONS_NAME.MOBIL_CODE;
                    member_mobil=GET_CONS_NAME.MOBILTEL;
                    member_tc_no=GET_CONS_NAME.TC_IDENTY_NO;
                    vocation_type=GET_CONS_NAME.VOCATION_TYPE_ID;
                    ims_code_id_ = GET_CONS_NAME.IMS_CODE_ID;
                    member_type=GET_CONS_NAME.CONSUMER_CAT_ID;
                    }
            </cfscript>
            <cfparam name="attributes.member_type" default="2">
            <cfparam name="attributes.comp_member_cat" default="">
            <cfparam name="attributes.cons_member_cat" default="">
            <cfquery name="get_vocation_type" datasource="#dsn#">
                SELECT VOCATION_TYPE_ID, VOCATION_TYPE FROM SETUP_VOCATION_TYPE ORDER BY VOCATION_TYPE
            </cfquery>
		</cfif>
		<cfif len(member_county)>
            <cfquery name="GET_COUNTY_TAX" datasource="#DSN#">
                SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #member_county#
            </cfquery>		
        </cfif>
		<cfif len(ims_code_id_)>
            <cfquery name="get_ims" datasource="#dsn#">
                SELECT * FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #ims_code_id_#
            </cfquery>
        </cfif>
			<cfif len(GET_SALE_DET.COMPANY_ID)>
                <cfquery name="GET_COMPANYCAT" datasource="#DSN#">
                    SELECT DISTINCT	
                        COMPANYCAT_ID,
                        COMPANYCAT
                    FROM
                        GET_MY_COMPANYCAT
                    WHERE
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    ORDER BY
                        COMPANYCAT
                </cfquery>
             </cfif>
            <cfif len(GET_SALE_DET.CONSUMER_ID)>
                <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
                    SELECT DISTINCT
                        CONSCAT_ID,
                        CONSCAT,
                        HIERARCHY
                    FROM
                        GET_MY_CONSUMERCAT
                    WHERE
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                        AND IS_ACTIVE = 1
                    ORDER BY
                        CONSCAT	
                </cfquery>
			</cfif>                
        <cfquery name="GET_BANK_ACTION_INFO" datasource="#dsn2#">
            SELECT
                * 
            FROM
                INVOICE,
                INVOICE_CASH_POS,
                #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS CC
            WHERE
                INVOICE.INVOICE_ID = INVOICE_CASH_POS.INVOICE_ID AND
                INVOICE_CASH_POS.POS_ACTION_ID = CC.CREDITCARD_PAYMENT_ID AND
                CC.BANK_ACTION_ID IS NOT NULL AND
                INVOICE.INVOICE_ID = #attributes.IID#
        </cfquery> 
        <cfset attributes.basket_id = 18>
		<cfset attributes.is_retail = 1>    
     </cfif>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and listfindnocase('add,upd',attributes.event))>
		$( document ).ready(function() {
			phone_code_list = new Array(<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>);
		});			
		function get_phone_code()
		{	
			if(document.form_basket.city.selectedIndex > 0)
				{	document.form_basket.tel_code.value = phone_code_list[document.form_basket.city.selectedIndex-1];
					document.form_basket.faxcode.value = phone_code_list[document.form_basket.city.selectedIndex-1]; }
			else
				{	document.form_basket.tel_code.value = '';
					document.form_basket.faxcode.value = ''; }
		}
		function pencere_ac(no)
		{
			if (document.form_basket.city[document.form_basket.city.selectedIndex].value == "")
				alert("<cf_get_lang no='255.İlk Olarak İl Seçiniz'>!");
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_basket.county_id&field_name=form_basket.county&city_id=' + document.form_basket.city.value,'small');
		}
		function kontrol_member_cat(type)
		{
			if (type == 1)
			{
				is_company.style.display = '';
				is_consumer.style.display = 'none';
				document.getElementById('cons_member_cat').value = '';
			}
			if (type == 2)
			{
				is_company.style.display = 'none';
				is_consumer.style.display = '';
				document.getElementById('comp_member_cat').value = '';
			}
		}	
		function check_cash_pos()
		{
			/*secili kasa olup olmadigi kontrol ediliyor*/
			<cfoutput query="get_money_bskt">
				if(eval(form_basket.kasa#get_money_bskt.currentrow#)!= undefined && eval(form_basket.cash_amount#get_money_bskt.currentrow#)!= undefined && eval(form_basket.cash_amount#get_money_bskt.currentrow#).value!="")
				{
					eval(form_basket.cash_amount#get_money_bskt.currentrow#).value=filterNum((eval(form_basket.cash_amount#get_money_bskt.currentrow#).value),4);
					form_basket.cash.value=1;
				}
			</cfoutput>
			for(var a=1; a<=5; a++)
			{	
				if(eval('form_basket.pos_amount_'+a)!= undefined && eval('form_basket.pos_amount_'+a).value!="")
					{
					eval('form_basket.pos_amount_'+a).value=filterNum((eval('form_basket.pos_amount_'+a).value));
					form_basket.is_pos.value=1;
					}			
			}
			return true;
		}
		<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>
			function kontrol()
			{   
				if(!paper_control(form_basket.invoice_number,'INVOICE')) return false;
				if(!chk_process_cat('form_basket')) return false;
				if(!check_display_files('form_basket')) return false;
				if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
				if(!check_product_accounts()) return false;			
				if(form_basket.member_type[0].checked)
				{
					if(form_basket.comp_name.value=="" || form_basket.tax_office.value=="" || form_basket.tax_num.value=="" || form_basket.address.value=="")
						{
							alert("<cf_get_lang no ='337.Kurumsal Müşteri İçin Firma, Vergi Dairesi, Vergi Numarası ve Adres Bilgilerini Giriniz'>!");
							return false;
						}					
					if(form_basket.company_stage.value=="" && form_basket.company_id.value == "")
						{
							alert("<cf_get_lang no ='338.Kurumsal Üye Süreçlerinizi Kontrol Ediniz'>!");
							return false;
						}
				}
				else if(form_basket.member_type[1].checked)
				{
					if(form_basket.member_name.value=="" || form_basket.member_surname.value=="" || form_basket.address.value=="")
						{
							alert("<cf_get_lang no='256.Bireysel Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz'>!");
							return false;
						}
					if(form_basket.consumer_stage.value=="" && form_basket.consumer_id.value == "")
						{
							alert("<cf_get_lang no ='339.Bireysel Üye Süreçlerinizi Kontrol Ediniz'>!");
							return false;
						}
				}
				if(form_basket.department_id.value=="")
				{
					alert("<cf_get_lang no='282.Depo Seçiniz'>!");
					return false;
				}
				var kalan_risk_ = 0;
				if(form_basket.member_type[0].checked)//kurumsal
				{
					var risk_info = wrk_safe_query('inv_risk_info','dsn2',0,document.getElementById('company_id').value);
				}
				else if(form_basket.member_type[1].checked)//bireysel
				{
					var risk_info = wrk_safe_query('inv_risk_info2','dsn2',0,document.getElementById('consumer_id').value);
				}
				if(risk_info != undefined && risk_info.recordcount)
				{
					risk_tutar_ = parseFloat(risk_info.TOTAL_RISK_LIMIT) - parseFloat(risk_info.BAKIYE) - (parseFloat(risk_info.CEK_ODENMEDI) + parseFloat(risk_info.SENET_ODENMEDI) + parseFloat(risk_info.CEK_KARSILIKSIZ) + parseFloat(risk_info.SENET_KARSILIKSIZ));
					kalan_risk_ = parseFloat(risk_tutar_ - wrk_round(form_basket.basket_net_total.value));
				}
				else
					kalan_risk_ = -1;
					
				<cfif is_control_risk eq 1>
					if (kalan_risk_ < 0)
					{	
						if(filterNum(form_basket.total_cash_amount.value) > wrk_round(form_basket.basket_net_total.value))
						{
							alert("<cf_get_lang no='257.Tahsilat Fatura Toplamından Fazla'>");
							return false;
						}
						if(filterNum(form_basket.total_cash_amount.value) < wrk_round(form_basket.basket_net_total.value))
						{
							alert("<cf_get_lang no ='340.Tahsilat Fatura Toplamından Az'>!");
							return false;
						}
					}
				<cfelseif is_control_risk eq 2>
					if(filterNum(form_basket.total_cash_amount.value) > wrk_round(form_basket.basket_net_total.value))
					{
						alert("<cf_get_lang no='257.Tahsilat Fatura Toplamından Fazla'>");
						return false;
					}
					if(filterNum(form_basket.total_cash_amount.value) < wrk_round(form_basket.basket_net_total.value))
					{
						alert("<cf_get_lang no ='340.Tahsilat Fatura Toplamından Az'>!");
						return false;
					}
				</cfif>
				if(check_stock_action('form_basket')) //islem kategorisi stock hareketi yapıyorsa
				{
					var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
					if(basket_zero_stock_status.IS_SELECTED != 1)
					{
						var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
						var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
						if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,temp_process_type.value)) return false;
					}
				}
				return (check_cash_pos() && saveForm());
				return false;
			}			
			str_cons_link="&field_member_code=form_basket.member_code&field_comp_name=form_basket.comp_name&field_address=form_basket.address&field_mobil_code=form_basket.mobil_code&field_mobil_tel=form_basket.mobil_tel&field_tel_code=form_basket.tel_code&field_tel_number=form_basket.tel_number&field_email=form_basket.email&field_vocation=form_basket.vocation_type&field_ims_code_id=form_basket.ims_code_id&field_ims_code_name=form_basket.ims_code_name";
			str_cons_link=str_cons_link+"&field_tax_office=form_basket.tax_office&field_tax_num=form_basket.tax_num&field_county=form_basket.county&field_county_id=form_basket.county_id&field_city=form_basket.city&field_faxcode=form_basket.faxcode&field_fax_number=form_basket.fax_number&field_tc_no=form_basket.tc_num";
			str_cons_link=str_cons_link+"&field_member_name=form_basket.member_name&field_member_surname=form_basket.member_surname";
			str_cons_link=str_cons_link+"&field_company_id=form_basket.company_id&field_partner_id=form_basket.partner_id&field_consumer_id=form_basket.consumer_id";
			
			function cons_pre_records()
			{	
				if(form_basket.member_name.value!="" && form_basket.member_surname.value!="")
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&invoice_retail=1<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif>&consumer_name=' + encodeURIComponent(form_basket.member_name.value) + '&consumer_surname=' + encodeURIComponent(form_basket.member_surname.value)+ '&vocation_type_id=' + form_basket.vocation_type.value  + '&tax_no=' + form_basket.tax_num.value +str_cons_link,'project','popup_check_consumer_prerecords');
			}
			
			function comp_pre_records()
			{
				if(form_basket.comp_name.value!="")
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&invoice_retail=1<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif>&tax_num='+ encodeURIComponent(form_basket.tax_num.value) +'&fullname='+ encodeURIComponent(form_basket.comp_name.value) +'&nickname=' + encodeURIComponent(form_basket.comp_name.value) +'&name='+''+'&surname='+''+'&tel_code='+''+'&telefon='+''+str_cons_link,'project','popup_check_company_prerecords');
			}
			function tax_num_pre_records()
			{	
				if(form_basket.tax_num.value!="")
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&is_from_sale=1<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif>&tax_num='+ encodeURIComponent(form_basket.tax_num.value) +'&fullname='+ encodeURIComponent(form_basket.comp_name.value) +'&nickname=' + encodeURIComponent(form_basket.comp_name.value) +'&name='+''+'&surname='+''+'&tel_code='+''+'&telefon='+''+str_cons_link,'project','popup_check_company_prerecords');
			}
		</cfif>
		<cfif isdefined("attributes.event") and attributes.event is 'upd'>
			function kontrol()
			{	
				control_account_process(<cfoutput>'#attributes.iid#',document.form_basket.old_process_type.value</cfoutput>); 
				if (!paper_control(document.form_basket.invoice_number,'INVOICE',true,<cfoutput>'#attributes.iid#','#get_sale_det.invoice_number#'</cfoutput>)) return false;
				if (!chk_process_cat('form_basket')) return false;
				if (!check_display_files('form_basket')) return false;
				if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
				if (!check_product_accounts()) return false;
				if(form_basket.member_type[0].checked && (form_basket.comp_name.value=="" || form_basket.tax_office.value=="" || form_basket.tax_num.value=="" || form_basket.address.value==""))
				{
					alert("Kurumsal Müşteri İçin Firma, Vergi Dairesi, Vergi Numarası ve Adres Bilgilerini Giriniz!");
					return false;
				}
				else if(form_basket.member_type[1].checked && (form_basket.member_name.value=="" || form_basket.member_surname.value=="" || form_basket.address.value==""))
				{
					alert("Bireysel Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz!");
					return false;
				}				
				var kalan_risk_ = 0;
				if(form_basket.member_type[0].checked)//kurumsal
				{
					var risk_info = wrk_safe_query('inv_risk_info','dsn2',0,document.getElementById('company_id').value);
				}
				else if(form_basket.member_type[1].checked)//bireysel
				{
					var risk_info = wrk_safe_query('inv_risk_info2','dsn2',0,document.getElementById('consumer_id').value);
				}
				if(risk_info != undefined && risk_info.recordcount)
				{
					risk_tutar_ = parseFloat(risk_info.TOTAL_RISK_LIMIT) - parseFloat(risk_info.BAKIYE) - (parseFloat(risk_info.CEK_ODENMEDI) + parseFloat(risk_info.SENET_ODENMEDI) + parseFloat(risk_info.CEK_KARSILIKSIZ) + parseFloat(risk_info.SENET_KARSILIKSIZ));
					kalan_risk_ = parseFloat(risk_tutar_ - wrk_round(form_basket.basket_net_total.value));
				}
				else
					kalan_risk_ = -1;
				
				<cfif is_control_risk eq 1>
					if (kalan_risk_ < 0)
					{
						if(filterNum(form_basket.total_cash_amount.value) > wrk_round(form_basket.basket_net_total.value))
						{
							alert("Tahsilat Fatura Toplamından Fazla!");
							return false;
						}
						if(filterNum(form_basket.total_cash_amount.value) < wrk_round(form_basket.basket_net_total.value))
						{
							alert("Ödemeler Fatura Toplamından Az!");
							return false;
						}	
					}
				<cfelseif is_control_risk eq 2>
					if(filterNum(form_basket.total_cash_amount.value) > wrk_round(form_basket.basket_net_total.value))
					{
						alert("Tahsilat Fatura Toplamından Fazla!");
						return false;
					}
					if(filterNum(form_basket.total_cash_amount.value) < wrk_round(form_basket.basket_net_total.value))
					{
						alert("Ödemeler Fatura Toplamından Az!");
						return false;
					}
				</cfif>
				if(document.form_basket.fatura_iptal.checked==false)
				{
					if(check_stock_action('form_basket')) //islem kategorisi stock hareketi yapıyorsa
					{
						var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
						if(basket_zero_stock_status.IS_SELECTED != 1)
						{
							var ship_sql = wrk_safe_query('inv_ship_q','dsn2',0,<cfoutput>#attributes.iid#</cfoutput>);
							if(ship_sql.SHIP_ID != '') /*faturanın irsaliyesi icin sıfır stok kontrolu yapılır */
							{
								var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
								var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
								if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,ship_sql.SHIP_ID,temp_process_type.value)) return false;
							}
						}
					}
				}
				return (check_cash_pos() && saveForm());
				return false;
			}
			function kontrol2()
			{
				control_account_process(<cfoutput>'#attributes.iid#',document.form_basket.old_process_type.value</cfoutput>); 
				if (!chk_process_cat('form_basket')) return false;
				if(!check_display_files('form_basket')) return false;
				if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
				form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
				return true;
			}
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.add_bill_retail';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'invoice/form/add_bill_retail.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'invoice/query/add_invoice_retail.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.add_bill_retail&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_bill_retail)";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.detail_invoice_retail';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'invoice/form/upd_bill_retail.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'invoice/query/upd_invoice_retail.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.add_bill_retail&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'iid=##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_retail)";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{	
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invoice.emptypopup_upd_bill_retail&invoice_id=#attributes.iid#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'invoice/query/upd_invoice_retail.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'invoice/query/upd_invoice_retail.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#fusebox.circuit#.list_bill';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&old_process_type&del_invoice_id&invoice_number&department_id&location_id&process_cat';
	}
	
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		if(session.ep.our_company_info.GUARANTY_FOLLOWUP)
		{	
			if(listgetat(attributes.fuseaction,1,'.') is 'invoice')
			  	modul_ = 'stock';
			else
				modul_ = listgetat(attributes.fuseaction,1,'.');
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[305]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=#modul_#.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[323]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_pursuits_documents_plus&action_id=#attributes.iid#&pursuit_type=is_sale_invoice','page')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[2577]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill')";
		
		 tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[170]#';
		 tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bill_retail";
		 
		
		 tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[170]#';
		 tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['href'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#url.iid#&print_type=10','page')";				
		
		 tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			if((GET_SALE_DET.INVOICE_TYPE_CODE eq 'SATIS' or GET_SALE_DET.INVOICE_TYPE_CODE eq 'IADE') and (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0))
			{
				transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = structNew();
				transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = '<cf_wrk_efatura_display action_id="#attributes.iid#" action_type="INVOICE" action_date="#get_sale_det.invoice_date#">';
			}
		}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'invoiceBillRetail';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVOICE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-member_name','item-address','item-comp_name','item-tax_office','item-comp_member_cat','item-location']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
