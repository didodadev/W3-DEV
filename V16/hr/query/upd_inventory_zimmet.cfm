<cfinclude template="../query/get_emp_detail.cfm">
<cftransaction>
	<cfquery name="upd_invent" datasource="#DSN#">
		UPDATE
			EMPLOYEES_INVENT_ZIMMET
		SET		
			COMPANY_ID=#attributes.company_id#,
			EMPLOYEE_ID=#attributes.employee_id#,
			UPDATE_DATE=#now()#,
			UPDATE_EMP=#SESSION.EP.USERID#,
			UPDATE_IP='#CGI.REMOTE_ADDR#',
            PROCESS_STAGE = #attributes.process_stage#
		WHERE
			ZIMMET_ID=#attributes.ZIMMET_ID#
	</cfquery>
	
	<cfquery name="del_max" datasource="#DSN#">
		DELETE
		FROM
			EMPLOYEES_INVENT_ZIMMET_ROWS
		WHERE
			ZIMMET_ID=#attributes.ZIMMET_ID#
	</cfquery>

<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol#i#")>
		<cfset attributes.tarih=evaluate("attributes.tarih#i#")>
		<cfif len(evaluate("given_id_#i#")) and len(attributes.tarih) >
            <cf_date tarih='attributes.tarih'>
            <cfset "attributes.tarih#i#"=attributes.tarih>
            <cfquery name="add_invent_row" datasource="#DSN#">
                INSERT INTO
                    EMPLOYEES_INVENT_ZIMMET_ROWS		
                    (
                        ZIMMET_ID,
                        DEVICE_NAME,
                        INVENTORY_NO,
                        PROPERTY,
                        ZIMMET_DATE,
                        GIVEN_EMP_ID,
                        RELATION_PHYSICAL_ASSET_ID
                    )
                    VALUES
                    (
                        #attributes.ZIMMET_ID#,
                        '#wrk_eval("device_name#i#")#',
                        '#wrk_eval("inventory_no_#i#")#',
                        '#wrk_eval("property_#i#")#',
                        #attributes.tarih#,
                        #evaluate("given_id_#i#")#,
                        <cfif isdefined("attributes.relation_asset_id#i#") and len(wrk_eval("attributes.relation_asset_id#i#")) and len(wrk_eval("attributes.relation_asset#i#"))>#evaluate("relation_asset_id#i#")#<cfelse>NULL</cfif>
                    )
            </cfquery>
        </cfif>
    </cfif>
</cfloop>	
</cftransaction>
<cfset attributes.actionId = attributes.zimmet_id>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_inventory_zimmet&event=upd&zimmet_id=#attributes.zimmet_id#</cfoutput>";
</script>

