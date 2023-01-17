<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfif (IsDefined("attributes.event") and attributes.event is 'list') or not IsDefined("attributes.event")>
	<cf_xml_page_edit fuseact="invoice.list_purchase">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.order_type" default="2">
	<cfparam name="attributes.free_type" default="#x_show_free#">
	<cfparam name="attributes.department_id" default="#listgetat(session.ep.user_location,1,'-')#">
	<cfparam name="attributes.company" default="">
	<cfparam name="attributes.company_id" default="">
	<cfparam name="attributes.consumer_id" default="">
	<cfparam name="attributes.cat" default="">
	<cfparam name="attributes.member_cat_type" default="">
	<cfparam name="attributes.zone_id" default="">
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
		<cfelse>
			<cfif session.ep.our_company_info.unconditional_list>
				<cfset attributes.start_date = ''>
		<cfelse>
			<cfset attributes.start_date = date_add('d',-15,wrk_get_today())>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
		<cfelse>
		<cfif session.ep.our_company_info.unconditional_list>
			<cfset attributes.finish_date = ''>
		<cfelse>
			<cfset attributes.finish_date = date_add('d',15,attributes.start_date)>
		</cfif>
	</cfif>
	<cfset attributes.xml_is_salaried = xml_is_salaried>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdefined("attributes.form_varmi")>
		<cfinclude template="../invoice//query/get_purchases.cfm"> 
	<cfelse>
		<cfset purchases.recordcount = 0>
	</cfif>
	<cfif isdefined("x_consignment_delivery") and x_consignment_delivery eq 0>
		<cfset islem_tipi = '76,78,77,80,70,71,72,73,74,88,140,141'><!--- konsinye iade irsaliyeleri görünsün seçeneği hayır ise --->
	<cfelse>
		<cfset islem_tipi = '76,78,77,79,80,70,71,72,73,74,75,88,140,141'>
	</cfif>
	<cfif session.ep.our_company_info.guaranty_followup>
		<cfset islem_tipi = islem_tipi&',85,86'>
	</cfif>
	<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
		SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
	</cfquery>
	<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
		SELECT CC.COMPANYCAT_ID,CC.COMPANYCAT FROM COMPANY_CAT CC,COMPANY_CAT_OUR_COMPANY CCOC WHERE CC.COMPANYCAT_ID = CCOC.COMPANYCAT_ID AND CCOC.OUR_COMPANY_ID = #session.ep.company_id# ORDER BY COMPANYCAT
	</cfquery>
	<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
		SELECT CC.CONSCAT_ID,CC.CONSCAT FROM CONSUMER_CAT CC,CONSUMER_CAT_OUR_COMPANY CCOC WHERE CC.CONSCAT_ID = CCOC.CONSCAT_ID AND CCOC.OUR_COMPANY_ID = #session.ep.company_id# ORDER BY CONSCAT
	</cfquery>
	<cfif purchases.recordcount>
		<cfparam name="attributes.totalrecords" default="#purchases.query_count#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif> 
	<cfif purchases.recordcount>
        <cfset company_id_list=''>
        <cfset consumer_id_list=''>
        <cfset dept_id_list=''>
        <cfset process_cat_id_list=''>
        <cfset serial_process_id_list=''>
        <cfset row_process_id_list=''>
        <cfoutput query="purchases" >
            <cfif listfindnocase('70,71,72,83',ACTION_TYPE)>
                <cfset serial_process_id_list=listappend(serial_process_id_list,action_id)>
                <cfset row_process_id_list=listappend(row_process_id_list,action_id)>
            </cfif>
            <cfif len(company_id)>
                <cfif not listfind(company_id_list,company_id)>
                    <cfset company_id_list=listappend(company_id_list,company_id)>
                </cfif>
            <cfelseif len(consumer_id)>
                <cfif not listfind(consumer_id_list,consumer_id)>
                    <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
                </cfif>
            </cfif>
            <cfif len(purchases.department_in) and not listfind(dept_id_list,purchases.department_in)>
                <cfset dept_id_list=listappend(dept_id_list,purchases.department_in)>
            </cfif>
            <cfif len(purchases.deliver_store_id) and not listfind(dept_id_list,purchases.deliver_store_id)>
                <cfset dept_id_list=listappend(dept_id_list,purchases.deliver_store_id)>
            </cfif>
            <!--- xml de Belge Tipinde Islem Kategorileri Gorüntulenebilsin Evet ise --->
            <cfif x_show_process_cat eq 1>
                <cfif len(purchases.process_cat) and (purchases.process_cat neq 0) and not listfind(process_cat_id_list,purchases.process_cat)>
                    <cfset process_cat_id_list=listappend(process_cat_id_list,purchases.process_cat)>
                </cfif>
            </cfif>
        </cfoutput>
        <cfif len(company_id_list)>
            <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
            <cfquery name="GET_COMPANY" datasource="#DSN#">
                SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
            </cfquery>
        </cfif>
        <cfif len(consumer_id_list)>
            <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
            <cfquery name="GET_CONSUMER" datasource="#DSN#">
                SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
            </cfquery>
        </cfif>
        <cfif len(dept_id_list)>
            <cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
            <cfquery name="GET_DEPT_NAME" datasource="#DSN#">
                SELECT 
                    DEPARTMENT_HEAD 
                FROM 
                    DEPARTMENT
                WHERE 
                    DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#dept_id_list#">) 
                ORDER BY	
                    DEPARTMENT_ID
            </cfquery>
        </cfif>
        <!--- xml de Belge Tipinde Islem Kategorileri Gorüntulenebilsin Evet ise --->
        <cfif len(process_cat_id_list) and x_show_process_cat eq 1>					
            <cfquery name="GET_PROCESS_CAT_ROW" dbtype="query">
                SELECT PROCESS_CAT_ID,PROCESS_CAT FROM GET_PROCESS_CAT WHERE PROCESS_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#process_cat_id_list#">) ORDER BY	PROCESS_CAT_ID
            </cfquery>
            <cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat_row.process_cat_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(row_process_id_list)>
            <cfquery name="get_row_info" datasource="#dsn2#">
                SELECT 
                    SUM(SHIP_ROW.AMOUNT) AS ROW_COUNT,
                    SHIP_ID
                FROM 
                    SHIP_ROW,
                    #dsn3_alias#.STOCKS STOCKS
                WHERE 
                    SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID AND 
                    SHIP_ROW.SHIP_ID IN (#row_process_id_list#) AND 
                    STOCKS.IS_SERIAL_NO = 1
                GROUP BY
                    SHIP_ROW.SHIP_ID
            </cfquery>
            <cfset row_process_id_list = listsort(listdeleteduplicates(valuelist(get_row_info.SHIP_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(serial_process_id_list)>
            <cfquery name="get_serial_info" datasource="#dsn3#">
                SELECT 
                    COUNT(GUARANTY_ID) AS ROW_COUNT,
                    PROCESS_ID
                FROM 
                    SERVICE_GUARANTY_NEW 
                WHERE 
                    PROCESS_ID IN (#serial_process_id_list#)
                    AND PERIOD_ID = #session.ep.period_id#
                    AND PROCESS_CAT IN (70,71,72,83)
                GROUP BY
                    PROCESS_ID
            </cfquery>
            <cfset serial_process_id_list = listsort(listdeleteduplicates(valuelist(get_serial_info.PROCESS_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfset sum_price = 0>
    </cfif>         
<cfelseif IsDefined("attributes.event") and listFindNoCase('purFromOrder,saleFromOrder,billFromShip,billPurFromShip',attributes.event)>
    <cfinclude template="../invoice/query/get_session_cash_all.cfm">    
    <cfinclude template="../invoice/query/control_bill_no.cfm">
    <cfif IsDefined("attributes.event") and listFindNoCase('billFromShip,billPurFromShip',attributes.event)>    	
		<cfinclude template="../invoice/query/get_ship_detail.cfm"> 
        <cfif not get_ship_detail.recordcount>
			<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
			<cfexit method="exittemplate">        
		</cfif>  
        <cfscript>session_basket_kur_ekle(process_type:1,table_type_id:2,to_table_type_id:1,action_id:attributes.SHIP_ID);</cfscript>
    	<cfif IsDefined("attributes.event") and attributes.event is 'billPurFromShip'>
    		<cf_xml_page_edit fuseact="invoice.form_add_bill_purchase_from_ship">           
    	    <cfset order_date_list = ''>
            <cfset attributes.basket_id = 1>
    		<cfset attributes.basket_sub_id = 1>
        	<cfif get_ship_detail.recordcount>
            <cfquery name="GET_ORDER_DATES" datasource="#DSN3#">
                SELECT ORDER_DATE FROM ORDERS WHERE ORDER_ID IN(SELECT ORDER_ID FROM ORDER_ROW WHERE WRK_ROW_ID IN(SELECT WRK_ROW_RELATION_ID FROM #dsn2_alias#.SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.ship_id#">))
            </cfquery>
            <cfoutput query="get_order_dates">
                <cfset order_date_list = listappend(order_date_list,dateformat(get_order_dates.order_date,'dd/mm/yyyy'))>
            </cfoutput>
        </cfif>
        </cfif>  
    </cfif>       
    <cfif IsDefined("attributes.event") and attributes.event is 'billFromShip'>    	
        <cf_xml_page_edit fuseact="invoice.form_add_bill_from_ship"> 
		<cfset paper_type = 'invoice'>
        <cfif isdefined('get_ship_detail.company_id') and len(get_ship_detail.company_id)>
            <cfif len(get_ship_detail.use_efatura) and get_ship_detail.use_efatura eq 1 and datediff('d',get_ship_detail.efatura_date,now()) gte 0>
                <cfset paper_type = 'e_invoice'>
            </cfif>
        <cfelseif isdefined('get_ship_detail.consumer_id') and len(get_ship_detail.consumer_id)>
            <cfif len(get_ship_detail.use_efatura) and get_ship_detail.use_efatura eq 1 and datediff('d',get_ship_detail.efatura_date,now()) gte 0>
                <cfset paper_type = 'e_invoice'>
            </cfif>
        </cfif>    	
        <cfset attributes.basket_id = 2>
    	<cfset attributes.basket_sub_id = 2>
		<cfset attributes.comp_id = get_ship_detail.company_id>
		<cfset attributes.cons_id = get_ship_detail.consumer_id>		
    </cfif>
	<cfif IsDefined("attributes.event") and listFindNoCase('purFromOrder,saleFromOrder',attributes.event)>
        <cfparam name="attributes.barkod" default="0">
        <cfparam name="attributes.invoice_date" default="#now()#">
        <cfscript>session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,to_table_type_id:1,process_type:1);</cfscript>
        <cfquery name="GET_ORDER_INFO" datasource="#dsn3#">
            SELECT * FROM ORDERS WHERE ORDER_ID = #attributes.order_id#
        </cfquery>
        <cfif len(get_order_info.deliver_dept_id) and len(get_order_info.location_id)>
            <cfquery name="get_depo_loc_info" datasource="#dsn#">
                SELECT 
                    SL.LOCATION_ID,
                    D.DEPARTMENT_ID,
                    D.BRANCH_ID,
                    SL.COMMENT,
                    D.DEPARTMENT_HEAD
                FROM
                    STOCKS_LOCATION SL,
                    DEPARTMENT D
                WHERE 
                    SL.LOCATION_ID = #get_order_info.location_id# AND
                    SL.DEPARTMENT_ID = #get_order_info.deliver_dept_id# AND
                    SL.DEPARTMENT_ID = D.DEPARTMENT_ID
            </cfquery>
        </cfif>
        <cfset kontrol_status = 1>	
        <cfif len(GET_ORDER_INFO.card_paymethod_id)>
            <cfquery name="get_card_paymethod" datasource="#dsn3#">
                SELECT 
                    CARD_NO
                    <cfif GET_ORDER_INFO.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi --->
                    ,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
                    <cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
                    ,COMMISSION_MULTIPLIER 
                    </cfif>
                FROM 
                    CREDITCARD_PAYMENT_TYPE 
                WHERE 
                    PAYMENT_TYPE_ID=#GET_ORDER_INFO.card_paymethod_id#
            </cfquery>
        </cfif>
        <cfif len(get_order_info.project_id)>
            <cfquery name="get_project" datasource="#dsn#">
                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_order_info.project_id#
            </cfquery>
        </cfif>
    </cfif>    
	<cfif IsDefined("attributes.event") and attributes.event is 'purFromOrder'>
        <cf_xml_page_edit fuseact="invoice.add_purchase_invoice_from_order">         
        <cf_papers paper_type="invoice" form_name="form_basket" form_field="invoice_number">
        <cfset paper_number = "">
        <cfset paper_code = "">    
    <cfelseif IsDefined("attributes.event") and attributes.event is 'saleFromOrder'>  
    	<cf_xml_page_edit fuseact="invoice.add_sale_invoice_from_order">
        <cfset attributes.comp_id = GET_ORDER_INFO.COMPANY_ID>
		<cfif len(get_order_info.order_employee_id)>
            <cfquery name="GET_EMP_INFO" datasource="#dsn#">
                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.order_employee_id#">
            </cfquery>
        </cfif>
        <cfif not len(get_order_info.deliver_dept_id) and not len(get_order_info.location_id)>
			<cfset get_order_info.deliver_dept_id = ListGetAt(session.ep.user_location,1,'-')>
            <cfif ListLen(session.ep.user_location,'-') eq 3>
                <cfset get_order_info.location_id =  ListGetAt(session.ep.user_location,3,'-')>
            <cfelse>
                <cfset get_order_info.location_id = "">
            </cfif>
        </cfif>
        <!--- Faturaya dönüstürüldügü icin üyenin varsa fatura adresi sevk adresi olarak atanır FA--->
		<cfif is_copy_order_address_ eq 0> <!--- XML e baglı olarak Siparis adresi korunarak fatura adresine aktarilir LS --->
            <cfif len(GET_ORDER_INFO.company_id)>
                <cfquery name="get_invoice_address" datasource="#dsn#">
                    SELECT COMPBRANCH_ADDRESS,COMPBRANCH_POSTCODE,SEMT,COUNTY_ID,CITY_ID,COUNTRY_ID,COMPBRANCH_ID FROM COMPANY_BRANCH WHERE IS_INVOICE_ADDRESS=1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.company_id#">
                </cfquery>
            <cfelse>
                <cfquery name="get_invoice_address" datasource="#dsn#">
                    SELECT TAX_ADRESS COMPBRANCH_ADDRESS,TAX_POSTCODE COMPBRANCH_POSTCODE,TAX_SEMT SEMT,TAX_COUNTY_ID COUNTY_ID,TAX_CITY_ID CITY_ID,TAX_COUNTRY_ID COUNTRY_ID, '' COMPBRANCH_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.consumer_id#">
                </cfquery>
            </cfif>
            <cfif get_invoice_address.recordcount>
                <cfif len(get_invoice_address.county_id)>
                    <cfquery name="get_county_" datasource="#dsn#">
                        SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.county_id#">
                    </cfquery>
                    <cfset county_ = get_county_.county_name>
                <cfelse>
                    <cfset county_ = "">
                </cfif>
                <cfif len(get_invoice_address.city_id)>
                    <cfquery name="get_city_" datasource="#dsn#">
                        SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.city_id#">
                    </cfquery>
                    <cfset city_ = get_city_.city_name>
                <cfelse>
                    <cfset city_ = "">
                </cfif>
                <cfif len(get_invoice_address.country_id)>
                    <cfquery name="get_country_" datasource="#dsn#">
                        SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_address.country_id#">
                    </cfquery>
                    <cfset country_ = get_country_.country_name>
                <cfelse>
                    <cfset country_ = "">
                </cfif>
                <cfset get_order_info.ship_address = "#get_invoice_address.COMPBRANCH_ADDRESS# #get_invoice_address.COMPBRANCH_POSTCODE# #get_invoice_address.semt# #county_# #city_# #country_#">
                <cfset get_order_info.city_id = get_invoice_address.city_id>
                <cfset get_order_info.county_id = get_invoice_address.country_id>
                <cfset get_order_info.ship_address_id = get_invoice_address.compbranch_id>
            </cfif>
        </cfif>
        <cfset paper_type = 'invoice'>
		<cfif isdefined('get_order_info.company_id') and len(get_order_info.company_id)>
            <cfquery name="get_comp_info" datasource="#dsn#">
                SELECT FULLNAME,USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.company_id#">
            </cfquery>
            <cfif len(get_comp_info.use_efatura) and get_comp_info.use_efatura eq 1 and datediff('d',get_comp_info.efatura_date,now()) gte 0>
                <cfset paper_type = 'e_invoice'>
            </cfif>
        <cfelseif isdefined('get_order_info.consumer_id') and len(get_order_info.consumer_id)>
            <cfquery name="get_cons_info_" datasource="#dsn#">
                SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME,USE_EFATURA,EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_info.consumer_id#">
            </cfquery>
            <cfif len(get_cons_info_.use_efatura) and get_cons_info_.use_efatura eq 1 and datediff('d',get_cons_info_.efatura_date,now()) gte 0>
                <cfset paper_type = 'e_invoice'>
            </cfif>
        </cfif>
		<cfif len(GET_ORDER_INFO.company_id)>
            <cfset member_account_code = get_company_period(GET_ORDER_INFO.company_id)>
        <cfelse>
            <cfset member_account_code = get_consumer_period(GET_ORDER_INFO.consumer_id)>
        </cfif>
        <cfset attributes.basket_id = 2>
        <cfset attributes.basket_sub_id = 7>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>
			$( document ).ready(function() {
			document.getElementById('keyword').focus();
			});
	</cfif>
	<cfif IsDefined("attributes.event") and ListFindNoCase('billPurFromShip,billFromShip,saleFromOrder,purFromOrder',attributes.event)>
		$( document ).ready(function() {
			change_paper_duedate('invoice_date');
		});		
	</cfif>		
	<cfif IsDefined("attributes.event") and attributes.event is 'billFromShip'>	
		function add_irsaliye()
		{
			if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
			{ 
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&id=sale&sale_product=1&company_id='+document.getElementById('company_id').value+'&consumer_id='+ document.getElementById('consumer_id').value,'page')
				return true;
			}
			else
			{
				alert('Önce Üye Seçiniz ! ');
				return false;
			}
		}
		
		function kontrol()
		{	
			if(!paper_control(form_basket.serial_no,'INVOICE',true,'','','','','','',1,form_basket.serial_number)) return false;
			if (!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
	
			if (document.getElementById('comp_name').value == ""  && document.getElementById('consumer_id').value == "" && document.getElementById('employee_id').value == "" )
			{ 
				alert ("<cf_get_lang no='181.Cari Hesabı Seçmelisiniz !'>");
				return false;
			}
	
			if(document.getElementById('department_id').value == "" && document.getElementById('department_name').value == "")
			{
				alert("<cf_get_lang no='206.Departman Seçiniz'>!");
				return false;
			}
			var tarih_ = document.getElementById('control_ship_date').value;
			var sonuc_ = datediff(document.getElementById('invoice_date').value,tarih_,0);
			if(sonuc_ > 0)
			{
				alert('Fatura Tarihi İrsaliye Tarihinden Önce Olamaz!');
				return false;
			}
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
			// xml de proje kontrolleri yapılsın seçilmişse
			<cfif xml_control_ship_project eq 1>
				var irsaliye_deger_list = document.getElementById('irsaliye_project_id_listesi').value;
				if(irsaliye_deger_list != '')
				{
					var liste_uzunlugu = list_len(irsaliye_deger_list);
					for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
					{
						var project_id_ = list_getat(irsaliye_deger_list,str_i_row,',');
						if(document.getElementById('project_id').value != '' && document.getElementById('project_head').value != '')
							var sonuc_ = document.getElementById('project_id').value;
						else
							var sonuc_ = 0;
						if(project_id_ != sonuc_)
						{
							alert('İlgili Faturaya Bağlı İrsaliyelerin Projeleri İle Faturada Seçilen Proje Aynı Olmalıdır!');
							return false;
						}
					}
				}
			</cfif>
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
							if(list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID))
							{
								row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
								amount_info = list_getat(amount_list_new,row_info);
								amount_info = parseFloat(amount_info) + parseFloat(filterNum(window.basket.items[str_i_row].AMOUNT));
								amount_list_new = list_setat(amount_list_new,row_info,amount_info);
							}
							else
							{
								wrk_row_id_list_new = wrk_row_id_list_new + ',' + dwindow.basket.items[str_i_row].WRK_ROW_RELATION_ID;
								amount_list_new = amount_list_new + ',' + filterNum(window.basket.items[str_i_row].AMOUNT);
							}
						}
					}
					for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
					{
						if(document.form_basket.product_id[str_i_row].value != '' && document.form_basket.wrk_row_relation_id[str_i_row].value != '' && document.form_basket.row_ship_id[str_i_row].value != '')
						{
							var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	
							if(list_len(window.basket.items[str_i_row].ROW_SHIP_ID,';') > 1)
							{
								new_period = list_getat(document.form_basket.row_ship_id[str_i_row].value,2,';');
								var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
								new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
							}
							else
								new_dsn2 = "#dsn2#";
							var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0, window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
							var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0, window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
							ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
							row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
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
				else if(document.all.product_id != undefined && document.all.product_id.value != '')
				{
					if(document.form_basket.product_id.value != '' && document.form_basket.wrk_row_relation_id.value != '' && document.form_basket.row_ship_id.value != '')
					{
						var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,document.form_basket.wrk_row_relation_id.value);	
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
			if (!check_accounts('form_basket')) return false;
			if (!check_product_accounts()) return false;
			kontrol_yurtdisi();
			change_paper_duedate('invoice_date');
			return saveForm();
			return false;
			
		}
		function ayarla_gizle_goster()
		{
			if(form_basket.cash.checked) {
				not.style.display='';
				not1.style.display='';		
			}else{
				not.style.display='none';
				not1.style.display='none';
			}
		}
		function add_adress()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.adres';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					if(form_basket.ship_address_id!=undefined) str_adrlink = str_adrlink+'&field_adress_id=form_basket.ship_address_id';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=form_basket.adres';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					if(form_basket.ship_address_id!=undefined) str_adrlink = str_adrlink+'&field_adress_id=form_basket.ship_address_id';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'>");
				return false;
			}
		}
		function kontrol_yurtdisi()
		{
			var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			if(deger.length)
			{
				var fis_no = eval("document.form_basket.ct_process_type_" + deger);
				if(fis_no.value == 531)
					reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
			}
		}
	</cfif>	
	<cfif IsDefined("attributes.event") and attributes.event is 'purFromOrder'>
		function add_irsaliye()
		{
			if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
				{ 
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&id=sale&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value,'page')
				return true;
				}
			else
				{
				alert("<cf_get_lang_main no ='303.Önce Üye Seçiniz'>!");
				return false;
				}
		}
		function kontrol()
		{
			if (!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if(!kontrol_ithalat()) return false;
			if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
			if (document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "" )
				{ 
				alert ("<cf_get_lang no='181.Cari Hesabı Seçmelisiniz !'>");
				return false;
				}
			if (document.form_basket.department_name.value == ""  && (document.form_basket.department_id.value == "" || document.form_basket.location_id.value == ""))
				{ 
				alert ("<cf_get_lang_main no='311.Önce Depo Seçmelisiniz'>!");
				return false;
				}
			
			if (!check_accounts('form_basket')) return false;
			if (!check_product_accounts()) return false;
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
			//sipariş satır kontrolü
				<cfif xml_control_ship_row eq 1>
				ship_list_ = document.getElementById('order_id').value; 
				if(ship_list_ != '')
				{
					var ship_row_list = '';
					if(window.basket.items.length != undefined && window.basket.items.length >1)
					{
						var bsk_rowCount = window.basket.items.length; 
						for(var str_i_row=0; str_i_row < bsk_rowCount; str_i_row++)
						{
							if(window.basket.items[str_i_row].PRODCUT_ID != '' && document.form_basket.wrk_row_relation_id[str_i_row].value == '')
							{
								ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODCUT_NAME + '\n';
							}
						}
						
					}	
					else if(window.basket.items[0].PRODCUT_ID != undefined && window.basket.items[0].PRODCUT_ID!='')
					{
						if(window.basket.items[0].PRODCUT_ID != '' && window.basket.items[0].WRK_ROW_RELATION_ID == '')
						{
							ship_row_list = ship_row_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[0].PRODCUT_NAME + '\n';
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
						alert("Aşağıda Belirtilen Ürünler İlişkili Sipariş Dışında Eklenmiştir.  ! Lütfen Ürünleri Kontrol Ediniz ! \n\n" + ship_row_list);
						return false;
					}
				}
				</cfif>
			//<!--- toptan satıs fat ve alım iade fat icin sıfır stok kontrolu--->
			var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			change_paper_duedate('invoice_date');
			saveForm();
			return false;
		}
		function ayarla_gizle_goster()
		{
			if(form_basket.cash.checked)
				kasa_sec.style.display='';
			else
				kasa_sec.style.display='none';
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
					reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
				}
			}
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
					kasa_sec.style.display = 'none';
					kasa_sec_text.style.display = 'none';
					if(form_basket.cash != undefined)
						form_basket.cash.checked=false;
					reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
				}
				else
				{
					kasa_sec_text.style.display = '';
					kasa_sec.style.display = '';
				}
			}
		}
		
		function add_adress()
		{
			if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
			{
				if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.adres';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=form_basket.adres';
					if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
					if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'>");
				return false;
			}
		}	
	</cfif>
	<cfif IsDefined("attributes.event") and attributes.event is 'saleFromOrder'>
		$( document ).ready(function() {
			<cfif xml_chk_prod_w_barkod eq 1 and attributes.barkod neq 1>
				windowopen('<cfoutput>#request.self#?fuseaction=invoice.popup_check_product_count&oid=#attributes.order_id#</cfoutput>','medium')
			</cfif>	
		});
	function add_irsaliye()
	{
		if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
			{ 
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&id=sale&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value,'page')
			return true;
			}
		else
			{
			alert("<cf_get_lang_main no ='303.Önce Üye Seçiniz'> !");
			return false;
			}
	}
	function kontrol()
	{
		<cfif xml_show_ship_date eq 1>
			if (!date_check(form_basket.invoice_date,form_basket.ship_date,"Fiili Sevk Tarihi, Fatura Tarihinden Önce Olamaz!"))
				return false;
		</cfif>
		if (!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		if (document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "" )
			{ 
			alert ("<cf_get_lang no='181.Cari Hesabı Seçmelisiniz !'>");
			return false;
			}
		if (document.form_basket.department_name.value == ""  && (document.form_basket.department_id.value == "" || document.form_basket.location_id.value == ""))
			{ 
			alert ("<cf_get_lang_main no='311.Önce Depo Seçmelisiniz'>!");
			return false;
			}
		if (!check_accounts('form_basket')) return false;
		if (!check_product_accounts()) return false;
		//<!--- toptan satıs fat ve alım iade fat icin sıfır stok kontrolu--->
		var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(temp_process_cat.length)
		{
			if(check_stock_action('form_basket')) //islem kategorisi stok hareketi yapıyorsa
			{
				var fis_no = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
				if(basket_zero_stock_status.IS_SELECTED != 1)
				{
					if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,fis_no.value)) return false;
				}
			}
		}
		//sipariş satır kontrolü
		<cfif xml_control_ship_row eq 1>
		ship_list_ = document.getElementById('order_id').value; 
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
				alert("Aşağıda Belirtilen Ürünler İlişkili Sipariş Dışında Eklenmiştir.  ! Lütfen Ürünleri Kontrol Ediniz ! \n\n" + ship_row_list);
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
		if(form_basket.cash.checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
	function kontrol_ithalat()
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
		if(deger != ""){
			var fis_no = eval("form_basket.ct_process_type_" + deger);
			if(fis_no.value == 531)
			{
				if(form_basket.cash != undefined && form_basket.cash.checked)
				{

				}
				else
				{
					if(sistem_para_birimi==document.all.basket_money.value)
					{
						alert("<cf_get_lang no ='342.Sistem Para Birimi ile Fatura Para Birimi İhracat Faturası için Farklı Olmalı'>!");
					}
				}
				reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
			}
		}
		return true;
	}	
	function kontrol_yurtdisi()
	{
		var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(deger.length)
		{
			var fis_no = eval("document.form_basket.ct_process_type_" + deger);
			if(fis_no.value == 531)
			{ 
				kasa_sec_text.style.display = 'none';
				kasa_sec.style.display='none';
				form_basket.cash.checked=false;
				reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
			}
			else
				kasa_sec_text.style.display = '';
		}
	}
	
	
	function add_adress()
	{
		if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
		{
			if(form_basket.company_id.value!="")
			{
				str_adrlink = '&field_long_adres=form_basket.adres';
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
				if(form_basket.ship_address_id!=undefined) str_adrlink = str_adrlink+'&field_adress_id=form_basket.ship_address_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=form_basket.adres';
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';


				if(form_basket.ship_address_id!=undefined) str_adrlink = str_adrlink+'&field_adress_id=form_basket.ship_address_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'>");
			return false;
		}
	}
	</cfif>
	<cfif IsDefined("attributes.event") and attributes.event is 'billPurFromShip'>
		function add_irsaliye()
		{
			if(form_basket.company_id.value.length || form_basket.consumer_id.value.length)
			{ 
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&id=purchase&sale_product=0&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value,'page')
				return true;
			}
			else
			{
				alert("<cf_get_lang_main no='303.Önce Üye Seçiniz'> ! ");
				return false;
			}
		}
		
		function kontrol()
		{	
			if(!paper_control(form_basket.serial_no,'INVOICE',false,0,<cfoutput>'#GET_SHIP_DETAIL.SHIP_NUMBER#'</cfoutput>,form_basket.company_id.value,form_basket.consumer_id.value,'','',1,form_basket.serial_number)) return false;
			if (!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
			if (document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "" && document.form_basket.employee_id.value == "")
			{ 
				alert ("<cf_get_lang no='181.Cari Hesabı Seçmelisiniz !'>");
				return false;
			}
			<cfif xml_control_ship_date eq 1>
				var tarih_ = document.form_basket.control_ship_date.value;
				var sonuc_ = datediff(document.form_basket.invoice_date.value,tarih_,0);
				if(sonuc_ > 0)
				{
					alert('Fatura Tarihi İrsaliye Tarihinden Önce Olamaz!');
					return false;
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
			if(document.getElementById('department_id').value == "" && document.getElementById('department_name').value == "")
			{
				alert("<cf_get_lang no='184.Depo Girmelisiniz !'>");
				document.getElementById('department_name').focus();
				return false;	
			}
			if (!check_accounts('form_basket')) return false;
			if (!check_product_accounts()) return false;
			kontrol_yurtdisi();
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
						if(window.basket.items[0].PRODUCT_ID != '' && window.basket.items[0].WRK_ROW_RELATION_ID== '')
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
							var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
							var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
							
							ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
							row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
							amount_info = list_getat(amount_list_new,row_info);
							var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
							if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
							{
								if(total_inv_amount > ship_amount_)
									ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME+ '\n';
							}
						}
					}
				}	
				else if(window.basket.items[0].PRODUCT_ID != undefined && window.basket.items[0].PRODUCT_ID !='')
				{
					if(window.basket.items[0].PRODUCT_ID  != '' && window.basket.items[0].WRK_ROW_RELATION_ID  != '' && window.basket.items[0].ROW_SHIP_ID != '')
					{
						var get_inv_control = wrk_safe_query("inv_get_inv_control","dsn2",0,window.basket.items[0].WRK_ROW_RELATION_ID );	
						if(list_len(window.basket.items[0].ROW_SHIP_ID,';') > 1)
						{
							new_period = list_getat(window.basket.items[0].ROW_SHIP_ID,2,';');
							var get_period = wrk_safe_query("inv_get_period","dsn",0,new_period);
							new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}
						else
							new_dsn2 = "#dsn2#";
						var get_ship_control = wrk_safe_query("inv_get_ship_control",new_dsn2,0,window.basket.items[0].WRK_ROW_RELATION_ID );
						var get_ship_control2 = wrk_safe_query("inv_get_ship_control2",new_dsn2,0,window.basket.items[0].WRK_ROW_RELATION_ID );
						ship_amount_ = parseFloat(get_ship_control.AMOUNT)-parseFloat(get_ship_control2.AMOUNT); 
						var total_inv_amount = parseFloat(get_inv_control.AMOUNT)+parseFloat(filterNum(window.basket.items[0].AMOUNT ));
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && ship_amount_ >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
						{
							if(total_inv_amount > ship_amount_)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[0].PRODUCT_NAME  + '\n';
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
			change_paper_duedate('invoice_date');
			saveForm();
			return false;
		}
		function ayarla_gizle_goster()
		{
			if(form_basket.cash.checked) {
				not1.style.display='';		
			}else{
				not1.style.display='none';
			}
		}
		function kontrol_yurtdisi()
		{
			deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
			if(deger != ""){
				var fis_no = eval("form_basket.ct_process_type_" + deger);
				if(fis_no.value == 591) 
				{
					reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
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
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.list_purchase';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'invoice/display/list_purchase.cfm';
	
	WOStruct['#attributes.fuseaction#']['purFromOrder'] = structNew();
	WOStruct['#attributes.fuseaction#']['purFromOrder']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['purFromOrder']['fuseaction'] = 'invoice.add_purchase_invoice_from_order';
	WOStruct['#attributes.fuseaction#']['purFromOrder']['filePath'] = 'invoice/display/add_purchase_invoice_from_order.cfm';
	WOStruct['#attributes.fuseaction#']['purFromOrder']['queryPath'] = 'invoice/query/add_invoice_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['purFromOrder']['nextEvent'] = 'invoice.form_add_bill_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['purFromOrder']['js'] = "javascript:gizle_goster_basket(add_bill)";
	
	WOStruct['#attributes.fuseaction#']['saleFromOrder'] = structNew();
	WOStruct['#attributes.fuseaction#']['saleFromOrder']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['saleFromOrder']['fuseaction'] = 'invoice.add_sale_invoice_from_order';
	WOStruct['#attributes.fuseaction#']['saleFromOrder']['filePath'] = 'invoice/display/add_sale_invoice_from_order.cfm';
	WOStruct['#attributes.fuseaction#']['saleFromOrder']['queryPath'] = 'invoice/query/add_invoice_sale.cfm';
	WOStruct['#attributes.fuseaction#']['saleFromOrder']['nextEvent'] = 'invoice.form_add_bill&event=upd';
	WOStruct['#attributes.fuseaction#']['saleFromOrder']['js'] = "javascript:gizle_goster_basket(add_bill)";
	
	WOStruct['#attributes.fuseaction#']['billFromShip'] = structNew();
	WOStruct['#attributes.fuseaction#']['billFromShip']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['billFromShip']['fuseaction'] = 'invoice.form_add_bill_from_ship';
	WOStruct['#attributes.fuseaction#']['billFromShip']['filePath'] = 'invoice/form/add_invoice_from_ship.cfm';
	WOStruct['#attributes.fuseaction#']['billFromShip']['queryPath'] = 'invoice/query/add_invoice_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['billFromShip']['nextEvent'] = 'invoice.form_add_bill&event=upd';
	WOStruct['#attributes.fuseaction#']['billFromShip']['js'] = "javascript:gizle_goster_basket(sale_ship)";
	
	WOStruct['#attributes.fuseaction#']['billPurFromShip'] = structNew();
	WOStruct['#attributes.fuseaction#']['billPurFromShip']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['billPurFromShip']['fuseaction'] = 'invoice.form_add_bill_purchase_from_ship';
	WOStruct['#attributes.fuseaction#']['billPurFromShip']['filePath'] = 'invoice/form/add_invoice_pur_from_ship.cfm';
	WOStruct['#attributes.fuseaction#']['billPurFromShip']['queryPath'] = 'invoice/query/add_invoice_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['billPurFromShip']['nextEvent'] = 'invoice.form_add_bill_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['billPurFromShip']['js'] = "javascript:gizle_goster_basket(from_ship)";
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'invoiceListPurchase,saleFromOrder,purFromOrder';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'billFromShip,billPurFromShip,';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVOICE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_stage','item-comp_name','item-partner_name','item-serial_no','item-invoice_date','item-location_id','item-adres']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.		
</cfscript>
