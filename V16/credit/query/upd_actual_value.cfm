<cf_date tarih='attributes.action_date'>

    <cfset year = datepart('yyyy',attributes.action_date) >
    <cfset month = datepart('m',attributes.action_date) >
    <cfset day = datepart('d',attributes.action_date) >
    <cfset hour = attributes.hours >
    <cfset minute = attributes.minutes >
    
    <cfset date = CreateDateTime(year,month,day,hour,minute)>
    
    <cfquery name="upd_stockbond" datasource="#dsn3#">
        UPDATE STOCKBONDS SET 
            ACTUAL_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.actual_value#">, 
            OTHER_ACTUAL_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.OTHER_ACTUAL_VALUE#">
        WHERE STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stockbond_id#"> 
    </cfquery>

    <cfif isDefined("attributes.history_id") and len(attributes.history_id)> 
        <cfquery name="upd_history" datasource="#dsn3#">
            UPDATE STOCKBONDS_VALUE_CHANGES 
                SET ACTUAL_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.actual_value#">,
                    OTHER_ACTUAL_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.OTHER_ACTUAL_VALUE#">,
                    DATE = #date#,
                    MONEY_TYPE = '#session.ep.money#',
                    OTHER_MONEY_TYPE = '#attributes.rd_money#'
            WHERE
                HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.history_id#">
        </cfquery>
    <cfelse>
        <!--- güncel değer history --->
        <cfquery name="add_history" datasource="#dsn3#">
            INSERT INTO STOCKBONDS_VALUE_CHANGES
                (
                    STOCKBOND_ID,
                    ACTUAL_VALUE,
                    OTHER_ACTUAL_VALUE,
                    DATE,
                    MONEY_TYPE,
                    OTHER_MONEY_TYPE,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stockbond_id#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.actual_value#">, 
                    <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.OTHER_ACTUAL_VALUE#">,
                    #date#,
                    '#session.ep.money#',
                    '#attributes.rd_money#',
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.REMOTE_ADDR#'
                )
        </cfquery>
    </cfif>
