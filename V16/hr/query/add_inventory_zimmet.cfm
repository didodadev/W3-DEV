<cfinclude template="../query/get_emp_detail.cfm">
<cfquery name="get_authority" datasource="#DSN#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#  AND BRANCH_ID = #get_dep.BRANCH_ID#
	 </cfquery>
	<cfif get_authority.recordCount eq 0>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='57532.Yetkiniz Yok'>!");
			window.history.go(-1);
		</script>
		<cfabort>
	</cfif>
<cfquery name="get_emp" datasource="#DSN#">
	SELECT
		ZIMMET_ID
	FROM
		EMPLOYEES_INVENT_ZIMMET
	WHERE
		EMPLOYEE_ID=#attributes.employee_id#
</cfquery>
<cfif get_emp.recordcount>
	<script type="text/javascript">
		alert("Seçtiginiz Çalışana Ait Zimmet Kaydı Bulunmaktadır!");
		history.back();
	</script>
	<cfabort>
</cfif>

	<cftransaction>
		<cfquery name="add_invent" datasource="#DSN#" result="MAX_ID">
			INSERT INTO 
				EMPLOYEES_INVENT_ZIMMET
				(	
					COMPANY_ID,
					EMPLOYEE_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
                    PROCESS_STAGE
				)
				VALUES
				(
					#attributes.company_id#,
					#attributes.employee_id#,
					#now()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
                    #attributes.process_stage#
				)
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
	<!--- 		<cfset a=evaluate("relation_asset_id#i#")>
			<cfif evaluate("relation_asset_id#i#")><cfoutput>#a#</cfoutput></cfif> --->
			<cfif isdefined("attributes.row_kontrol#i#") and  evaluate("attributes.row_kontrol#i#") eq 1>
				<cfset attributes.tarih=evaluate("attributes.tarih#i#")>
				<cfif len(attributes.tarih)>
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
                            #MAX_ID.IDENTITYCOL#,
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
    <cfset attributes.actionId=MAX_ID.IDENTITYCOL>
    <script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_inventory_zimmet&event=upd&zimmet_id=#MAX_ID.IDENTITYCOL#</cfoutput>"
    </script>

