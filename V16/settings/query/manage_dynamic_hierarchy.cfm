<cfquery name="get_positions_all" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,		
		POSITION_CODE,
		POSITION_CAT_ID,
		TITLE_ID,
		FUNC_ID,
		DEPARTMENT_ID
	FROM 
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_ID IS NOT NULL AND
		DEPARTMENT_ID IS NOT NULL AND
		IS_MASTER = 1
</cfquery>
<cfoutput query="get_positions_all">
<cfset this_emp_ = EMPLOYEE_ID>
	<cfset this_code_ = POSITION_CODE>
	<cfset this_dep_ = DEPARTMENT_ID>
	<cfset this_pos_ = POSITION_CAT_ID>
	<cfset this_un_ = TITLE_ID>
	<cfset this_func_id = FUNC_ID>
	<cfquery name="get_uppers" datasource="#dsn#">
		SELECT 
			O.HIERARCHY AS HIE1,
			Z.HIERARCHY AS HIE2,
			O.HIERARCHY2 AS HIE3,			
			B.HIERARCHY AS HIE4,
			D.HIERARCHY AS HIE5
		FROM
			DEPARTMENT D,
			BRANCH B,
			OUR_COMPANY O,
			ZONE Z
		WHERE
			B.ZONE_ID = Z.ZONE_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = O.COMP_ID AND
			D.DEPARTMENT_ID = #this_dep_#
	</cfquery>
	<cfquery name="get_position_cat" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = #this_pos_#
	</cfquery>
	<cfquery name="get_title" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_TITLE WHERE TITLE_ID = #this_un_#
	</cfquery>
	<cfif len(this_func_id)><!--- fonksiyon son eleman olacak sekilde ayarlandi --->
		<cfquery name="get_fonk" datasource="#DSN#">
			SELECT
			   HIERARCHY
			FROM
				SETUP_CV_UNIT
			WHERE
				UNIT_ID = #this_func_id#
		</cfquery>
		<cfif get_fonk.recordcount and len(get_fonk.HIERARCHY)>
			<cfset fonk_add_ = '.#get_fonk.HIERARCHY#'>
		<cfelse>
			<cfset fonk_add_ = ''>
		</cfif>
	<cfelse>
		<cfset fonk_add_ = ''>
	</cfif>
	<cfif get_uppers.recordcount>
		<cfset new_hie_ = '#get_uppers.HIE1#.' & '#get_uppers.HIE2#.' & '#get_uppers.HIE3#.' & '#get_uppers.HIE4#.' & '#get_uppers.HIE5#.' & '#get_title.HIERARCHY#.' & '#get_position_cat.HIERARCHY#' & '#fonk_add_#'>
	<cfelse>
		<cfset new_hie_ = ''>
	</cfif>
	<cfset attributes.dynamic_hierarchy_add = ''>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE EMPLOYEE_POSITIONS SET DYNAMIC_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">,DYNAMIC_HIERARCHY_ADD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#"> WHERE POSITION_CODE = #this_code_#
	</cfquery>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE EMPLOYEES SET DYNAMIC_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">,DYNAMIC_HIERARCHY_ADD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#"> WHERE EMPLOYEE_ID = #this_emp_#
	</cfquery>
</cfoutput>

<script type="text/javascript">
	alert("<cf_get_lang no ='2162.Aktarım Başarı İle Yapılmıştır'>!");
	window.location.href='<cfoutput>#request.self#?fuseaction=settings.welcome</cfoutput>';
</script>
