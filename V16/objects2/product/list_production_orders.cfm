<cfsetting showdebugoutput="yes">
<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.production_stage" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.oby" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default=""><!--- #session_base.company_id#--->
<cfparam name="attributes.member_type" default=""><!--- partner--->
<cfparam name="attributes.member_name" default=""> <!--- #session.pp.company# --->
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.order_employee_id" default="">
<cfparam name="attributes.order_employee" default="">
<cfparam name="attributes.sales_partner_id" default="">
<cfparam name="attributes.sales_partner" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.start_date_2" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.finish_date_2" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.product_cat_code" default="">
<cfparam name="attributes.status" default="2">
<cfparam name="attributes.operation_order" default="2">
<cfparam name="attributes.related_orders" default="1">
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
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.related_stock_id" default="">
<cfparam name="attributes.related_product_id" default="">
<cfparam name="attributes.related_product_name" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.reference_no" default="">
<cfinclude template="../../objects/functions/get_prod_order_funcs.cfm">
<cfif fuseaction_ is 'operations'>
	<cfparam name="attributes.result" default="0">
<cfelse>
	<cfparam name="attributes.result" default="">
</cfif>
<cfquery name="GET_PARTNERS" datasource="#DSN#">
	SELECT
    	PARTNER_ID
    FROM
    	COMPANY_PARTNER
    WHERE
    	COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
</cfquery>
<cfquery name="GET_W" datasource="#DSN#">
	SELECT 
    	* 
	FROM 
    	#dsn3_alias#.WORKSTATIONS 
	WHERE 
		ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
    	<!--- DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_code.position_code#">) --->
        OUTSOURCE_PARTNER IN (#ValueList(get_partners.partner_id)#) 
	ORDER BY STATION_NAME ASC
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif get_w.recordcount><cfset authority_station_id_list = ValueList(get_w.station_id,',')><cfelse><cfset authority_station_id_list = 0></cfif>
<cfif isdefined('attributes.demand_no')><cfset attributes.keyword = attributes.demand_no><cfset attributes.is_submitted = 1></cfif>
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfscript>
		get_prod_order_action = createObject("component", "V16.production_plan.cfc.get_prod_order");
        get_prod_order_action.dsn3 = dsn3;
        GET_PO = get_prod_order_action.get_prod_order_fnc(
			product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
			product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
			related_product_id : '#IIf(IsDefined("attributes.related_product_id"),"attributes.related_product_id",DE(""))#',
			related_stock_id : '#IIf(IsDefined("attributes.related_stock_id"),"attributes.related_stock_id",DE(""))#',
			related_product_name : '#IIf(IsDefined("attributes.related_product_name"),"attributes.related_product_name",DE(""))#',
			production_stage : '#IIf(IsDefined("attributes.production_stage"),"attributes.production_stage",DE(""))#',
			position_code : '#IIf(IsDefined("attributes.position_code"),"attributes.position_code",DE(""))#',
			position_name : '#IIf(IsDefined("attributes.position_name"),"attributes.position_name",DE(""))#',
			product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
			product_catid : '#IIf(IsDefined("attributes.product_catid"),"attributes.product_catid",DE(""))#',
			spect_main_id : '#IIf(IsDefined("attributes.spect_main_id"),"attributes.spect_main_id",DE(""))#',
			spect_name : '#IIf(IsDefined("attributes.spect_name"),"attributes.spect_name",DE(""))#',
			short_code_id : '#IIf(IsDefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#',
			startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
			short_code_name : '#IIf(IsDefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			result : '#IIf(IsDefined("attributes.result"),"attributes.result",DE(""))#',
			sales_partner : '#IIf(IsDefined("attributes.sales_partner"),"attributes.sales_partner",DE(""))#',
			sales_partner_id : '#IIf(IsDefined("attributes.sales_partner_id"),"attributes.sales_partner_id",DE(""))#',
			order_employee : '#IIf(IsDefined("attributes.order_employee"),"attributes.order_employee",DE(""))#',
			order_employee_id : '#IIf(IsDefined("attributes.order_employee_id"),"attributes.order_employee_id",DE(""))#',
			project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
			project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
			member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
			company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
			status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(""))#',
			fuseaction_ : '#IIf(IsDefined("fuseaction_"),"fuseaction_",DE(""))#',
			is_show_result_amount : '#IIf(IsDefined("is_show_result_amount"),"is_show_result_amount",DE(""))#',
			operation_type_id : '#IIf(IsDefined("operation_type_id"),"operation_type_id",DE(""))#',
			operation_type : '#IIf(IsDefined("operation_type"),"operation_type",DE(""))#',
			operation_order : '#IIf(IsDefined("operation_order"),"operation_order",DE(""))#',
			station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
			authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
			related_orders : '#IIf(IsDefined("related_orders"),"related_orders",DE(""))#'
		);
		GET_PO_DET_ALL = get_prod_order_action.get_prod_order_fnc2(
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			start_date_2 : '#IIf(IsDefined("attributes.start_date_2"),"attributes.start_date_2",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			finish_date_2 : '#IIf(IsDefined("attributes.finish_date_2"),"attributes.finish_date_2",DE(""))#'
		);
	</cfscript>
<!--- 
		GET_PO_DET = get_prod_order_action.get_prod_order_fnc2(
			station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
			authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
			product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
			product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
			product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
			product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			start_date_2 : '#IIf(IsDefined("attributes.start_date_2"),"attributes.start_date_2",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			finish_date_2 : '#IIf(IsDefined("attributes.finish_date_2"),"attributes.finish_date_2",DE(""))#',
			prod_order_stage : '#IIf(IsDefined("attributes.prod_order_stage"),"attributes.prod_order_stage",DE(""))#',
			oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
			fuseaction_ : '#IIf(IsDefined("fuseaction_"),"fuseaction_",DE(""))#'
		);

--->
	<cfquery name="GET_PO_DET" dbtype="query">
		SELECT * FROM GET_PO_DET_ALL WHERE P_ORDER_ID IS NOT NULL AND (STATION_ID IS NULL) ORDER BY P_ORDER_ID DESC 
	</cfquery>
    <cfquery name="GET_PO_DET2" dbtype="query">
        SELECT
            *
        FROM
            GET_PO_DET
       	WHERE
            STATION_ID IS NOT NULL 
    </cfquery>
<cfelse>
	<cfset get_po_det.recordcount = 0>
	<cfset get_po_det2.recordcount = 0>
</cfif>

<cfparam name="attributes.totalrecords" default='#get_po_det2.recordcount#'>
<cfscript>wrkUrlStrings('url_str','status','production_stage','is_submitted','keyword','order_no','consumer_id','company_id','member_type','member_name','station_id','order_employee_id','order_employee','sales_partner_id','sales_partner','product_id','product_name','prod_order_stage','result','related_product_id','related_product_name','related_stock_id');</cfscript>
<cfif isdate(attributes.start_date)>
	<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdate(attributes.start_date_2)>
	<cfset url_str = url_str & "&start_date_2=#dateformat(attributes.start_date_2,'dd/mm/yyyy')#">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdate(attributes.finish_date_2)>
	<cfset url_str = url_str & "&finish_date_2=#dateformat(attributes.finish_date_2,'dd/mm/yyyy')#">
</cfif>
<cfif isDefined('attributes.oby') and len(attributes.oby)>
	<cfset url_str = "#url_str#&oby=#attributes.oby#">
</cfif>
<cfif isDefined('attributes.short_code_id') and len(attributes.short_code_id)>
	<cfset url_str = '#url_str#&short_code_id=#attributes.short_code_id#'>
</cfif>
<cfif isDefined('attributes.short_code_name') and len(attributes.short_code_name)>
	<cfset url_str = '#url_str#&short_code_name=#attributes.short_code_name#'>
</cfif>
<cfif len(attributes.position_code) and len(attributes.position_name)>
	<cfset url_str = "#url_str#&position_code=#attributes.position_code#&position_name=#attributes.position_name#">
</cfif>
<cfif len(attributes.product_cat_code)>
	<cfset url_str="#url_str#&product_cat_code=#attributes.product_cat_code#">
</cfif>
<cfif len(attributes.product_catid)>
	<cfset url_str="#url_str#&product_catid=#attributes.product_catid#">
</cfif>
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
	<cfset url_str = '#url_str#&project_id=#attributes.project_id#'>
</cfif>
<cfif isDefined('attributes.project_head') and len(attributes.project_head)>
	<cfset url_str = '#url_str#&project_head=#attributes.project_head#'>
</cfif>
<cfif len(attributes.product_cat)>
	<cfset url_str="#url_str#&product_cat=#attributes.product_cat#">
</cfif>
<cfif isDefined('attributes.operation_type_id') and len(attributes.operation_type_id)>
	<cfset url_str = '#url_str#&operation_type_id=#attributes.operation_type_id#'>
</cfif>
<cfif isDefined('attributes.operation_type') and len(attributes.operation_type)>
	<cfset url_str = '#url_str#&operation_type=#attributes.operation_type#'>
</cfif>
<cfif isDefined('attributes.operation_order') and len(attributes.operation_order)>
	<cfset url_str = '#url_str#&operation_order=#attributes.operation_order#'>
</cfif>
<cfif isDefined('attributes.related_orders') and len(attributes.related_orders)>
	<cfset url_str = '#url_str#&related_orders=#attributes.related_orders#'>
</cfif>

<cfquery name="GET_PRODUCT_INFOS" datasource="#DSN3#">
	SELECT 
    	USER_FRIENDLY_URL,
        PRODUCT_ID
    FROM
    	PRODUCT
</cfquery>
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
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>
<cfif fuseaction_ is 'demands'><!--- Talep --->
	<cfset print_type_ = 282>
	<cfset colspan_info = 10>
<cfelse>
	<cfset print_type_ = 281>
	<cfset colspan_info = 16>
</cfif>
<cfsavecontent variable="header_">
    <cfif fuseaction_ contains 'order'>
        <cf_get_lang no='55.Üretim Emirleri'>
    <cfelseif fuseaction_ contains 'demands'>
        <cf_get_lang_main no='115.Talepler'>
    <cfelseif fuseaction_ contains 'in_productions'>
        <cf_get_lang_main no='1400.Üretimdekiler'>
    <cfelseif fuseaction_ contains 'operations'>
        <cf_get_lang no='63.Operasyonlar'>
    </cfif>
</cfsavecontent>
<!--- Yazdırmak istediğimiz zaman fuseaction'un başına autoexcelpopuppage ifadesi eklendiği için fuseaction_ is ifadeleri fuseaction_ contains şekline dönüştürüldü.. EY 20130212 --->
<cfif isdefined("is_show_demand_no") and is_show_demand_no eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_spec_code") and is_spec_code eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_spec_name") and is_spec_name eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_process") and is_show_process eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
	<cfset colspan_info = colspan_info+2>
</cfif>
<cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_order_no") and is_show_order_no eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_detail") and is_show_detail eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_project") and is_show_project eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_temp_date") and is_show_temp_date eq 1>
	<cfset colspan_info = colspan_info+2>
</cfif>
<cfif fuseaction_ is 'operations'>
	<cfset colspan_info = colspan_info+3>
</cfif>
<cfform name="search_list" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <input type="hidden" name="is_excel" id="is_excel" value="0">
    <table style="width:100%;">
		<tr>
        	<td>
                <table align="right">
                    <tr>
                        <td>
                            <cf_get_lang_main no='48.Filtre'>
                            <cfsavecontent variable="key_title"><cf_get_lang no='133.Talep No'>, <cf_get_lang_main no='1677.Emir No'> , <cf_get_lang_main no='799.Siparis No'> ve  <cf_get_lang no ='385.Lot No'>,<cf_get_lang_main no ='1372.Referans'>,<cf_get_lang_main no='245.Ürün'> Alanlarında Arama Yapabilirsiniz!</cfsavecontent>
                            <cfinput type="text" name="keyword" id="keyword" title="#key_title#" value="#attributes.keyword#" style="width:80px;">
                        </td>
                        <td>
                           <!--- <select name="station_id" id="station_id" style="width:170px;">
                                <option value=""><cf_get_lang no='58.Tüm İstasyonlar'></option>
                                <option value="0" <cfif attributes.station_id eq 0>selected</cfif>><cf_get_lang no='131.İstasyonu Boş Olanlar'></option>
                                <cfoutput query="get_w">
                                    <option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>>#station_name#</option>
                                </cfoutput>
                            </select> --->
                            <select name="prod_order_stage" id="prod_order_stage" style="width:100px;">
                                <option value=""><cf_get_lang_main no='1447.Süreç'></option>
                                <cfoutput query="get_process_type">
                                    <option value="#process_row_id#"<cfif isdefined('attributes.prod_order_stage') and attributes.prod_order_stage eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="related_orders" id="related_orders">
                                <option value="1" <cfif attributes.related_orders eq 1>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                <option value="2" <cfif attributes.related_orders eq 2>selected</cfif>>Üst Emirler</option>
                                <option value="3" <cfif attributes.related_orders eq 3>selected</cfif>>Alt Emirler</option>
                            </select>
                        </td>
                        <td>
                            <select name="result" id="result" style="width:100px;">
                                <option value=""><cf_get_lang_main no='1854.Üretim Sonucu'></option>
                                <option value="1"<cfif attributes.result eq 1>selected</cfif>><cf_get_lang no ='587.Girilenler'></option>
                                <option value="0"<cfif attributes.result eq 0>selected</cfif>><cf_get_lang no ='586.Girilmeyenler'></option>
                            </select>
                        </td>
                        <td>
                            <select name="oby" id="oby" style="width:90px;">
                                <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no='1661.Azalan No'></option>
                                <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no='1662.Artan No'></option>
                                <option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
                                <option value="4" <cfif attributes.oby eq 4>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
                            </select>
                        </td>
                        <td>
                            <select name="status" id="status" style="width:65px;">
                                <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                <option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                                <option value="3" <cfif attributes.status eq 3>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                            </select>
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_search_button is_excel='0'>
                            <!---<cf_workcube_file_action pdf='0' mail='0' doc='1' print='1'>--->
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td>
            	<table align="right">		  
                    <tr>
                        <td align="right">
                            <cf_get_lang_main no='235.Spec'>
                            <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
                            <input type="text" name="spect_name" id="spect_name" value="<cfoutput>#attributes.spect_name#</cfoutput>" style="width:110px;">
                            <a href="javascript://" onclick="product_control();"><img src="/images/plus_thin.gif" align="absmiddle"></a>
                            <cf_get_lang_main no='245.Ürün'>
                            <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                            <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                            <input type="text" name="product_name"  id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>" style="width:110px;" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
                            <a href="javascript://" onclick="spect_remove();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_products&field_id=search_list.stock_id&product_id=search_list.product_id&field_name=search_list.product_name&keyword='+encodeURIComponent(document.getElementById('product_name').value),'list');"><img src="/images/plus_thin.gif" align="absmiddle"></a>
                            <cfif isdefined("is_show_production_station") and is_show_production_station eq 1>
                                <cfif fuseaction_ is 'order'>
                                    <select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
                                        <option value="4" style="background-color:#00CCFF;font-size:12px;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'4')>selected</cfif>><cf_get_lang no ='270.Başlamadı'></option>
                                        <option value="0" style="background-color:#FFCC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'0')>selected</cfif>><cf_get_lang no ='578.Operatöre Gönderildi'></option>
                                        <option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang no ='577.Başladı'></option>
                                        <option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang no ='580.Üretim Durdu(Arıza)'></option>
                                        <option value="2" style="background-color:#FF0000;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'2')>selected</cfif>><cf_get_lang no ='271.Bitti'></option>
                                    </select>
                                <cfelseif fuseaction_ is 'in_productions'>
                                    <select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
                                        <option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang no ='577.Başladı'></option>
                                        <option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang no ='580.Üretim Durdu(Arıza)'></option>
                                    </select>
                                </cfif>
                            </cfif>
                            <cf_get_lang_main no='641.Başlangıç Tarihi'>
                            <cfsavecontent variable="message"><cf_get_lang_main no='1449.Lütfen geçerli bir tarih giriniz!'> !</cfsavecontent>
                            <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" message="#message#" maxlength="10" validate="eurodate" style="width:80px;">
                            <cf_wrk_date_image date_field="start_date">
                            <cfinput type="text" name="start_date_2" id="start_date_2" value="#dateformat(attributes.start_date_2,'dd/mm/yyyy')#" message="#message#" maxlength="10" validate="eurodate" style="width:80px;">				
                            <cf_wrk_date_image date_field="start_date_2">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td>
                <table align="right">
                    <tr>
                        <td>
                            <cf_get_lang_main no ='74.Kategori'>
                            <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                            <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                            <cfinput type="text" name="product_cat" id="product_cat" style="width:110px;" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
                            <a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_product_cats&field_code=search_list.product_cat_code&is_sub_category=1&field_id=search_list.product_catid&field_name=search_list.product_cat','list');"><img src="/images/plus_thin.gif" title="Kategori Ekle" align="absmiddle"></a>
                            <cf_get_lang_main no='4.Proje'>
                            <cfif isdefined('attributes.project_head') and len(attributes.project_head)>
                                <cfset project_id_ = #attributes.project_id#>
                            <cfelse>
                                <cfset project_id_ = ''>
                            </cfif>
                            <cf_wrkProject
                                project_Id="#project_id_#"
                                width="110"
                                AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
                                boxwidth="600"
                                boxheight="400">
                            <cf_get_lang_main no='288.Bitiş Tarihi'>
                            <cfsavecontent variable="message"><cf_get_lang_main no='1449.Lütfen geçerli bir tarih giriniz!'></cfsavecontent>
                            <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" maxlength="10" message="#message#"  validate="eurodate" style="width:80px;">
                            <cf_wrk_date_image date_field="finish_date">
                            <cfinput type="text" name="finish_date_2" id="finish_date_2" value="#dateformat(attributes.finish_date_2,'dd/mm/yyyy')#" maxlength="10" message="#message#" validate="eurodate" style="width:80px;">				
                            <cf_wrk_date_image date_field="finish_date_2">
                            <cfif fuseaction_ is 'operations'>
                                <cf_get_lang no='63.Operasyonlar'>
                                <input type="hidden" name="operation_type_id" id="operation_type_id" value="<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)><cfoutput>#attributes.operation_type_id#</cfoutput></cfif>" />
                                <input type="text" name="operation_type" id="operation_type" style="width:90px;" value="<cfif isdefined("attributes.operation_type") and len(attributes.operation_type) and len(attributes.operation_type_id)><cfoutput>#attributes.operation_type#</cfoutput></cfif>" />
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_operation_type&field_id=search_list.operation_type_id&field_name=search_list.operation_type&is_submitted=1&keyword='+encodeURIComponent(document.search_list.operation_type.value),'list');"><img src="/images/plus_thin.gif"></a>
                                <select name="operation_order" id="operation_order" style="width:105px;">
                                    <option value="1" <cfif attributes.operation_order eq 1>selected</cfif>>Sıradaki Operasyon</option>
                                    <option value="2" <cfif attributes.operation_order eq 2>selected</cfif>>Tümü</option>							
                                </select>
                            </cfif>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>
<table style="width:100%;">
	<thead>
		<tr class="color-header" style="height:22px;">
			<th class="form-title"><cf_get_lang_main no='1677.Emir No'></th>
			<cfif isdefined("is_show_demand_no") and is_show_demand_no eq 1>
				<th class="form-title"><cf_get_lang no='133.Talep No'></th>
			</cfif>
            <th class="form-title"><cf_get_lang_main no='799.Siparis No'></th>
            <th class="form-title">Lot No</th>
			<th class="form-title"><cf_get_lang_main no ='106.Stok Kod'></th>
			<th class="form-title"><cf_get_lang_main no='245.Ürün'></th>
			<cfif isdefined("is_show_detail") and is_show_detail eq 1>
				<th class="form-title"><cf_get_lang_main no='217.Açıklama'></th>
			</cfif>
			<cfif isdefined("is_show_project") and is_show_project eq 1>
				<th class="form-title"><cf_get_lang_main no='4.Proje'></th>
			</cfif>
			<cfif isdefined("is_spec_code") and is_spec_code eq 1>
				<th class="form-title" nowrap="nowrap"><a style="cursor:pointer;" ><cf_get_lang_main no='235.Spec'> Id</a></th>
			</cfif>
			<cfif isdefined("is_spec_name") and is_spec_name eq 1>
				<th class="form-title"><a style="cursor:pointer;" ><cf_get_lang_main no='235.Spec'></a></th>
			</cfif>
			<th class="form-title"><cf_get_lang_main no='1422.İstasyon'></th> 
            <th class="form-title"><cf_get_lang_main no='1447.Süreç'></th>
            <th class="form-title" <cfif ((fuseaction_ is 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ is 'order' and attributes.result eq 0))>style="text-align:left;width:100px;"<cfelse>style="text-align:left;width:80px;"</cfif>>
                Hedef Başlangıç
                <cfif ((fuseaction_ is 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ is 'order' and attributes.result eq 0))><br/>
                    <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz'> !</cfsavecontent>
                    <input type="text" name="temp_date" id="temp_date" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" style="width:70px;" class="box" onblur="change_date_info(1);" validate="eurodate" message="#message#">
                    <cfsavecontent variable="message"><cf_get_lang_main no='1369.Lütfen Saat Giriniz'> !</cfsavecontent>
                    <input type="text" name="temp_hour" id="temp_hour" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(1);" validate="integer" message="#message#">
                    <input type="text" name="temp_min" id="temp_min" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(1);" validate="integer" message="#message#">
                </cfif>
            </th>
            <th class="form-title" <cfif ((fuseaction_ is 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ is 'order' and attributes.result eq 0))>style="text-align:left;width:100px;"<cfelse>style="text-align:left;width:80px;"</cfif>>
                Hedef Bitiş
                <cfif ((fuseaction_ is 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ is 'order' and attributes.result eq 0))><br/>
                    <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz'> !</cfsavecontent>
                    <input type="text" name="temp_date_2" id="temp_date_2" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" style="width:70px;" class="box" onblur="change_date_info(2);" validate="eurodate" message="#message#">
                    <cfsavecontent variable="message"><cf_get_lang_main no='1369.Lütfen Saat Giriniz'> !</cfsavecontent>
                    <input type="text" name="temp_hour_2" id="temp_hour_2" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(2);" validate="integer" message="#message#">
                    <input type="text" name="temp_min_2" id="temp_min_2" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(2);" validate="integer" message="#message#">
                </cfif>
            </th>
            <th class="form-title" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
			<th class="form-title"><cf_get_lang_main no='224.Birim'></th>
			<!-- sil -->
			<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                 <th></th>
                 <th></th>
                 <th></th>
			</cfif>
            <!-- sil -->
		</tr>
	</thead>
	<tbody class="color-row">
		<cfif len(attributes.is_submitted)>
			<cfif get_po_det2.recordcount>
				<cfset prod_order_stage_list = ''>
				<cfset stock_id_list =''>
				<cfset p_order_id_list =''>
				<cfset operation_type_id_list =''>
				<cfset action_employee_id_list =''>
				<cfset project_id_list =''>
				<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows=get_po_det2.recordcount>
				</cfif>
				<cfoutput query="get_po_det2" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(p_order_id) and not listfind(p_order_id_list,p_order_id)>
						<cfset p_order_id_list=listappend(p_order_id_list,p_order_id)>
					</cfif>
					<cfif len(prod_order_stage) and not listfind(prod_order_stage_list,prod_order_stage)>
						<cfset prod_order_stage_list=listappend(prod_order_stage_list,prod_order_stage)>
					</cfif>
					<cfif fuseaction_ is 'demands'>
						<cfif len(stock_id) and not listfind(stock_id_list,stock_id)>
							<cfset stock_id_list=listappend(stock_id_list,stock_id)>
						</cfif>
					</cfif>
					<cfif fuseaction_ is 'operations'>
						<cfif len(operation_type_id) and not listfind(operation_type_id_list,operation_type_id)>
							<cfset operation_type_id_list=listappend(operation_type_id_list,operation_type_id)>
						</cfif>
						<cfif attributes.result eq 1>
							<cfif len(action_employee_id) and not listfind(action_employee_id_list,action_employee_id)>
								<cfset action_employee_id_list=listappend(action_employee_id_list,action_employee_id)>
							</cfif>
						</cfif>
					</cfif>
					<cfif len(project_id) and not listfind(project_id_list,project_id)>
						<cfset project_id_list=listappend(project_id_list,project_id)>
					</cfif>
				</cfoutput>
				<cfquery name="GET_ROW" datasource="#DSN3#">
					SELECT
						ORDER_NUMBER,
						PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
					FROM
						PRODUCTION_ORDERS_ROW,
						ORDERS
					WHERE
						PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID IN(#p_order_id_list#) AND
						PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID 
				</cfquery>
				<cfloop query="get_row">
					<cfif not isdefined('order_list_#p_order_id#')>
						<cfset 'order_list_#p_order_id#' = order_number>
					<cfelse>
						<cfset 'order_list_#p_order_id#' = listdeleteduplicates(ListAppend(Evaluate('order_list_#p_order_id#'),order_number,','))>
					</cfif>
				</cfloop>
				<cfif len(stock_id_list) and  fuseaction_ is 'demands'>
					<cfquery name="GET_STOCK_STATIONS" datasource="#DSN3#">
						SELECT
							WP.STOCK_ID,
							0 AS MAIN_STOCK_ID ,
							W.STATION_ID AS STATION_ID_ ,
							W.STATION_NAME,
							WP.OPERATION_TYPE_ID,
							ISNULL(WP.PRODUCTION_TIME,0) P_TIME
						FROM 
							WORKSTATIONS W,
							WORKSTATIONS_PRODUCTS WP
						WHERE
							W.STATION_ID = WP.WS_ID 
							AND WP.STOCK_ID IN (#stock_id_list#)
							AND WP.MAIN_STOCK_ID IS NULL
					UNION ALL
						SELECT
							WP.STOCK_ID,
							WP.MAIN_STOCK_ID,
							W.STATION_ID AS STATION_ID_ ,
							W.STATION_NAME,
							WP.OPERATION_TYPE_ID,
							ISNULL(WP.PRODUCTION_TIME,0) P_TIME
						FROM 
							WORKSTATIONS W,
							WORKSTATIONS_PRODUCTS WP
						WHERE
							W.STATION_ID = WP.WS_ID 
							AND WP.MAIN_STOCK_ID IN (#stock_id_list#)
					</cfquery>
					<cfloop query="get_stock_stations">
						<cfif not isdefined('stock_defined_stations_list_#stock_id#')>
							<cfset 'stock_defined_stations_list_#stock_id#' = station_id_>
						<cfelse>
							<cfset 'stock_defined_stations_list_#stock_id#' = listdeleteduplicates(ListAppend(Evaluate('stock_defined_stations_list_#stock_id#'),station_id_,','))>
						</cfif>
					</cfloop>
				</cfif>
				<cfif len(prod_order_stage_list)>
					<cfset prod_order_stage_list=listsort(prod_order_stage_list,"numeric","ASC",",")>
					<cfquery name="PROCESS_TYPE" datasource="#DSN#">
						SELECT
							STAGE,
							PROCESS_ROW_ID
						FROM
							PROCESS_TYPE_ROWS
						WHERE
							PROCESS_ROW_ID IN(#prod_order_stage_list#)
						ORDER BY
							PROCESS_ROW_ID
					</cfquery>
				</cfif>
				<cfif fuseaction_ is 'operations'>
					<cfif len(operation_type_id_list)>
						<cfset operation_type_id_list=listsort(operation_type_id_list,"numeric","ASC",",")>
						<cfquery name="GET_OPERATION_TYPE" datasource="#DSN3#">
							SELECT
								OPERATION_TYPE,
								OPERATION_TYPE_ID
							FROM
								OPERATION_TYPES
							WHERE
								OPERATION_TYPE_ID IN(#operation_type_id_list#)
							ORDER BY
								OPERATION_TYPE_ID
						</cfquery>
					</cfif>
					<cfif attributes.result eq 1>
						<cfif len(action_employee_id_list)>
							<cfset action_employee_id_list=listsort(action_employee_id_list,"numeric","ASC",",")>
							<cfquery name="GET_ACTION_EMPLOYEE" datasource="#DSN#">
								SELECT 
									EMPLOYEE_ID,
									EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME ACTION_EMPLOYEE 
								FROM 
									EMPLOYEES 
								WHERE 
									EMPLOYEE_ID IN (#action_employee_id_list#) 
								ORDER BY 
									EMPLOYEE_ID
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				<cfif len(project_id_list)>
					<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
					<cfquery name="get_project" datasource="#DSN#">
						SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN(#project_id_list#) ORDER BY PROJECT_ID
					</cfquery>
					<cfset project_id_list = listsort(valuelist(get_project.project_id),"numeric","asc",",")>
				</cfif>
				<form name="go_p_order_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order">
					<input type="hidden" name="keyword" id="keyword" value=""><!--- Üretim Emirlerin Listesine Giderken Doldurulur.. --->
					<input type="hidden" name="production_order_no" id="production_order_no" value=""><!--- Üretim Malzeme İhtiyaçlarına Giderken doldurulur.. --->
					<input type="hidden" name="is_submitted" value="1">
					<input type="hidden" name="start_date" value="">
					<input type="hidden" name="finish_date" value="">
					<input type="hidden" name="row_demand_all" value="<cfoutput query="get_po_det2">#p_order_id#<cfif currentrow neq recordcount>,</cfif></cfoutput>">
				</form>
				<form name="convert_demand_to_production" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.emptypopup_convert_demand_to_production">
					<input type="hidden" name="is_upd_related_demands" value="<cfif isdefined("is_upd_related_demands")><cfoutput>#is_upd_related_demands#</cfoutput><cfelse>0</cfif>"><!--- İlişkili taleplerin güncellenip güncellenmeyeceğini tutuyor arka sayfada kullanılıyor --->
					<cfif fuseaction_ is 'operations'>
						<input type="hidden" name="operation_id_list" id="operation_id_list" value="">
						<input type="hidden" name="employee_id_list" id="employee_id_list" value="">
						<input type="hidden" name="p_order_id_list" id="p_order_id_list" value="">
						<input type="hidden" name="amount_list" id="amount_list" value="">
						<input type="hidden" name="station_id_list" id="station_id_list" value="">
						<input type="hidden" name="operation_result_id_list" id="operation_result_id_list" value="">
						<cfif attributes.result eq 1>
							<input type="hidden" name="result" id="result" value="1">
						<cfelse>
							<input type="hidden" name="result" id="result" value="0">
						</cfif>
					</cfif>
					<cfoutput query="get_po_det2" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr style="height:20px;">
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<td><a href="#request.self#?fuseaction=objects2.detail_prod_order&upd=#p_order_id#" class="tableyazi">#p_order_no#</a></td>
							<cfelse>
								<td>#p_order_no#</td>
							</cfif>
                            <td><cfif isdefined("order_list_#p_order_id#")>#evaluate("order_list_#p_order_id#")#</cfif></td>
                            <td nowrap>#lot_no#</td>
							<td>#stock_code#</td>
                            <cfquery name="GET_PRODUCT_INFO" dbtype="query">
                            	SELECT
                                	*
                                FROM
                                	GET_PRODUCT_INFOS
                                WHERE
                                	PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                            </cfquery>
							<td>
								<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
									<a href="#request.self#?fuseaction=objects2.detail_product&stock_id=#stock_id#" class="tableyazi">
										#product_name# #property#
								  </a>
								<cfelse>
									<cfif get_product_info.recordcount and len(get_product_info.user_friendly_url)>
                                        <a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#get_product_info.user_friendly_url#')#">#product_name# #property#</a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&sid=#stock_id#">#product_name# #property#</a>                                
                                    </cfif>
								</cfif>
							</td>
							<cfif isdefined("is_show_detail") and is_show_detail eq 1>
								<td>#detail#</td>
							</cfif>
							<cfset _station_id_ = station_id>
							<td>
								<cfif len(_station_id_)>
									#get_station_prod(station_id)#
							  </cfif>
							</td>
							<cfif ((fuseaction_ is 'demands' and is_show_process eq 1) or (fuseaction_ is not 'demands')) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<td id="td_process_#p_order_id#"><cfif len(prod_order_stage)>#process_type.stage[listfind(prod_order_stage_list,prod_order_stage,',')]#</cfif></td>
							<cfelseif ((fuseaction_ is 'demands' and is_show_process eq 1) or (fuseaction_ is not 'demands')) and (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<td><cfif len(prod_order_stage)>#process_type.stage[listfind(prod_order_stage_list,prod_order_stage,',')]#</cfif></td>
							</cfif>
							<cfif (fuseaction_ is 'demands' or (fuseaction_ is 'order' and attributes.result eq 0)) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<!-- sil -->
                                <td nowrap>
                                    <input maxlength="10" type="text" id="production_start_date_#p_order_id#" name="production_start_date_#p_order_id#"  validate="eurodate" style="width:65px;" value="#dateformat(start_date,'dd/mm/yyyy')#">
                                    <cf_wrk_date_image date_field="production_start_date_#p_order_id#">
                                    <select name="production_start_h_#p_order_id#" id="production_start_h_#p_order_id#">
                                        <cfloop from="0" to="23" index="i">
                                            <option value="#i#" <cfif TimeFormat(start_date,'HH') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                    <select name="production_start_m_#p_order_id#" id="production_start_m_#p_order_id#">
                                        <cfloop from="0" to="59" index="i">
                                            <option value="#i#" <cfif TimeFormat(start_date,'MM') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td nowrap>
                                    <input maxlength="10" type="text" name="production_finish_date_#p_order_id#" id="production_finish_date_#p_order_id#" validate="eurodate" style="width:65px;" value="#dateformat(finish_date,'dd/mm/yyyy')#">
                                    <cf_wrk_date_image date_field="production_finish_date_#p_order_id#">
                                    <select name="production_finish_h_#p_order_id#" id="production_finish_h_#p_order_id#">
                                        <cfloop from="0" to="23" index="i">
                                            <option value="#i#" <cfif TimeFormat(finish_date,'HH') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                    <select name="production_finish_m_#p_order_id#" id="production_finish_m_#p_order_id#">
                                        <cfloop from="0" to="59" index="i">
                                            <option value="#i#" <cfif TimeFormat(finish_date,'MM') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                </td>
								<td>
									<input type="hidden" name="old_quantity_#p_order_id#" value="#quantity#">
									<input type="text" style="width:65px;" name="quantity_#p_order_id#" value="#tlformat(quantity,3)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,3));">
								</td>
								<!-- sil -->
								<cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
									<td align="right" style="text-align:right;">#row_result_amount#</td>
									<td align="right" style="text-align:right;">#quantity-row_result_amount#</td>
								</cfif>
							<cfelse>
								<td>#dateformat(start_date,'dd/mm/yyyy')# #TimeFormat(start_date,'HH')#:#TimeFormat(start_date,'MM')#</td>
								<td>#dateformat(finish_date,'dd/mm/yyyy')# #TimeFormat(finish_date,'HH')#:#TimeFormat(finish_date,'MM')#</td>
								<td align="right" style="text-align:right;">#TlFormat(quantity,0)#</td>
								<cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
                                    <td align="right" style="text-align:right;">#row_result_amount#</td>
                                    <td align="right" style="text-align:right;">#quantity-row_result_amount#</td>
								</cfif>
							</cfif>
							<td>#main_unit#</td>
							<!-- sil -->
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<cfif fuseaction_ neq 'demands'>
								<td>
									<cfif is_stage eq 4>
										<cfif is_group_lot eq 1>
											 <img src="/images/g_blue_glob.gif" title="Gruplandı Fakat Operatöre Gönderilmedi">
										<cfelse>
											 <img src="/images/blue_glob.gif" title="Başlamadı">
										</cfif>       
									<cfelseif is_stage eq 0>
										<img src="/images/yellow_glob.gif" title="Operatöre Gönderildi">
									<cfelseif is_stage eq 1>
										<img src="/images/green_glob.gif" title="Başladı">
									<cfelseif is_stage eq 2>
										<img src="/images/red_glob.gif" title="Bitti">
									<cfelseif is_stage eq 3>
										<img src="/images/grey_glob.gif" title="Başlamadı">
									</cfif>
								</td>
							</cfif>
							<td align="center">
                            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_print_files&print_type=#print_type_#&action_id=#p_order_id#&date1=#DateFormat(attributes.start_date,"dd/mm/yyyy")#&date2=#DateFormat(attributes.finish_date,"dd/mm/yyyy")#&iid=#attributes.station_id#&iiid=<cfif len(attributes.product_cat)>#attributes.product_cat_code#</cfif><cfif len(attributes.result)>&keyword=#attributes.result#</cfif>&action_row_id=#attributes.production_stage#','page');"><img src="../images/print2.gif"></a>
                            </td>
							<td style="text-align:center;"><a href="#request.self#?fuseaction=objects2.detail_prod_order&upd=#p_order_id#"> <img src="/images/update_list.gif" title="<cf_get_lang no='123.Üretim Emri Düzenle'>"></a></td>
							<!---<input type="checkbox" name="row_demand" id="row_demand" value="#P_ORDER_ID#;#CURRENTROW#"></td>--->
							<!-- sil -->
							</cfif>
						</tr>
						<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
						<tr id="order_stocks_detail#currentrow#" class="nohover" style="display:none" >
							<td colspan="#colspan_info#">
								<div align="left" id="display_order_stock_info#currentrow#" style="border:none;"></div>
							</td>
						</tr>
						</cfif>
					</cfoutput>
				<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
			</tbody>
				<!-- sil -->
		  <!--- <tfoot>
				<tr height="40" class="nohover">
					<td colspan="<cfoutput>#colspan_info#</cfoutput>" align="right" style="text-align:right;">
						<input type="button" value="<cf_get_lang_main no ='446.Excel Getir'>" name="excelll" onClick="convert_to_excel();">
						<cfif fuseaction_ is not 'operations'>
							<input type="button" value="<cf_get_lang no ='502.Grupla'>" onClick="demand_convert_to_production(2);">
							<input type="button" value="<cf_get_lang no ='210.Malzeme İhtiyaç Listesi'>" onClick="demand_convert_to_production(3);">
							<input type="button" id="tumune_ihtiyac_button" value="<cf_get_lang no ='211.Tümüne Malzeme İhtiyaç Listesi'>" onClick="demand_convert_to_production(4);">
							<cfif (fuseaction_ is 'demands' or (fuseaction_ is 'order' and attributes.result eq 0)) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'>
							</cfif>
							<cfif fuseaction_ is 'order' and attributes.result eq 0 and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<input type="button" value="<cf_get_lang no='682.Seçili Emirleri Güncelle'>"  onClick="demand_convert_to_production(5);">
							</cfif>
							<cfif fuseaction_ is 'demands'>
								<input type="button" name="updDemandValues_" value="<cf_get_lang no ='217.Seçili Talepleri Güncelle'>" onClick="demand_convert_to_production(1);">
								<input type="button" name="delDemandValues_" value="<cf_get_lang no ='683.Seçili Talepleri Sil'>" onClick="demand_convert_to_production(6);">
								<input type="button" name="convert_to_production_" value="<cf_get_lang no ='334.Üretime Çevir'>" onClick="demand_convert_to_production(0);">
							</cfif>
						</cfif>
						<cfif fuseaction_ is 'operations' and attributes.result eq 0>
							<input type="button" name="convert_to_production_" value="Seçili Operasyonları Sonlandır" onClick="demand_convert_to_production(7);">
						<cfelseif fuseaction_ is 'operations' and attributes.result eq 1>
							<input type="button" name="convert_to_production_" value="Seçili Operasyonları Güncelle" onClick="demand_convert_to_production(7);">
						</cfif>
						<input type="hidden" name="process_type" id="process_type" value=""><!--- process type query sayfasında 0 ise talepler üretime çevirili 1 ise sadece bilgileri güncellenir.. --->
						<input type="hidden" name="p_order_id_list" id="p_order_id_list" value="">
						<div id="user_message_demand"></div>
					</td>
				</tr>
				<!-- sil -->
			</tfoot> --->
			<tbody>
				</cfif>
				</form>
				<script type="text/javascript">
					function demand_convert_to_production(type)
						{
							if(type==4)// type 4 ise
							 {
								document.getElementById("tumune_ihtiyac_button").value="<cfoutput>#getLang('main',293)#</cfoutput>";
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
													user_message='<cf_get_lang no ="251.Malzeme İhtiyaç Listesine Yönlendiriliyorsunuz Lütfen Bekleyiniz">!';
												else if(type==1)
												{
													var selected_process_ = document.convert_demand_to_production.process_stage.value;
													if(selected_process_=='')
													{
														alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='1447.Süreç'>");
														return false;
													}
													user_message='<cf_get_lang no ="264.Talepler Güncelleniyor Lütfen Bekleyiniz">!';
												}
												else if(type==5)
												{
													var selected_process_ = document.convert_demand_to_production.process_stage.value;
													if(selected_process_=='')
													{
														alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='1447.Süreç'>");
														return false;
													}
													user_message='<cf_get_lang no="678.Emirler Güncelleniyor Lütfen Bekleyiniz"> !';
												}
												else if(type==6)
												{
													var selected_process_ = document.convert_demand_to_production.process_stage.value;
													if(selected_process_=='')
													{
														alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='1447.Süreç'>");
														return false;
													}
													user_message='<cf_get_lang no="679.Talepler Siliniyor Lütfen Bekleyiniz"> !';
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
															alert(crtrow +'. Satırda İstasyon Eksik. Lütfen İstasyon Seçiniz.');
															return false;
														}
														if(document.getElementById('operation_amount_'+crtrow).value == '')
														{
															alert(crtrow +'. Satırda Miktar Eksik. Lütfen Miktar Seçiniz.');
															return false;
														}
														if(document.getElementById('operation_amount_'+crtrow).value > document.getElementById('operation_amount__'+crtrow).value)
														{
															alert(crtrow +'. Satırda Operasyon Miktarı Kalan Miktardan Fazla.');
															return false;
														}
														if(document.getElementById('employee_id_'+crtrow).value == '')
														{
															alert(crtrow +'. Satırda İşlemi Yapan Eksik. Lütfen İşlemi Yapanı Seçiniz.');
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
													user_message='<cf_get_lang no ="265.Talepler Üretime Çeviriliyor Lütfen Bekleyiniz">!';
													
												document.getElementById('process_type').value=type;
												windowopen('','small','p_action_window');
												convert_demand_to_production.target = 'p_action_window';
												convert_demand_to_production.submit();
												//AjaxFormSubmit(convert_demand_to_production,'user_message_demand',1,user_message,'<cf_get_lang_main no ="1374.Tamamlandı">!','','',1);
											}
											
										}
									}
									else{
										if(type==0)
											alert("<cf_get_lang no ='266.Üretime Göndermek İçin Talep Seçiniz'>");
										else if(type==1)
											alert("<cf_get_lang no ='267.Güncellenecek Talepleri Seçiniz'>!");
										else if(type==5)
											alert("<cf_get_lang no='680.Güncellenecek Emirleri Seçiniz'>!");
										else if(type==6)
											alert("<cf_get_lang no='681.Silinecek Talepleri Seçiniz'>!");
										else if(type==2)
											alert("<cf_get_lang no ='268.Gruplanacak Satırları Seçiniz'>!");
										else if(type==3)
											alert("<cf_get_lang no ='269.Malzeme İhtiyaçları İçin Talep Seçiniz'>!");
										else if(type==7)
											alert("Sonlandırılacak Operasyonları Seçiniz!");
										return false;
									}
								}
						}// type 4 degilse	
					}	
				</script>
			<cfelse>
				<tr>
					<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		<cfelse>
			<tr>
				<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang_main no ='289.Filtre Ediniz'> !</td>
			</tr>
		</cfif>
	</tbody>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<!-- sil -->
	<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%; height:35px;">
		<tr>
			<td>
				<cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#get_po_det2.recordcount#" 
					startrow="#attributes.startrow#" 
					adres="#attributes.fuseaction##url_str#">
			</td>
			<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
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
document.getElementById('keyword').focus();
 <cfif (fuseaction_ is 'demands' or  fuseaction_ is 'order') and is_show_multi_print eq 1>
	function send_services_print()
	{	
	<cfif len(attributes.is_submitted)>
			<cfif not get_po_det2.recordcount>
				alert("<cf_get_lang no ='273.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
				return false;
			</cfif>
			<cfif get_po_det2.recordcount eq 1>
				if(document.convert_demand_to_production.row_demand.checked == false)
				{
					alert("<cf_get_lang no ='273.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
					return false;
				}
				else
					service_list_ = list_getat(document.convert_demand_to_production.row_demand.value,1,';');
			</cfif>
			<cfif get_po_det2.recordcount gt 1>
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
					alert("<cf_get_lang no ='273.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
					return false;
				}
			</cfif>
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=#print_type_#</cfoutput>&iid='+service_list_,'page');
		<cfelse>
			alert("<cf_get_lang no ='273.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
			return false;
		</cfif>
	}
</cfif>
	function pencere_ac_employee(no)
	{
		//row_id_ = p_order_id+'_'+stock_id+'_'+no;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=convert_demand_to_production.employee_id_' + no +'&field_name=convert_demand_to_production.employee_name_' + no +'&select_list=1,9','list');
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
	function change_date_info(type)
	{
		if(type == 1)//hedef başlangıç
		{
			if(document.getElementById('temp_hour').value == '' || document.getElementById('temp_hour').value > 23)
				document.getElementById('temp_hour').value = '00';
			if(document.getElementById('temp_min').value == '' || document.getElementById('temp_min').value > 59)
				document.getElementById('temp_min').value = '00';
			if(document.getElementById('temp_date').value!= '')
				for (i=0;i<document.getElementsByName('row_demand').length;i++)
				{
					new_row_number = parseInt(<cfoutput>#attributes.startrow#</cfoutput>+i);
					new_id = list_getat(document.convert_demand_to_production.row_demand[new_row_number-1].value,1,';');
					document.getElementById('production_start_date_'+new_id).value = document.getElementById('temp_date').value;
					document.getElementById('production_start_h_'+new_id).value = parseFloat(document.getElementById('temp_hour').value);
					document.getElementById('production_start_m_'+new_id).value = parseFloat(document.getElementById('temp_min').value);
				}
		}
		else//hedef bitiş
		{
			if(document.getElementById('temp_hour_2').value == '' || document.getElementById('temp_hour_2').value > 23)
				document.getElementById('temp_hour_2').value = '00';
			if(document.getElementById('temp_min_2').value == '' || document.getElementById('temp_min_2').value > 59)
				document.getElementById('temp_min_2').value = '00';
			if(document.getElementById('temp_date_2').value!= '')
				for (i=0;i<document.getElementsByName('row_demand').length;i++)
				{
					new_row_number = parseInt(<cfoutput>#attributes.startrow#</cfoutput>+i);
					new_id = list_getat(document.convert_demand_to_production.row_demand[new_row_number-1].value,1,';');
					document.getElementById('production_finish_date_'+new_id).value = document.getElementById('temp_date_2').value;
					document.getElementById('production_finish_h_'+new_id).value = parseFloat(document.getElementById('temp_hour_2').value);
					document.getElementById('production_finish_m_'+new_id).value = parseFloat(document.getElementById('temp_min_2').value);
				}
		}
	}
	function product_control()/*Ürün seçmeden spect seçemesin.*/
	{
		if(document.search_list.stock_id.value=="" || document.search_list.product_name.value=="" )
		{
		alert("Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir");
		return false;
		}
		else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_spect_main&field_main_id=search_list.spect_main_id&field_name=search_list.spect_name&is_display=1&stock_id='+document.search_list.stock_id.value,'list');
	}
	function spect_remove()/*Eğer ürün seçildikten sonra spect seçilmişse yeniden ürün seçerse ilgili spect'i kaldır.*/
	{
		document.search_list.spect_main_id.value = "";
		document.search_list.spect_name.value = "";	
	}
	function connectAjax(crtrow,prod_id,stock_id,order_amount,spect_main_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&deep_level_max=1&tree_stock_status=1</cfoutput>&pid='+prod_id+'&sid='+ stock_id+'&amount='+order_amount+'&spect_main_id='+spect_main_id;
		AjaxPageLoad(bb,'display_order_stock_info'+crtrow,1);
	}
</script>
