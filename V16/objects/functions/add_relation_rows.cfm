<!--- 
	TEKLİF,SİPARİŞ,İRSALİYE VE FATURA BELGELERİNİN ARALARINDAKİ DÖNÜŞÜMLERDE KULLANILMAK ÜZERE YAZILDI,KOD KİRLİĞİĞİ ÖNLEMEK AÇISINDAN FONKSİYON İLE YAPILDI...
	HANGİ BELGENİN "SATIRI" HANGİ BELGENİN SATIRI İLE İLİŞKİLİ OLDUĞUNU TUTAR...
	M.ER 23 02 2009
 --->
<cffunction name="add_relation_rows" returntype="boolean" output="false">
	<cfargument name="action_type" type="string" required="yes" default="add"><!--- add or del --->
	<cfargument name="to_table" type="string" required="no">
    <cfargument name="from_table" type="string" required="no">
    <cfargument name="to_wrk_row_id" type="string" required="no">
    <cfargument name="from_wrk_row_id" type="string" required="no">
    <cfargument name="amount" type="numeric" required="no">
    <cfargument name="to_action_id" type="numeric" required="no">
    <cfargument name="from_action_id" type="numeric" required="no">
    <cfargument name="action_dsn" type="string" required="no" default="#dsn3#">
    	<cfif arguments.action_type is 'add'>
            <cfquery name="ADD_PAPER_ROW_TO_PAPER_ROW" datasource="#action_dsn#">
                INSERT INTO 
                   #dsn3_alias#.RELATION_ROW
                    (
                        PERIOD_ID,
                        TO_TABLE,
                        FROM_TABLE,
                        TO_WRK_ROW_ID,
                        FROM_WRK_ROW_ID,
                        TO_AMOUNT,
                        TO_ACTION_ID,
                        FROM_ACTION_ID
                    )
                    VALUES
                    (
                        #session.ep.period_id#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.to_table#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.from_table#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.to_wrk_row_id#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.from_wrk_row_id#">,
                        #arguments.amount#,
                        #arguments.to_action_id#,
                        #arguments.from_action_id#
                    )
            </cfquery>
        <cfelseif arguments.action_type is 'del'>
            <cfquery name="DEL_RELATION_PAPERS_ROW" datasource="#action_dsn#">
                DELETE FROM  #dsn3_alias#.RELATION_ROW WHERE TO_ACTION_ID = #arguments.to_action_id# AND TO_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.to_table#"> AND
				<cfif isdefined('session.ep.period_id')>
					PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfelse>
					PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#">
				</cfif>
            </cfquery>
		</cfif>
	<cfreturn true>
</cffunction>

