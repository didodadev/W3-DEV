
<cfparam name="attributes.emp_id" default="#session.ep.userid#">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.part" default="1">
<cfparam  name="attributes.seperator_order_id" default="1">

<cfinclude template="../../objects/query/get_emp_det.cfm">
<style>
        /* Tablo */,
        .text{
        color:black !important;
        font-weight: bold;
        font-size:18px !important;
        }
        table thead tr th {
        border-bottom: 1px solid #000000 !important;
        }
        .tablesorter-headerRow{
        background-color:#ece3e4;
        color:red !important;
        border-top: 2px solid #ece9e8;
        border-bottom: 2px solid #ece9e8;
        }
        .text :hover{
        color:red !important;
        }
        .ajax_list > tbody > tr > td{
            font-size:18px;
            font-weight:400;
        }
        .tablesorter-header-inner {
            font-size:20px;
        }
        .ui-wrk-btn {
            margin: 5px 0 0 20px;
            border: 0;
            font-size: 20px !important;
            padding: 10px 20px !important;
            text-align: center;
            border-radius: 7px;
            transition: .4s !important;
            cursor: pointer;
        }
        .op_item_detail_left{
            margin-top:20px;
        }
        .op_item_detail_svg_icon a:link {
        color: #fff;
        text-decoration: none;
        }
        .op_item_detail_left .op_detail_content_title{
            font-family:'Roboto', sans-serif !important;
            font-weight:bold!important;
        }
        .fa-home
        {
            color:#EBB2B2 !important; 
            font-size:40px !important; 
        }
        .op_item_detail_circle_item{
            height:60px !important;
            width:60px !important;
        }
        .op_item_detail_svg_icon{
        	padding: 0 0 0 15px;    
        }
        .days{
            float:right;
            font-size:30px;
            color:#0d89c0;
            font-weight:bold;
        }
        .days1{
            text-align:center;<cfif attributes.list_type eq 1>background-color:#ceeaf0;</cfif>
            cursor:pointer;
            font-size:20px;
            margin-right:15px;
            width: 110px;
            height: 35px;
            border-radius: 10px;
            padding-top: 5px;
        }
        .days1:hover{background-color:#bdd7dd;}

        .days2{
            text-align:center;<cfif attributes.list_type eq 2>background-color:#ceeaf0;</cfif>
            cursor:pointer;
            font-size:20px;
            margin-right:15px;
            width: 110px;
            height: 35px;
            border-radius: 10px;
            padding-top: 5px;
        }
        .days2:hover{background-color:#bdd7dd;}

        .days3{
            text-align:center;<cfif attributes.list_type eq 3>background-color:#ceeaf0;</cfif>
            cursor:pointer;
            font-size:20px;
            margin-right:15px;
            width: 110px;
            height: 35px;
            border-radius: 10px;
            padding-top: 5px;
        }
        .days3:hover{background-color:#bdd7dd;}

        .days a:visited {
            color:#0d89c0;
        }
        .arrows{font-size:27px;margin-right:10px;}
        .arrows a{
            color:#0D8AC0;
        }
        .uniqueBox{
            margin-top:65px !important;
        }
        .flowcard {
            position: fixed;
            z-index:99;
            height:65px;
            width:100%;
        }
        .dana-btn-list{
            display: flex;justify-content: end;
        }
        .dana-btn-list li{
            margin-right:15px;
        }
</style>
<cfset attributes.department_id = get_emp_pos.department_id>
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
    <cfif attributes.list_type eq 1>
        <cfset attributes.startdate =DateFormat(Fix(Now()+(1*(attributes.part-1))), "yyyy-mm-dd")>
        <cfset attributes.finishdate =DateFormat(Fix(Now()+(1*(attributes.part))), "yyyy-mm-dd")>
    <cfelseif attributes.list_type eq 2>
        <cfset attributes.startdate =DateFormat((Fix( Now() +1) - DayOfWeek(Now()-1)+(7*((attributes.part)-1))), "yyyy-mm-dd")>
        <cfset attributes.finishdate =DateFormat((Fix( Fix( Now() ) - DayOfWeek(Now()-1) +8)+(7*((attributes.part)-1))), "yyyy-mm-dd")>
    <cfelseif attributes.list_type eq 3>
        <cfif attributes.part gt 0>
            <cfset now_=Now()>
            <cfloop index="i" from="1" to="#attributes.part#" >
            <cfset attributes.startdate =DateFormat(Fix( now_ ) - Day(now_-1), "yyyy-mm-dd")>
            <cfset attributes.finishdate =DateFormat(Fix( Fix( now_ ) - Day(now_-1) +DaysInMonth(now_) ), "yyyy-mm-dd")>
            <cfif Day(attributes.finishdate) eq 1><cfset now_=attributes.finishdate+1><cfelse><cfset now_=attributes.finishdate></cfif>
            </cfloop>
        <cfelse>
            <cfset attributes.sayac=(attributes.part-1)*-1>
            <cfset now_=Now()>
            <cfloop index="i" from="1" to="#attributes.sayac#" >
            <cfset attributes.finishdate =DateFormat(((Fix( now_ ) - Day(now_-1))), "yyyy-mm-dd")>
            <cfset attributes.startdate =DateFormat(((Fix( now_ ) - Day(now_-1))) -DaysInMonth(Fix(attributes.finishdate-1)), "yyyy-mm-dd")>
            <cfset now_=attributes.finishdate>
            </cfloop>
        </cfif>
    </cfif>
</cfif>
<cfquery name="get_production_orders_lots" datasource="#dsn3#">
    SELECT
        PO.P_ORDER_ID,
        PO.P_ORDER_NO AS TOPLU_URETIM,
        PO.LOT_NO,
        PO.START_DATE,
        PO.FINISH_DATE,
        PO.DETAIL,
        PO.STATION_ID,
        PO.IS_STAGE,
        PO.STOCK_ID,
        S.PRODUCT_ID,
        P.PRODUCT_ID,
        PO.QUANTITY,
        PO.IS_GROUP_LOT,
        P.PRODUCT_NAME,
        PO.STOCKS_JSON,
        (select STATION_NAME from WORKSTATIONS W  WHERE W.STATION_ID= PO.STATION_ID ) STATION_NAME
    FROM
        PRODUCTION_ORDERS PO
        LEFT JOIN WORKSTATIONS W ON PO.STATION_ID = W.STATION_ID 
        LEFT JOIN STOCKS S ON S.STOCK_ID = PO.STOCK_ID 
        LEFT JOIN PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID 
    WHERE
        W.EMP_ID LIKE (<cfqueryparam cfsqltype="cf_sql_varchar" value=",%#session.ep.userid#%,">) 
        AND PO.IS_GROUP_LOT = 1
        AND Po.IS_STAGE IS NOT NULL
        <cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
        AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
        AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
        <cfelseif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
            AND START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
        </cfif>
    GROUP BY
    PO.P_ORDER_ID,
        PO.LOT_NO,
        PO.START_DATE,
        PO.FINISH_DATE,
        PO.DETAIL,
        PO.STATION_ID,
        PO.IS_STAGE,
        PO.P_ORDER_NO,
        PO.STOCK_ID,
        P.PRODUCT_ID,
        S.PRODUCT_ID,
        PO.QUANTITY,
        P.PRODUCT_NAME,
        PO.IS_GROUP_LOT,
        PO.STOCKS_JSON
    UNION ALL
    SELECT
        PO.P_ORDER_ID,
        PO.P_ORDER_NO AS TOPLU_URETIM,
        PO.LOT_NO,
        PO.START_DATE,
        PO.FINISH_DATE,
        PO.DETAIL,
        PO.STATION_ID,
        PO.IS_STAGE,
        PO.STOCK_ID,
        S.PRODUCT_ID,
        P.PRODUCT_ID,
        PO.QUANTITY,
        PO.IS_GROUP_LOT,
        P.PRODUCT_NAME,
        PO.STOCKS_JSON,
        (select STATION_NAME from WORKSTATIONS W  WHERE W.STATION_ID= PO.STATION_ID ) STATION_NAME
    FROM
        PRODUCTION_ORDERS PO
        LEFT JOIN WORKSTATIONS W ON PO.STATION_ID = W.STATION_ID 
        LEFT JOIN STOCKS S ON S.STOCK_ID = PO.STOCK_ID 
        LEFT JOIN PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID 
    WHERE
        W.EMP_ID LIKE (<cfqueryparam cfsqltype="cf_sql_varchar" value=",%#session.ep.userid#%,">) 
        AND (PO.IS_GROUP_LOT = 0 OR PO.IS_GROUP_LOT IS NULL)
        AND PO.IS_STAGE IS NOT NULL
        <cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
        AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
        AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
        <cfelseif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
            AND START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
        </cfif>
</cfquery>

<cfset _p_order_id_list_ = ValueList(get_production_orders_lots.P_ORDER_ID,',')>
<cfset _p_order_number_list_ = listdeleteduplicates(valuelist(get_production_orders_lots.TOPLU_URETIM,','))>

<cfset attributes.lot_no=#get_production_orders_lots.lot_no#>

<cfquery name="GET_WORKSTATION" datasource="#dsn3#">
        SELECT 
            W.STATION_ID,
            W.EMP_ID,
            W.STATION_NAME
        FROM 
            WORKSTATIONS W 
            LEFT JOIN PRODUCTION_ORDERS PO ON PO.STATION_ID = W.STATION_ID
        WHERE
            PO.STATION_ID IS NOT NULL AND 
            PO.IS_STAGE IS NOT NULL AND
            W.EMP_ID LIKE (<cfqueryparam cfsqltype="cf_sql_varchar" value=",%#session.ep.userid#%,">)
            GROUP BY W.STATION_ID,
            W.EMP_ID,
            W.STATION_NAME
        
</cfquery>
<cfif get_production_orders_lots.recordcount gt 0>
<cfquery name="get_lot_count" dbtype="query">
    SELECT DISTINCT 
        LOT_NO
    FROM 
        get_production_orders_lots
</cfquery>
</cfif>
<cfquery name="GET_ASSET_STATION" datasource="#DSN#">
    
    SELECT 
    RPAS.*,
    W.STATION_ID,
    
    W.EMP_ID
    FROM  RELATION_PHYSICAL_ASSET_STATION RPAS
    LEFT JOIN #DSN3#.WORKSTATIONS W  ON W.STATION_ID = RPAS.STATION_ID
    WHERE
    W.EMP_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ep.userid#%">
        
</cfquery>
<cfquery name="LOCAL.Children"  datasource="#dsn#">
    SELECT
    *,
    CASE 
        WHEN EMPLOYEES.PHOTO IS NOT NULL AND LEN(EMPLOYEES.PHOTO) > 0 
            THEN '/documents/hr/'+EMPLOYEES.PHOTO 
        WHEN EMPLOYEES.PHOTO IS NULL AND EMPLOYEES_DETAIL.SEX = 0
            THEN  '/images/female.jpg'
    ELSE '/images/male.jpg' END AS PHOTOS
    FROM
    EMPLOYEE_POSITIONS
    INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
    INNER JOIN EMPLOYEES_DETAIL ON EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
    WHERE
    EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
    AND
    (
        EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = #session.ep.position_code#
        OR
        EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = #session.ep.position_code#
    )
    AND EMPLOYEES.EMPLOYEE_STATUS = 1
    AND POSITION_STATUS = 1
    ORDER BY
    EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
    EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
</cfquery>
<cfparam name="attributes.tab" default="1">
<cfparam name="attributes.subtab" default="1">
<cfparam name="attributes.userno" default="">
<div class="flowcard">
    <h4 class="flowcard-header">
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.welcome"><img src="images/helpdesklogo.png" title="Homepage"/></a>
        <label class="flowlabel bold" onclick="location.href = '<cfoutput>#request.self#?fuseaction=production.order_lot</cfoutput>'" id="production"><i class="fa fa-gears"></i><i><cf_get_lang dictionary_id="65418.Lot Bazında Emirler"></i></label>
        <label class="flowlabel bold" onclick="location.href = '<cfoutput>#request.self#?fuseaction=stock.list_quality_controls</cfoutput>&tab=2'" id="quality"><i class="fa fa-thumbs-up"></i><i><cf_get_lang dictionary_id="45359.Üretim Emirleri"></i></label>
        <label class="flowlabel bold" onclick="location.href = '<cfoutput>#request.self#?fuseaction=stock.list_stock</cfoutput>'" id="stocks"><i class="fa fa-cubes"></i><i><cf_get_lang dictionary_id="58166.Stoklar"></i></label>
        <label class="flowlabel bold" onclick="location.href = '<cfoutput>#request.self#?fuseaction=assetcare.list_asset_failure</cfoutput>'" id="failure" style="border-right:none !important;"><i class="fa fa-wrench"></i><i><cf_get_lang dictionary_id="35985.Arızalar"></i></label>
        <label class="flowlabel bold" style="float: right; margin-top:15px !important;">
            <div class="portHeadLightMenu">
                <ul>
                    <li>
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.welcome"><i class="fa fa-home"></i></a>
                    </li>
                </ul>
            </div>
        </label>
    </h4>
    <div class="flowcard-body col col-12 scrollbar" id="flowcard-body">
    </div>
</div>
    <cf_box  box_style="maxi">
        <div class="op_item_detail">
            <div class="op_item_detail_info">				
                <div class="op_item_detail_img">
                    <cfoutput><cfif len(detail_emp.photo)><img src="/documents/hr/#detail_emp.photo#"><cfelse><img src="/images/maleicon.jpg"></cfif></cfoutput>
                </div>
                <cfoutput>
                    <div class="op_item_detail_left">
                        <h1 class="op_detail_content_title">#session.ep.name# #session.ep.surname#</h1>
                        <h3 style="margin:0;">#session.ep.position_name#</h3>
                    </div>
                     <cfif get_production_orders_lots.recordcount> 
                        <div class="blog_detail flex-col">
                            <div class="op_item_detail_right">
                                <div class="op_item_detail_busy">
                                    <div class="op_item_detail_svg">
                                        <div class="op_item_detail_svg_icon"><label><cf_get_lang dictionary_id='57123.Emir'></label>
                                            <div class="op_item_detail_circle">
                                                <div class="op_item_detail_circle_item"><p><a href="javascript://">#get_production_orders_lots.recordcount#</a></p></div>
                                            </div>
                                        </div>
                                        <div class="op_item_detail_svg_icon"><label><cf_get_lang dictionary_id='40415.Lot-Parti'></label>
                                            <div class="op_item_detail_circle">
                                                <div class="op_item_detail_circle_item"><p><a href="javascript://" ><cfif isdefined("get_lot_count.recordCount")>#get_lot_count.recordCount#<cfelse>0</cfif></a></p></div>
                                            </div>
                                        </div>
                                        <div class="op_item_detail_svg_icon"><label><cf_get_lang dictionary_id='58834.İstasyon'></label>
                                            <div class="op_item_detail_circle">
                                                <div class="op_item_detail_circle_item"><p><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=production.popup_list_workstation</cfoutput>')">#GET_WORKSTATION.recordcount#</a></p></div>
                                            </div>
                                        </div>
                                        <div class="op_item_detail_svg_icon"><label><cf_get_lang dictionary_id='62973.Ekipman'></label>
                                            <div class="op_item_detail_circle">
                                                <div class="op_item_detail_circle_item" ><p><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=production.physical_assets_orders</cfoutput>')">#GET_ASSET_STATION.RECORDCOUNT#</a></p></div>
                                            </div>
                                        </div>
                                        <div class="op_item_detail_svg_icon"><label><cf_get_lang dictionary_id='49364.Ekip'></label>
                                            <div class="op_item_detail_circle">
                                                <div class="op_item_detail_circle_item" ><p><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=production.list_production_team</cfoutput>')">#LOCAL.Children.recordcount#</a></p></div>
                                            </div>
                                        </div>
                                    </div>									
                                </div>
                            </div>
                        </div>
                     </cfif> 
                </cfoutput>
            </div>
        <br/>
        <div style="padding-bottom:10px;display:flex;">
            <div class="bold" style="display:flex;flex:1;align-items:center;font-size:21px;">
                <cfoutput>
                    <cfif attributes.list_type eq 1>
                        #DateFormat(attributes.startdate,dateformat_style)#
                    <cfelseif attributes.list_type eq 2>
                        #DateFormat(attributes.startdate,dateformat_style)# - 
                        #DateFormat(attributes.finishdate,dateformat_style)#
                    <cfelseif attributes.list_type eq 3>
                        <cfquery name="get_tr" datasource="#dsn#">
                            SELECT DISTINCT ITEM_TR FROM SETUP_LANGUAGE_TR WHERE ITEM_ENG='#DateFormat(attributes.startdate,"mmmmmmmmmmmm")#'
                        </cfquery>
                        #DateFormat(attributes.startdate,'yyyy')# - 
                        <cfif get_tr.recordCount gt 0>#get_tr.ITEM_TR#<cfelse>#DateFormat(attributes.startdate,"mmmmmmmmmmmm")#</cfif>
                    </cfif>
                </cfoutput>
            </div>
            <div style="display: flex;align-items: center;"> 
                <div class="days" style="display:flex;align-items:center;">
                    <cfoutput>
                        <div class="arrows" style="text-align:right;">
                            <a href="#request.self#?fuseaction=production.order_operator&list_type=#attributes.list_type#&part=#attributes.part-1#"><i class="fa fa-arrow-circle-left"></i></a>
                        </div> 
                        <div class="days1">
                            <a href="#request.self#?fuseaction=production.order_operator&list_type=1&part=1"><cf_get_lang dictionary_id="57490.Gün"></a>
                        </div> 
                        <div class="days2"> 
                            <a href="#request.self#?fuseaction=production.order_operator&list_type=2&part=1"><cf_get_lang dictionary_id="58734.Hafta"></a>
                        </div> 
                        <div class="days3">
                            <a href="#request.self#?fuseaction=production.order_operator&list_type=3&part=1"><cf_get_lang dictionary_id="58724.Ay"></a>
                        </div> 
                        <div class="arrows">
                            <a href="#request.self#?fuseaction=production.order_operator&list_type=#attributes.list_type#&part=#attributes.part+1#"><i class="fa fa-arrow-circle-right arrows"></i></a>
                        </div>
                    </cfoutput>
                </div>
            </div>
        </div>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="90" class="text-left"></th>
                    <th width="150"><cf_get_lang dictionary_id='29474.Emir No'></th>
                    <th><cf_get_lang dictionary_id='34120.Ürün-İşlem'></th>
                    <th width="80"></th>
                    <th class="text-center" width="200"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th class="text-center" width="110"><cf_get_lang dictionary_id='40551.Termin'></th>
                    <th class="text-center" width="350"><cf_get_lang dictionary_id='57692.İşlem'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_production_orders_lots.recordcount>
                    <cfoutput query="get_production_orders_lots">
                        <cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
                            SELECT 					
                                PI.PATH,
                                P.PRODUCT_NAME,
                                PI.PATH_SERVER_ID,
                                PU.PRODUCT_ID,
                                PU.PRODUCT_ID,
                                PU.MAIN_UNIT_ID,
                                PU.MAIN_UNIT,
                                PU.PRODUCT_UNIT_STATUS	
                            FROM 
                                PRODUCT_IMAGES AS PI 
                                LEFT JOIN PRODUCT P ON P.PRODUCT_ID = PI.PRODUCT_ID
                                LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_ID = P.PRODUCT_ID
                            WHERE 
                                PI.PRODUCT_ID = #PRODUCT_ID# AND 
                                PU.PRODUCT_UNIT_STATUS = 1
                        </cfquery>
                        <cfquery name="GET_RESULTS" datasource="#DSN3#">
                            SELECT 					
                                PR_ORDER_ID	
                            FROM 
                                PRODUCTION_ORDER_RESULTS
                            WHERE
                                P_ORDER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#p_order_id#">
                        </cfquery>
                        <cfquery name="GET_DET_PRO" datasource="#dsn3#">
                            SELECT 
                                PR.PRODUCT_ID,
                                PR.STOCK_ID,
                                P.PRODUCT_ID,
                                P.PRODUCT_NAME,
                                P.PRODUCT_CODE,
                                P_I.PATH,
                                PR.AMOUNT,
                                PU.PRODUCT_ID,
                                PU.MAIN_UNIT,
                                S.STOCK_ID AS STOCK_ID_MAIN
                            FROM
                                PRODUCT_TREE PR
                                LEFT JOIN PRODUCT P ON P.PRODUCT_ID = PR.PRODUCT_ID 
                                LEFT JOIN PRODUCT_IMAGES P_I ON P_I.PRODUCT_ID = P.PRODUCT_ID 
                                LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_ID =P.PRODUCT_ID 
                                LEFT JOIN STOCKS S ON S.PRODUCT_ID =P.PRODUCT_ID 
                            WHERE 
                                PR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
                                and 
                                PR.PRODUCT_ID IS NOT NULL
                        </cfquery>
                        <cfif len(STOCKS_JSON)><cfset get_stock_ids=deserializeJSON(STOCKS_JSON)></cfif>
                    <cfparam  name="attributes.production_order_result" default="1">
                        <tr>
                            <td class="text-center" width="80">
                                <cfif len(GET_PRODUCT_IMAGES.PATH)>
                                    <img src="documents/product/#GET_PRODUCT_IMAGES.PATH#" width="70" height="70">
                                <cfelse>
                                    <img src="../images/production/no-image.png" width="70" height="70">
                                </cfif>
                            </td>
                            <cfsavecontent variable="production_detail_info">&event=upd&p_order_no=#TOPLU_URETIM#&lot_no=#lot_no#&station_id=#STATION_ID# </cfsavecontent>
                            <input type="hidden" value="#production_detail_info#" id="#lot_no#" name="#lot_no#">
                            <td class="text-left">#TOPLU_URETIM#<br/><cf_get_lang dictionary_id='38869.Lot'>:#lot_no#</td>
                            <td>#product_NAME#</td>
                            <td class="text-center"><cf_workcube_barcode show="1" type="qrcode" width="70" height="70" value="#TOPLU_URETIM#/#lot_no#"></td>
                            <td class="text-center" style="padding-bottom: 40px;">#QUANTITY# #GET_PRODUCT_IMAGES.MAIN_UNIT#</td>
                            <td class="text-center">
                                <cfif datediff("d",now(),finish_date) lte 0 and datediff("y",now(),finish_date) lte 0 and datediff("d",now(),finish_date)  lte 0>
                                    <span href="javascript://" style="color:##555!important;font-size: 20px;">#dateformat(finish_date,dateformat_style)#<br/>#TimeFormat(finish_date,'HH')#:#TimeFormat(finish_date,'MM')# <br/><i class="fa fa-frown-o text-center" style="color:red!important;"></i></span>
                                <cfelse>
                                    <span href="javascript://" style="color:##555!important;font-size: 20px;">#dateformat(finish_date,dateformat_style)#<br/>#TimeFormat(finish_date,'HH')#:#TimeFormat(finish_date,'MM')# <br/><i class="fa fa-smile-o text-center" style="color:##FFAB00!important;"></i></span>
                                </cfif>
                            </td>
                            <td align="right">
                            <ul class="dana-btn-list">
                                <li>
                                    <cfif IS_STAGE neq 5 AND IS_STAGE neq 4 >
                                        <a style="background-color:<cfif len(STOCKS_JSON) and GET_DET_PRO.recordCount eq StructCount(get_stock_ids)>##00b046<cfelse>##ffa72d</cfif>" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=prod.popup_production_control&p_order_id=#p_order_id#&stock_id=#STOCK_ID#&list_type=#attributes.list_type#&part=#attributes.part#')" title="<cf_get_lang dictionary_id='330.Kontrol Edildi'>!"><i class="fa fa-puzzle-piece"></i><cfoutput></cfoutput></a>
                                    <cfelseif IS_STAGE eq 5>
                                        <a style="background-color:##f80306" href="javascript://"  onclick="openBoxDraggable('#request.self#?fuseaction=prod.popup_production_control&p_order_id=#p_order_id#&stock_id=#STOCK_ID#&list_type=#attributes.list_type#&part=#attributes.part#')" title="<cf_get_lang dictionary_id='63918.Kontrol Edilmedi'>!"><i class="fa fa-puzzle-piece" ></i><cfoutput></cfoutput></a>
                                    <cfelse>
                                        <a href="javascript://"  onclick="openBoxDraggable('#request.self#?fuseaction=prod.popup_production_control&p_order_id=#p_order_id#&stock_id=#STOCK_ID#&list_type=#attributes.list_type#&part=#attributes.part#')" title=""><i class="fa fa-puzzle-piece" ></i><cfoutput></cfoutput></a>
                                    </cfif>
                                </li>
                                <li>
                                    <cfif IS_STAGE eq 1 or IS_STAGE eq 2 or IS_STAGE eq 0>
                                        <a style="background-color:##00b046" href="javascript://" title="<cf_get_lang dictionary_id='38037.Başladı'>!"><i class="fa fa-play" ></i><cfoutput></cfoutput></a>
                                    <cfelse>
                                        <a href="javascript://" <cfif (IS_STAGE eq 6 or IS_STAGE eq 3) and (len(STOCKS_JSON) and GET_DET_PRO.recordCount eq StructCount(get_stock_ids))>onclick="openBoxDraggable('#request.self#?fuseaction=prod.popup_production_start&p_order_id=#p_order_id#','','ui-draggable-box-small')"</cfif> title="<cf_get_lang dictionary_id='38037.Başladı'>!"><i class="fa fa-play"></i><cfoutput></cfoutput></a>
                                    </cfif>
                                </li>
                                <li>
                                    <cfquery name="GET_PRODUCTION_OPERATIONS" datasource="#DSN3#">
                                        SELECT
                                            (PO.AMOUNT-ISNULL((SELECT SUM(POR.REAL_AMOUNT) FROM PRODUCTION_OPERATION_RESULT POR WHERE POR.OPERATION_ID = PO.P_OPERATION_ID AND POR.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#p_order_id#">),0)) AMOUNT
                                        FROM
                                            PRODUCTION_OPERATION PO
                                        WHERE
                                            PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#p_order_id#">
                                        ORDER BY
                                            PO.P_OPERATION_ID DESC
                                    </cfquery>
                                    <cfif GET_PRODUCTION_OPERATIONS.recordCount gt 0>
                                        <cfquery name="get_amount" dbtype="query"> 
                                        SELECT
                                            SUM(AMOUNT) AMOUNT             
                                        FROM
                                            GET_PRODUCTION_OPERATIONS
                                        </cfquery>
                                    </cfif>
                                    <cfif IS_STAGE eq 0 or IS_STAGE eq 2>
                                    <a href="javascript://" style="background-color:<cfif  isdefined('get_amount.amount') and get_amount.amount gt 0>##ffa72d<cfelse>##00b046</cfif>"  title="#getLang('','','57777')#" onclick="openBoxDraggable('#request.self#?fuseaction=prod.production_result_operations&p_order_id=#p_order_id#&stock_id=#STOCK_ID#&list_type=#attributes.list_type#&part=#attributes.part#&seperator_order_id=#attributes.seperator_order_id#','','ui-draggable-box-large')"  title="<cf_get_lang dictionary_id='36891.Operatöre Gönderildi'>!"><i class="fa fa-gears"></i><cfoutput></cfoutput></a>
                                    <cfelse>
                                    <a href="javascript://" <cfif IS_STAGE eq 1>onclick="openBoxDraggable('#request.self#?fuseaction=prod.production_result_operations&p_order_id=#p_order_id#&stock_id=#STOCK_ID#&list_type=#attributes.list_type#&part=#attributes.part#&seperator_order_id=#attributes.seperator_order_id#','','ui-draggable-box-large')"</cfif>  title="<cf_get_lang dictionary_id='36891.Operatöre Gönderildi'>!"><i class="fa fa-gears"></i><cfoutput></cfoutput></a>
                                    </cfif>
                                    </li>
                                <li>
                                    <cfif IS_STAGE eq 2>
                                        <a style="background-color:##f80306" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=prod.popup_<cfif GET_RESULTS.recordCount>upd_</cfif>production_result&list_type=#attributes.list_type#&part=#attributes.part#&p_order_id=#p_order_id#&stock_id=#STOCK_ID#&seperator_order_id=#attributes.seperator_order_id#','','ui-draggable-box-large')" title="<cf_get_lang dictionary_id='38038.Bitti'>!"><i class="fa fa-flag"></i><cfoutput></cfoutput></a>
                                    <cfelse>
                                        <a href="javascript://" <cfif IS_STAGE eq 0 and isdefined("get_amount.amount") and get_amount.amount lte 0>onclick="openBoxDraggable('#request.self#?fuseaction=prod.popup_<cfif GET_RESULTS.recordCount>upd_</cfif>production_result&p_order_id=#p_order_id#&stock_id=#STOCK_ID#&list_type=#attributes.list_type#&part=#attributes.part#&seperator_order_id=#attributes.seperator_order_id#','','ui-draggable-box-large')"</cfif> title="<cf_get_lang dictionary_id='38038.Bitti'>!"><i class="fa fa-flag"></i><cfoutput></cfoutput></a>
                                    </cfif>
                                </li>
                                <li>
                                    <cfif IS_STAGE eq 3>
                                        <a style="background-color:##0d9bd5" href="javascript://" title="<cf_get_lang dictionary_id='38117.Üretim Durdu(Arıza)'>"><i class="fa fa-stop"></i><cfoutput></cfoutput></a>
                                    <cfelse>
                                        <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=prod.popup_production_start&p_order_id=#p_order_id#&production_order_result=#attributes.production_order_result#','','ui-draggable-box-small')" title="<cf_get_lang dictionary_id='38117.Üretim Durdu(Arıza)'>"> <i class="fa fa-stop"></i><cfoutput></cfoutput></a>
                                    </cfif>
                                </li>
                                <li><a title="<cf_get_lang dictionary_id='57474.Yazdır'>" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#p_order_id#&action=prod.order','WOC')"><i class="fa fa-print"></i></a></li>
                                </ul>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="color-row" height="20">
                        <td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </div>
    </cf_box>
<script>
    $('.header'). remove();
</script>