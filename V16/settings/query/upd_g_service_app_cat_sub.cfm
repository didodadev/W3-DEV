<cfscript>
	if(isdefined("attributes.position_cats")) pos_cats =ListSort(ListDeleteDuplicates(attributes.position_cats),"Numeric", "Desc") ; else pos_cats ='';
</cfscript>
<cfquery name="upd_service_appcat_sub" datasource="#dsn#">
	UPDATE
		G_SERVICE_APPCAT_SUB
	SET
		SERVICECAT_ID = <cfif isdefined("attributes.servicecat_id") and len(attributes.servicecat_id)>#attributes.servicecat_id#<cfelse>NULL</cfif>,
		SERVICE_SUB_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_sub_cat#">,
        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_id#">,
        UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_EMP = #session.ep.userid#	,
        IS_STATUS = <cfif isdefined("attributes.is_status")>1<cfelse>0</cfif>	
	WHERE
		SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
</cfquery>

<cfquery name="del_sub_posts" datasource="#dsn#">
	DELETE FROM G_SERVICE_APPCAT_SUB_POSTS WHERE SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
</cfquery>
<cfif isdefined("attributes.to_emp_ids") and ListLen(attributes.to_emp_ids)>
	<cfloop list="#attributes.to_emp_ids#" index="a">
		<cfquery name="add_appcat_sub1" datasource="#dsn#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_POSTS
				(
                    SERVICE_SUB_CAT_ID,
                    POSITION_CAT_ID,
                    POSITION_CODE
               )
			VALUES
			   (
                   #attributes.service_cat_sub_id#,
                   NULL,
                   #a#
			   )
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.partner_ids") and len(attributes.partner_ids) gt 0>
	<cfloop list="#attributes.partner_ids#" index="b">
		<cfquery name="add_appcat_sub2" datasource="#dsn#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_POSTS
				(
                    SERVICE_SUB_CAT_ID,
                    SERVICE_PAR_ID
				)
			VALUES
			   (
                   #attributes.service_cat_sub_id#,
                   #b#
			   )
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids) gt 0>
	<cfloop list="#attributes.consumer_ids#" index="c">
		<cfquery name="add_appcat_sub3" datasource="#dsn#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_POSTS
				(
                    SERVICE_SUB_CAT_ID,
                    SERVICE_CONS_ID
				)
			VALUES
			   (
                   #attributes.service_cat_sub_id#,
                   #c#
			   )
		</cfquery>
	</cfloop>
</cfif>
<cfif ListLen(pos_cats)>
	<cfloop list="#pos_cats#" index="d" delimiters=",">
		<cfquery name="add_appcat_sub4" datasource="#dsn#">
			INSERT INTO
				G_SERVICE_APPCAT_SUB_POSTS
				(
				SERVICE_SUB_CAT_ID,
				POSITION_CAT_ID,
				POSITION_CODE
				)
			VALUES
			   (
			   #attributes.service_cat_sub_id#,
			   #d#,
			   NULL
			   )
		</cfquery>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_upd_g_service_app_cat_sub&service_cat_sub_id=#attributes.service_cat_sub_id#" addtoken="no">
