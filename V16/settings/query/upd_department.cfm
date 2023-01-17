<cfif isdefined('attributes.change_date') and len(attributes.change_date)>
	<cf_date tarih="attributes.change_date">
	<cfif isdefined('attributes.last_change_date') and len(attributes.last_change_date)>
    	<cf_date tarih="attributes.last_change_date">
        <cfif DateCompare(attributes.last_change_date, attributes.change_date) eq 1>
        	<script type="text/javascript">
				alert('Seçtiğiniz değişiklik tarihinden sonraki bir tarihte değişiklik tarihi kaydı vardır. Lütfen kontrol ediniz.');
				history.back();
			</script>
			<cfabort>
		</cfif>
   	</cfif>
</cfif>
<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.DEPARTMENT_HEAD=replacelist(attributes.DEPARTMENT_HEAD,list,list2)>
<cfif not isDefined("FORM.DEPARTMENT_STATUS")>
	<cfset FORM.DEPARTMENT_STATUS = 0>
</cfif>
<cfif isdefined('attributes.UP_DEPARTMENT_ID') and len(attributes.UP_DEPARTMENT_ID) and isdefined('attributes.level_no') and len(attributes.level_no)>
	<cfquery name="get_up_dep_level_no" datasource="#DSN#">
		SELECT LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID=#attributes.UP_DEPARTMENT_ID#
	</cfquery>
    <cfif get_up_dep_level_no.LEVEL_NO gte attributes.level_no>
    	<script type="text/javascript">
			alert("Üst departmanın kademe numarası daha küçük olmalıdır!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif isdefined('attributes.UP_DEPARTMENT_ID') and isdefined('attributes.UP_DEPARTMENT') and len(attributes.UP_DEPARTMENT_ID) and len(attributes.UP_DEPARTMENT)>
	<cfquery name="get_hier" datasource="#DSN#">
		SELECT HIERARCHY_DEP_ID FROM DEPARTMENT WHERE DEPARTMENT_ID=#attributes.UP_DEPARTMENT_ID#
	</cfquery>
	<cfif len(get_hier.HIERARCHY_DEP_ID)>
		<cfset hier=get_hier.HIERARCHY_DEP_ID & "." & attributes.DEPARTMENT_ID>
	<cfelse>
		<cfset hier=attributes.UP_DEPARTMENT_ID & "." & attributes.DEPARTMENT_ID>	
	</cfif>
<cfelse>
	<cfset hier=attributes.DEPARTMENT_ID>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined('attributes.up_department_id') and len(attributes.up_department_id)>
			<cfquery name="update_dep_hierarchy" datasource="#dsn#">
				UPDATE
					DEPARTMENT
				SET
					<cfif database_type IS 'MSSQL'><!---Cfqueryparam da sorun yaşadığımızdan sql_unicode() kullandık PY--->
						HIERARCHY_DEP_ID = #sql_unicode()#'#hier#.' + SUBSTRING(HIERARCHY_DEP_ID, #len(oldhierarchy)#+2, LEN(HIERARCHY_DEP_ID)-#len(oldhierarchy)#)
					<cfelseif database_type IS 'DB2'>
						HIERARCHY_DEP_ID = '#hier#.' || SUBSTR(HIERARCHY_DEP_ID, #len(oldhierarchy)#+2, LENGTH(HIERARCHY_DEP_ID)-#len(oldhierarchy)#)
					</cfif>
				WHERE 
					HIERARCHY_DEP_ID LIKE '#oldhierarchy#.%' AND
					DEPARTMENT_ID <> #attributes.department_id#
			</cfquery>
		</cfif>
        <cfquery name="ADD_DEPARTMENT" datasource="#DSN#">
			UPDATE 
				DEPARTMENT 
			SET 
				DEPARTMENT_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DEPARTMENT_HEAD#">, 
				<cfif isdefined('attributes.ADMIN1_POSITION_CODE') and isdefined('attributes.admin1_position') and len(attributes.ADMIN1_POSITION_CODE) and len(attributes.admin1_position)>
				ADMIN1_POSITION_CODE = #attributes.ADMIN1_POSITION_CODE#,
				<cfelse>
				ADMIN1_POSITION_CODE = NULL,
				</cfif>
				<cfif isdefined('attributes.ADMIN2_POSITION_CODE') and isdefined('attributes.admin2_position') and len(attributes.ADMIN2_POSITION_CODE) and len(attributes.admin2_position)>
				ADMIN2_POSITION_CODE = #attributes.ADMIN2_POSITION_CODE#,
				<cfelse>
				ADMIN2_POSITION_CODE = NULL,
				</cfif>
				<!--- DEPARTMENT_NAME_ID = <cfif isdefined('attributes.DEPARTMENT_NAME_ID') and len(attributes.DEPARTMENT_NAME_ID)>#attributes.DEPARTMENT_NAME_ID#<cfelse>NULL</cfif>,  --->
				DEPARTMENT_STATUS = <cfif isdefined("attributes.DEPARTMENT_STATUS")>1<cfelse>0</cfif>, 
				IS_ORGANIZATION = <cfif isdefined("attributes.IS_ORGANIZATION")>1,<cfelse>0,</cfif>
				DEPARTMENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DEPARTMENT_DETAIL#">, 
				IS_STORE = <cfif isdefined("attributes.IS_STORE") and len(attributes.IS_STORE)>#attributes.IS_STORE#<cfelse>NULL</cfif>,
				HIERARCHY_DEP_ID = <cfif len(hier)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hier#">,<cfelse>NULL,</cfif>
				HIERARCHY = <cfif  isdefined('attributes.HIERARCHY') and len(attributes.HIERARCHY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#HIERARCHY#">,<cfelse>NULL,</cfif>
				SPECIAL_CODE = <cfif  isdefined('attributes.special_code') and len(attributes.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.special_code#">,<cfelse>NULL,</cfif>
				IS_PRODUCTION = <cfif isdefined('attributes.is_production')>#attributes.is_production#<cfelse>NULL</cfif>,
				DEPARTMENT_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#">, 
                UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                LEVEL_NO = <cfif len(attributes.level_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.level_no#"><cfelse>NULL</cfif>,
                CHANGE_DATE = <cfif isdefined('attributes.change_date') and len(attributes.change_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.change_date#"><cfelse>NULL</cfif>,
				IN_COMPANY_REASON_ID = <cfif isdefined("attributes.reason_id") and len("attributes.reason_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_id#"><cfelse>NULL</cfif>,
				DEPT_STAGE = <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
				SPECIAL_CODE2= <cfif  isdefined('attributes.SPECIAL_CODE_2') and len(attributes.SPECIAL_CODE_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SPECIAL_CODE_2#"><cfelse>NULL</cfif>,
				DEPARTMENT_CAT= <cfif  isdefined('attributes.depatment_cat') and len(attributes.depatment_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.depatment_cat#"><cfelse>NULL</cfif>,
				DEPARTMENT_TYPE = <cfif  isdefined('attributes.depatment_type') and len(attributes.depatment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.depatment_type#"><cfelse>NULL</cfif>

			WHERE 
				DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
		</cfquery>
        <cf_wrk_get_history datasource="#dsn#" source_table="DEPARTMENT" target_table="DEPARTMENT_HISTORY" record_id= "#attributes.department_id#" record_name="DEPARTMENT_ID">
        <cfquery name="get_max_hist_id" datasource="#dsn#">
            SELECT MAX(DEPT_HIST_ID) AS DEPT_HIST_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = #attributes.department_id#
        </cfquery>
        <cfquery name="upd_dep_hist" datasource="#dsn#">
            UPDATE
                DEPARTMENT_HISTORY
            SET
                EMP_COUNT = #attributes.total_emp_count#
            WHERE 
                DEPT_HIST_ID = #get_max_hist_id.DEPT_HIST_ID#
		</cfquery>
		<cfif attributes.x_show_process eq 1>
		    <cfsavecontent variable="dept_"><cf_get_lang_main no='160.Departman'></cfsavecontent>
			<cf_workcube_process
				is_upd='1'
				data_source='#dsn#'
				old_process_line='#attributes.old_process_line#'
				process_stage='#attributes.process_stage#'
				record_member='#session.ep.userid#'
				record_date='#now()#'
				action_table='DEPARTMENT'
				action_column='DEPT_STAGE'
				action_id='#attributes.department_id#'
				action_page='#request.self#?fuseaction=#attributes.fuseaction#&event=upd&id=#attributes.department_id#'
				warning_description='#dept_# : #attributes.department_id#'>
		</cfif>
		<cf_add_log  log_type="0" action_id="#attributes.department_id#" action_name="#attributes.head# ">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.callAjaxBranch") and attributes.callAjaxBranch eq 1><!--- Organizasyon Yönetimi sayfasıdan ajax ile çağırıldıysa 20190912ERU --->
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.list_depts&event=upd&id=#attributes.DEPARTMENT_ID#&type=4&branch_id=#attributes.branch_id#&comp_id=#attributes.comp_id#&department_id=#attributes.department_id#</cfoutput>','ajax_right');
    <cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=upd&id=#attributes.DEPARTMENT_ID#</cfoutput>';
	</cfif>
</script>