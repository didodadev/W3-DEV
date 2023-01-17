<cfif (isdefined("attributes.event") and attributes.event is 'det') or not isdefined("attributes.event")>
	<!--- Sayfa kısıtına ilişkin kod --->
	<cfset page_name = "prod.graph_gant">
    <cfquery name="get_defined_page" datasource="#dsn#">
        SELECT DISTINCT DENIED_PAGE, DENIED_TYPE FROM EMPLOYEE_POSITIONS_DENIED WHERE DENIED_PAGE = '#page_name#'
    </cfquery>
    <cfif get_defined_page.recordcount gt 0>
        <cfquery name="get_page_access_and_denied" datasource="#dsn#">
            SELECT DISTINCT
                EP.EMPLOYEE_ID,
                EPD.DENIED_TYPE,
                EPD.IS_VIEW,
                EPD.IS_INSERT,
                EPD.IS_DELETE
            FROM
                EMPLOYEE_POSITIONS_DENIED EPD,
                EMPLOYEE_POSITIONS EP
            WHERE
                EPD.DENIED_PAGE = '#page_name#' AND
                EPD.DENIED_TYPE = #get_defined_page.DENIED_TYPE# AND
                EP.EMPLOYEE_ID = #session.ep.userid# AND
                (
                    EP.POSITION_CAT_ID = EPD.POSITION_CAT_ID OR
                    EP.POSITION_CODE = EPD.POSITION_CODE OR
                    EP.USER_GROUP_ID = EPD.USER_GROUP_ID
                )
                <cfif get_defined_page.DENIED_TYPE eq 1>
                    AND (EPD.IS_VIEW = 1 AND EPD.IS_INSERT = 1)
                <cfelse>
                    AND (EPD.IS_VIEW = 1 OR EPD.IS_INSERT = 1)
                </cfif>
        </cfquery>
        <cfif get_defined_page.DENIED_TYPE eq 1 and get_page_access_and_denied.recordcount gt 0 or get_defined_page.DENIED_TYPE eq 0 and get_page_access_and_denied.recordcount eq 0>
            <cfset display_mode = 0>
        <cfelse>
            <cfset display_mode = 1>
        </cfif>
    <cfelse>
        <cfset display_mode = 0>
    </cfif>
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'det') or not isdefined("attributes.event")>
	<script src="/js/jquery-1_7_1_min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function getCSSColors()
        {
            try
            {
                var bg_color = $("#color_list").length != null ? rgbToHex($("#color_list").css("background-color")): "";
                var border_color = $("#color_border").length != null ? rgbToHex($("#color_border").css("background-color")): "";
                var flashObj = document.production_plan_graph ? document.production_plan_graph: document.getElementById("production_plan_graph");
                if (flashObj) flashObj.applyCSS(bg_color, border_color);
            } catch (e) { }
        }
        
        function rgbToHex(value)
        {
            if (value.search("rgb") == -1)
                return value;
            else {
                value = value.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
                function hex(x) {
                    return ("0" + parseInt(x).toString(16)).slice(-2);
                }
                return "#" + hex(value[1]) + hex(value[2]) + hex(value[3]);
            }
        }
        
        function openConsumerWindow(){
            windowopen('index.cfm?fuseaction=objects.popup_list_all_pars&field_consumer=consumer_info.consumer_id&field_comp_id=consumer_info.company_id&field_member_name=consumer_info.member_name&select_list=7,8&call_function=handlerConsumerSelection()','list');
        }
        
        function handlerConsumerSelection(){
            var consumerID = $.trim($("#consumer_info #consumer_id").val());
            var companyID = $.trim($("#consumer_info #company_id").val());
            var consumerName = $.trim($("#consumer_info #member_name").val());
            
            var flashObj = document.production_plan_graph ? document.production_plan_graph: document.getElementById("production_plan_graph");
            if (flashObj){
                flashObj.setConsumerInfo(companyID != null && companyID.length != 0 ? companyID: consumerID, companyID != null && companyID.length != 0, consumerName);
            } else {
                alert("Flash nesnesi bulunamadı!");
            }
        }
    </script>
</cfif>  

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'det';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'prod.graph_gant';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'production_plan/display/graph.cfm';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '';

	WOStruct['#attributes.fuseaction#']['det']['default'] = 1;		
	
</cfscript>
