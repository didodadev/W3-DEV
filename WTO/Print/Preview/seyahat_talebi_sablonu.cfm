<cfif isNumeric(attributes.action_id)>
    <cfset attributes.travel_demand_id = attributes.action_id>
  <cfelse>
    <cfset attributes.travel_demand_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_id,accountKey:'wrk')>
</cfif>

<cfparam name="attributes.employee_id" default="#session.ep.userid#" />
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset GET_TITLES = createObject("component","V16.hr.cfc.get_titles_positions")>
<cfset cmp_branch.dsn = dsn>
<cfset GET_TITLES.dsn = dsn>
<cfset get_demands = createObject("component","V16.myhome.cfc.get_travel_demands")>
<cfset get_travel_demand = get_demands.travel_demands(travel_demand_id : attributes.travel_demand_id)>
<cfif not get_travel_demand.recordcount>
    <cfset hata  = 10>
    <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfscript>
        get_demands = createObject("component","V16.myhome.cfc.get_travel_demands");
        get_demands.dsn = dsn;
        GET_MONEY = get_demands.GET_MONEY();
        get_emp_pos = get_demands.get_emp_pos(position_id : get_travel_demand.emp_position_id);
        get_department = get_demands.get_department(position_code : get_travel_demand.emp_position_id);
        get_stage_name = get_demands.get_stage_name(process_id : get_travel_demand.demand_stage);
        GET_COUNTRY = get_demands.GET_COUNTRY();
        GET_CITY = get_demands.GET_CITY();
    </cfscript>  
    <cfoutput>
        <cf_woc_header>
        <cf_woc_elements>
            <cf_wuxi id="travel-id" data="#attributes.travel_demand_id#" label="55247" type="cell">
            <cf_wuxi id="employee-id" data="#get_emp_info(get_travel_demand.employee_id,0,0)#" label="29514" type="cell">
            <cf_wuxi id="paper_no" data="#get_travel_demand.paper_no#" label="31257" type="cell">
            <cf_wuxi id="position_name" data="#get_emp_pos.position_name#" label="58497" type="cell">
            <cf_wuxi id="department_head" data="#get_department.DEPARTMENT_HEAD#" label="57572" type="cell">
            <cf_wuxi id="place" data="#get_travel_demand.place#" label="60394" type="cell">
            <cf_wuxi id="city" data="#get_travel_demand.city#" label="60395" type="cell">
            <cf_wuxi id="is_top_title_limit" data="#iif(get_travel_demand.is_top_title_limit eq 1,DE('57495'),DE('57496'))#" label="60396" type="cell" data_type="dictionary">
            <cf_wuxi id="top_title_id" data="#iif(len(get_travel_demand.top_title_id),'get_emp_info(get_travel_demand.top_title_id,0,0)',DE(''))#" label="60397" type="cell">
            <cf_wuxi id="task_causes" data="#get_travel_demand.task_causes#" label="29525+34777" type="cell">
            <cfsavecontent  variable="type"><cfif get_travel_demand.travel_type eq 1>60477<cfelseif get_travel_demand.travel_type eq 2>60478<cfelseif get_travel_demand.travel_type eq 3>60479</cfif></cfsavecontent>
            <cf_wuxi id="travel_type" data="#type#" label="59973+58651" type="cell">
            <cfsavecontent  variable="vehicle"><cfif get_travel_demand.travel_vehicle contains 1>60427<cfelseif get_travel_demand.travel_vehicle contains 2>29677+58480<cfelseif get_travel_demand.travel_vehicle contains 3>60429<cfelseif get_travel_demand.travel_vehicle contains 4>60430<cfelseif get_travel_demand.travel_vehicle contains 6>60431<cfelse>34748</cfif></cfsavecontent>
            <cf_wuxi id="travel_vehicle" data="#vehicle#" label="60428" type="cell" data_type="dictionary">
            <cf_wuxi id="project_id" data="#iif(len(get_travel_demand.project_id),'get_project_name(get_travel_demand.project_id)',DE(''))#" label="57416" type="cell">
            <cf_wuxi id="is_departure_fee" data="#iif(get_travel_demand.is_departure_fee eq 1,DE('57495'),DE('57496'))#" label="60422" type="cell" data_type="dictionary">
            <cf_wuxi id="travel_advance_demand_fare" data="#TLFormat(get_travel_demand.travel_advance_demand_fare)# #get_travel_demand.travel_advance_demand_type#" label="31282" type="cell">
            <cf_wuxi id="stage" data="#get_stage_name.stage#" label="58859+57482" type="cell" style="background-color:##eee;border-top:1px solid ##c0c0c0;border-bottom:1px solid ##c0c0c0">
        </cf_woc_elements>
        <cf_woc_elements>
            <cf_woc_list id="aaa">
                <thead>
                    <tr>
                        <cf_wuxi label="58053" type="cell" is_row="0" id="wuxi_58053"> 
                        <cf_wuxi label="57700" type="cell" is_row="0" id="wuxi_57700"> 
                        <cf_wuxi label="48188" type="cell" is_row="0" id="wuxi_48188"> 
                        <cf_wuxi label="60402" type="cell" is_row="0" id="wuxi_60402"> 
                        <cf_wuxi label="55335" type="cell" is_row="0" id="wuxi_55335"> 
                        <cf_wuxi label="60408" type="cell" is_row="0" id="wuxi_60408"> 
                        <cf_wuxi label="60414" type="cell" is_row="0" id="wuxi_60414"> 
                        <cf_wuxi label="57467" type="cell" is_row="0" id="wuxi_57467"> 
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <cf_wuxi data="#dateFormat(get_travel_demand.departure_date,dateformat_style)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#dateFormat(get_travel_demand.departure_of_date,dateformat_style)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#iif(len(get_travel_demand.departure_date) and len(get_travel_demand.departure_of_date),datediff('d',get_travel_demand.departure_date,get_travel_demand.departure_of_date) + 1,DE('0'))#" type="cell" is_row="0"> 
                        <cf_wuxi data="#TLformat(get_travel_demand.fare)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#iif(get_travel_demand.is_vehicle_demand eq 1,DE('57495'),DE('57496'))#" type="cell" data_type="dictionary" is_row="0"> 
                        <cf_wuxi data="#iif(get_travel_demand.is_hotel_demand eq 1,DE('57495'),DE('57496'))#" type="cell" data_type="dictionary" is_row="0"> 
                        <cf_wuxi data="#iif(get_travel_demand.is_visa_requirement eq 1,DE('57495'),DE('57496'))#" type="cell" data_type="dictionary" is_row="0">              
                        <cf_wuxi data="#get_travel_demand.task_detail#" type="cell" is_row="0">              
                    </tr>
                </tbody>
            </cf_woc_list> 
            <cf_woc_list id="bbb">
                <thead>
                    <tr>
                        <cf_wuxi label="58053" type="cell" is_row="0" id="activity_start_date"> 
                        <cf_wuxi label="57700" type="cell" is_row="0" id="activity_finish_date"> 
                        <cf_wuxi label="29465" type="cell" is_row="0" id="activity_fare"> 
                        <cf_wuxi label="57467" type="cell" is_row="0" id="activity_detail"> 
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <cf_wuxi data="#dateFormat(get_travel_demand.activity_start_date,dateformat_style)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#dateFormat(get_travel_demand.activity_finish_date,dateformat_style)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#TLFormat(filternum(get_travel_demand.activity_fare))#" type="cell" is_row="0">                   
                        <cf_wuxi data="#get_travel_demand.activity_detail#" type="cell" is_row="0">                   
                    </tr>
                </tbody>
            </cf_woc_list>                 
            <cf_woc_list id="ccc">
                <thead>
                    <tr>
                        <cf_wuxi label="60427+45410" type="cell" is_row="0" id="flight_departure_date"> 
                        <cf_wuxi label="60427+45408" type="cell" is_row="0" id="flight_departure_of_date"> 
                        <cf_wuxi label="60423" type="cell" is_row="0" id="airfare"> 
                        <cf_wuxi label="57467" type="cell" is_row="0" id="flight_detail"> 
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <cf_wuxi data="#dateFormat(get_travel_demand.flight_departure_date,dateformat_style)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#dateFormat(get_travel_demand.flight_departure_of_date,dateformat_style)#" type="cell" is_row="0"> 
                        <cf_wuxi data="#TLFormat(get_travel_demand.airfare)#" type="cell" is_row="0">                
                        <cf_wuxi data="#get_travel_demand.flight_detail#" type="cell" is_row="0">                
                    </tr>
                </tbody>
            </cf_woc_list>
            <cf_wuxi data="#get_travel_demand.activity_address#" label="58723" type="cell" id="activity_address">
            <cf_wuxi data="#get_travel_demand.activity_website#" label="34867" type="cell" id="activity_website">
        </cf_woc_elements>
        <cf_woc_footer>
    </cfoutput>
</cfif>