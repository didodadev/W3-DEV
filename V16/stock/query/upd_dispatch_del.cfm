<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
    	<cfif not isDefined("new_dsn2")><cfset new_dsn2 = dsn2></cfif>
        <cfquery name="GET_PROCESS_TYPE_DEL" datasource="#new_dsn2#">
            SELECT 
                PROCESS_TYPE,
                PROCESS_CAT_ID,
                IS_CARI,
                IS_ACCOUNT,
                IS_STOCK_ACTION,
                IS_ACCOUNT_GROUP,
                IS_PROJECT_BASED_ACC,
                IS_COST,
                ACTION_FILE_NAME,
                ACTION_FILE_SERVER_ID,
                ACTION_FILE_FROM_TEMPLATE,
                ISNULL(IS_ADD_INVENTORY,0) IS_ADD_INVENTORY,
                ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
             FROM 
                #dsn3_alias#.SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_CAT_ID = #form.process_cat#
        </cfquery>
        <cfscript>
            is_dept_based_acc = GET_PROCESS_TYPE_DEL.IS_DEPT_BASED_ACC;
        </cfscript>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = "#attributes.upd_id#"
			action_table="SHIP"
			action_column="SHIP_ID"
			is_action_file = 1
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=#attributes.UPD_ID#'
			action_file_name='#get_process_type_del.action_file_name#'
			action_db_type = '#dsn2#'
			is_template_action_file = '#get_process_type_del.action_file_from_template#'>
		<cfquery name="DEL1" datasource="#DSN2#">
			DELETE FROM
				STOCKS_ROW 
			WHERE
				UPD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#"> AND
				PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_number.ship_type#">
		</cfquery>
		<!--- history --->
		<cfinclude template="del_ship_history.cfm">
		<!--- //history --->
		<cfscript>
			//seri no kayitlari silinir
			del_serial_no(
			process_id : attributes.UPD_ID,
			process_cat : GET_NUMBER.SHIP_TYPE, 
			period_id : session.ep.period_id
			);
				
			muhasebe_sil(action_id:attributes.UPD_ID, process_type:form.old_process_type);
		</cfscript>
		<!---  depo sevk ic talep bağlantısı silinir --->
		<cfquery name="DEL5" datasource="#DSN2#">
			DELETE FROM #dsn3_alias#.INTERNALDEMAND_RELATION_ROW WHERE TO_SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		</cfquery>
		<cfquery name="DEL4" datasource="#DSN2#">
			DELETE FROM	SHIP_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#">
		</cfquery>
		<cfquery name="DEL2" datasource="#DSN2#">
			DELETE FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#">
		</cfquery>
		<cfquery name="DEL3" datasource="#DSN2#">
			DELETE FROM	SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#">
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.UPD_ID#" action_name="#attributes.ship_number# Silindi" paper_no="#attributes.ship_number#"  process_type="#get_number.ship_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif not isdefined('attributes.webService')>
	<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type_del.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
		<cfscript>cost_action(action_type:2,action_id:attributes.UPD_ID,query_type:3);</cfscript>
		<script type="text/javascript">
            window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_purchase</cfoutput>";
        </script>
	<cfelse>
		<script type="text/javascript">
            window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_purchase</cfoutput>";
        </script>
	</cfif>
</cfif>
