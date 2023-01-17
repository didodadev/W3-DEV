<cfif isdefined('attributes.giris')><!---Toplu VTS den Geliyorsa--->
    <cfif isdefined('attributes.p_operation_id') and isdefined('attributes.station_id')>
    	<cfquery name="del_employee_station" datasource="#dsn3#">
            DELETE FROM         
                PRODUCTION_OPERATION_RESULT
            WHERE  
                <cfif isdefined('attributes.p_operation_id')>   
                    OPERATION_ID = #attributes.p_operation_id# AND 
                </cfif>
                STATION_ID = #attributes.station_id# AND 
                REAL_AMOUNT = 0 AND 
                ACTION_EMPLOYEE_ID = #attributes.id#
        </cfquery>
    	<cfquery name="get_operation_control" datasource="#dsn3#">
            SELECT * FROM PRODUCTION_OPERATION_RESULT WHERE OPERATION_ID = #attributes.p_operation_id#
        </cfquery>
        <cfif not get_operation_control.recordcount>
            <cfquery name="upd_operation" datasource="#dsn3#">
                UPDATE    
                    PRODUCTION_OPERATION
                SET              
                    STAGE =0
                WHERE     
                    P_OPERATION_ID = #attributes.p_operation_id#
            </cfquery>
        </cfif>
        <cflocation url="#request.self#?fuseaction=production.list_ezgi_collect_production&main_menu=1&type=1" addtoken="No">
    <cfelse>
    	<cfquery name="upd_station_employee" datasource="#dsn3#">
            UPDATE    
                EZGI_STATION_EMPLOYEE
            SET              
                FINISH_DATE = #now()#
            WHERE     
                EMPLOYEE_ID = #attributes.id# AND
                FINISH_DATE IS NULL
        </cfquery>
        <cflocation url="#request.self#?fuseaction=production.list_ezgi_collect_production&main_menu=1&type=4" addtoken="No">
    </cfif>
<cfelse><!--- E-VTS den geliyorsa--->
    <cfquery name="del_employee_station" datasource="#dsn3#">
        DELETE FROM         
            PRODUCTION_OPERATION_RESULT
        WHERE  
            <cfif isdefined('attributes.p_operation_id')>   
                OPERATION_ID = #attributes.p_operation_id# AND 
            </cfif>
            STATION_ID = #attributes.station_id# AND 
            REAL_AMOUNT = 0 AND 
            ACTION_EMPLOYEE_ID = #attributes.employee_id#
    </cfquery>
    <cfif isdefined('attributes.p_operation_id')>  
        <cfquery name="upd_station_employee" datasource="#dsn3#">
            UPDATE    
                EZGI_STATION_EMPLOYEE
            SET              
                FINISH_DATE = #now()#
            WHERE     
                STATION_EMPLOYEE_ID = #attributes.employee_id#
        </cfquery>
        <cfquery name="get_operation_control" datasource="#dsn3#">
            SELECT * FROM PRODUCTION_OPERATION_RESULT WHERE OPERATION_ID = #attributes.p_operation_id#
        </cfquery>
        <cfif not get_operation_control.recordcount>
            <cfquery name="upd_operation" datasource="#dsn3#">
                UPDATE    
                    PRODUCTION_OPERATION
                SET              
                    STAGE =0
                WHERE     
                    P_OPERATION_ID = #attributes.p_operation_id#
            </cfquery>
        </cfif>
    </cfif>
    <script type="text/javascript">
        <cfif isdefined('attributes.production')>
            wrk_opener_reload();
            window.close();
        <cfelse>
            window.location.href='<cfoutput>#request.self#?fuseaction=production.list_ezgi_production_operation&is_form_submitted=1&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#</cfoutput>';
        </cfif>
    </script>
</cfif>