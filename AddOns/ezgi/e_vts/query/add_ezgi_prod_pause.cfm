<cfif isdefined('pause_cat')>
	<cfquery name="get_prod_pause" datasource="#dsn3#">
        SELECT     
            ACTION_DATE,
            PROD_PAUSE_ID
        FROM         
            SETUP_PROD_PAUSE
        WHERE  
        	<cfif isdefined('attributes.p_order_id') and len(attributes.p_order_id)>   
            	P_ORDER_ID = #attributes.p_order_id# AND 
            </cfif>
            STATION_ID = #attributes.station_id#AND 
            EMPLOYEE_ID = #attributes.employee_id# AND 
            <cfif isdefined('attributes.operation_id') and len(attributes.operation_id)>
            	OPERATION_ID = #attributes.operation_id# AND 
            </cfif>
            <cfif isdefined('attributes.result_id') and len(attributes.result_id)>
            	OPERATION_RESULT_ID = #attributes.result_id# AND
            </cfif>
            PROD_DURATION IS NULL
    </cfquery>
    <cfif get_prod_pause.recordcount>
		<cfset fark= DateDiff("s", #get_prod_pause.ACTION_DATE#, #now()#)>
        <cfquery name="upd_prod_pause" datasource="#dsn3#">
            UPDATE 
                SETUP_PROD_PAUSE
            SET 
                PROD_DURATION = #fark#
            WHERE
                PROD_PAUSE_ID = #get_prod_pause.PROD_PAUSE_ID#       
        </cfquery>
  	</cfif>      
<cfelse>
    <cfquery name="add_prod_pause" datasource="#dsn3#">
        INSERT INTO 
            SETUP_PROD_PAUSE
            (
            PROD_PAUSE_TYPE_ID, 
            ACTION_DATE,
            <cfif isdefined('attributes.operation_id') and len(attributes.operation_id)>
            	OPERATION_ID, 
            </cfif>
            <cfif isdefined('attributes.result_id') and len(attributes.result_id)>
            	OPERATION_RESULT_ID,
            </cfif>
            EMPLOYEE_ID,
            STATION_ID,
            <cfif isdefined('attributes.p_order_id') and len(attributes.p_order_id)> 
            	P_ORDER_ID,
            </cfif>
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP
            )
        VALUES     
            (
            #prod_pause#,
            #now()#,
            <cfif isdefined('attributes.operation_id') and len(attributes.operation_id)>
            	#attributes.operation_id#,
            </cfif>
            <cfif isdefined('attributes.result_id') and len(attributes.result_id)>
            	#attributes.result_id#,
            </cfif>
            #attributes.employee_id#,
            #attributes.station_id#,
            <cfif isdefined('attributes.p_order_id') and len(attributes.p_order_id)> 
            	#attributes.p_order_id#,
            </cfif>
            #now()#,
            #session.ep.userid#,
            '#cgi.remote_addr#'
            )
    </cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>