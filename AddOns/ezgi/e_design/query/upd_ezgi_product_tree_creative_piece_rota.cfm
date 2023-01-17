<cftransaction>
    <cfquery name="del_rota" datasource="#dsn3#">
        DELETE FROM EZGI_DESIGN_PIECE_ROTA WHERE PIECE_ROW_ID = #attributes.piece_id#
    </cfquery>
    <cfloop from="1" to="#attributes.record_num#" index="i">
        <cfif Evaluate('attributes.row_kontrol#i#') eq 1>
            <cfquery name="add_default_rota" datasource="#dsn3#">
                INSERT INTO 
                    EZGI_DESIGN_PIECE_ROTA
                    (
                    PIECE_ROW_ID, 
                    OPERATION_TYPE_ID, 
                    SIRA, 
                    AMOUNT
                    )
                VALUES
                    (      
                    #attributes.piece_id#, 
                    #Evaluate('attributes.operation_type_id#i#')#, 
                    #i#, 
                    #FilterNum(Evaluate('attributes.quantity#i#'),2)#
                    )
            </cfquery>
        </cfif>
    </cfloop>
</cftransaction>
<cfoutput>#getLang('account',208)#</cfoutput>
<cfif isdefined('attributes.master_plan_id')>
	<cfinclude template="../../e_production/query/upd_ezgi_iflow_master_plan_operation.cfm">
	<script type="text/javascript">
        alert("<cfoutput>#getLang('account',208)#</cfoutput>");
        wrk_opener_reload();
        window.close();
    </script>
<cfelse>
	<script type="text/javascript">
        alert("<cfoutput>#getLang('account',208)#</cfoutput>");
        window.close();
    </script>
</cfif>