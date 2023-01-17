<cflock name="#CREATEUUID()#" timeout="20">
    <cftransaction>
        <cfquery name="get_stage" datasource="#dsn2#">
            SELECT PROCESS_CAT FROM STOCK_FIS WHERE FIS_ID=#attributes.del_id#
        </cfquery>
        <cfquery name="del_stock_fis_row" datasource="#dsn2#">
            DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #attributes.DEL_ID#
        </cfquery>
        <cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
            DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID=#attributes.DEL_ID#
        </cfquery>
        <cfquery name="DEL_FIS_NUMBER" datasource="#dsn2#">
            DELETE FROM STOCK_FIS WHERE FIS_NUMBER = '#attributes.fis_number_#'
        </cfquery>		
        <cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
            DELETE 
            FROM 
                STOCKS_ROW 
            WHERE 
                PROCESS_TYPE=#attributes.fis_type# 
            AND 
                UPD_ID=#attributes.DEL_ID#
        </cfquery>
        <cfscript>
        del_serial_no(
        process_id : attributes.DEL_ID,
        process_cat : attributes.fis_type, 
        period_id : session.ep.period_id
        );
        </cfscript>
        <!--- seri no kayitlari silinir --->
        <cfquery name="GET_FIS_FILE" datasource="#dsn2#">
            SELECT 
                FILE_NAME,
                FILE_SERVER_ID
            FROM 
                FILE_IMPORTS 
            WHERE 
                FIS_NUMBER = '#attributes.fis_number_#'
        </cfquery>
        <cfif GET_FIS_FILE.RECORDCOUNT>
            <cfif FileExists('#upload_folder#store#dir_seperator##GET_FIS_FILE.FILE_NAME#')>
                <cf_del_server_file output_file="store/#GET_FIS_FILE.FILE_NAME#" output_server="#GET_FIS_FILE.FILE_SERVER_ID#">
            </cfif>
            <cfquery name="DEL_FIS_FILE" datasource="#dsn2#">
                DELETE FROM FILE_IMPORTS WHERE FIS_NUMBER = '#attributes.fis_number_#'
            </cfquery>
        </cfif>
         <cfquery name="UPDATE_SAYIM" datasource="#dsn2#">
            UPDATE SAYIMLAR SET FIS_ID = NULL WHERE FIS_ID = #attributes.DEL_ID#
        </cfquery>
        <cf_add_log  log_type="-1" action_id="#attributes.del_id#" process_type="#get_stage.process_cat#" action_name="#attributes.fis_number_#" paper_number="#attributes.fis_number_#" data_source="#dsn2#">
    </cftransaction>
</cflock>
<cfif session.ep.our_company_info.is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:3,action_id:attributes.DEL_ID,query_type:3);</cfscript>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_purchase&cat=#attributes.fis_type#</cfoutput>";
</script>
