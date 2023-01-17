<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.care_cat=replacelist(attributes.care_cat,list,list2)>
<cfquery name="check" datasource="#dsn#">
	SELECT
		HIERARCHY
	FROM
		SETUP_CARE_CAT
	WHERE
	<cfif len(hierarchy)>
		HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HIERARCHY#.#CARE_CAT_CODE#">
	<cfelse>
		HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CARE_CAT_CODE#">
	</cfif>
	AND CARE_CAT_ID <> #attributes.care_cat_id#
</cfquery>

<cfif check.recordCount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2520.Bu Kod kullanılmakta; başka kod kullanınız'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>

	<cfif len(hierarchy)>
		<cfset appendix = "#hierarchy#.#care_cat_code#">
	<cfelse>
		<cfset appendix = "#care_cat_code#">
	</cfif>
	<!--- önce kategori update edilir --->
	<cfquery name="upd_care_cat" datasource="#dsn#">
		UPDATE
			SETUP_CARE_CAT
		SET
			HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#appendix#">,
			CARE_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.care_cat#">,
			DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote.addr#">,
			UPDATE_DATE = #now()#
		WHERE
			CARE_CAT_ID = #care_cat_id#
	</cfquery>
	
	<cfset eski_len = len(oldhierarchy)>
	
	<!--- alt elemalar update edilir --->
		<cfquery name="UPDATE_PRODUCT_CATS" datasource="#dsn#">
			UPDATE
				SETUP_CARE_CAT
			SET
			<cfif database_type IS 'MSSQL'><!---cfqueryparam da sorun yaşandığından sql_unicode() eklendi PY --->
				HIERARCHY = #sql_unicode()#'#appendix#.' + SUBSTRING(HIERARCHY, #len(oldhierarchy)#+2, LEN(HIERARCHY)-#len(oldhierarchy)#),
			<cfelseif database_type IS 'DB2'>
				HIERARCHY = '#appendix#.' || SUBSTR(HIERARCHY, #len(oldhierarchy)#+2, LENGTH(HIERARCHY)-#len(oldhierarchy)#),
			</cfif>
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote.addr#">,
				UPDATE_DATE = #now()#
			WHERE
				HIERARCHY LIKE '#oldhierarchy#.%' AND CARE_CAT_ID <> #care_cat_id#
		</cfquery>

		<cfif appendix neq oldhierarchy>
			<cfif len(form.hierarchy)>
				<cfquery name="upd_sub_care_cat" datasource="#dsn#">
					UPDATE 
						SETUP_CARE_CAT
					SET
						IS_SUB_CARE_CAT = 1
					WHERE
						HIERARCHY = '#form.hierarchy#'
				</cfquery>
			</cfif>
			<cfif oldhierarchy contains '.'>
				<cfset oldhierarchy_root = listdeleteat(oldhierarchy,listlen(oldhierarchy,'.'),'.')>
			<cfelse>
				<cfset oldhierarchy_root = oldhierarchy>
			</cfif>
			<cfquery name="get_sub_care_cat" datasource="#dsn#">
				SELECT 
					HIERARCHY
				FROM
					SETUP_CARE_CAT
				WHERE
					HIERARCHY LIKE '#oldhierarchy_root#.%'
			</cfquery>
			<cfif not get_sub_care_cat.recordCount>
				<cfquery name="upd_sub_care_cat" datasource="#dsn#">
					UPDATE 
						SETUP_CARE_CAT
					SET
						IS_SUB_CARE_CAT = 0
					WHERE
						HIERARCHY = '#oldhierarchy_root#'
				</cfquery>
			</cfif>
		</cfif>
		
		<cfquery name="get_sub_cat" datasource="#dsn#">
			SELECT
				HIERARCHY
			FROM
				SETUP_CARE_CAT
			WHERE
				HIERARCHY LIKE '#appendix#.'
		</cfquery>
		<cfif get_sub_cat.recordCount>
		<!--- update edilen kategorinin alt kategorisi var --->	
			<cfquery name="upd_sub_care_cat" datasource="#dsn#">
				UPDATE 
					SETUP_CARE_CAT
				SET
					IS_SUB_CARE_CAT = 1
				WHERE
					HIERARCHY = '#appendix#'
			</cfquery>
		<cfelse>
		<!--- update edilen kategorinin alt kategorisi yok --->	
			<cfquery name="upd_sub_care_cat" datasource="#dsn#">
				UPDATE 
					SETUP_CARE_CAT
				SET
					IS_SUB_CARE_CAT = 0
				WHERE
					HIERARCHY = '#appendix#'
			</cfquery>
		</cfif>		
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href= document.referrer;
</script>
