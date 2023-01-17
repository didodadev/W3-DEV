<cf_get_lang_set module_name="service">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    <cfelse>
        <cfset attributes.finish_date = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
    </cfif>
    <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = date_add('m',-1,attributes.finish_date)>
    </cfif>
    
    <cfscript>
        this_year = session.ep.period_year;
        last_year = session.ep.period_year-1;
        next_year = session.ep.period_year+1;
        if (database_type is 'MSSQL') 
            {
            last_year_dsn2 = '#dsn#_#this_year-1#_#session.ep.company_id#';
            next_year_dsn2 = '#dsn#_#this_year+1#_#session.ep.company_id#';
            }
        else if (database_type is 'DB2')
            {
            last_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year-1#';
            next_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year+1#';
            }	
    </cfscript>
    <cfquery name="GET_PERIODS" datasource="#DSN#">
        SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfquery name="CONTROL_LAST_YEAR" dbtype="query" maxrows="1">
        SELECT PERIOD_YEAR FROM GET_PERIODS WHERE PERIOD_YEAR = #last_year#
    </cfquery>
    <cfquery name="CONTROL_NEXT_YEAR" dbtype="query">
        SELECT PERIOD_YEAR FROM GET_PERIODS WHERE PERIOD_YEAR = #next_year#
    </cfquery>
    <cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_SERVICE" datasource="#DSN3#">
            SELECT
                SERVICE.SERVICE_ID,
                SERVICE.SERVICE_NO,
                SERVICE.APPLY_DATE,
                SERVICE.SERVICE_HEAD,
                SERVICE.SERVICE_COMPANY_ID,
                SERVICE.SERVICE_EMPLOYEE_ID,
                SERVICE.SERVICE_CONSUMER_ID,
                SERVICE.APPLICATOR_NAME,
                SERVICE.APPLICATOR_COMP_NAME,
                SERVICE.SERVICE_PRODUCT_ID,
                SERVICE.PRODUCT_NAME,
                SERVICE.PRO_SERIAL_NO,
                SERVICE.RECORD_MEMBER,
                SERVICE.RECORD_PAR,
                SERVICE.SERVICE_BRANCH_ID,
                SERVICE_APPCAT.SERVICECAT,
                SP.PRIORITY,
                SP.COLOR,
                PROCESS_TYPE_ROWS.STAGE
            FROM
                SERVICE,
                SERVICE_APPCAT,
                #dsn_alias#.SETUP_PRIORITY AS SP,
                #dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS
            WHERE 		
                (
                (
                SERVICE.SERVICE_ID IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
                AND
                SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
                )
                <cfif control_last_year.recordcount or control_next_year.recordcount>OR</cfif>
                <cfif control_last_year.recordcount>
                    (
                    SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
                    AND
                    SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
                    AND
                    SERVICE.SERVICE_ID IN (SELECT SR.SERVICE_ID FROM #last_year_dsn2#.SHIP_ROW SR,#last_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
                    AND
                    SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #last_year_dsn2#.SHIP_ROW SR,#last_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
                    )
                    <cfif control_next_year.recordcount>OR</cfif>
                </cfif>
                <cfif control_next_year.recordcount>
                    (
                    SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
                    AND
                    SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
                    AND
                    <cfif control_last_year.recordcount>
                    SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #last_year_dsn2#.SHIP_ROW SR,#last_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
                    AND
                    SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #last_year_dsn2#.SHIP_ROW SR,#last_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
                    AND
                    </cfif>
                    SERVICE.SERVICE_ID IN (SELECT SR.SERVICE_ID FROM #next_year_dsn2#.SHIP_ROW SR,#next_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
                    AND
                    SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #next_year_dsn2#.SHIP_ROW SR,#next_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
                    )
                </cfif>
                ) 
                AND
                SERVICE.SERVICECAT_ID=SERVICE_APPCAT.SERVICECAT_ID
                AND SP.PRIORITY_ID = SERVICE.PRIORITY_ID
                AND SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
                <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                    AND SERVICE.APPLY_DATE >= #attributes.start_date#
                </cfif>
                <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                    AND SERVICE.APPLY_DATE < #DATEADD("d",1,attributes.finish_date)#
                </cfif>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND (
                        SERVICE.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        SERVICE.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        )
                </cfif>
                <cfif not isdefined("attributes.service_status")>
                    AND SERVICE.SERVICE_ACTIVE = 1
                </cfif>
                <cfif isdefined("attributes.service_status") and attributes.service_status eq "0">
                    AND SERVICE.SERVICE_ACTIVE = 0
                <cfelseif isdefined("attributes.service_status") and attributes.service_status eq "1">				
                    AND SERVICE.SERVICE_ACTIVE = 1
                </cfif>
                <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
                    AND SERVICE.SERVICE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                </cfif>
                <cfif isdefined("attributes.related_company_id") and len(attributes.related_company_id) and isdefined("attributes.related_member_name") and len(attributes.related_member_name)> 
                    AND SERVICE.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_company_id#">
                </cfif>
                <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.member_name") and len(attributes.member_name)> 
                    AND SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfif>
                <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.member_name") and len(attributes.member_name)> 
                    AND SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                </cfif>
                <cfif isdefined("attributes.department") and len(attributes.department_id) and len(attributes.location_id) and len(attributes.department)>
                    AND SERVICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                    AND SERVICE.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">	
                </cfif>
            ORDER BY
                SERVICE.RECORD_DATE DESC
        </cfquery>
    <cfelse>
        <cfset get_service.recordcount = 0>
    </cfif>
    <cfparam name="attributes.keyword" default=''>
    <cfparam name="attributes.serial_no" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_service.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfquery name="GET_SERVICE" datasource="#DSN3#" maxrows="1">
        SELECT
            S.SERVICE_NO,
            S.SERVICE_BRANCH_ID,
            S.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            S.LOCATION_ID,
            S.SERVICE_PARTNER_ID,
            S.SERVICE_COMPANY_ID,
            S.SERVICE_CONSUMER_ID,
            S.SERVICE_ADDRESS
        FROM
            SERVICE S,
            #dsn_alias#.DEPARTMENT D
        WHERE
            S.SERVICE_ID IN (#attributes.service_ids#) AND
            S.DEPARTMENT_ID = D.DEPARTMENT_ID
    </cfquery>
    <cfif not GET_SERVICE.recordcount>
        <script type="text/javascript">
            alert('Servis Bulunamadı veya Servis Lokasyonu Hatalı!Lütfen Düzenleyiniz!');
            history.back();
        </script>
        <cfabort>
    </cfif>
        
    <cfscript>
    if(len(get_service.service_company_id))
    {
        company_id = get_service.service_company_id;
        company_name = '#get_par_info(company_id,1,1,0)#';
        consumer_id = '';
        if(len(get_service.service_partner_id))
        {
            partner_id = get_service.service_partner_id;
            partner_name = '#get_par_info(partner_id,0,-1,0)#';
        }
        else 
        {
            partner_id = '';
            partner_name = '';
        }
    }
    else if(len(get_service.service_consumer_id))
    {
        company_id = '';
        consumer_id = get_service.service_consumer_id;
        partner_id = '';
        company_name = '';
        partner_name = '#get_cons_info(consumer_id,0,0)#';
    }
    </cfscript>
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>    
	<cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);</cfscript>
	<cfset attributes.UPD_ID = URL.SHIP_ID>
    <cfinclude template="../service/query/get_upd_purchase.cfm">
    <cfset attributes.ship_type = get_upd_purchase.ship_type>
    <cfif not get_upd_purchase.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
	<cfset company_id = get_upd_purchase.company_id>
    <cfset attributes.company_id = get_upd_purchase.company_id>
    
    <cfif len(get_upd_purchase.ship_method)>
		<cfset attributes.ship_method_id=get_upd_purchase.ship_method>
        <cfinclude template="../service/query/get_ship_method.cfm">
    </cfif>
    
    <cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
    <cfelse>
        <cfquery name="GET_CONS_NAME_UPD" datasource="#dsn#">
            SELECT
                CONSUMER_NAME,
                CONSUMER_SURNAME,
                COMPANY,
                CONSUMER_ID
            FROM
                CONSUMER
            WHERE
                CONSUMER_ID = #get_upd_purchase.consumer_id#
        </cfquery>
    </cfif>
    
    <cfset search_dep_id = get_upd_purchase.deliver_store_id>
    <cfinclude template = "../service/query/get_dep_names_for_inv.cfm">
    <cfset txt_department_name = get_name_of_dep.department_head>
    <cfset branch_id = get_name_of_dep.branch_id>
    <cfif len(search_dep_id) and len(trim(get_upd_purchase.location))>
        <cfset search_location_id = get_upd_purchase.location>
        <cfinclude template="../service/query/get_location_for_inv.cfm">
        <cfset txt_department_name = txt_department_name & "-" & get_location.comment>
        <cfset txt_department_id = "#get_location.department_location#">
    <cfelse>
        <cfset txt_department_id = "#search_dep_id#">
        <cfset branch_id="">
    </cfif>
    
    <cfquery name="GET_INV" datasource="#DSN2#">
        SELECT
            INVOICE_NUMBER,
            SHIP_NUMBER,
            IS_WITH_SHIP
        FROM
            INVOICE_SHIPS
        WHERE
            SHIP_ID = #get_upd_purchase.ship_id# AND
            SHIP_PERIOD_ID = #session.ep.period_id#
    </cfquery>
    
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();	
		});	
		function kontrol()
		{
			member_name_ = document.getElementById('member_name').value;
			member_type_ = document.getElementById('member_type').value;
			related_com_ = document.getElementById('related_company_id').value;
			related_member_ = document.getElementById('related_member_name').value;
			department_ = document.getElementById('department').value;
			department_id_ = document.getElementById('department_id').value;
			if((member_name_== "" & member_type_ == "") & (related_member_=="" & related_com_=="") & (department_=="" & department_id_=="")) 	
			{
				alert("<cf_get_lang no ='304.Cari Hesap,İş Ortağı veya Depo Seçmelisiniz'>!");
				return false;
			}
			return true;
		}
		function depolararasi_gonder()
		{
			document.send_form_.action = '<cfoutput>#request.self#?fuseaction=service.add_ship_dispatch</cfoutput>';
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function add_irsaliye()
		{	
			if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!=""))
			{	
			str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&dept_id='+form_basket.department_id.value +'&company_id='+form_basket.company_id.value; 
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list');
				return true;
			}
			else (form_basket.company_id.value =="")
			{
				alert("<cf_get_lang no='131.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
		}
		
		function kontrol_firma()
		{
			if(!chk_period(form_basket.ship_date,"İşlem")) return false;
			if(!chk_process_cat('form_basket')) return false;
			if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="")
			{
				alert("<cf_get_lang no='203.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
			if(document.form_basket.txt_departman_.value=="")
			{
				alert("<cf_get_lang no='202.Depo Girmelisiniz'>");
				return false;
			}
			saveForm();
			return true;
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
				alert("<cf_get_lang no='203.Cari Hesap Seçmelisiniz'>!");
				return false;
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>		
		function add_irsaliye()
		{
			if((form_basket.company_id.value.length!="" && form_basket.company_id.value!=""))
			{	
			str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&dept_id='+form_basket.department_id.value +'&company_id='+form_basket.company_id.value;//&id=purchase&sale_product=0
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list');
				return true;
			}
			else (form_basket.company_id.value =="")
			{
				alert("<cf_get_lang_main no='73.Öncelik'> : <cf_get_lang_main no='246.Üye'>");
				return false;
			}
		}
		
		function kontrol_firma()
		{
			if(!chk_period(form_basket.ship_date,"İşlem")) return false;
			if(!chk_process_cat('form_basket')) return false;
			if(document.form_basket.txt_departman_.value == "")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1351.Depo'>");
				return false;
			}	
			saveForm();		
			return false;
		}
		
		function kontrol2()
		{	
			form_basket.del_ship.value =1;
			
			saveForm();	
			return true;
		}
		
		function check_process_is_sale()/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
		{
			<cfif isdefined("get_basket.basket_id") and get_basket.basket_id is 10>
				var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				if(selected_ptype!='')
				{
					eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
					if(proc_control==78||proc_control==79)
						sale_product= 0;
					else
						sale_product = 1;
				}
				else
					return true;
			<cfelse>
				return true;
			</cfif>
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
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1420.Abone'>");
				return false;
			}
		}
		check_process_is_sale();
	</cfif>
</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.service_ship';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'service/display/service_ship.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.service_ship';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'service/form/add_sale_ship.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'service/query/add_sale_ship.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.service_ship&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.service_ship';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'service/form/upd_sale_ship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'service/query/upd_sale_ship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.service_ship&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'ship_id=##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(sale_ship)";

	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['target'] = "_blank";
		if(session.ep.our_company_info.workcube_sector is 'it')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = 'Stok Hareketler';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.UPD_ID#&in_or_out=0','list')";
		}

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.UPD_ID#&print_type=30','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>  
