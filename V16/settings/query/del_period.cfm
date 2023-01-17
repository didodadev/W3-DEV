<cflock timeout="60">
	<cftransaction>
        <cfquery name="get_period" datasource="#dsn#">
            SELECT OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
        </cfquery>
        
		<cfquery name="DEL_PERIOD" datasource="#dsn#">
			DELETE FROM SETUP_PERIOD WHERE PERIOD_ID=#attributes.PERIOD_ID#
		</cfquery>
		<cfquery name="DEL_PERIOD" datasource="#dsn#">
			DELETE FROM SETUP_MONEY	WHERE PERIOD_ID=#attributes.PERIOD_ID#
		</cfquery>
        
		<cfquery name="GET_COMPANY_PERIODS" datasource="#dsn#">
            SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #get_period.our_company_id#
        </cfquery> 
	<cf_add_log  log_type="-1" action_id="#attributes.period_id#" action_name="#attributes.head# ">
    </cftransaction>  
    <cftransaction>    
        <cfquery name="drop_view" datasource="#dsn#_#get_period.our_company_id#">
            IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GET_ALL_INVOICE_ROW]'))
                DROP VIEW [GET_ALL_INVOICE_ROW]
        </cfquery>

		<cfif get_company_periods.recordcount>
            <cfquery name="cr_view" datasource="#dsn#_#get_period.our_company_id#">
                CREATE VIEW [GET_ALL_INVOICE_ROW] AS
                <cfloop query="GET_COMPANY_PERIODS">
                    SELECT
                        INVOICE_ID,
                        WRK_ROW_RELATION_ID,
                        AMOUNT
                    FROM
                        #dsn#_#get_company_periods.period_year#_#get_period.our_company_id#.INVOICE_ROW
                    WHERE
                        INVOICE_ID IN(SELECT S.INVOICE_ID FROM #dsn#_#get_company_periods.period_year#_#get_period.our_company_id#.INVOICE S WHERE ISNULL(S.IS_IPTAL,0) = 0)
                    <cfif currentrow neq get_company_periods.recordcount> UNION</cfif>
                </cfloop>
            </cfquery>
        </cfif>
        
        <cfquery name="drop_view" datasource="#dsn#_#get_period.our_company_id#">
            IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GET_ALL_SHIP_ROW]'))
                DROP VIEW [GET_ALL_SHIP_ROW]
        </cfquery>
        <cfif get_company_periods.recordcount>
            <cfquery name="cr_view" datasource="#dsn#_#get_period.our_company_id#">
                CREATE VIEW [GET_ALL_SHIP_ROW] AS
                    <cfloop query="GET_COMPANY_PERIODS">
                        SELECT
                            SHIP_ID,
                            WRK_ROW_RELATION_ID,
                            WRK_ROW_ID,
                            AMOUNT
                        FROM
                            #dsn#_#get_company_periods.period_year#_#get_period.our_company_id#.SHIP_ROW
                        WHERE
                            SHIP_ID IN(SELECT S.SHIP_ID FROM #dsn#_#get_company_periods.period_year#_#get_period.our_company_id#.SHIP S WHERE ISNULL(S.IS_SHIP_IPTAL,0) = 0)
                        <cfif currentrow neq get_company_periods.recordcount> UNION</cfif>
                    </cfloop>
            </cfquery>		
        </cfif>	
	</cftransaction>
    
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_period" addtoken="no">
