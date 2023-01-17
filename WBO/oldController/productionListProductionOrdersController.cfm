<cf_get_lang_set module_name="production">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact="production.list_production_orders">
    <cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
    <cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
    <cfparam name="authority_station_id_list" default="0">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.p_order_no" default="">
    <cfparam name="attributes.order_number" default="">
    <cfparam name="attributes.serial_no" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
	<cfparam name="attributes.station_id" default="">
    <cfparam name="attributes.product_code_2" default="">
    <cfparam name="attributes.order_type" default="">
    <cfparam name="attributes.spect" default="">
    <cfif len(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    </cfif>
    <cfquery name="GET_W" datasource="#dsn#">
        SELECT 
            STATION_ID,
            STATION_NAME
        FROM 
            #dsn3_alias#.WORKSTATIONS W
        WHERE 
            W.ACTIVE = 1 AND
            W.EMP_ID LIKE '%,#session.ep.userid#,%' AND
            DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
        ORDER BY 
            STATION_NAME
    </cfquery>
    <cfset authority_station_id_list = ValueList(get_w.station_id,',')>
    <cfif isdefined("attributes.is_form_submitted")>
        <cfscript>
            get_production_orders_action = createObject("component", "production.cfc.get_production_orders");
            get_production_orders_action.dsn3 = dsn3;
            get_production_orders_action.dsn_alias = dsn_alias;
            GET_PO = get_production_orders_action.get_production_orders_fnc(
                keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                p_order_no : '#IIf(IsDefined("attributes.p_order_no"),"attributes.p_order_no",DE(""))#',
                order_number : '#IIf(IsDefined("attributes.order_number"),"attributes.order_number",DE(""))#',
                order_number : '#IIf(IsDefined("attributes.order_number"),"attributes.order_number",DE(""))#',
                serial_no : '#IIf(IsDefined("attributes.serial_no"),"attributes.serial_no",DE(""))#',
                station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
                production_stage : '#IIf(IsDefined("attributes.production_stage"),"attributes.production_stage",DE(""))#',
                product_code_2 : '#IIf(IsDefined("attributes.product_code_2"),"attributes.product_code_2",DE(""))#',
                spect : '#IIf(IsDefined("attributes.spect"),"attributes.spect",DE(""))#',
                xml_show_related_p_order_state : '#IIf(IsDefined("xml_show_related_p_order_state") and xml_show_related_p_order_state eq 1,1,DE(0))#'
            );
            GET_PO_DET = get_production_orders_action.get_production_orders_fnc2(
                authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
                start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                nullstation : '#IIf(IsDefined("nullstation") and nullstation eq 1,1,DE(0))#',
                order_type : '#IIf(IsDefined("attributes.order_type"),"attributes.order_type",DE(""))#',
                xml_show_related_p_order_state : '#IIf(IsDefined("xml_show_related_p_order_state") and xml_show_related_p_order_state eq 1,1,DE(0))#'
            );
        </cfscript>
    <cfelse>
        <cfset GET_PO_DET.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif get_po_det.recordcount>
        <cfparam name="attributes.totalrecords" default='#get_po_det.recordcount#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
    <cfscript>wrkUrlStrings('url_str','is_form_submitted','keyword');</cfscript>
    <cfif isdate(attributes.start_date)>
        <cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.finish_date)>
        <cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
    </cfif>
    <cfif len(attributes.order_type)>
        <cfset url_str = url_str & "&order_type=#attributes.order_type#">
    </cfif>
    <cfif len(attributes.p_order_no)>
        <cfset url_str = url_str & "&p_order_no=#attributes.p_order_no#">
    </cfif>
    <cfif len(attributes.order_number)>
        <cfset url_str = url_str & "&order_number=#attributes.order_number#">
    </cfif>
    <cfif len(attributes.serial_no)>
        <cfset url_str = url_str & "&serial_no=#attributes.serial_no#">
    </cfif>
    <cfif len(attributes.product_code_2)>
        <cfset url_str = url_str & "&product_code_2=#attributes.product_code_2#">
    </cfif>
    <cfif len(attributes.station_id)>
        <cfset url_str = url_str & "&station_id=#attributes.station_id#">
    </cfif>
    <cfif isdefined("attributes.production_stage") and len(attributes.production_stage)>
        <cfset url_str = url_str & "&production_stage=#attributes.production_stage#">
    </cfif>
    <style>
        .box_yazi {font-size:16px;border-color:#666666;font:bold} 
        .box_yazi_td {font-size:14px;border-color:#666666;} 
    </style>
<cfelseif (isdefined("attributes.event") and attributes.event is 'gosteruemri')> 
    <cfquery name="get_order_list" datasource="#dsn3#">
        SELECT DISTINCT
            POO.P_ORDER_ID,
            PO.P_ORDER_NO,
            S.PRODUCT_NAME
        FROM
            PRODUCTION_ORDERS PO,
            STOCKS S,
            PRODUCTION_ORDER_OPERATIONS POO
        WHERE
            PO.P_ORDER_ID = POO.P_ORDER_ID AND
            POO.RECORD_EMP = #session.ep.userid# AND
            S.STOCK_ID = PO.STOCK_ID AND
            PO.P_ORDER_ID NOT IN (
                                    SELECT 
                                        POR.P_ORDER_ID
                                    FROM 
                                        PRODUCTION_ORDER_RESULTS POR,
                                        PRODUCTION_ORDER_RESULTS_ROW PORR
                                    WHERE
                                        POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
                                        POR.P_ORDER_ID = PO.P_ORDER_ID AND
                                        PORR.TYPE = 1 AND
                                        PORR.STOCK_ID = PO.STOCK_ID
                                    GROUP BY
                                        POR.P_ORDER_ID
                                    HAVING
                                        SUM(PORR.AMOUNT) = PO.QUANTITY
                            ) AND
            POO.WRK_ROW_ID NOT IN (SELECT WRK_ROW_ID FROM PRODUCTION_ORDER_OPERATIONS WHERE TYPE = 2) AND
            POO.TYPE <> 2
    </cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')> 
<!--- Üretim Sonucu Oluşturma --->
    <cf_xml_page_edit fuseact="production.form_add_production_order">
    <cfif not isnumeric(attributes.upd)>
        <cfset hata  = 10>
        <cfinclude template="../dsp_hata.cfm">
    </cfif>
    <cfquery name="get_order" datasource="#dsn3#">
        SELECT 
            PO.P_ORDER_ID,
            PO.P_ORDER_NO,
            PO.STATION_ID,
            PO.FINISH_DATE,
            PO.IS_DEMONTAJ,
            S.PRODUCT_NAME,
            S.STOCK_ID,
            PO.SPECT_VAR_NAME,
            PO.QUANTITY,
            PO.SPECT_VAR_ID,
            PO.SPEC_MAIN_ID,
            PO.PO_RELATED_ID,
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
            (SELECT TOP 1 MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID) AS MAIN_UNIT,
            (SELECT TOP 1 PRODUCT_CATID FROM #dsn1_alias#.PRODUCT PRODUCT WHERE PRODUCT.PRODUCT_ID = S.PRODUCT_ID) PRODUCT_CATID
        FROM 
            PRODUCTION_ORDERS PO,
            STOCKS S
        WHERE 
            P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
            S.STOCK_ID = PO.STOCK_ID
    </cfquery>
    <cfif len(get_order.PO_RELATED_ID)>
        <cfquery name="get_related" datasource="#dsn3#">
            SELECT TOP 1 P_ORDER_ID,P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.PO_RELATED_ID#">
        </cfquery>
    </cfif>    
    <cfif not get_order.RECORDCOUNT>
        <cfset hata  = 10>
        <cfinclude template="../dsp_hata.cfm">
    <cfelse>
        <cfquery name="get_prod_pause_type" datasource="#dsn3#">
            SELECT DISTINCT
                SPPT.PROD_PAUSE_TYPE_ID,
                SPPT.PROD_PAUSE_TYPE
            FROM
                SETUP_PROD_PAUSE_TYPE SPPT,
                SETUP_PROD_PAUSE_TYPE_ROW SPPTR
            WHERE
                SPPT.PROD_PAUSE_TYPE_ID=SPPTR.PROD_PAUSE_TYPE_ID AND
                SPPTR.PROD_PAUSE_PRODUCTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.product_catid#">
        </cfquery>
        <cfquery name="GET_ROW" datasource="#dsn3#">
            SELECT
                ORDER_NUMBER,
                PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
            FROM
                PRODUCTION_ORDERS_ROW,
                ORDERS
            WHERE
                PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
                PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID 
        </cfquery>
        <cfif len(get_order.station_id)>
            <cfquery name="get_w" datasource="#dsn3#">
                SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.station_id#">
            </cfquery>
            <cfquery name="get_relation_physical_asset" datasource="#dsn#">
                SELECT 
                    ASSET_P.ASSETP_ID, 
                    ASSET_P.ASSETP, 
                    RELATION_PHYSICAL_ASSET_STATION.STATION_ID	
                FROM 
                    ASSET_P, 
                    RELATION_PHYSICAL_ASSET_STATION 
                WHERE 
                    ASSET_P.ASSETP_ID = RELATION_PHYSICAL_ASSET_STATION.PHYSICAL_ASSET_ID AND 
                    RELATION_PHYSICAL_ASSET_STATION.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.station_id#">
            </cfquery>
        <cfelse>
            <cfset get_w.recordcount = 0>
            <cfset get_relation_physical_asset.recordcount = 0>
        </cfif>
        <cfquery name="get_serial" datasource="#dsn3#">	
            SELECT 
                SERIAL_NO,
                GUARANTY_ID 
            FROM 
                SERVICE_GUARANTY_NEW 
            WHERE 
                PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
                PROCESS_CAT = 1194 AND
                PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order.p_order_no#">
        </cfquery>
        <cfif len(get_order.station_id)>
            <cfquery name="GET_STATION_INFO" datasource="#dsn3#">
                SELECT 
                    DEPARTMENT,
                    STATION_NAME,
                    EXIT_DEP_ID,
                    EXIT_LOC_ID,
                    ENTER_DEP_ID,
                    ENTER_LOC_ID,
                    PRODUCTION_DEP_ID,
                    PRODUCTION_LOC_ID
                FROM 
                    WORKSTATIONS 
                WHERE 
                    STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.station_id#">
            </cfquery>
        <cfelse>
            <cfset get_station_info.recordcount = 0>
        </cfif>
        <cfif get_station_info.recordcount and len(get_station_info.EXIT_DEP_ID)>
            <cfquery name="get_department" datasource="#dsn#">
                SELECT 
                    D.DEPARTMENT_HEAD 
                FROM 
                    DEPARTMENT D,
                    STOCKS_LOCATION SL 
                WHERE 
                    D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND 
                    D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION_INFO.EXIT_DEP_ID#"> AND
                    SL.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION_INFO.EXIT_LOC_ID#">
            </cfquery>
   		</cfif>
          
        <cfquery name="get_amount" datasource="#dsn3#">
            SELECT SUM(AMOUNT) AMOUNT FROM (SELECT AMOUNT,WRK_ROW_ID FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND TYPE=1 GROUP BY AMOUNT,WRK_ROW_ID)T1
        </cfquery>
        <cfif GET_STATION_INFO.recordcount and len(GET_STATION_INFO.DEPARTMENT)>
            <cfquery name="get_employees" datasource="#dsn#">
                SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION_INFO.DEPARTMENT#"> AND EMPLOYEE_ID IS NOT NULL AND EMPLOYEE_ID <> 0
            </cfquery>
        <cfelse>
            <cfset get_employees.recordcount = 0>
            <cfset get_employees.EMPLOYEE = ''>
            <cfset get_employees.EMPLOYEE_ID = ''>
        </cfif>
        <cfquery name="get_operations" datasource="#dsn3#">
            SELECT * FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
        </cfquery>
        <cfquery name="get_serial_count" dbtype="query">
            SELECT 
                COUNT(WRK_ROW_ID),
                EMPLOYEE_ID,
                ASSET_ID,
                AMOUNT,
                SERIAL_NO,
                WRK_ROW_ID
            FROM 
                get_operations 
            WHERE 
                TYPE = 1
            GROUP BY 
                SERIAL_NO,
                EMPLOYEE_ID,
                ASSET_ID,
                AMOUNT,
                WRK_ROW_ID
            ORDER BY 
                WRK_ROW_ID
        </cfquery>
        <cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
            <cfquery name="get_row_product" datasource="#dsn3#">
                SELECT PRODUCT_ID,STOCK_ID,PRODUCT_NAME,AMOUNT FROM PRODUCTION_ORDER_OPERATIONS_PRODUCT WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_serial_count.WRK_ROW_ID#"> ORDER BY RECORD_DATE DESC
            </cfquery>
        </cfif>  
        <style>
            .box_yazi_td {font-size:14px;border-color:#666666;font:bold;color:#0033FF} 
            .box_yazi_td2 {font-size:18px;border-color:#666666;font:bold}
            .box_yazi {font-size:16px;border-color:#666666;font:bold;} 
        </style>
        <cfif not get_serial_count.recordcount>
            <link rel="stylesheet" type="text/css" href="../css/temp/multiselect_check/jquery.multiselect.css">
            <script type="text/javascript" src="../JS/jquery-ui-1.8.14.custom.min.js"></script>
            <script type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.filter.js"></script>
            <script type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.js"></script>
        </cfif>  
    </cfif>     
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">	
		function open_order()
		{  
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.list_production_orders&event=gosteruemri','open_order_',1);
		
		}
		function kontrol()
		{
			if(datediff(document.getElementById('start_date').value,document.getElementById('finish_date').value,0)<0)
			{
				alert("<cf_get_lang_main no='394.Tarih Aralığını kontrol Ediniz'>!");
				return false;
			}
			else
			return true;
		}
	</script>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>  
	<script type="text/javascript">
	$( document ).ready(function() {
  		 row_count=<cfoutput>#get_serial_count.recordcount#</cfoutput>;		
		$('#record_num').val(row_count);
	}); //ready		
		function sil(sy)
		{		
			var my_element=eval("production_order.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			<cfif (isdefined("xml_is_material") and xml_is_material eq 1) or (isdefined("xml_is_operation") and xml_is_operation eq 1)>
				var my_element_1=eval("frm_row_1"+sy);
				my_element_1.style.display="none";
			</cfif>
			my_element.style.display="none";
			var my_element_2=eval("frm_row_2"+sy);
			my_element_2.style.display="none";
			var my_element_3=eval("frm_row_3"+sy);
			my_element_3.style.display="none";
			var my_element_4=eval("frm_row_4"+sy);
			my_element_4.style.display="none";
			for(i=1;i<=document.getElementById('row_count_1'+sy).value; ++i)
			{
				var my_element_5=eval("production_order.row_kontrol_2"+sy+'_'+i);
				my_element_5.value=0;
				var my_element_5=eval("frm_row_5"+sy+'_'+i);
				my_element_5.style.display="none";
			}
			<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
				var serial_no_ = eval("document.production_order.serial_no"+sy).value;
			<cfelse>
				var serial_no_ = "";
			</cfif>
			var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
			var wrk_row_id = "";
			var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
			wrk_row_id = sy+'_'+p_order_id_+'_'+userid_;
	
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_production_order_results&wrk_row_id='+wrk_row_id+'&is_del=1&p_order_id='+p_order_id_+'&serial_no='+serial_no_+'',1);	
			toplam_kontrol();
		}
		function add_row()
		{		
			row_count++;
			var NewRow;
			var NewCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("align","center"); 
			document.production_order.record_num.value=row_count;
			<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.colSpan = 7;
				newCell.height = "80";
				newCell.style.verticalAlign= 'bottom';
				newCell.align = "center";
				newCell.innerHTML = '<div align="center"><strong><cf_get_lang no="28.Başlangıç Sayacı">&nbsp;</strong><input type="text" name="start_counter_'+row_count+'" id="start_counter_'+row_count+'" value="" onkeyup="isNumber(this);" title="<cf_get_lang no='28.Başlangıç Sayacı'>" style="font-size:26px;width:200px;height:40px;">&nbsp;&nbsp;&nbsp; <strong><cf_get_lang no='29.Bitiş Sayacı'>&nbsp;</strong><input type="text" name="finish_counter_'+row_count+'" id="finish_counter_'+row_count+'" value="" onkeyup="isNumber(this);" title="<cf_get_lang no='29.Bitiş Sayacı'>" style="font-size:26px;width:200px;height:40px;"></div>';
			</cfif>
			<cfif (isdefined("xml_is_material") and xml_is_material eq 1) or (isdefined("xml_is_operation") and xml_is_operation eq 1)>
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row_1" + row_count);
				newRow.setAttribute("id","frm_row_1" + row_count);
				newRow.setAttribute("align","center");
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.colSpan = 7;
				newCell.height = "80";
				newCell.align = "center";
				newCell.style.verticalAlign= 'bottom';	
				newCell.innerHTML = '<div align="center"><cfif isdefined("xml_is_material") and xml_is_material eq 1><input type="button" name="materials'+row_count+'" id="materials'+row_count+'" style="font-size:18px;font:bold;width:210px;height:44px;" value="<cf_get_lang no='30.MALZEME İHTİYAÇLARI'>" onClick="gizle_goster(open_material_' + row_count + ');open_material(' + row_count + ');"> </cfif><cfif isdefined("xml_is_operation") and xml_is_operation eq 1><input type="button" name="operations'+row_count+'" id="operations'+row_count+'" onClick="form_operation(' + row_count + ');" style="font-size:18px;font:bold;width:210px;height:44px;" disabled="disabled" value="<cf_get_lang no='31.OPERASYONLAR'>"> </cfif></div>';
			</cfif>
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row_2" + row_count);
			newRow.setAttribute("id","frm_row_2" + row_count);
			newRow.setAttribute("align","center");
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.colSpan = 7;
			newCell.height = "100";
			newCell.align = "center";
			newCell.innerHTML = '<div align="center"><input type="hidden" name="get_row_product'+row_count+'" id="get_row_product'+row_count+'" value=""/><input type="hidden" name="row_count_1'+row_count+'" id="row_count_1'+row_count+'" value=""><input type="button" name="p_start'+row_count+'" id="p_start'+row_count+'" style="font-size:18px;font:bold;width:210px;height:44px;" value="<cf_get_lang no='34.ÜRETİME BAŞLA'>" onclick="production_start('+ row_count +');"> <input type="button" name="p_stop'+row_count+'" id="p_stop'+row_count+'" disabled="disabled" style="font-size:18px;font:bold;width:210px;height:44px;"value="<cf_get_lang no='36.ÜRETİMİ DURDUR'>" onclick="production_stop(' + row_count + ');"> <input type="button" name="p_finish'+row_count+'" id="p_finish'+row_count+'" disabled="disabled" style="font-size:18px;font:bold;width:210px;height:44px;" value="<cf_get_lang no='38.ÜRETİMİ SONLANDIR'>" onclick="production_finish(' + row_count + ');"> <input type="text" name="amount'+row_count+'" id="amount'+row_count+'" value="1" <cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>readonly</cfif> style="font-size:28px;width:150px;height:44px;" onkeyup="return(FormatCurrency(this,event));"><input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a></div>';
			
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row_3" + row_count);
			newRow.setAttribute("id","frm_row_3" + row_count);
			newRow.setAttribute("align","center");
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.width = "40";
			newCell.innerHTML = '<td>&nbsp;</td>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.fontSize = "16px";
			newCell.style.fontWeight = "bold";
			newCell.align = "center";
			newCell.setAttribute("nowrap","nowrap");
				b = '<div style="font-size:16px" align="center"><cf_get_lang_main no="164.Çalışan">&nbsp;<select name="employee' + row_count  +'" id="employee' + row_count  +'" class="multiColmn" multiple="multiple" style="width:200px;height:70px;font-size:18px">';
				<cfif get_employees.recordcount>
					<cfoutput query="get_employees">
						if('#employee_id#' == #session.ep.userid#)
							b += '<option value="#employee_id#" selected>#employee#</option>';
						else
							b += '<option value="#employee_id#">#employee#</option>';
					</cfoutput>
				</cfif>
				newCell.innerHTML =b+ '</select></div>';
				try{
					$(".multiColmn")
					   .multiselect({
						  minWidth:200, 
						  checkAllText:" Seç ",
						  uncheckAllText:" Kaldır ",
						  noneSelectedText: 'Seçiniz',
						  selectedText: '# / # Kayıt Seçildi '
					   });
						$(".multiColmn").multiselect().multiselectfilter();
						$(".multiColmn").multiselect({
						open: function () {
							$("input[type='search']").focus();                   
						}
					});
					var $widget = $(".multiColmn").multiselect(),  
					state = true;
				}catch(err){};
			<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.style.fontSize = "16px";
				newCell.width = "210";
				newCell.style.fontWeight = "bold";
				newCell.setAttribute("nowrap","nowrap");
					c = '<cf_get_lang_main no="1421.Fiziki Varlık">&nbsp;<select name="asset' + row_count  +'" id="asset' + row_count  +'" style="width:200px;height:25px;font-size:18px">';
					<cfif get_relation_physical_asset.recordcount>
						<cfoutput query="get_relation_physical_asset">
							c += '<option value="#ASSETP_ID#">#ASSETP#</option>';
						</cfoutput>
					</cfif>
					newCell.innerHTML =c+ '</select>';
			</cfif>
			<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.style.fontSize = "16px";
				newCell.style.fontWeight = "bold";
				newCell.width = "60";
				newCell.innerHTML = '<td><cf_get_lang_main no='225.Seri No'></td>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.width = "210";
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<div style="width:200;" id="serial_no_place'+row_count+'"></div>';
			</cfif>
			<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<td><a href="javascript://" style="vertical-align:bottom" onclick="add_product_row('+ row_count +');"><img src="images/p.gif" border="0"></a></td>';
			</cfif>
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row_4" + row_count);
			newRow.setAttribute("id","frm_row_4" + row_count);
			newRow.setAttribute("align","center");
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.colSpan = 7;
			newCell.innerHTML = '<td>&nbsp;&nbsp;<div style="width:200;" id="open_material_' + row_count  +'"></div></td>';
			toplam_kontrol();
			serial_control(row_count,2);
		}
	
		var row_count_2=0;
		$('#record_num_2').val(row_count_2);
		function add_product_row(no)
		{
			if (document.getElementById('record_num').value > no)
			{
				alert("<cf_get_lang no='39.Farklı Üretim Satırı Bulunduğu için Ürün Ekleyemezsiniz'>!");
				return false;
			}
			row_count_2++;
			var NewRow;
			var NewCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row_5" + no + "_" + row_count_2);
			newRow.setAttribute("id","frm_row_5" + no + "_" +  row_count_2);
			newRow.setAttribute("align","center");
			document.getElementById('record_num_2').value=row_count_2;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.height = "55";
			newCell.colSpan = 6;//alert(no);alert(row_count_2);
			document.getElementById('row_count_1'+no).value = row_count_2;
			newCell.innerHTML = '<div align ="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="hidden" name="row_kontrol_2'+no+'_' +row_count_2+'" id="row_kontrol_2'+no+'_' +row_count_2+'" value="1"><input type="text" name="amount_product'+no+'_' +row_count_2+'" id="amount_product'+no+'_' +row_count_2+'" value="1" maxlength="10" onkeyup="return(FormatCurrency(this,event));" title="<cf_get_lang_main no='223.Miktar'>" style="font-size:22px;width:100px;height:30px;">&nbsp;<input type="hidden" name="product_id'+no+'_' +row_count_2+'" id="product_id'+no+'_' +row_count_2+'" value=""><input  type="hidden" name="stock_id'+no+'_' +row_count_2+'" id="stock_id'+no+'_' +row_count_2+'" value=""><input type="text" name="product_name'+no+'_' +row_count_2+'" value="" id="product_name'+no+'_' +row_count_2+'" title="<cf_get_lang_main no='245.Ürün'>" style="font-size:22px;width:450px;height:30px;" style="width:145px;" value=""><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id"+row_count_2+"').value+'&sid='+document.getElementById('stock_id"+row_count_2+"').value+'','list');"+'"><img src="/images/plus_thin_p.gif" border="0" align="absbottom" alt="<cf_get_lang no="458.Ürün Detay">" style="display:none;" id="product_info'+no+'_' +row_count_2+'"></a><a href="javascript://" onClick="pencere_ac_product('+no+','+ row_count_2 +');"> <img src="/images/plus_thin_big.gif" border="0" align="absbottom"></a><a style="cursor:pointer" onclick="sil_product('+no+','+ row_count_2 +');"><img  src="images/delete_list.gif" border="0"></a></div>';
		}
		function pencere_ac_product(no,row_)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=all.product_id'+no+'_'+row_+'&field_id=all.stock_id'+no+'_'+row_+'&field_name=all.product_name'+no+'_'+row_,'list');
		}
	
		function toplam_kontrol()
		{	
			var row_no=0;
			row_no=document.getElementById('record_num').value;
			total_amount(row_no);
			return true;
		}
		function total_amount(no)
		{	
			var toplam_1=0;
			for(var i=1; i <= no; i++)
			{
				if(eval("document.getElementById('amount'+i)").value != '' && eval("document.production_order.row_kontrol"+i).value == 1)
				{
					var ara_toplam=filterNum(eval("document.getElementById('amount'+i)").value,2);
					if(ara_toplam!= null && ara_toplam.value != "")
					{
						toplam_1 = parseFloat(toplam_1 + parseFloat(ara_toplam));
						document.production_order.toplam_tutar.value=toplam_1;
					}
				}
			}
		}
	
		function sil_product(no,row_)
		{
			var my_element_5=eval('production_order.row_kontrol_2'+no+'_'+row_);
			my_element_5.value=0;
			var my_element_5=eval('frm_row_5'+no+'_'+row_);
			my_element_5.style.display="none";
		}
		
		function control()
		{		
			var production_count = 0;
			for(i=1;i<=document.getElementById('record_num').value;++i)
			{
				if(document.getElementById('frm_row_2'+i).style.display =='')
					var production_count = parseFloat(production_count) + parseFloat(filterNum(eval("document.getElementById('amount'+i)").value,2));	
			} 
			<cfif isdefined("xml_is_amount_kontrol") and xml_is_amount_kontrol eq 1>
				if(document.getElementById('remaining').value <= production_count)
				{

					alert("<cf_get_lang no='40.Satırlardaki Toplam Miktar Kalan Miktardan Fazla'>!");
					return false;
				}
			</cfif>
			add_row();
		}
		function control2()
		{
			var production_count_ = 0;
			for(i=1;i<=document.getElementById('record_num').value;++i)
			{
				if(document.getElementById('frm_row_2'+i).style.display =='')
					var production_count_ = parseFloat(production_count_) + parseFloat(filterNum(document.getElementById('amount'+i).value,2));
			} 
			<cfif isdefined("xml_is_amount_kontrol") and xml_is_amount_kontrol eq 1>
				if(document.getElementById('remaining').value < production_count_)
				{
					alert("<cf_get_lang no='40.Satırlardaki Toplam Miktar Kalan Miktardan Fazla'>!");
					return false;
				}
			</cfif>
			return true;
		}
		function addLoadEvent(func)
		{
			var oldonload = window.onload;
			if (typeof window.onload != 'function')
			{
				window.onload = func;
			}
			else
			{
				window.onload = function() 
				{
					if (oldonload)
					{
						oldonload();
					}
					func();
				}
			}
		}
		addLoadEvent
		(
			function bbb() 
			{
				if(document.getElementById('count_') != undefined)
				{
					var record_count = document.getElementById('count_').value;
					for(rr=1;rr<=record_count;rr++)
					{
						if(document.getElementById('serial_ajax'+rr) != undefined && document.getElementById('serial_ajax'+rr).value == 1)
						serial_control(rr,1);
					}
				}
			}
		)
		function serial_control(no,type)
		{
			if(document.getElementById('wrk_row_id_'+no) != undefined)
			var _wrkrowid_ = document.getElementById('wrk_row_id_'+no).value;
			var send_address = "<cfoutput>#request.self#?fuseaction=production.emptypopup_get_serial_no_ajax&p_order_id=#attributes.upd#&p_order_no=#get_order.p_order_no#</cfoutput>&wrk_row_id="+_wrkrowid_+"&row_="+no+"&type=";
			send_address += type;
			AjaxPageLoad(send_address,'serial_no_place'+no);
		}	
		function serialno_control(no)
		{
			for(yy=1;yy<=document.getElementById('record_num').value;yy++)
			{
				if(yy!= no)
				{
					if(document.getElementById('serial_no'+yy).value == document.getElementById('serial_no'+no).value)
					{
						alert("<cf_get_lang no='41.Seçilen Seri No Kullanılmıştır'>!");
						document.getElementById('serial_no'+no).value ="";
					}
				}
			}
		}
		function production_start(no,wrkrow)
		{//üretime başla denilmiş ise
			if(control2())
			{				
				var record_num_ = document.getElementById('row_count_1'+no).value;
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				if (wrkrow != undefined && wrkrow != '')
				{
					wrk_row_id_ = wrkrow;
				}
				else
				{
					var wrk_row_id_ = "";
					var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
					wrk_row_id_ = no+'_'+p_order_id_+'_'+userid_;
				}
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					if (eval("document.getElementById('serial_no'+no)") == undefined || eval("document.getElementById('serial_no'+no)").value == '')
					{	
						alert("<cf_get_lang no='42.Lütfen Seri No Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
				{
					alert("<cf_get_lang no='43.Lütfen Çalışan Seçiniz'>!");
					return false;
				}
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
					{
						alert("<cf_get_lang_main no='1423.Lütfen Fiziki Varlık Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('amount'+no)") == undefined || eval("document.getElementById('amount'+no)").value == '')
				{
					alert("<cf_get_lang no='44.Miktar Girmelisiniz'>!");
					return false;
				}
				document.getElementById('p_finish'+no+'').disabled=false;//butona 2 kere tıklanmasın diye pasif yapıyoruz.!
				document.getElementById('p_stop'+no+'').disabled=false;
				<cfif isdefined("xml_is_operation") and xml_is_operation eq 1>
					document.getElementById('operations'+no+'').disabled=false;
				</cfif>
				my_temp_name = '#employee'+no;
				var employee_ =$(my_temp_name).val();
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					var serial_no_ = eval("document.getElementById('serial_no'+no)").value;
				<cfelse>
					var serial_no_ = "";
				</cfif>
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					var asset_id_ = eval("document.getElementById('asset'+no)").value;
				<cfelse>
					var asset_id_ = '';
				</cfif>
				var amount_value = eval("document.getElementById('amount'+no)").value;
				var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
				<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
					var start_counter_ = document.getElementById('start_counter_'+no).value;
					var finish_counter_ = document.getElementById('finish_counter_'+no).value;
				<cfelse>
					var start_counter_ = '';
					var finish_counter_ = '';
				</cfif>
				var url='';
				<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
					for(i=1;i<=row_count_2;++i)
					{
						if(document.getElementById('product_id'+no+'_'+i).value !='' && document.getElementById('stock_id'+no+'_'+i).value !='' && document.getElementById('amount_product'+no+'_'+i).value !='')
						{
							product_id_ = document.getElementById('product_id'+no+'_'+i).value;
							stock_id_ = document.getElementById('stock_id'+no+'_'+i).value;
							product_name_ = document.getElementById('product_name'+no+'_'+i).value;
							amount_value_ = document.getElementById('amount_product'+no+'_'+i).value;
							amount_product_ = filterNum(amount_value_,'#session.ep.our_company_info.rate_round_num#');
							row_kontrol_ = document.getElementById('row_kontrol_2'+no+'_'+i).value;
							row_ = no +'_'+i;
							url += '&product_id'+row_+'='+product_id_+'&stock_id'+row_+'='+stock_id_+'&product_name'+row_+'='+product_name_+'&amount'+row_+'='+amount_product_+'&row_kontrol'+row_+'='+row_kontrol_+'';
						}
						else
						{
							alert(i+'. <cf_get_lang no="45.Satırda bilgiler eksik">');
							return false;
						}
					}
				</cfif>
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_production_order_results'+url+'&no='+no+'&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&type=1&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&serial_no='+serial_no_+'&asset_id='+asset_id_+'&amount='+amount_+'');	
				//windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_production_order_results'+url+'&no='+no+'&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&type=1&is_del=0&p_order_id='+p_order_id_+'&employee='+employee_+'&serial_no='+serial_no_+'&asset_id='+asset_id_+'&amount='+amount_+'','list');	
				document.getElementById('p_start'+no+'').value = "<cf_get_lang no='32.ÜRETİM BAŞLADI'>";
				document.getElementById('p_stop'+no+'').value = "<cf_get_lang no='36.ÜRETİMİ DURDUR'>";
				document.getElementById('p_start'+no+'').disabled=true;//butona 2 kere tıklanmasın diye pasif yapıyoruz.!
				document.getElementById('p_stop'+no+'').disabled=false;
				document.getElementById('employee'+no+'').disabled=true;
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					document.getElementById('asset'+no+'').disabled=true;
				</cfif>
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					document.getElementById('serial_no'+no+'').disabled=true;
				</cfif>
				alert("<cf_get_lang no='14.Üretimler Başlatıldı'>!");
			}
			else
				return false;
		}
		
		function production_stop(no,wrkrow)
		{//üretimi durdur
			if(control2())
			{
				var record_num_ = document.getElementById('row_count_1'+no).value;
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				if (wrkrow != undefined && wrkrow != '')
				{
					wrk_row_id_ = wrkrow;
				}
				else
				{
					var wrk_row_id_ = "";
					var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
					wrk_row_id_ = no+'_'+p_order_id_+'_'+userid_;
				}
				<cfif get_prod_pause_type.recordcount eq 0>
					alert("<cf_get_lang no='46.Ürün Kategorisinde Duraklama Tipi Tanımlı Değil! Duraklama Tipi Tanımlayınız'>!");
					return false;
				</cfif>
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					if (eval("document.getElementById('serial_no'+no)") == undefined || eval("document.getElementById('serial_no'+no)").value == '')
					{	
						alert("<cf_get_lang no='42.Lütfen Seri No Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
				{
					alert("<cf_get_lang no='43.Lütfen Çalışan Seçiniz'>!");
					return false;
				}
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
					{
						alert("<cf_get_lang_main no='1423.Lütfen Fiziki Varlık Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('amount'+no)") == undefined || eval("document.getElementById('amount'+no)").value == '')
				{
					alert("<cf_get_lang no='44.Miktar Girmelisiniz'>!");
					return false;
				}
				document.getElementById('p_stop'+no+'').disabled=true;
				document.getElementById('p_finish'+no+'').disabled=true;
				<cfif isdefined("xml_is_operation") and xml_is_operation eq 1>
					document.getElementById('operations'+no+'').disabled=true;
				</cfif>
				document.getElementById('p_start'+no+'').disabled=false;
				document.getElementById('p_stop'+no+'').value = 'ÜRETİM DURDU';
				document.getElementById('p_start'+no+'').value = 'ÜRETİME DEVAM ET';
				my_temp_name = '#employee'+no;
				var employee_ =$(my_temp_name).val();
				//var employee_ = eval("document.getElementById('employee'+no)").value;
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					var serial_no_ = eval("document.getElementById('serial_no'+no)").value;
				<cfelse>
					var serial_no_ = "";
				</cfif>
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					var asset_id_ = eval("document.getElementById('asset'+no)").value;
				<cfelse>
					var asset_id_ = '';
				</cfif>
				var amount_value = eval("document.getElementById('amount'+no)").value;
				var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
				<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
					var start_counter_ = document.getElementById('start_counter_'+no).value;
					var finish_counter_ = document.getElementById('finish_counter_'+no).value;
				<cfelse>
					var start_counter_ = '';
					var finish_counter_ = '';
				</cfif>
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				var product_catid_ = '<cfoutput>#get_order.PRODUCT_CATID#</cfoutput>'; //Ürün Kategorisi
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_prod_operations&is_oper_row=0&no='+no+'&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&is_del=0&type=0&p_order_id='+p_order_id_+'&product_catid='+product_catid_+'&employee='+employee_+'&serial_no='+serial_no_+'&asset_id='+asset_id_+'&amount='+amount_+'','small');
			}
			else
				return false;
		}
		
		function production_finish(no,wrkrow)
		{//üretimi sonlandır
			if(control2())
			{
				if(!chk_process_cat('production_order')) return false;
				if(!process_cat_control()) return false;
				var record_num_ = document.getElementById('row_count_1'+no).value;
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				if (wrkrow != undefined && wrkrow != '')
				{
					wrk_row_id_ = wrkrow;
				}
				else
				{
					var wrk_row_id_ = "";
					var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
					wrk_row_id_ = no+'_'+p_order_id_+'_'+userid_;
				}
				url_= '/V16/production/cfc/get_production_operations.cfc?method=get_production_operation_control&wrk_row_id='+ encodeURIComponent(wrk_row_id_);		
				prod_operation = 0;
				$.ajax({
						url: url_,
						dataType: "text",
						cache:false,
						async: false,
						success: function(read_data) {
						data_ = jQuery.parseJSON(read_data);
						if(data_.DATA.length != 0)
						{
							alert("<cf_get_lang no='47.Sonlandırılmamış Operasyonlar Bulunmaktadır'>!");
							prod_operation = 1;
							//return false;
						}
					}
				});
				if(prod_operation == 1)
					return false;			
				
				<cfif isdefined("xml_is_serial_no") and xml_is_serial_no eq 1>
					if (eval("document.getElementById('serial_no'+no)") == undefined || eval("document.getElementById('serial_no'+no)").value == '')
					{	
						alert("<cf_get_lang no='42.Lütfen Seri No Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('employee'+no)") == undefined || eval("document.getElementById('employee'+no)").value == '')
				{
					alert("<cf_get_lang no='43.Lütfen Çalışan Seçiniz'>!");
					return false;
				}
				<cfif isdefined("xml_is_asset") and xml_is_asset eq 1>
					if (eval("document.getElementById('asset'+no)") == undefined || eval("document.getElementById('asset'+no)").value == '')
					{
						alert("<cf_get_lang_main no='1423.Lütfen Fiziki Varlık Seçiniz'>!");
						return false;
					}
				</cfif>
				if (eval("document.getElementById('amount'+no)") == undefined || eval("document.getElementById('amount'+no)").value == '')
				{
					alert("<cf_get_lang no='44.Miktar Girmelisiniz'>!");
					return false;
				}
				<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
					if (eval("document.getElementById('start_counter_'+no)").value != '' && eval("document.getElementById('finish_counter_'+no)").value == '')
					{
						alert("<cf_get_lang no='48.Bitiş Sayacı Giriniz'>!");
						return false;
					}
				</cfif>
				var j_url_str = "" ;//
				var process_cat = document.getElementById('process_cat').length//işlem kategorisi
				if(process_cat < 2){
					alert("<cf_get_lang no='49.Bu İşlemi Yapabilmek İçin İşlem Kategorisine Yetkili Olmalısınız'>!");
					return false;
				}
				process_cat = document.getElementById('process_cat').value;
				var process_stage= document.getElementById('process_stage').value;//Süreç
				if(process_stage == ""){
					alert("<cf_get_lang no='50.Bu İşlemi Yapabilmek İçin Sürece Yetkili Olmasılısınız'>!");
					return false;
				}
				<cfif get_prod_pause_type.recordcount>
					var pause_type_id = '<cfoutput>#get_prod_pause_type.PROD_PAUSE_TYPE_ID#</cfoutput>'; //duraklama tipi
				<cfelse>
					var pause_type_id = '';
				</cfif>
				j_url_str +='&process_cat='+process_cat+'&process_stage='+process_stage+'';
				<cfif isdefined("xml_is_counter") and xml_is_counter eq 1>
					var start_counter_ = document.getElementById('start_counter_'+no).value;
					var finish_counter_ = document.getElementById('finish_counter_'+no).value;
				<cfelse>
					var start_counter_ = '';
					var finish_counter_ = '';
				</cfif>
				var amount_value = eval("document.getElementById('amount'+no)").value;
				var amount_ = filterNum(amount_value,'#session.ep.our_company_info.rate_round_num#');
				document.getElementById('p_stop'+no+'').disabled=true;
				document.getElementById('p_start'+no+'').disabled=true;
				document.getElementById('p_finish'+no+'').disabled=true;
				<cfif isdefined("xml_is_operation") and xml_is_operation eq 1>
					document.getElementById('operations'+no+'').disabled=true;
				</cfif>
				document.getElementById('p_finish'+no+'').value = "<cf_get_lang no='37.ÜRETİM SONLANDIRILIYOR'>";
				var product_url='';
				<cfif isdefined("xml_is_row_product") and xml_is_row_product eq 1>
					if (document.getElementById('get_row_product'+no) != undefined && document.getElementById('get_row_product'+no).value != '')
					{
						var row_count_2 = document.getElementById('get_row_product'+no).value;
					}
					else
					{
						var row_count_2 = document.getElementById('record_num_2').value;
					}
					for(i=1;i<=row_count_2;++i)
					{
						if(document.getElementById('product_id'+no+'_'+i).value !='' && document.getElementById('stock_id'+no+'_'+i).value !='' && document.getElementById('amount_product'+no+'_'+i).value !='')
						{
							stock_id_ = document.getElementById('stock_id'+no+'_'+i).value;
							amount_value_ = document.getElementById('amount_product'+no+'_'+i).value;
							amount_product_ = filterNum(amount_value_,'#session.ep.our_company_info.rate_round_num#');
							row_kontrol_ = document.getElementById('row_kontrol_2'+no+'_'+i).value;
							row_ = no +'_'+i;
							product_url += '&stock_id'+row_+'='+stock_id_+'&amount'+row_+'='+amount_product_+'&row_kontrol'+row_+'='+row_kontrol_+'';
						}
						else
						{
							alert(i+'. <cf_get_lang no="45.Satırda bilgiler eksik">');
							return false;
						}
					}
				</cfif>
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_ajax_add_prod_order_result_group&employee='+eval("document.getElementById('employee'+no)").value+'&record_num='+record_num_+'&wrk_row_id='+wrk_row_id_+'&start_counter='+start_counter_+'&finish_counter='+finish_counter_+'&is_prod=1&no='+no+'&type=2'+j_url_str+'&p_order_id_list='+p_order_id_+'&amount='+amount_+'&pause_type_id='+pause_type_id+''+product_url+'','prod_order',1);	
			}
			else
				return false;
		}
		function open_order()
		{ 
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.list_production_orders&event=gosteruemri','open_order_',1);
		}
		function open_material(no)
		{  
			var this_production_amount = '<cfoutput>#get_order.QUANTITY#</cfoutput>';
			var send_material_address = "<cfoutput>#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&p_order_id=#attributes.upd#&stock_id=#get_order.STOCK_ID#&order_amount=#get_order.quantity#&spect_main_id=#get_order.SPEC_MAIN_ID#&spect_var_id=#get_order.SPECT_VAR_ID#&from_upd_production_page=1&this_production_amount=#get_order.QUANTITY#&is_production=1</cfoutput>";
			AjaxPageLoad(send_material_address,'open_material_'+no);
		}
		function form_operation(no,wrkrow)
		{
			if(control2())
			{
				var p_order_id_ = '<cfoutput>#attributes.upd#</cfoutput>'; //Üretim Emri ID
				var production_amount_ = '<cfoutput>#get_order.QUANTITY#</cfoutput>';
				if (wrkrow != undefined && wrkrow != '')
				{
					wrk_row_id_ = wrkrow;
				}
				else
				{
					var wrk_row_id_ = "";
					var userid_ = '<cfoutput>#session.ep.userid#</cfoutput>';
					wrk_row_id_ = no+'_'+p_order_id_+'_'+userid_;
				}
				windowopen('<cfoutput>#request.self#?fuseaction=production.form_add_production_operation&production_amount='+production_amount_+'&wrk_row_id='+wrk_row_id_+'&prod_id=#attributes.upd#</cfoutput>','longpage');
			}
			else
				return false;
		}
	
	</script>  
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
			
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'production.list_production_orders';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production/display/list_production_orders.cfm';	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'production.form_add_production_order';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production/form/form_add_production_order.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production/form/form_add_production_order.cfm';	
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'upd=##p_order_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'production.list_production_orders&event=list';
	
	WOStruct['#attributes.fuseaction#']['gosteruemri'] = structNew();
	WOStruct['#attributes.fuseaction#']['gosteruemri']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['gosteruemri']['fuseaction'] = 'production.list_production_orders';
	WOStruct['#attributes.fuseaction#']['gosteruemri']['filePath'] = 'production/form/production_orders_list.cfm';
	WOStruct['#attributes.fuseaction#']['gosteruemri']['queryPath'] = 'production/form/production_orders_list.cfm';	
	WOStruct['#attributes.fuseaction#']['gosteruemri']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['gosteruemri']['Identity'] = '';
	WOStruct['#attributes.fuseaction#']['gosteruemri']['nextEvent'] = '';	

</cfscript>
