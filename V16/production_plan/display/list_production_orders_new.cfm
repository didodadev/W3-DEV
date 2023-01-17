<cfsetting showdebugoutput="YES">

<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfsavecontent variable="header_">
    <cfif fuseaction_ contains 'order'>
        <cf_get_lang dictionary_id='36368.Üretim Emirleri'>
    <cfelseif fuseaction_ contains 'demands'>
        <cf_get_lang dictionary_id='57527.Talepler'>
    <cfelseif fuseaction_ contains 'in_productions'>
        <cf_get_lang dictionary_id='58812.Üretimdekiler'>
    <cfelseif fuseaction_ contains 'operations'>
        <cf_get_lang dictionary_id='36376.Operasyonlar'>
    </cfif>
</cfsavecontent>

<cf_xml_page_edit default_value="1" fuseact="prod.order_new">


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.station_list" default="0">
<cfparam name="attributes.related_orders" default="1">

<cfif fuseaction_ contains 'operations'>
	<cfparam name="attributes.result" default="0">
<cfelse>
	<cfparam name="attributes.result" default="">
</cfif>

<cfparam name="attributes.oby" default="1">
<cfparam name="attributes.status" default="2">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat_code" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.order_employee_id" default="">
<cfparam name="attributes.order_employee" default="">
<cfparam name="attributes.related_stock_id" default="">
<cfparam name="attributes.related_product_id" default="">
<cfparam name="attributes.related_product_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.start_date_2" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.finish_date_2" default="">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.production_stage" default="">

<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date=''>
</cfif>	
<cfif isdefined('attributes.start_date_2') and isdate(attributes.start_date_2)>
	<cf_date tarih='attributes.start_date_2'>
</cfif>
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date=''>
</cfif>
<cfif isdefined('attributes.finish_date_2') and isdate(attributes.finish_date_2)>
	<cf_date tarih='attributes.finish_date_2'>
</cfif>

<cfif isdefined('is_workstation_order_') and is_workstation_order_ eq 1>
    <cfquery name="GET_W" datasource="#dsn#">
       SELECT
			T1.*,
			WORKSTATIONS2.STATION_NAME UPSTATION
		FROM
		(
        SELECT 
            CASE WHEN UP_STATION IS NULL THEN
                STATION_ID 
            ELSE
                 UP_STATION 
            END AS UPSTATION_ID,
            STATION_ID,
            STATION_NAME,
             UP_STATION,
            CASE WHEN (SELECT TOP 1 WS1.UP_STATION FROM #dsn3_alias#.WORKSTATIONS WS1 WHERE WS1.UP_STATION = WORKSTATIONS.STATION_ID) IS NOT NULL THEN 0 ELSE 1 END AS TYPE
        FROM 
            #dsn3_alias#.WORKSTATIONS
        WHERE 
            ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
            DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
       )T1
            LEFT JOIN #dsn3_alias#.WORKSTATIONS AS WORKSTATIONS2 ON WORKSTATIONS2.STATION_ID = T1.UPSTATION_ID
        ORDER BY  
         	UPSTATION,
            UPSTATION_ID,
            UP_STATION,
            TYPE,
            STATION_NAME
    </cfquery>
<cfelse>
	<cfquery name="GET_W" datasource="#dsn#">
        SELECT 
            STATION_ID,
            STATION_NAME,
            '' UP_STATION
        FROM 
            #dsn3_alias#.WORKSTATIONS 
        WHERE 
            ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
            DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
        ORDER BY STATION_NAME ASC
    </cfquery>
</cfif>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfif GET_W.recordcount><cfset authority_station_id_list = ValueList(GET_W.STATION_ID,',')><cfelse><cfset authority_station_id_list = 0></cfif>
<cfif len(attributes.station_id)>
	<cfquery name="get_station_list" datasource="#dsn3#">
		SELECT STATION_ID FROM WORKSTATIONS WHERE UP_STATION = #attributes.station_id#
	</cfquery>
	<cfif get_station_list.recordcount><cfset station_list = ValueList(get_station_list.STATION_ID)><cfelse><cfset station_list = 0></cfif>
</cfif>

<cfif GET_W.recordcount><cfset authority_station_id_list = ValueList(GET_W.STATION_ID,',')><cfelse><cfset authority_station_id_list = 0></cfif>
<cfif len(attributes.station_id)>
	<cfquery name="get_station_list" datasource="#dsn3#">
		SELECT STATION_ID FROM WORKSTATIONS WHERE UP_STATION = #attributes.station_id#
	</cfquery>
	<cfif get_station_list.recordcount><cfset station_list = ValueList(get_station_list.STATION_ID)><cfelse><cfset station_list = 0></cfif>
</cfif>
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<!---<cfif fuseaction_ contains 'demands'><!--- Talep --->
	<cfset print_type_ = 282>
	<cfset colspan_info = 10>
<cfelseif fuseaction_ contains 'order'><!--- Emir --->
	<cfset print_type_ = 281>
	<cfset colspan_info = 12>	
<cfelse>
	<cfset print_type_ = 281>
	<cfset colspan_info = 16>
</cfif>--->
<cfset print_type_ = 281>
<cfset colspan = 14 >
<cfif is_show_result_amount eq 1 >
	<cfset colspan = colspan + 2>
</cfif>
<cfif is_spec_code eq 1 >
	<cfset colspan = colspan + 1>
</cfif>
<cfif is_spec_name eq 1 >
	<cfset colspan = colspan + 1>
</cfif>
<cfif is_show_demand_no eq 1 >
	<cfset colspan = colspan + 1>
</cfif>
<cfif is_show_process eq 1 >
	<cfset colspan = colspan + 1>
</cfif>
<cfif is_show_lot_no eq 1 >
	<cfset colspan = colspan + 1>
</cfif>
<cfif is_show_demand_no_ eq 1 >
	<cfset colspan = colspan + 1>
</cfif>


<cfif isdefined("attributes.is_submitted")>
	<cfscript>
	get_prod_order_action = createObject("component", "V16.production_plan.cfc.get_prod_order");
    get_prod_order_action.dsn3 = dsn3;
    get_prod_order_action.dsn = dsn;
    GET_PO = get_prod_order_action.list_production_orders_fnc(
    	keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
		maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
		startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
		station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
		station_list : '#IIf(IsDefined("station_list"),"station_list",DE(""))#',
		authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
		prod_order_stage : '#IIf(IsDefined("attributes.prod_order_stage"),"attributes.prod_order_stage",DE(""))#',
		related_orders : '#IIf(IsDefined("related_orders"),"related_orders",DE(""))#',
		result : '#IIf(IsDefined("attributes.result"),"attributes.result",DE(""))#',
		oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
		status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(""))#',
		product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
		product_catid : '#IIf(IsDefined("attributes.product_catid"),"attributes.product_catid",DE(""))#',
		product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
		position_code : '#IIf(IsDefined("attributes.position_code"),"attributes.position_code",DE(""))#',
		member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
		member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
	    company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
		consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
		product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
		position_name : '#IIf(IsDefined("attributes.position_name"),"attributes.position_name",DE(""))#',
		order_employee_id : '#IIf(IsDefined("attributes.order_employee_id"),"attributes.order_employee_id",DE(""))#',
		order_employee : '#IIf(IsDefined("attributes.order_employee"),"attributes.order_employee",DE(""))#',
		related_product_id : '#IIf(IsDefined("attributes.related_product_id"),"attributes.related_product_id",DE(""))#',
		related_stock_id : '#IIf(IsDefined("attributes.related_stock_id"),"attributes.related_stock_id",DE(""))#',
		related_product_name : '#IIf(IsDefined("attributes.related_product_name"),"attributes.related_product_name",DE(""))#',
		project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
		project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
		product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
		product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
		spect_main_id : '#IIf(IsDefined("attributes.spect_main_id"),"attributes.spect_main_id",DE(""))#',
		spect_name : '#IIf(IsDefined("attributes.spect_name"),"attributes.spect_name",DE(""))#',
		short_code_id : '#IIf(IsDefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#',
		short_code_name : '#IIf(IsDefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
		start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
		start_date_2 : '#IIf(IsDefined("attributes.start_date_2"),"attributes.start_date_2",DE(""))#',
		finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
		finish_date_2 : '#IIf(IsDefined("attributes.finish_date_2"),"attributes.finish_date_2",DE(""))#',
		production_stage : '#IIf(IsDefined("attributes.production_stage"),"attributes.production_stage",DE(""))#',
		fuseaction_ : '#IIf(IsDefined("fuseaction_"),"fuseaction_",DE(""))#',
		P_ORDER_NO1 : '#IIf(IsDefined("attributes.P_ORDER_NO1"),"attributes.P_ORDER_NO1",DE(""))#',
		DEMAND_NO1 : '#IIf(IsDefined("attributes.DEMAND_NO1"),"attributes.DEMAND_NO1",DE(""))#',
		LOT_NO1 : '#IIf(IsDefined("attributes.LOT_NO1"),"attributes.LOT_NO1",DE(""))#',
		REFERENCE_NO1 : '#IIf(IsDefined("attributes.REFERENCE_NO1"),"attributes.REFERENCE_NO1",DE(""))#',
		order_no_filter : '#IIf(IsDefined("attributes.order_no_filter"),"attributes.order_no_filter",DE(""))#',
		PRODUCT_NAME1 : '#IIf(IsDefined("attributes.PRODUCT_NAME1"),"attributes.PRODUCT_NAME1",DE(""))#'
			
    );
	</cfscript>
    <cfif GET_PO.recordcount>
    	<cfset attributes.totalrecords = GET_PO.query_count>
    <cfelse>
    	<cfset attributes.totalrecords = 0>
    </cfif>
    
</cfif>

<cfform name="search_list" action="#request.self#?fuseaction=prod.#fuseaction_#" method="post">
    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <input type="hidden" name="is_excel" id="is_excel" value="0">
    <cf_big_list_search title="#header_#">
        <cf_big_list_search_area>
            <cf_object_main_table>
                <cf_object_table column_width_list="60,80">
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cf_object_tr id="form_ul_keyword" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id='57460.Filtre'></cf_object_td>
                        <cf_object_td>
							<cfif fuseaction_ contains 'operations'>
                                <cfsavecontent variable="key_title"><cf_get_lang dictionary_id='29474.Emir No'> ,<cf_get_lang dictionary_id ='29419.Operasyon'> , <cf_get_lang dictionary_id='58211.Siparis No'> <cf_get_lang dictionary_id='57989.ve'>  <cf_get_lang dictionary_id ='36698.Lot No'>,<cf_get_lang dictionary_id ='58784.Referans'>,<cf_get_lang dictionary_id='60540.Ürün Alanlarında Arama Yapabilirsiniz'> !</cfsavecontent>
                            <cfelse>
                                <cfsavecontent variable="key_title"><cf_get_lang dictionary_id='36446.Talep No'>, <cf_get_lang dictionary_id='29474.Emir No'>, <cf_get_lang dictionary_id ='36698.Lot No'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id ='60539.Referans Alanlarında Arama Yapabilirsiniz'> !</cfsavecontent>
                            </cfif>
                            <cfset checked_list = "">
							<cfif isdefined("attributes.P_ORDER_NO1")>
								<cfset checked_list = listappend(checked_list,"P_ORDER_NO1")>
							</cfif>
							<cfif isdefined("attributes.DEMAND_NO1")>
								<cfset checked_list = listappend(checked_list,"DEMAND_NO1")>
							</cfif>
							<cfif isdefined("attributes.LOT_NO1")>
								<cfset checked_list = listappend(checked_list,"LOT_NO1")>
							</cfif>
							<cfif isdefined("attributes.REFERENCE_NO1")>
								<cfset checked_list = listappend(checked_list,"REFERENCE_NO1")>
							</cfif>
                            <cf_wrk_search_input name="keyword" id="keyword" title="#key_title#" style="width:80px;" check_column="#checked_list#" checkbox="Üretim Emri No,Talep No,Lot No,Referans No" columnlist="P_ORDER_NO1,DEMAND_NO1,LOT_NO1,REFERENCE_NO1" >
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="60,80">
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58211.Siparis No'></cfsavecontent>
                    <cf_object_tr id="form_ul_keyword" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id='58211.Siparis No'></cf_object_td>
                        <cf_object_td>
                        	<input type="text" name="order_no_filter" style="width:80px;" value="<cfif isdefined("attributes.order_no_filter")><cfoutput>#attributes.order_no_filter#</cfoutput></cfif>" />
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="170">
                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='36371.Tüm İstasyonlar'></cfsavecontent>
                    <cf_object_tr id="form_ul_station_id" title="#title#">
                        <cf_object_td>
                            <select name="station_id" id="station_id" style="width:170px;">
                                <option value=""><cf_get_lang dictionary_id='36371.Tüm İstasyonlar'></option>
                                <option value="0" <cfif attributes.station_id eq 0>selected</cfif>><cf_get_lang dictionary_id='36444.İstasyonu Boş Olanlar'></option>
                                <cfoutput query="get_w">
                                    <option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>><cfif len(up_station)>&nbsp;&nbsp;</cfif>#station_name#</option>
                                </cfoutput>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="100">
                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='58859.Süreç'></cfsavecontent>
                    <cf_object_tr id="form_ul_prod_order_stage" title="#title#">
                        <cf_object_td>
                            <select name="prod_order_stage" id="prod_order_stage" style="width:100px;">
                                <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                                <cfoutput query="get_process_type">
                                    <option value="#process_row_id#"<cfif isdefined('attributes.prod_order_stage') and attributes.prod_order_stage eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cfif (fuseaction_ contains 'demands') or (fuseaction_ contains 'order')>
                    <cf_object_table column_width_list="100">
                        <cfsavecontent variable="title"><cf_get_lang dictionary_id='36656.Emir'></cfsavecontent>
                        <cf_object_tr id="form_ul_related_orders" title="#title#">
                            <cf_object_td>
                                <select name="related_orders" id="related_orders" style="width:100px;">
                                    <option value="1" <cfif attributes.related_orders eq 1>selected</cfif>><cf_get_lang dictionary_id='36656.Emir'> <cf_get_lang dictionary_id='58651.Türü'></option>
                                    <option value="2" <cfif attributes.related_orders eq 2>selected</cfif>><cf_get_lang dictionary_id='60541.Üst Emirler'></option>
                                    <option value="3" <cfif attributes.related_orders eq 3>selected</cfif>><cf_get_lang dictionary_id='60542.Alt Emirler'></option>
                                </select>
                            </cf_object_td>
                        </cf_object_tr>
                    </cf_object_table>
                </cfif>
                <cfif fuseaction_ contains 'operations'>
                    <cf_object_table column_width_list="100">
                        <cfsavecontent variable="title"><cf_get_lang dictionary_id='54365.Operasyonlar'></cfsavecontent>
                        <cf_object_tr id="form_ul_result" title="#title#">
                            <cf_object_td>
                                <select name="result" id="result" style="width:100px;" title="<cf_get_lang dictionary_id='36452.Operasyon Sonucu'>">
                                    <option value="1"<cfif attributes.result eq 1>selected</cfif>><cf_get_lang dictionary_id ='36900.Girilenler'></option>
                                    <option value="0"<cfif attributes.result eq 0>selected</cfif>><cf_get_lang dictionary_id ='36899.Girilmeyenler'></option>
                                </select>
                            </cf_object_td>
                        </cf_object_tr>
                    </cf_object_table>
                <cfelse>   
                    <cf_object_table column_width_list="100">
                        <cfsavecontent variable="title"><cf_get_lang dictionary_id='54365.Operasyonlar'></cfsavecontent>
                        <cf_object_tr id="form_ul_result" title="#title#">
                            <cf_object_td>
                                <select name="result" id="result" style="width:100px;">
                                    <option value=""><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
                                    <option value="1"<cfif attributes.result eq 1>selected</cfif>><cf_get_lang dictionary_id ='36900.Girilenler'></option>
                                    <option value="0"<cfif attributes.result eq 0>selected</cfif>><cf_get_lang dictionary_id ='36899.Girilmeyenler'></option>
                                </select>
                            </cf_object_td>
                        </cf_object_tr>
                    </cf_object_table>
                </cfif>
                <cf_object_table column_width_list="100">
                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='58924.Sıralama'></cfsavecontent>
                    <cf_object_tr id="form_ul_oby" title="#title#">
                        <cf_object_td>
                            <select name="oby" id="oby" style="width:100px;">
                                <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
                                <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
                                <option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                                <option value="4" <cfif attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="65">
                    <cf_object_tr id="form_ul_status" title="Durum">
                        <cf_object_td>
                            <select name="status" id="status" style="width:65px;">
                                <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="3" <cfif attributes.status eq 3>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="80"><!------>
                    <cf_object_tr id="">
                        <cf_object_td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_search_button>
                            <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
            </cf_object_main_table>
        </cf_big_list_search_area><!------>
        <cf_big_list_search_detail_area>
            <cf_object_main_table>
                <cf_object_table column_width_list="60,130">
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id ='57519.Cari Hesap'></cfsavecontent>
                    <cf_object_tr id="form_ul_member_name" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id ='57519.Cari Hesap'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                            <input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                            <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                            <input type="text" name="member_name"   id="member_name" style="width:110px;"  value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search_list.consumer_id&field_comp_id=search_list.company_id&field_member_name=search_list.member_name&field_type=search_list.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search_list.member_name.value),'list');"><img src="/images/plus_thin.gif" align="absbottom"></a>
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id ='57486.Kategori'></cfsavecontent>
                    <cf_object_tr id="form_ul_product_cat" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id ='57486.Kategori'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                            <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                            <cfinput type="text" name="product_cat" id="product_cat" style="width:110px;" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
                            <a href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=search_list.product_cat_code&is_sub_category=1&field_id=search_list.product_catid&field_name=search_list.product_cat');"><img src="/images/plus_thin.gif" align="absbottom" title="Kategori Ekle"></a>
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57544.Sorumlu'></cfsavecontent>
                    <cf_object_tr id="form_ul_position_name" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id='57544.Sorumlu'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
                            <input type="text" name="position_name" id="position_name" style="width:110px;" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_list.position_code&field_name=search_list.position_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_list.position_name.value),'list');"><img src="/images/plus_thin.gif" align="absbottom"></a>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="60,130">
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id ='36785.Satış Çalışanı'></cfsavecontent>
                    <cf_object_tr id="form_ul_order_employee" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id ='36785.Satış Çalışanı'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="order_employee_id"  id="order_employee_id"value="<cfoutput>#attributes.order_employee_id#</cfoutput>">
                            <input type="text"  name="order_employee"  id="order_employee"  style="width:110px;"  value="<cfoutput>#attributes.order_employee#</cfoutput>" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','135')" autocomplete="off">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_list.order_employee_id&field_name=search_list.order_employee&select_list=1','list');"><img src="/images/plus_thin.gif" align="absbottom"></a>
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id ='36445.Hammadde'></cfsavecontent>
                    <cf_object_tr id="form_ul_related_product_name" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id ='36445.Hammadde'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="related_stock_id" id="related_stock_id" value="<cfoutput>#attributes.related_stock_id#</cfoutput>">
                            <input type="hidden" name="related_product_id" id="related_product_id" value="<cfoutput>#attributes.related_product_id#</cfoutput>">
                            <input type="text"   name="related_product_name"  id="related_product_name" style="width:110px;"  value="<cfoutput>#attributes.related_product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('related_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','related_product_id,related_stock_id','','3','225');" autocomplete="off">
                            <a href="javascript://" onclick="spect_remove();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.related_stock_id&product_id=search_list.related_product_id&field_name=search_list.related_product_name&keyword='+encodeURIComponent(document.search_list.related_product_name.value),'list');"><img src="/images/plus_thin.gif" align="absbottom"></a>
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
                    <cf_object_tr id="form_ul_project_head" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id='57416.Proje'></cf_object_td>
                        <cf_object_td>
                            <cfif isdefined('attributes.project_head') and len(attributes.project_head)>
                                <cfset project_id_ = #attributes.project_id#>
                            <cfelse>
                                <cfset project_id_ = ''>
                            </cfif>
                            <cf_wrkproject
                                project_id="#project_id_#"
                                width="110"
                                agreementno="1" customer="2" employee="3" priority="4" stage="5"
                                boxwidth="600"
                                boxheight="400">
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>  
                <cf_object_table column_width_list="60,130">
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
                    <cf_object_tr id="form_ul_product_name" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id='57657.Ürün'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                            <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                            <input type="text"   name="product_name"  id="product_name" style="width:110px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE,','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
                            <a href="javascript://" onclick="spect_remove();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.stock_id&product_id=search_list.product_id&field_name=search_list.product_name&keyword='+encodeURIComponent(document.search_list.product_name.value),'list');"><img src="/images/plus_thin.gif" align="absbottom"></a>
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57647.Spec'></cfsavecontent>
                    <cf_object_tr id="form_ul_spect_name" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id='57647.Spec'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
                            <input type="text" name="spect_name" id="spect_name" value="<cfoutput>#attributes.spect_name#</cfoutput>" style="width:110px;">
                            <a href="javascript://" onclick="product_control();"><img src="/images/plus_thin.gif" align="absbottom"></a>
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id ='58225.Model'></cfsavecontent>
                    <cf_object_tr id="form_ul_short_code_name" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id ='58225.Model'></cf_object_td>
                        <cf_object_td>
                            <cf_wrkproductmodel
                                returninputvalue="short_code_id,short_code_name"
                                returnqueryvalue="MODEL_ID,MODEL_NAME"
                                width="110"
                                fieldname="short_code_name"
                                fieldid="short_code_id"
                                compenent_name="getProductModel"            
                                boxwidth="300"
                                boxheight="150"                        
                                model_id="#attributes.short_code_id#">
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="65">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57756.Durum'></cfsavecontent>
                    <cfif isdefined("is_show_production_station") and is_show_production_station eq 1>
                        <cfif fuseaction_ contains 'order'>
                            <cf_object_tr id="form_ul_production_stage" title="#message#">
                                <cf_object_td rowspan="3">
                                    <select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
                                        <option value="4" style="background-color:#00CCFF;font-size:12px;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'4')>selected</cfif>><cf_get_lang dictionary_id ='36583.Başlamadı'></option>
                                        <option value="0" style="background-color:#FFCC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'0')>selected</cfif>><cf_get_lang dictionary_id ='36891.Operatöre Gönderildi'></option>
                                        <option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang dictionary_id ='36890.Başladı'></option>
                                        <option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang dictionary_id ='36893.Üretim Durdu(Arıza)'></option>
                                        <option value="2" style="background-color:#FF0000;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'2')>selected</cfif>><cf_get_lang dictionary_id ='36584.Bitti'></option>
                                    </select>                        
                                </cf_object_td>
                            </cf_object_tr>
                        <cfelseif fuseaction_ contains 'in_productions'> 
                            <cf_object_tr id="form_ul_production_stage" title="#message#">
                                <cf_object_td rowspan="3">
                                     <select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
                                        <option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang dictionary_id ='36890.Başladı'></option>
                                        <option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang dictionary_id ='36893.Üretim Durdu(Arıza)'></option>
                                    </select>                        
                                </cf_object_td>
                            </cf_object_tr>
                        </cfif>
                    </cfif>                                       
                </cf_object_table>
                <cf_object_table column_width_list="90,220">
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                    <cf_object_tr id="form_ul_start_date" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cf_object_td>
                        <cf_object_td>
                           <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                <cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" style="width:80px;" value="#dateformat(attributes.start_date,dateformat_style)#">
                            <cfelse>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
                                <cfinput required="Yes" message="#message#" type="text" name="start_date" maxlength="10" validate="#validate_style#" style="width:80px;" value="#dateformat(attributes.start_date,dateformat_style)#">
                            </cfif>
                            <cf_wrk_date_image date_field="start_date">
                            <cfinput type="text" name="start_date_2" value="#dateformat(attributes.start_date_2,dateformat_style)#" validate="#validate_style#" style="width:80px;">
                            <cf_wrk_date_image date_field="start_date_2">
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                    <cf_object_tr id="form_ul_finish_date" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cf_object_td>
                        <cf_object_td>
                            <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                <cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" style="width:80px;">
                            <cfelse>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
                                <cfinput required="Yes" message="#message#" type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" style="width:80px;">
                            </cfif>
                            <cf_wrk_date_image date_field="finish_date">
                            <cfinput type="text" name="finish_date_2" value="#dateformat(attributes.finish_date_2,dateformat_style)#" validate="#validate_style#" style="width:80px;">
                            <cf_wrk_date_image date_field="finish_date_2">
                        </cf_object_td>
                    </cf_object_tr>
                    <!---<cfif fuseaction_ contains 'operations'>
                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='63.Operasyonlar'></cfsavecontent>
                        <cf_object_tr id="form_ul_operation_type" title="#header_#">
                           <cf_object_td type="text"><cf_get_lang dictionary_id='63.Operasyonlar'></cf_object_td>
                            <cf_object_td>
                                <input type="hidden" name="operation_type_id" id="operation_type_id" value="<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)><cfoutput>#attributes.operation_type_id#</cfoutput></cfif>" />
                                <input type="text" name="operation_type" id="operation_type" style="width:90px;" value="<cfif isdefined("attributes.operation_type") and len(attributes.operation_type) and len(attributes.operation_type_id)><cfoutput>#attributes.operation_type#</cfoutput></cfif>" />
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_operation_type&field_id=search_list.operation_type_id&field_name=search_list.operation_type&is_submitted=1&keyword='+encodeURIComponent(document.search_list.operation_type.value),'list');"><img src="/images/plus_thin.gif" align="absbottom"></a>
                            </cf_object_td>
                        </cf_object_tr>
                    </cfif>--->                        
                </cf_object_table>                                                     
            </cf_object_main_table>
        </cf_big_list_search_detail_area>
    </cf_big_list_search>
</cfform>

<cf_big_list>
	<thead>
    	<tr>
            <th></th>
        	<th><cf_get_lang dictionary_id='29474.Emir No'></th>
            <cfif isdefined("is_show_demand_no") and is_show_demand_no eq 1>
                <th style="width:20px;"><cf_get_lang dictionary_id='36446.Talep No'></th>
            </cfif>
            <th><cf_get_lang dictionary_id='58211.Siparis No'>& <cf_get_lang dictionary_id ='57519.Cari Hesap'></th><!---sipariş ve cari hesap birleşti--->
            <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                <th style="width:60px;"><cf_get_lang dictionary_id ='36698.Lot No'></th>
            </cfif>
            <cfif isdefined("is_show_demand_no_") and is_show_demand_no_ eq 1>
                <th style="width:50px;"><cf_get_lang dictionary_id='43583.İç Talep No'></th>
            </cfif>
            <th><cf_get_lang dictionary_id ='57518.Stok Kod'></th>
            <th><cf_get_lang dictionary_id ='57657.Ürün'></th>
            <cfif isdefined("is_spec_code") and is_spec_code eq 1>
                <th style="width:30px;" nowrap="nowrap"><a style="cursor:pointer;" ><cf_get_lang dictionary_id='54850.Spec Id'></a></th>
            </cfif>
            <cfif isdefined("is_spec_name") and is_spec_name eq 1>
                <th style="width:40px;"><a style="cursor:pointer;" ><cf_get_lang dictionary_id='57647.Spec'></a></th>
            </cfif>
            <th><cf_get_lang dictionary_id='58834.İstasyon'></th>
            <cfif is_show_process eq 1>         
                <th style="width:50px;"><cf_get_lang dictionary_id='58859.Süreç'></th>
            </cfif>
            <th><cf_get_lang dictionary_id='36604.Hedef Başlangıç'></th>
            <th><cf_get_lang dictionary_id='36606.Hedef Bitiş'></th>
            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
            <cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
                    <th style="width:30px;text-align:right;"><cf_get_lang dictionary_id='36608.Üretilen'></th>
                    <th style="width:30px;text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
            </cfif>
            <th><cf_get_lang dictionary_id='57636.Birim'></th>
            <th></th>
              <th style="width:10px;"></th>
                <th style="text-align:center; width:10px;" class="header_icn_none">
                    <cfif not fuseaction_ contains 'operations'>
                        <cfoutput>
                        <a href="#request.self#?fuseaction=prod.add_prod_order<cfif fuseaction_ contains 'demands'>&is_demand=1</cfif>&is_collacted=1">
                            <img src="/images/copy_list.gif" title="<cfif fuseaction_ contains 'demands'><cf_get_lang dictionary_id='36531.Toplu Talep Ekle'><cfelse><cf_get_lang dictionary_id='36534.Toplu Üretim Emri Ekle'></cfif>">
                        </a>
                        <a href="#request.self#?fuseaction=prod.add_prod_order<cfif fuseaction_ contains 'demands'>&is_demand=1</cfif>">
                            <img src="/images/plus_list.gif" title="<cfif fuseaction_ contains 'demands'><cf_get_lang dictionary_id='36389.Talep Ekle'><cfelse><cf_get_lang dictionary_id='36378.Üretim Emri Ekle'></cfif>">
                        </a>
                        </cfoutput>
                    </cfif>
                </th>
              <th class="header_icn_none">
                    <cfif (fuseaction_ contains 'demands' or  fuseaction_ contains 'order') and is_show_multi_print eq 1>
                        <cfoutput><a href="javascript://" onclick="send_services_print();"><img src="/images/print2.gif" title="<cf_get_lang dictionary_id='36535.Toplu Yazdır'>"></a></cfoutput>
                    </cfif>
                    <cfif isdefined("get_po.recordcount") and  get_po.recordcount>
                        <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','row_demand');">                
                    </cfif>
                </th>
        </tr>
    </thead>
	<cfif isdefined("attributes.is_submitted")>
			<cfif GET_PO.recordcount>
              <tbody>
               <form name="go_p_order_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order_new">
                    <input type="hidden" name="keyword" id="keyword" value=""><!--- Üretim Emirlerin Listesine Giderken Doldurulur.. --->
                    <input type="hidden" name="production_order_no" id="production_order_no" value=""><!--- Üretim Malzeme İhtiyaçlarına Giderken doldurulur.. --->
                    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                    <input type="hidden" name="start_date" id="start_date" value="">
                    <input type="hidden" name="finish_date" id="finish_date" value="">
                    <input type="hidden" name="row_demand_all" id="row_demand_all" value="<cfoutput query="get_po">#P_ORDER_ID#<cfif currentrow neq recordcount>,</cfif></cfoutput>">
                </form>
                <form name="convert_demand_to_production" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.emptypopup_convert_demand_to_production">
                	<input type="hidden" name="is_upd_related_demands" id="is_upd_related_demands" value="<cfif isdefined("is_upd_related_demands")><cfoutput>#is_upd_related_demands#</cfoutput><cfelse>0</cfif>"><!--- İlişkili taleplerin güncellenip güncellenmeyeceğini tutuyor arka sayfada kullanılıyor --->
					<cfoutput query="GET_PO">
                        <tr>
                            <td align="center" id="order_row#currentrow#" class="color-row" onclick="gizle_goster(order_stocks_detail#currentrow#);connectAjax('#currentrow#','#p_order_id#','#PRODUCT_ID#','#STOCK_ID#','#quantity#','#SPEC_MAIN_ID#');gizle_goster_nested('siparis_goster#currentrow#','siparis_gizle#currentrow#');">
                                        <img id="siparis_goster#currentrow#" style="cursor:pointer;" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
                                        <img id="siparis_gizle#currentrow#" style="cursor:pointer;display:none;" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id ='58628.Gizle'>">
                            </td>
                            <td>
                                <a href="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#p_order_id#" class="tableyazi">
                                #p_order_no#</a>
                            </td>
                            <cfif isdefined("is_show_demand_no") and is_show_demand_no eq 1>
                              <td><cfif len(demand_no)>#demand_no#<cfelse>&nbsp;</cfif></td>
                            </cfif>
                            <td>#ORDER_NUMBER_AND_CARI#</td>
                            <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                              <td nowrap>#get_po.lot_no#</td>
                            </cfif>
                            <cfif isdefined("is_show_demand_no_") and is_show_demand_no_ eq 1>
                              <td nowrap>#get_po.internal_number#</td>
                            </cfif>
                            <td>#stock_code#</td>
                            <td>
                                <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                    <a href="#request.self#?fuseaction=prod.add_product_tree&stock_id=#stock_id#" class="tableyazi">
                                        #product_name# #property#
                                    </a>
                                <cfelse>
                                    #product_name# #property#
                                </cfif>
                            </td>
                            <cfif isdefined("is_spec_code") and is_spec_code eq 1>
                               <td>#SPEC_MAIN_ID#</td>
                            </cfif>
                            <cfif isdefined("is_spec_name") and is_spec_name eq 1>
                                <td>
                                 <cfif len(SPECT_VAR_ID) or len(SPEC_MAIN_ID)>
                                    <cfset s_link = '&id=#SPECT_VAR_ID#&stock_id=#stock_id#&spect_main_id=#SPEC_MAIN_ID#'>
                                    <cfif not len(SPECT_VAR_ID)>
                                        <cfset s_link = '&upd_main_spect=1&spect_main_id=#SPEC_MAIN_ID#'>
                                    </cfif>
                                    <cfif is_show_spec_no eq 1><!--- spec no gelsin --->
                                        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect#s_link#&is_disable=1','list');" class="tableyazi">
                                                #SPEC_MAIN_ID#-#SPECT_VAR_ID#
                                            </a>
                                        <cfelse>
                                            #SPEC_MAIN_ID#-#SPECT_VAR_ID#
                                        </cfif>
                                    <cfelse><!--- spec adı gelsin --->
                                        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect#s_link#&is_disable=1','list');" class="tableyazi">
                                                #SPECT_VAR_NAME#
                                            </a>
                                        <cfelse>
                                            #SPECT_VAR_NAME#
                                        </cfif>
                                    </cfif>
                                 </cfif>
                                </td>
                            </cfif>
                            <td>
                                <cfif len(station_id)>
                                <a class="tableyazi" href="#request.self#?fuseaction=prod.upd_workstation&station_id=#station_id#">#get_station_prod(station_id)#</a>
                                </cfif>
                            </td>
                            <cfif is_show_process eq 1>
                              <td>#stage#</td>
                            </cfif>
                            <td>#dateformat(start_date,dateformat_style)# #TimeFormat(start_date,'HH')#:#TimeFormat(start_date,'MM')#</td>
                            <td>#dateformat(finish_date,dateformat_style)# #TimeFormat(finish_date,'HH')#:#TimeFormat(finish_date,'MM')#</td>
                            <td>#quantity#</td>
                            <cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
                              <td>#result_amount#</td>
                              <td>#kalan#</td>
                            </cfif>
                            <td>#main_unit#</td>
                            <td>
                                <cfif IS_STAGE eq 4>
                                        <cfif IS_GROUP_LOT eq 1>
                                             <img src="/images/g_blue_glob.gif" title="<cf_get_lang dictionary_id ='36892.Gruplandı Fakat Operatöre Gönderilmedi'>">
                                        <cfelse>
                                             <img src="/images/blue_glob.gif" title="<cf_get_lang dictionary_id ='36583.Başlamadı'>">
                                        </cfif>       
                                    <cfelseif IS_STAGE eq 0>
                                        <img src="/images/yellow_glob.gif" title="<cf_get_lang dictionary_id ='36891.Operatöre Gönderildi'>">
                                    <cfelseif IS_STAGE eq 1>
                                        <img src="/images/green_glob.gif" title="<cf_get_lang dictionary_id ='36890.Başladı'>">
                                    <cfelseif IS_STAGE eq 2>
                                        <img src="/images/red_glob.gif" title="<cf_get_lang dictionary_id ='36584.Bitti'>">
                                    <cfelseif IS_STAGE eq 3>
                                        <img src="/images/grey_glob.gif" title="<cf_get_lang dictionary_id ='36893.Üretim Durdu(Arıza)'>">
                                 </cfif>
                            </td> 
                            <td align="center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=#print_type_#&action_id=#p_order_id#&date1=#DateFormat(attributes.start_date,dateformat_style)#&date2=#DateFormat(attributes.finish_date,dateformat_style)#&iid=#attributes.station_id#&iiid=<cfif len(attributes.product_cat)>#attributes.product_cat_code#</cfif>
                                <cfif len(attributes.result)>&keyword=#attributes.result#</cfif>&action_row_id=#attributes.production_stage#','page');"><img src="../images/print2.gif"></a></td>
                                <td style="text-align:center;"><a href="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#p_order_id#"> <img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='36436.Üretim Emri Düzenle'>"></a></td>
                                <td width="1%">
                                <input type="checkbox" name="row_demand" id="row_demand" value="#P_ORDER_ID#;#CURRENTROW#"></td>
                             
                              
                        </tr>
                        <tr id="order_stocks_detail#currentrow#" class="nohover" style="display:none" >
                                <td colspan="#colspan#">
                                    <div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#" style="border:none;"></div>
                                </td>
                        </tr>
                    </cfoutput>
                    
              </tbody>  
                <tfoot>
                    <tr height="40" class="nohover">
                        <td colspan="<cfoutput>#colspan#</cfoutput>" align="right" style="text-align:right;">
                            <input type="button" value="<cf_get_lang dictionary_id ='57858.Excel Getir'>" name="excelll" id="excelll" onclick="convert_to_excel();">
                            <cfif not fuseaction_ contains 'operations'>
                                <input type="button" value="<cf_get_lang dictionary_id ='36815.Grupla'>" onclick="demand_convert_to_production(2);">
                                <input type="button" value="<cf_get_lang dictionary_id ='36523.Malzeme İhtiyaç Listesi'>" onclick="demand_convert_to_production(3);">
                                <input type="button" id="tumune_ihtiyac_button" value="<cf_get_lang dictionary_id ='36524.Tümüne Malzeme İhtiyaç Listesi'>" onclick="demand_convert_to_production(4);">
                                <cfif (fuseaction_ contains 'demands' or (fuseaction_ contains 'order' and attributes.result eq 0)) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                    <cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'>
                                </cfif>
                                <cfif fuseaction_ contains 'order' and attributes.result eq 0 and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                    <input type="button" value="<cf_get_lang dictionary_id='36995.Seçili Emirleri Güncelle'>"  onclick="demand_convert_to_production(5);">
                                </cfif>
                                <cfif fuseaction_ contains 'demands'>
                                    <input type="button" name="updDemandValues_" id="updDemandValues_" value="<cf_get_lang dictionary_id ='36530.Seçili Talepleri Güncelle'>" onclick="demand_convert_to_production(1);">
                                    <input type="button" name="delDemandValues_" id="delDemandValues_" value="<cf_get_lang dictionary_id ='36996.Seçili Talepleri Sil'>" onclick="demand_convert_to_production(6);">
                                    <input type="button" name="convert_to_production_" id="convert_to_production_" value="<cf_get_lang dictionary_id ='36647.Üretime Çevir'>" onclick="demand_convert_to_production(0);">
                                </cfif>
                            </cfif>
                            <cfif fuseaction_ contains 'operations' and attributes.result eq 0>
                                <input type="button" name="convert_to_production_" id="convert_to_production_" value="<cf_get_lang dictionary_id='60545.Seçili Operasyonları Sonlandır'>" onclick="demand_convert_to_production(7);">
                            <cfelseif fuseaction_ contains 'operations' and attributes.result eq 1>
                                <input type="button" name="convert_to_production_" id="convert_to_production_" value="<cf_get_lang dictionary_id='60546.Seçili Operasyonları Güncelle'>" onclick="demand_convert_to_production(7);">
                            </cfif>
                            <input type="hidden" name="process_type" id="process_type" value=""><!--- process type query sayfasında 0 ise talepler üretime çevirili 1 ise sadece bilgileri güncellenir.. --->
                            <input type="hidden" name="p_order_id_list" id="p_order_id_list" value="">
                            <div id="user_message_demand"></div>
                        </td>
                    </tr>
                <!-- sil -->
            	</tfoot>
                </form>
				<script type="text/javascript">
                function demand_convert_to_production(type)
                    {
                        if(type==4)// type 4 ise
                         {
                            document.getElementById("tumune_ihtiyac_button").value='<cfoutput>#getLang("main",293)#</cfoutput>';
                            document.getElementById("tumune_ihtiyac_button").disabled = true;
                            window.go_p_order_list.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_materials_total";
                            document.go_p_order_list.submit();
                         }
                        else// type 4 degilse
                        {
                            var is_selected=0;
                            if(document.getElementsByName('row_demand').length > 0){
                                var p_order_id_list="";
                                var currntrow_list="";
                                if(document.getElementsByName('row_demand').length ==1){
                                    if(document.getElementById('row_demand').checked==true){
                                        is_selected=1;
                                        p_order_id_list+=list_getat(document.convert_demand_to_production.row_demand.value,1,';')+',';
                                        currntrow_list+=list_getat(document.convert_demand_to_production.row_demand.value,2,';')+',';
                                    }
                                }	
                                else{
                                    for (i=0;i<document.getElementsByName('row_demand').length;i++){
                                            if(document.convert_demand_to_production.row_demand[i].checked==true){ 
                                                p_order_id_list+=list_getat(document.convert_demand_to_production.row_demand[i].value,1,';')+',';
                                                currntrow_list+=list_getat(document.convert_demand_to_production.row_demand[i].value,2,';')+',';
                                                is_selected=1;
                                            }
                                    }		
                                }
                                if(is_selected==1){
                                    if(list_len(p_order_id_list,',') > 1)
                                        {
                                        p_order_id_list = p_order_id_list.substr(0,p_order_id_list.length-1);	
                                        document.getElementById('p_order_id_list').value=p_order_id_list;
                                        if(type==2)//gruplanmak isteniyor.
                                        {
											<cfoutput>
                                            AjaxPageLoad('#request.self#?fuseaction=prod.popup_ajax_production_orders_groups&station_id='+document.getElementById('station_id').value+'&p_order_id_list='+document.getElementById('p_order_id_list').value+'','groups_p',1)
                                            </cfoutput>
                                        }
                                        else
                                            {							
                                            if(type==3)
                                                user_message='<cf_get_lang dictionary_id ="36564.Malzeme İhtiyaç Listesine Yönlendiriliyorsunuz Lütfen Bekleyiniz">!';
                                            else if(type==1)
                                            {
                                                var selected_process_ = document.convert_demand_to_production.process_stage.value;
                                                if(selected_process_=='')
                                                {
                                                    alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58859.Süreç'>");
                                                    return false;
                                                }
                                                user_message='<cf_get_lang dictionary_id ="36577.Talepler Güncelleniyor Lütfen Bekleyiniz">!';
                                            }
                                            else if(type==5)
                                            {
                                                var selected_process_ = document.convert_demand_to_production.process_stage.value;
                                                if(selected_process_=='')
                                                {
                                                    alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58859.Süreç'>");
                                                    return false;
                                                }
                                                user_message='<cf_get_lang dictionary_id="36991.Emirler Güncelleniyor Lütfen Bekleyiniz"> !';
                                            }
                                            else if(type==6)
                                            {
                                                var selected_process_ = document.convert_demand_to_production.process_stage.value;
                                                if(selected_process_=='')
                                                {
                                                    alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58859.Süreç'>");
                                                    return false;
                                                }
                                                user_message='<cf_get_lang dictionary_id="36992.Talepler Siliniyor Lütfen Bekleyiniz"> !';
                                            }
                                            else if(type == 7)
                                            {
                                                var employee_id_list_ = "";
                                                var station_id_list_ = "";
                                                var operation_type_id_list_ = "";
                                                var operation_amount_list_ = "";
                                                var operation_result_id_list_ = "";
                                                for(crt=1;crt<list_len(currntrow_list);crt++)
                                                {
                                                    var crtrow = list_getat(currntrow_list,crt,',');
                                                    if(document.getElementById('station_id_'+crtrow).value == '')
                                                    {
                                                        alert(crtrow +'. <cf_get_lang dictionary_id="60547.Satırda İstasyon Eksik">. <cf_get_lang dictionary_id="58837.Lütfen İstasyon Seçiniz">!');
                                                        return false;
                                                    }
                                                    if(document.getElementById('operation_amount_'+crtrow).value == '')
                                                    {
                                                        alert(crtrow +'. <cf_get_lang dictionary_id="60548.Satırda Miktar Eksik"> . <cf_get_lang dictionary_id="60222.Lütfen Miktar Seçiniz">!');
                                                        return false;
                                                    }
                                                    if(document.getElementById('operation_amount_'+crtrow).value > document.getElementById('operation_amount__'+crtrow).value)
                                                    {
                                                        alert(crtrow +'. <cf_get_lang dictionary_id="60549.Satırda Operasyon Miktarı Kalan Miktardan Fazla">!');
                                                        return false;
                                                    }
                                                    if(document.getElementById('employee_id_'+crtrow).value == '')
                                                    {
                                                        alert(crtrow +'. <cf_get_lang dictionary_id="60550.Satırda İşlemi Yapan Eksik">. <cf_get_lang dictionary_id="60551.Lütfen İşlemi Yapanı Seçiniz">!');
                                                        return false;
                                                    }
                                                    employee_id_list_+=document.getElementById('employee_id_'+crtrow).value+';';
                                                    station_id_list_+=document.getElementById('station_id_'+crtrow).value+';';
                                                    operation_type_id_list_+=document.getElementById('operation_type_id_'+crtrow).value+';';
                                                    operation_amount_list_+=document.getElementById('operation_amount_'+crtrow).value+';';
                                                    <cfif attributes.result eq 1>//sadece üretim sonucu girilenlerde gelsin. güncelleme yapabilmek için.
                                                        operation_result_id_list_+=document.getElementById('operation_result_id_'+crtrow).value+';';
                                                    </cfif>
                                                }
                                                document.getElementById('p_order_id_list').value = p_order_id_list ;
                                                document.getElementById('operation_id_list').value = operation_type_id_list_ ;
                                                document.getElementById('employee_id_list').value = employee_id_list_ ;
                                                document.getElementById('station_id_list').value = station_id_list_ ;
                                                document.getElementById('amount_list').value = operation_amount_list_ ;
                                                <cfif attributes.result eq 1>	
                                                    document.getElementById('operation_result_id_list').value = operation_result_id_list_ ;
                                                    user_message='Operasyon Sonuçları Güncelleniyor Lütfen Bekleyiniz!';
                                                <cfelseif attributes.result eq 0>
                                                    user_message='Operasyon Sonuçları Ekleniyor Lütfen Bekleyiniz!';
                                                </cfif>
                                            }
                                            else if(type==0)
                                                user_message='<cf_get_lang dictionary_id ="36578.Talepler Üretime Çeviriliyor Lütfen Bekleyiniz">!';
                                                
                                            document.getElementById('process_type').value=type;
                                            windowopen('','small','p_action_window');
                                            convert_demand_to_production.target = 'p_action_window';
                                            convert_demand_to_production.submit();
                                            //AjaxFormSubmit(convert_demand_to_production,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id ="1374.Tamamlandı">!','','',1);
                                        }
                                        
                                    }
                                }
                                else{
                                    if(type==0)
                                        alert("<cf_get_lang dictionary_id ='36579.Üretime Göndermek İçin Talep Seçiniz'>");
                                    else if(type==1)
                                        alert("<cf_get_lang dictionary_id ='36580.Güncellenecek Talepleri Seçiniz'>!");
                                    else if(type==5)
                                        alert("<cf_get_lang dictionary_id ='36993.Güncellenecek Emirleri Seçiniz'>!");
                                    else if(type==6)
                                        alert("<cf_get_lang dictionary_id ='36994.Silinecek Talepleri Seçiniz'>!");
                                    else if(type==2)
                                        alert("<cf_get_lang dictionary_id ='36581.Gruplanacak Satırları Seçiniz'>!");
                                    else if(type==3)
                                        alert("<cf_get_lang dictionary_id ='36582.Malzeme İhtiyaçları İçin Talep Seçiniz'>!");
                                    else if(type==7)
                                        alert("<cf_get_lang dictionary_id ='60552.Sonlandırılacak Operasyonları Seçiniz'>!");
                                    return false;
                                }
                            }
                    }// type 4 degilse	
                }	
            </script>
            <cfelse>
                <cfoutput>
                <tbody>
                    <tr>
                        <td colspan="#colspan#"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </tbody></cfoutput>	
            </cfif>
    <cfelse>
    <cfoutput>
        <tbody>
            <tr>
                <td colspan="#colspan#"><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</td>
            </tr>
        </tbody></cfoutput>
    </cfif> 
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.is_submitted")>
        <cfset url_str = url_str & "&is_submitted=#attributes.is_submitted#">
    </cfif>
     <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        <cfset url_str = url_str & "&keyword=#attributes.keyword#">
    </cfif>
    <cfif isdefined("attributes.order_no_filter") and len(attributes.order_no_filter)>
        <cfset url_str = url_str & "&order_no_filter=#attributes.order_no_filter#">
    </cfif>
     <cfif isdefined("attributes.station_id") and len(attributes.station_id)>
        <cfset url_str = url_str & "&station_id=#attributes.station_id#">
    </cfif>
    <cfif isdefined("attributes.prod_order_stage") and len(attributes.prod_order_stage)>
        <cfset url_str = url_str & "&prod_order_stage=#attributes.prod_order_stage#">
    </cfif>
     <cfif isdefined("attributes.related_orders") and len(attributes.related_orders)>
        <cfset url_str = url_str & "&related_orders=#attributes.related_orders#">
    </cfif>
      <cfif isdefined("attributes.result") and len(attributes.result)>
        <cfset url_str = url_str & "&result=#attributes.result#">
    </cfif>
      <cfif isdefined("attributes.result") and len(attributes.result)>
        <cfset url_str = url_str & "&result=#attributes.result#">
    </cfif>
    <cfif isdefined("attributes.oby") and len(attributes.oby)>
        <cfset url_str = url_str & "&oby=#attributes.oby#">
    </cfif>
     <cfif isdefined("attributes.status") and len(attributes.status)>
        <cfset url_str = url_str & "&status=#attributes.status#">
    </cfif>
     <cfif isdefined("attributes.member_name") and len(attributes.member_name)>
        <cfset url_str = url_str & "&member_name=#attributes.member_name#">
    </cfif>
     <cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
        <cfset url_str = url_str & "&product_cat=#attributes.product_cat#">
    </cfif>
     <cfif isdefined("attributes.position_name") and len(attributes.position_name)>
        <cfset url_str = url_str & "&position_name=#attributes.position_name#">
    </cfif>
     <cfif isdefined("attributes.order_employee") and len(attributes.order_employee)>
        <cfset url_str = url_str & "&order_employee=#attributes.order_employee#">
    </cfif>
     <cfif isdefined("attributes.related_product_name") and len(attributes.related_product_name)>
        <cfset url_str = url_str & "&related_product_name=#attributes.related_product_name#">
    </cfif>
     <cfif isdefined("attributes.project_head") and len(attributes.project_head)>
        <cfset url_str = url_str & "&project_head=#attributes.project_head#">
    </cfif>
     <cfif isdefined("attributes.product_name") and len(attributes.product_name)>
        <cfset url_str = url_str & "&product_name=#attributes.product_name#">
    </cfif>
    <cfif isdefined("attributes.spect_name") and len(attributes.spect_name)>
        <cfset url_str = url_str & "&spect_name=#attributes.spect_name#">
    </cfif>
    <cfif isdefined("attributes.short_code_name") and len(attributes.short_code_name)>
        <cfset url_str = url_str & "&short_code_name=#attributes.short_code_name#">
    </cfif>
    <cfif isdefined("attributes.production_stage") and len(attributes.production_stage)>
        <cfset url_str = url_str & "&production_stage=#attributes.production_stage#">
    </cfif>
    <cfif isdate(attributes.start_date)>
	    <cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,dateformat_style)#">
    </cfif>
    <cfif isdate(attributes.start_date_2)>
	    <cfset url_str = url_str & "&start_date_2=#dateformat(attributes.start_date_2,dateformat_style)#">
    </cfif>
    <cfif isdate(attributes.finish_date)>
	    <cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
    </cfif>
    <cfif isdate(attributes.finish_date_2)>
	    <cfset url_str = url_str & "&finish_date_2=#dateformat(attributes.finish_date_2,dateformat_style)#">
    </cfif>
    
    <!-- sil -->
        <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
            <tr>
                <td>
                    <cf_pages 
                        page="#attributes.page#" 
                        maxrows="#attributes.maxrows#" 
                        totalrecords="#attributes.totalrecords#" 
                        startrow="#attributes.startrow#" 
                        adres="prod.#fuseaction_##url_str#">
                </td>
                <td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
            </tr>
        </table>
    <!-- sil -->
    </cfif>
<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><div id="groups_p"></div></td>
	</tr>
</table>
<script type="text/javascript">
	function spect_remove()/*Eğer ürün seçildikten sonra spect seçilmişse yeniden ürün seçerse ilgili spect'i kaldır.*/
	{
		document.search_list.spect_main_id.value = "";
		document.search_list.spect_name.value = "";	
	} 
	
	function product_control()/*Ürün seçmeden spect seçemesin.*/
	{
		if(document.search_list.stock_id.value=="" || document.search_list.product_name.value=="" )
		{
		alert("<cf_get_lang dictionary_id ='36828.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
		return false;
		}
		else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=search_list.spect_main_id&field_name=search_list.spect_name&is_display=1&stock_id='+document.search_list.stock_id.value,'list');
	}
	
	function connectAjax(crtrow,p_order_id,prod_id,stock_id,order_amount,spect_main_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&deep_level_max=1&tree_stock_status=1</cfoutput>&p_order_id='+p_order_id+'&pid='+prod_id+'&sid='+ stock_id+'&amount='+order_amount+'&spect_main_id='+spect_main_id;
		AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
	}
	
	
    function send_services_print()
	{	
	<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
			<cfif not get_po.recordcount>
				alert("<cf_get_lang dictionary_id ='36586.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
				return false;
			</cfif>
			<cfif get_po.recordcount eq 1>
				if(document.convert_demand_to_production.row_demand.checked == false)
				{
					alert("<cf_get_lang dictionary_id ='36586.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
					return false;
				}
				else
					service_list_ = list_getat(document.convert_demand_to_production.row_demand.value,1,';');
			</cfif>
			<cfif get_po.recordcount gt 1>
				service_list_ = "";
				for (i=0; i < document.convert_demand_to_production.row_demand.length; i++)
				{
					if(document.convert_demand_to_production.row_demand[i].checked == true)
						{
						service_list_ = service_list_ + list_getat(document.convert_demand_to_production.row_demand[i].value,1,';') + ',';
						}	
				}
				if(service_list_.length == 0)
				{
					alert("<cf_get_lang dictionary_id ='36586.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
					return false;
				}
			</cfif>
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=#print_type_#</cfoutput>&iid='+service_list_,'page');
		<cfelse>
			alert("<cf_get_lang dictionary_id ='36586.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
			return false;
		</cfif>
	}
	
	
	function convert_to_excel()
	{
		document.search_list.is_excel.value = 1;
		search_list.action='<cfoutput>#request.self#?fuseaction=prod.emptypopup_#fuseaction_#</cfoutput>';
		search_list.submit();
		document.search_list.is_excel.value = 0;
		search_list.action='<cfoutput>#request.self#?fuseaction=prod.#fuseaction_#</cfoutput>';
		return true;
	}

</script>















