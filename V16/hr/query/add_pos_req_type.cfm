<cflock name="CreateUUID()" timeout="30">
	<cftransaction>
		<cfquery name="add_pos_req_type" datasource="#dsn#" result="MAX_ID">
		  INSERT INTO
			POSITION_REQ_TYPE
		  (
			   REQ_TYPE,
               IS_ACTIVE,
			   IS_GROUP,
			   PERFECTION_YEAR,
			   IS_COACH,
			   IS_DEP_ADMIN,
			   IS_STANDART,
			   RECORD_EMP,
			   RECORD_DATE,
			   RECORD_IP
			  <cfif len(attributes.detail)>
			   ,DETAIL
			  </cfif>
		  )
		  VALUES
		  (
			   '#REQ_TYPE#',
              <cfif isdefined('attributes.is_active') and len(attributes.is_active)>1<cfelse>0</cfif>,
			  <cfif isdefined("attributes.is_group_req_type")>1<cfelse>0</cfif>,
			  <cfif isdefined('attributes.perfection_year') and len(attributes.perfection_year)>#attributes.perfection_year#<cfelse>NULL</cfif>,
			  <cfif isdefined('attributes.is_coach') and len(attributes.is_coach)>1<cfelse>0</cfif>,
		   	  <cfif isdefined('attributes.is_dep_admin') and len(attributes.is_dep_admin)>1<cfelse>0</cfif>,
			  <cfif isdefined('attributes.is_standart') and len(attributes.is_standart)>1<cfelse>0</cfif>,
			   #session.ep.userid#,
			   #now()#,
			   '#CGI.REMOTE_ADDR#'
			  <cfif len(attributes.detail)>
			  ,'#attributes.detail#'
			  </cfif>
		  )
		</cfquery>
		<cf_relation_segment
			is_upd='1' 
			is_form='0'
			field_id='#MAX_ID.IDENTITYCOL#'
			table_name='POSITION_REQ_TYPE'
			action_table_name='RELATION_SEGMENT'
			select_list='1,2,3,4,5,6,7,8,10'>
	</cftransaction>
</cflock>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_position_req_type&event=upd&req_type_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
