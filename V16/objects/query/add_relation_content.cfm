<!---gelen tipe ait tum kayıtlara değerlendirme formu otomatik olarak atanır. --->
<!--- Fırsat --->
<cfif attributes.action_type eq 1>
	<cfset attributes.datasource = '#dsn3#'>
	<cfset table_name = 'OPPORTUNITIES'>
	<cfset field_name = 'OPP_ID'>
<!--- İçerik --->
<cfelseif attributes.action_type eq 2>
	<cfset attributes.datasource = '#dsn#'>
	<cfset table_name = 'CONTENT'>
	<cfset field_name = 'CONTENT_ID'>
<!--- kampanya --->
<cfelseif attributes.action_type eq 3>
	<cfset attributes.datasource = '#dsn3#'>
	<cfset table_name = 'CAMPAIGNS'>
	<cfset field_name = 'CAMP_ID'>
<!--- ürün --->
<cfelseif attributes.action_type eq 4>
	<cfset attributes.datasource = '#dsn3#'>
	<cfset table_name = 'STOCKS'>
	<cfset field_name = 'STOCK_ID'>
<!--- proje --->
<cfelseif attributes.action_type eq 5>
	<cfset attributes.datasource = '#dsn#'>
	<cfset table_name = 'PRO_PROJECTS'>
	<cfset field_name = 'PROJECT_ID'>
	<cfquery name="get_project_cats" datasource="#dsn#">
		SELECT PROJECT_CAT_ID FROM SURVEY_MAIN_PROJECT_CATS WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_main_id#">
	</cfquery>
<!--- iş --->
<cfelseif attributes.action_type eq 11>
	<cfset attributes.datasource = '#dsn#'>
	<cfset table_name = 'PRO_WORKS'>
	<cfset field_name = 'WORK_ID'>
	<cfquery name="get_work_cats" datasource="#dsn#">
		SELECT WORK_CAT_ID FROM SURVEY_MAIN_WORK_CATS WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_main_id#">
	</cfquery>
<!--- işe alım --->
<cfelseif attributes.action_type eq 7>
	<cfset attributes.datasource = '#dsn#'>
	<cfset table_name = 'EMPLOYEES_APP'>
	<cfset field_name = 'EMPAPP_ID'>
<!--- eğitim --->
<cfelseif attributes.action_type eq 9>
	<cfset attributes.datasource = '#dsn#'>
	<cfset table_name = 'TRAINING_CLASS'>
	<cfset field_name = 'CLASS_ID'>
</cfif>
<cfif isdefined("table_name") and len(table_name) and isdefined("field_name") and len(field_name)>

	<cfquery name="get_" datasource="#attributes.datasource#">
		SELECT 
			#field_name# AS ID 
		FROM 
			#table_name#
		WHERE
			1 = 1
			<cfif attributes.action_type eq 5 and get_project_cats.recordcount>
				AND PROCESS_CAT IN(#valuelist(get_project_cats.project_cat_id)#)
			</cfif>
			<cfif attributes.action_type eq 11 and get_work_cats.recordcount>
				AND WORK_CAT_ID IN(#valuelist(get_work_cats.work_cat_id)#)
			</cfif>
	</cfquery>
	<cfoutput query="get_">
		<cfquery name="get_control" datasource="#dsn#">
			SELECT 
				RELATION_CAT 
			FROM 
				CONTENT_RELATION 
			WHERE 
				SURVEY_MAIN_ID = #attributes.survey_main_id# AND 
				RELATION_TYPE = #attributes.action_type# AND 
				RELATION_CAT = #get_.id#
		</cfquery>
		<cfif not get_control.recordcount>
			<cfquery name="add_" datasource="#dsn#">
				INSERT INTO
					CONTENT_RELATION
				(
					SURVEY_MAIN_ID,
					RELATION_TYPE,
					RELATION_CAT
				)
				VALUES
				(
					#attributes.survey_main_id#,
					#attributes.action_type#,
					#get_.id#
				)
			</cfquery>
		</cfif>
	</cfoutput>
</cfif>
<script language="javascript">
	wrk_opener_reload();
	window.close();
</script>
