<cfparam name="attributes.modal_id" default="">
<cfset attributes.draggable = listFirst(attributes.draggable)>
<cfquery name="GET_ORG" datasource="#DSN#">
	SELECT 
        ORGANIZATION_ID,
        START_DATE, 
        FINISH_DATE, 
        ORGANIZATION_ANNOUNCEMENT
    FROM 
    	ORGANIZATION 
    WHERE 
    	ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_id#">
</cfquery>
<cfif isdefined('par_ids') and len(par_ids)>
	<cfloop list="#par_ids#" index="par_id">
		<cfquery name="GET_organization_PAR_ATT" datasource="#DSN#">
			SELECT 
				ORGANIZATION.START_DATE,
				ORGANIZATION.FINISH_DATE,
				ORGANIZATION.ORGANIZATION_ID
			FROM
				ORGANIZATION,
				ORGANIZATION_ATTENDER 
			WHERE 
				ORGANIZATION_ATTENDER.ORGANIZATION_ID = ORGANIZATION.ORGANIZATION_ID 
				AND ORGANIZATION_ATTENDER.PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#par_id#">
				AND
				(
					(
					  	ORGANIZATION.START_DATE >= #CreateODBCDateTime(GET_ORG.start_date)# AND
					  	ORGANIZATION.START_DATE < #CreateODBCDateTime(GET_ORG.finish_date)#
					)
					OR
					(
					  	ORGANIZATION.FINISH_DATE >= #CreateODBCDateTime(GET_ORG.start_date)# AND
					  	ORGANIZATION.FINISH_DATE < #CreateODBCDateTime(GET_ORG.start_date)#
					) 
				)
		</cfquery>
		<cfif get_organization_par_att.recordcount>
			<cfif get_organization_par_att.ORGANIZATION_ID neq attributes.organization_id>
				<script type="text/javascript">
					alert("<cfoutput>#get_par_info(par_id,0,-1,0)#</cfoutput> <cf_get_lang dictionary_id='46725.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
						<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
							closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
						<cfelse>
							window.history.back();
						</cfif>
				</script>
				<cfabort>
			<cfelse>
				<script type="text/javascript">
					alert("<cfoutput>#get_par_info(par_id,0,-1,0)#</cfoutput> <cf_get_lang dictionary_id='46726.Seçtiğiniz eğitime zaten katılımcıdır'>");
					<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
						closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
					<cfelse>
						window.history.back();
					</cfif>
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="GET_ORGANIZATION_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT PAR_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_id#"> AND PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#par_id#">
		</cfquery>
		<cfif not get_organization_potential_attender.recordcount>
			<cfquery name="ADD_ORGANIZATION_POTENTIAL_ATTENDERS" datasource="#DSN#">
				INSERT INTO
					ORGANIZATION_ATTENDER
					(
                        ORGANIZATION_ID,
                        PAR_ID,
                        IS_SELFSERVICE	
					)
					VALUES
					(
                        #attributes.organization_id#,
                        #par_id#,
                        0
					)
			</cfquery>
		</cfif>
	</cfloop>
<cfelseif isdefined('con_ids') and len(con_ids)>
	<cfloop list="#con_ids#" index="con_id">
		<cfquery name="GET_organization_CONS_ATT" datasource="#DSN#">
			SELECT 
				ORGANIZATION.START_DATE ,
				ORGANIZATION.FINISH_DATE,
				ORGANIZATION.ORGANIZATION_ID
			FROM
				ORGANIZATION,
				ORGANIZATION_ATTENDER 
			WHERE 
				ORGANIZATION_ATTENDER.ORGANIZATION_ID = ORGANIZATION.ORGANIZATION_ID 
				AND ORGANIZATION_ATTENDER.CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
				AND
				(
				   (
					  	ORGANIZATION.START_DATE >= #CreateODBCDateTime(GET_ORG.start_date)#
						AND
					  	ORGANIZATION.START_DATE < #CreateODBCDateTime(GET_ORG.finish_date)#
					)
					OR
					(
					  	ORGANIZATION.FINISH_DATE >= #CreateODBCDateTime(GET_ORG.start_date)#
						AND
					  	ORGANIZATION.FINISH_DATE < #CreateODBCDateTime(GET_ORG.finish_date)#
					) 
				)
		</cfquery>
		<cfif get_organization_cons_att.recordcount>
			<cfif get_organization_cons_att.ORGANIZATION_ID neq attributes.ORGANIZATION_ID>
				<script type="text/javascript">
					alert("<cfoutput>#get_cons_info(con_id,0,0)#</cfoutput> <cf_get_lang dictionary_id='46725.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
					window.history.back();
					//window.close();
				</script>
				<cfabort>
			<cfelse>
				<script type="text/javascript">
					alert("<cfoutput>#get_cons_info(con_id,0,0)#</cfoutput> <cf_get_lang dictionary_id='46726.Seçtiğiniz eğitime zaten katılımcıdır'>");
					<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
						closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
					<cfelse>
						window.history.back();
					</cfif>
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="GET_organization_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT CON_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#"> AND CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
		</cfquery>
		<cfif not get_organization_potential_attender.recordcount>
			<cfquery name="ADD_organization_POTENTIAL_ATTENDERS" datasource="#DSN#">
				INSERT INTO
					ORGANIZATION_ATTENDER
					(
                        ORGANIZATION_ID,
                        CON_ID,
                        IS_SELFSERVICE	
					)
					VALUES
					(
                        #attributes.ORGANIZATION_ID#,
                        #con_id#,
                        0
					)
			</cfquery>
		</cfif>
	</cfloop>
<cfelse>
	<cfloop list="#emp_ids#" index="emp_id">
		<cfquery name="GET_organization_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT EMP_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#"> AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
		</cfquery>
		<cfquery name="GET_organization_EMP_ATT" datasource="#DSN#">
			SELECT 
				ORGANIZATION.START_DATE ,
				ORGANIZATION.FINISH_DATE,
				ORGANIZATION.ORGANIZATION_ID
			FROM
				ORGANIZATION,
				ORGANIZATION_ATTENDER 
			WHERE 
				ORGANIZATION_ATTENDER.ORGANIZATION_ID = ORGANIZATION.ORGANIZATION_ID 
				AND ORGANIZATION_ATTENDER.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
				AND
				(
				    (
					  	ORGANIZATION.START_DATE >= #CreateODBCDateTime(GET_ORG.start_date)# AND
					  	ORGANIZATION.START_DATE < #CreateODBCDateTime(GET_ORG.finish_date)#
					)
					OR
					(
					  	ORGANIZATION.FINISH_DATE >= #CreateODBCDateTime(GET_ORG.start_date)# AND
					  	ORGANIZATION.FINISH_DATE < #CreateODBCDateTime(GET_ORG.finish_date)#
					) 
				)
		</cfquery>
		<cfif get_organization_emp_att.recordcount>
			<cfif get_organization_emp_att.ORGANIZATION_ID neq attributes.ORGANIZATION_ID>
				<script type="text/javascript">
					alert("<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> <cf_get_lang dictionary_id='46725.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
					<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
						closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
					<cfelse>
						window.history.back();
					</cfif>
				</script>
				<cfabort>
			<cfelseif not isdefined("control_emp_id_#emp_id#")>
				<script type="text/javascript">
					alert("<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> <cf_get_lang dictionary_id='46726.Seçtiğiniz eğitime zaten katılımcıdır'>");
					<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
						closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
					<cfelse>
						window.history.back();
					</cfif>
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfif not get_organization_potential_attender.recordcount>
			<cfset "control_emp_id_#emp_id#" = 1>
			<cfquery name="ADD_organization_POTENTIAL_ATTENDERS" datasource="#DSN#">
				INSERT INTO
					ORGANIZATION_ATTENDER
					(
						ORGANIZATION_ID,
						EMP_ID,
						IS_SELFSERVICE
					)
				VALUES
					(
						#attributes.ORGANIZATION_ID#,
						#emp_id#,
						0
					)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
 <script type="text/javascript">
	<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
		closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=campaign.popup_list_organization_attenders&organization_id=#attributes.organization_id#</cfoutput>','attenders_box')
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script> 
