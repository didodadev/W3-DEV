<cfinclude template="../../objects/functions/get_carici.cfm">
<cfinclude template="../../objects/functions/get_muhasebeci.cfm">
<cfinclude template="../../objects/functions/get_butceci.cfm">
<cfinclude template="../../objects/functions/cost_action.cfm">
<cfinclude template="../../objects/functions/get_cost.cfm">
<cfinclude template="../../objects/functions/add_ship_row_relation.cfm">
<cfinclude template="../../objects/functions/del_serial_no.cfm">
<cfinclude template="../../objects/functions/add_relation_rows.cfm">
<cfinclude template="../../objects/functions/add_order_row_reserved_stock.cfm">
<cfset xml_import = 1>
<cfquery name="get_cont" datasource="#dsn_Dev#">
	SELECT * FROM POS_CONS WHERE CON_ID = #attributes.con_id#
</cfquery>
<cfif get_cont.recordcount>
		<cfquery name="get_relateds" datasource="#dsn_dev#">
            SELECT * FROM POS_CONS_ACTIONS WHERE CON_ID = #attributes.con_id#
        </cfquery>
        
        <cfquery name="get_info" datasource="#dsn#">
            SELECT
                PE2.POS_ID,
                B.BRANCH_ID,
                (SELECT TOP 1 D.DEPARTMENT_ID FROM DEPARTMENT D WHERE D.BRANCH_ID = B.BRANCH_ID) AS DEPT
            FROM
                #dsn3_alias#.POS_EQUIPMENT PE2,
                BRANCH B
            WHERE
                PE2.BRANCH_ID = B.BRANCH_ID AND
                PE2.EQUIPMENT_CODE = #get_cont.kasa_numarasi#
        </cfquery>
	 <cfoutput query="get_relateds">
		<cfif action_type eq 69 and period_id eq session.ep.period_id>
			<!--- z raporu sil --->
			<cfset form.del_invoice_id = get_relateds.action_id>
            <cfset attributes.invoice_id = get_relateds.action_id>
            <cfset form.invoice_id = get_relateds.action_id>
            <cfset form.process_cat = 27>
            <cfset form.old_process_type = 69>
            <cfset form.invoice_number = 'Z-0'>
            <cfinclude template="del_z_report.cfm">
            <cfscript>
                StructDelete(form,'del_invoice_id');
                StructDelete(form,'invoice_id');
                StructDelete(form,'old_process_type');
                StructDelete(attributes,'invoice_id');
            </cfscript> 
            <cfscript>
                StructDelete(form,'invoice_number');
                StructDelete(attributes,'invoice_number');
            </cfscript>
            <!--- z raporu sil --->
       <cfelseif action_type eq 70 and period_id eq session.ep.period_id>
       		<!--- irsaliye sil --->
            <cfset form.del_ship = 1>
            <cfset form.UPD_ID = action_id>
            <cfset attributes.UPD_ID = action_id>
            <cfquery name="GET_NUMBER" datasource="#dsn2#">
                SELECT SHIP_ID,SHIP_NUMBER,IS_WITH_SHIP,SHIP_TYPE,PROCESS_CAT FROM SHIP WHERE SHIP_ID=#attributes.UPD_ID#
            </cfquery>
           <cfif GET_NUMBER.recordcount>
            <cfset form.process_cat = GET_NUMBER.PROCESS_CAT>
			<cfinclude template="upd_del_sale.cfm">
            
            <cfquery name="get_cash" datasource="#dsn2#">
            	SELECT * FROM CASH_ACTIONS WHERE SPECIAL_DEFINITION_ID = #attributes.UPD_ID# AND ACTION_TYPE_ID = 31
            </cfquery>
            <cfset attributes.old_process_type = 31>
            <cfset attributes.id = get_cash.action_id>
            <cfset url.id = get_cash.action_id>
            <cfset attributes.detail = ''>
            <cfif get_cash.recordcount>
                <cfinclude template="del_cash_revenue.cfm">
            </cfif>
           </cfif>
            <!--- irsaliye sil --->
	   <cfelseif action_type eq 55 and period_id eq session.ep.period_id>
       		<!--- gider pusulası sil --->
            <cfset form.del_invoice_id = get_relateds.action_id>
            <cfset attributes.invoice_id = get_relateds.action_id>
            <cfset form.invoice_id = get_relateds.action_id>
            <cfset form.process_cat = 89>
            <cfset form.old_process_type = 55>
            <cfset form.invoice_number = 'fatura'>
            
            <cfquery name="get_rows" datasource="#dsn2#">
            	SELECT * FROM INVOICE_ROW WHERE INVOICE_ID = #attributes.invoice_id#
            </cfquery>
            <cfset attributes.rows_ = get_rows.recordcount>
            
            <cfquery name="GET_NUMBER" datasource="#DSN2#">
                SELECT INVOICE_ID,INVOICE_NUMBER,CASH_ID,IS_CASH,IS_WITH_SHIP,WRK_ID FROM INVOICE WHERE INVOICE_ID = #form.invoice_id#
            </cfquery>
                        
            <cfloop query="get_rows">
            	<cfset "attributes.row_ship_id#i#" = "#get_rows.SHIP_ID#;#get_rows.SHIP_PERIOD_ID#">
            </cfloop>
            
            <cfinclude template="../../invoice/query/get_bill_process_cat.cfm">
			<cfinclude template="../../invoice/query/upd_invoice_purchase_6.cfm">
            <cfscript>
                StructDelete(form,'del_invoice_id');
                StructDelete(form,'invoice_id');
                StructDelete(form,'old_process_type');
                StructDelete(attributes,'invoice_id');
            </cfscript> 
            <cfscript>
                StructDelete(form,'invoice_number');
                StructDelete(attributes,'invoice_number');
            </cfscript>
            <!--- gider pusulası sil --->
       <cfelseif action_type eq 52 and period_id eq session.ep.period_id>
       		<!--- perakende satis faturasi sil --->
            <cfset form.del_invoice_id = get_relateds.action_id>
            <cfset attributes.invoice_id = get_relateds.action_id>
            <cfset form.invoice_id = get_relateds.action_id>
            <cfset form.process_cat = 105>
            <cfset form.old_process_type = 52>
            <cfset form.invoice_number = 'fatura'>
            
            <cfquery name="get_rows" datasource="#dsn2#">
            	SELECT * FROM INVOICE_ROW WHERE INVOICE_ID = #attributes.invoice_id#
            </cfquery>
            <cfset attributes.rows_ = get_rows.recordcount>
            
            <cfquery name="GET_NUMBER" datasource="#DSN2#">
                SELECT INVOICE_ID,INVOICE_NUMBER,CASH_ID,IS_CASH,IS_WITH_SHIP,WRK_ID FROM INVOICE WHERE INVOICE_ID = #form.invoice_id#
            </cfquery>
                        
            <cfloop query="get_rows">
            	<cfset "attributes.row_ship_id#i#" = "#get_rows.SHIP_ID#;#get_rows.SHIP_PERIOD_ID#">
            </cfloop>
            
            <cfinclude template="../../invoice/query/get_bill_process_cat.cfm">
            <cfinclude template="../../invoice/query/upd_invoice_8.cfm">
            <cfscript>
                StructDelete(form,'del_invoice_id');
                StructDelete(form,'invoice_id');
                StructDelete(form,'old_process_type');
                StructDelete(attributes,'invoice_id');
            </cfscript> 
            <cfscript>
                StructDelete(form,'invoice_number');
                StructDelete(attributes,'invoice_number');
            </cfscript>
            <!--- perakende satis faturasi sil --->
       </cfif>
    </cfoutput>
    <cfquery name="del_p" datasource="#dsn_dev#">
    	DELETE FROM POS_CONS_PAYMENTS WHERE CON_ID = #get_cont.CON_ID#
    </cfquery>
    <cfquery name="del_R" datasource="#dsn_dev#">
    	DELETE FROM POS_CONS_BANKNOTES WHERE CON_ID = #get_cont.CON_ID#
    </cfquery>
    <cfquery name="del_" datasource="#dsn_dev#">
    	DELETE FROM POS_CONS WHERE CON_ID = #get_cont.CON_ID#
    </cfquery>
    <cfquery name="del_" datasource="#dsn_dev#">
    	DELETE FROM POS_CONS_ACTIONS WHERE CON_ID = #get_cont.CON_ID#
    </cfquery>
</cfif>
<script>
	window.opener.location.reload();
	window.close();
</script>