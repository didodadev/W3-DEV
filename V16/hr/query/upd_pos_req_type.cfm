<cflock name="CreateUUID()" timeout="30">
	<cftransaction>
		<cfquery name="upd_pos_req_type" datasource="#dsn#">
			UPDATE
				POSITION_REQ_TYPE
			SET
			<cfif attributes.is_fill eq 0>
				REQ_TYPE = '#REQ_TYPE#',
				IS_GROUP=<cfif isdefined("attributes.is_group_req_type")>1,<cfelse>0,</cfif>
				PERFECTION_YEAR=<cfif isdefined('attributes.perfection_year') and len(attributes.perfection_year)>#attributes.perfection_year#<cfelse>NULL</cfif>,
				IS_COACH=<cfif isdefined('attributes.is_coach') and len(attributes.is_coach)>1<cfelse>0</cfif>,
				IS_DEP_ADMIN=<cfif isdefined('attributes.is_dep_admin') and len(attributes.is_dep_admin)>1<cfelse>0</cfif>,
				IS_STANDART=<cfif isdefined('attributes.is_standart') and len(attributes.is_standart)>1<cfelse>0</cfif>,
                IS_ACTIVE=<cfif isdefined('attributes.is_active') and len(attributes.is_active)>1<cfelse>0</cfif>,
			</cfif>
				DETAIL = <cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_DATE = #NOW()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#'
			WHERE
				REQ_TYPE_ID = #attributes.REQ_TYPE_ID#
		</cfquery>
		<cf_relation_segment
			is_upd='1' 
			is_form='0'
			field_id='#attributes.REQ_TYPE_ID#'
			table_name='POSITION_REQ_TYPE'
			action_table_name='RELATION_SEGMENT'
			select_list='1,2,3,4,5,6,7,8,10'>
	</cftransaction>
</cflock>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_position_req_type&event=upd&req_type_id=#attributes.req_type_id#</cfoutput>";
</script>

