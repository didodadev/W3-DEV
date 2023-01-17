<cfloop from="1" to="#attributes.record_num#" index="list">
	<cfif isdefined("attributes.related_row_kontrol#list#") and evaluate("attributes.related_row_kontrol#list#") eq 0>
		<cfquery name="del_related_parts" datasource="#dsn#">
			DELETE FROM 
				CONTENT_RELATION 
			WHERE 
				SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> 
				<cfif isdefined('attributes.related_id#list#') and len(evaluate('attributes.related_id#list#'))>
					AND RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.related_id#list#')#">
				<cfelse>
					AND RELATED_ALL = 1
				</cfif>
				AND RELATION_TYPE = #evaluate('attributes.related_type#list#')#
		</cfquery>
	</cfif>
</cfloop>

<cfif (isdefined('attributes.related_id') and len(attributes.related_id)) or isdefined('attributes.related_all_')>
	<cfquery name="get_control" datasource="#dsn#">
		SELECT 
			SURVEY_MAIN_ID 
		FROM 
			CONTENT_RELATION CR
		WHERE
			SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
			<cfif isdefined('attributes.related_all_')>
			(CR.RELATION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">  AND CR.RELATED_ALL = 1 AND CR.RELATION_CAT IS NULL)
			<cfelse>
			(CR.RELATION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">  AND CR.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_id#">)	
			</cfif>
	</cfquery>
	<cfif not get_control.recordcount><!--- aynı tipte kayit yok ise ekle--->
	<cfquery name="add_related_content" datasource="#dsn#">
		INSERT INTO
			CONTENT_RELATION
		(
			RELATION_TYPE,
			RELATION_CAT,
			RELATED_ALL,
			COMPANY_ID,
			SURVEY_MAIN_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
			VALUES
		(
			<cfif isdefined('attributes.type_id')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.related_id') and len(attributes.related_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_id#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.related_all_')>1<cfelse>0</cfif>,
			1,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
		)
	</cfquery> 
	</cfif>
	<!--- Tipler kontrol edilir, tümü secili oldugu halde aynı tipte tek kayıt olup olmadıgını kontrol eder, varsa siler --->
	<!---<cfquery name="get_all_related_parts" datasource="#dsn#">
		SELECT RELATION_TYPE FROM CONTENT_RELATION WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> ORDER BY RELATION_CAT
	</cfquery>
	<cfset related_type_list = ListSort(ListDeleteDuplicates(ValueList(get_all_related_parts.relation_type,',')),"numeric","asc")>
	<cfloop list="#related_type_list#" index="rel_type">
		<cfquery name="get_rel_parts" datasource="#dsn#">
			SELECT RELATED_ALL FROM CONTENT_RELATION WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND RELATION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#rel_type#">
		</cfquery>
		<cfquery name="get_rel_parts_" dbtype="query">
			SELECT RELATED_ALL FROM get_rel_parts WHERE RELATED_ALL = 1
		</cfquery>
		<cfif get_rel_parts.recordcount gt 1 and get_rel_parts_.recordcount>
			<cfquery name="del_related_" datasource="#dsn#">
				DELETE FROM CONTENT_RELATION WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND RELATION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#rel_type#"> AND RELATION_CAT IS NOT NULL AND RELATED_ALL <> 1
			</cfquery>  
		</cfif>
	</cfloop> --->
	<!--- Tipler kontrol edilir, tümü secili oldugu halde aynı tipte tek kayıt olup olmadıgını kontrol eder, varsa siler --->
</cfif>
<cfif fuseaction contains 'objects'>
	<cflocation addtoken="no" url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_detail_survey&survey_id=#attributes.survey_id#&related_submit=1">
<cfelse>	
	<cflocation addtoken="no" url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_detail_survey&survey_id=#attributes.survey_id#">
</cfif>





