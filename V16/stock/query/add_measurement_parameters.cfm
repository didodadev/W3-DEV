<cfif isdefined("attributes.measurement_name") and len(attributes.measurement_name)>
    <cfquery name="ADD_PARAMETER" datasource="#DSN#" result="MAX_ID" >
        INSERT INTO MEASUREMENT_PARAMETERS
        (
            MEASUREMENT_NAME
        )
        VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.measurement_name#">
        )
    </cfquery>
    <cfif isdefined("attributes.measurement_row") and len(attributes.measurement_row)>
        <cfset attributes.measurement_row = listLast(attributes.measurement_row)>
        <cfloop index = "kk" from = "1" to = "#attributes.measurement_row#">
            <cfif(isdefined("attributes.satir#kk#") and evaluate("attributes.satir#kk#") eq 1)>
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
                        ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#MAX_ID.IDENTITYCOL#">
                    )
                </cfquery>
            </cfif>
        </cfloop>
    </cfif>
    <cfset attributes.measurement_id = MAX_ID.IDENTITYCOL>
</cfif>
<script type="text/javascript">
    window.location.href="/<cfoutput>#request.self#?fuseaction=stock.measurement_parameters&event=upd&measurement_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>