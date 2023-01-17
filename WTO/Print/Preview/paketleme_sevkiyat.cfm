<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
	SELECT
		SR.SHIP_RESULT_ID,
        SR.SHIP_METHOD_TYPE,
        SR.SERVICE_COMPANY_ID,
		SR.SERVICE_CONSUMER_ID,
        SR.SERVICE_MEMBER_ID,
		SR.SERVICE_CONSUMER_MEMBER_ID,
        SR.ASSETP_ID,
        SR.DELIVER_EMP,
        SR.ASSETP,
        SR.DELIVER_EMP_NAME,
        SR.PLATE,
		SR.PLATE2,
        SR.NOTE,
        SR.SHIP_FIS_NO,
        SR.DELIVER_PAPER_NO,
        SR.REFERENCE_NO,
        SR.OUT_DATE,
        SR.DELIVERY_DATE,
        SR.DELIVER_POS,
        SR.DEPARTMENT_ID,
        SR.SHIP_STAGE,
        SR.COST_VALUE,
        SR.COST_VALUE2,
        SR.CALCULATE_TYPE,
        SR.COMPANY_ID,
        SR.PARTNER_ID,
        SR.CONSUMER_ID,
        SR.IS_TYPE,
        SR.SENDING_ADDRESS,
        SR.SENDING_POSTCODE,
        SR.SENDING_SEMT,
        SR.SENDING_COUNTY_ID,
        SR.SENDING_CITY_ID,
        SR.SENDING_COUNTRY_ID,
        SR.LOCATION_ID,
        SR.RECORD_EMP,
        SR.RECORD_IP,
        SR.RECORD_DATE,
        SR.UPDATE_EMP,
        SR.UPDATE_IP,
        SR.UPDATE_DATE,
        SR.INSURANCE_COMP_ID,
        SR.INSURANCE_COMP_PART,
        SR.DUTY_COMP_ID,
        SR.DUTY_COMP_PARTNER,
        SR.WAREHOUSE_ENTRY_DATE,
        SR.OTHER_MONEY_VALUE,
        SR.OTHER_MONEY,
		SM.SHIP_METHOD,
		SR.DELIVER_EMP_TC
	FROM
		SHIP_RESULT SR,
		#dsn_alias#.SHIP_METHOD SM
	WHERE
		SR.SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND
		SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID AND
		SR.MAIN_SHIP_FIS_NO IS NULL 
</cfquery>
<cfquery name="GET_ROW" datasource="#DSN2#">
    SELECT * FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>
<cfquery name="GET_PROCESS" datasource="#DSN#">
    SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.ship_stage#">
</cfquery>

<cf_woc_header>
    <cf_woc_elements>
        <cf_wuxi id="stage" data="#GET_PROCESS.STAGE#" label="58859" type="cell">

        <cfif len(get_ship_result.partner_id)>
            <cf_wuxi id="caccount" data="#get_par_info(get_ship_result.partner_id,0,1,0)#" label="57519" type="cell">
        <cfelseif len(get_ship_result.consumer_id)>
            <cf_wuxi id="caccount" data="#get_ship_result.consumer_id#" label="57519" type="cell">
	    <cfelse>
            <cf_wuxi id="caccount" data="" label="57519" type="cell">
        </cfif>

        <cfif len(get_ship_result.partner_id)>
            <cf_wuxi id="resemp" data="#get_par_info(get_ship_result.partner_id,0,-1,0)#" label="57578" type="cell">
        <cfelseif len(get_ship_result.consumer_id)>
            <cf_wuxi id="resemp" data="#get_cons_info(get_ship_result.consumer_id,0,0)#" label="57578" type="cell">
        <cfelse>
            <cf_wuxi id="resemp" data="" label="57578" type="cell">
        </cfif>

        <cf_wuxi id="shipmeth" data="#get_ship_result.ship_method#" label="29500" type="cell">

        <cfif len(get_ship_result.service_company_id)>
            <cf_wuxi id="sercom" data="#get_par_info(get_ship_result.service_company_id,1,0,0)#" label="57716" type="cell">
        <cfelse>
            <cf_wuxi id="sercom" data="#get_cons_info(get_ship_result.service_consumer_id,0,0)#" label="57716" type="cell">
        </cfif>

        <cfif len(get_ship_result.service_member_id)>
            <cf_wuxi id="sercomemp" data="#get_par_info(get_ship_result.service_member_id,0,-1,0)#" label="45460" type="cell">
        <cfelse>
            <cf_wuxi id="sercomemp" data="#get_cons_info(get_ship_result.service_consumer_member_id,0,0)#" label="45460" type="cell">
        </cfif>

        <cfif len(get_ship_result.assetp_id)>
            <cfquery name="GET_ASSETP" datasource="#DSN#">
                SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.assetp_id#">
            </cfquery>
            <cf_wuxi id="assetp" data="#get_assetp.assetp#" label="58480" type="cell">
        <cfelse>
            <cf_wuxi id="assetp" data="" label="58480" type="cell">
        </cfif>
        
        <cf_wuxi id="delemp" data="#get_emp_info(get_ship_result.deliver_emp,0,0)#" label="45466" type="cell">
        <cf_wuxi id="shipfis" data="#get_ship_result.ship_fis_no#" label="45458" type="cell">
        <cf_wuxi id="delpapno" data="#get_ship_result.deliver_paper_no#" label="34792" type="cell">
        <cf_wuxi id="resdate" data="#dateformat(get_ship_result.out_date,dateformat_style)#" label="45463" type="cell">
        <cf_wuxi id="deldate" data="#dateformat(get_ship_result.delivery_date,dateformat_style)#" label="57645" type="cell">
        <cf_wuxi id="delemp" data="#get_emp_info(get_ship_result.deliver_pos,0,0)#" label="45470" type="cell">

        <cfif len(get_ship_result.department_id)>
            <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
                SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.department_id#">
            </cfquery>
            <cf_wuxi id="dephead" data="#GET_DEPARTMENT.DEPARTMENT_HEAD#" label="29428" type="cell">
        <cfelse>
            <cf_wuxi id="dephead" data="" label="29428" type="cell">
        </cfif>

        <cf_wuxi id="senaddr" data="#get_ship_result.sending_address#" label="45646" type="cell">
    </cf_woc_elements>
            
    <cf_woc_elements>
        <cf_woc_list>
            <thead>
                <tr>
                    <cf_wuxi label="58138" type="cell" is_row="0" id="wuxi_58138"> 
                    <cf_wuxi label="57742" type="cell" is_row="0" id="wuxi_57742"> 
                    <cf_wuxi label="58733" type="cell" is_row="0" id="wuxi_58733"> 
                    <cf_wuxi label="58723" type="cell" is_row="0" id="wuxi_58723"> 
                    <cf_wuxi label="29500" type="cell" is_row="0" id="wuxi_29500"> 
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_row">
                    <tr id="frm_row#currentrow#">
                        <cfif get_ship_result.is_type neq 2>
                            <cfquery name="GET_SHIP" datasource="#DSN2#">
                                SELECT SHIP_NUMBER FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#">
                            </cfquery>
                        <cfelse>		
                            <cfquery name="GET_SHIP" datasource="#DSN3#">
                                SELECT ORDER_NUMBER SHIP_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#">
                            </cfquery>
                        </cfif>
                        <cfif len(get_ship.ship_number)>
                            <cf_wuxi data="#get_ship.ship_number#" type="cell" is_row="0"> 
                        <cfelse><td>&nbsp;</td></cfif>
                        <cfif len(ship_date)>
                            <cf_wuxi data="#dateformat(ship_date,dateformat_style)#" type="cell" is_row="0"> 
                        <cfelse><td>&nbsp;</td></cfif>
                        <cfif len(deliver_comp)>
                            <cf_wuxi data="#deliver_comp#" type="cell" is_row="0"> 
                        <cfelse><td>&nbsp;</td></cfif>
                        <cfif len(deliver_adress)>
                            <cf_wuxi data="#deliver_adress#" type="cell" is_row="0"> 
                        <cfelse><td>&nbsp;</td></cfif>
                        <cfif len(deliver_type)>
                            <cf_wuxi data="#deliver_type#" type="cell" is_row="0">      
                        <cfelse><td>&nbsp;</td></cfif>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_woc_list>
    </cf_woc_elements>
<cf_woc_footer>