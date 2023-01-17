<cfif isdefined("attributes.measurement_name") and len(attributes.measurement_id) and isdefined("attributes.measurement_id") and len(attributes.measurement_id)>
    <cfquery name="UPD_PARAMETER" datasource="#DSN#" >
        UPDATE 
            MEASUREMENT_PARAMETERS
        SET 
            MEASUREMENT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.measurement_name#">
        WHERE
            MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.measurement_id#">
    </cfquery>
    <cfif isdefined("attributes.measurement_row") and len(attributes.measurement_row)>
        <cfset attributes.measurement_row = listLast(attributes.measurement_row)>
        <cfloop index = "kk" from = "1" to = "#attributes.measurement_row#">
            <cfif(isdefined("attributes.satir#kk#") and evaluate("attributes.satir#kk#") eq 1)>
                <cfif isDefined("attributes.measurement_row_id#kk#")>
                    <cfquery name="CONTROL_PARAMETER" datasource="#DSN#" >   
                        SELECT * FROM MEASUREMENT_PARAMETERS_ROWS WHERE  ROW_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("attributes.measurement_row_id#kk#")#">
                    </cfquery>
                <cfelse>
                    <cfset CONTROL_PARAMETER.recordCount = 0>
                </cfif>
                <cfif CONTROL_PARAMETER.recordCount gt 0  and isDefined("attributes.measurement_row_id#kk#")>
                    <cfquery name="UPD_PARAMETERS_ROWS" datasource="#DSN#" >   
                        UPDATE
                            MEASUREMENT_PARAMETERS_ROWS
                        SET
                            UNIT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("attributes.MEASUREMENT_ROW_NAME#kk#")#">
                            ,SHORT_UNIT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("attributes.SHORT_MEASUREMENT_NAME#kk#")#">
                            ,MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.measurement_id#">
                        WHERE 
                            ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.measurement_row_id#kk#")#">
                    </cfquery>
                <cfelse>
                    <cfquery name="ADD_PARAMETER" datasource="#DSN#" >   
                        INSERT INTO 
                        MEASUREMENT_PARAMETERS_ROWS
                        (
                            UNIT_NAME
                            ,SHORT_UNIT_NAME
                            ,MEASUREMENT_ID
                        )
                        VALUES                    
                        (
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("attributes.MEASUREMENT_ROW_NAME#kk#")#">
                            ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("attributes.SHORT_MEASUREMENT_NAME#kk#")#">
                            ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.measurement_id#">
                        )
                    </cfquery>
                </cfif>
            <cfelseif (isdefined("attributes.satir#kk#") and evaluate("attributes.satir#kk#") eq 0)>
               <cfquery name="DEL_PARAMETER" datasource="#DSN#" >  
                    DELETE FROM MEASUREMENT_PARAMETERS_ROWS WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.measurement_row_id#kk#")#">
               </cfquery>
            </cfif>
        </cfloop>
    </cfif>
</cfif>