<cfquery name="get_lang" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_id#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="POSITION_CAT"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_POSITION_CAT"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#POSITION#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_id#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="POSITION_CAT"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_POSITION_CAT"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="get_lang_det" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_id#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="POSITION_CAT_DETAIL"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_POSITION_CAT"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang_det.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#position_detail#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_id#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="POSITION_CAT_DETAIL"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_POSITION_CAT"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="UPDPOSITION" datasource="#dsn#">
	UPDATE 
		SETUP_POSITION_CAT 
	SET 
		POSITION_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#POSITION#">,	
		POSITION_CAT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#POSITION_DETAIL#">,
		HIERARCHY = <cfif len(HIERARCHY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#HIERARCHY#"><cfelse>NULL</cfif>,
        TITLE_ID = <cfif len(title_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#title_id#"><cfelse>NULL</cfif>,
        ORGANIZATION_STEP_ID = <cfif len(ORGANIZATION_STEP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#ORGANIZATION_STEP_ID#"><cfelse>NULL</cfif>,
        COLLAR_TYPE = <cfif len(collar_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#collar_type#"><cfelse>NULL</cfif>,
        FUNC_ID = <cfif len(func_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#func_id#"><cfelse>NULL</cfif>,
		PERF_STATUS = <cfif isdefined("attributes.PERF_STATUS")>1<cfelse>0</cfif>,
		POSITION_CAT_TYPE = <cfif isdefined("attributes.position_cat_type")>1<cfelse>0</cfif>,
		POSITION_CAT_UPPER_TYPE = <cfif isdefined("attributes.position_cat_upper_type")>1<cfelse>0</cfif>,
		POSITION_CAT_STATUS = <cfif isdefined("attributes.position_cat_status")>1<cfelse>0</cfif>,
		<!--- T_ID = <cfif len(attributes.t_id)>#attributes.t_id#<cfelse>NULL</cfif>, SG kapattı kulvar alanı 20121006--->
		IS_MT = <cfif isdefined("attributes.IS_MT")>1<cfelse>0</cfif>,
		BUSINESS_CODE_ID = <cfif isdefined("attributes.business_code_id") and len(attributes.business_code_id) and isdefined("attributes.business_code") and len(attributes.business_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.business_code_id#"><cfelse>0</cfif>,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE 
		POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_id#">
</cfquery>
<cfquery name="del_" datasource="#dsn#">
	DELETE FROM SETUP_POSITION_CAT_DEPARTMENTS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
</cfquery>
<cfquery name="get_department_names" datasource="#dsn#">
	SELECT * FROM SETUP_DEPARTMENT_NAME ORDER BY DEPARTMENT_NAME
</cfquery>
<!---<cfoutput query="get_department_names"> <!---20131111 kaldirildi--->
	<cfif isdefined("attributes.relation_#DEPARTMENT_NAME_ID#")>
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO 
				SETUP_POSITION_CAT_DEPARTMENTS
			(
				POSITION_CAT_ID,
				DEPARTMENT_NAME_ID
			)
				VALUES
			(
				#attributes.position_id#,
				#DEPARTMENT_NAME_ID#
			)
		</cfquery>
	</cfif>
</cfoutput>--->
<!--- Pozistyon ekleme sayfasının xml ine göre pozisyon adları update ediliyor --->
<cfquery name="get_position_list_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = 'hr.form_add_position'
</cfquery>
<cfif (get_position_list_xml.recordcount and get_position_list_xml.property_value eq 0)>
	<cfquery name="upd_position" datasource="#dsn#">
		UPDATE
			EMPLOYEE_POSITIONS
		SET
			POSITION_NAME =<cfqueryparam cfsqltype="cf_sql_varchar" value="#POSITION#">
		WHERE
			POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.callAjax") and attributes.callAjax eq 1><!--- Organizasyon Yönetimi sayfasıdan ajax ile çağırıldıysa 20190912ERU --->
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.list_position_cats&event=upd&position_id=#POSITION_ID#&branch_id=#attributes.branch_id#&comp_id=#attributes.comp_id#&department_id=#attributes.department_id#&position_catid=#attributes.position_id#&department=#attributes.department#</cfoutput>','ajax_right');
    <cfelse>
		window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_position_cats&event=upd&position_id=#POSITION_ID#</cfoutput>";
	</cfif>
</script>
