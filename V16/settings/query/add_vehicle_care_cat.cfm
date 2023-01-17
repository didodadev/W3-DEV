<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.care_cat=replaceList(attributes.care_cat,list,list2)>

<cfquery name="check" datasource="#dsn#">
	SELECT
		HIERARCHY
	FROM
		SETUP_CARE_CAT
	WHERE
	<cfif len(hierarchy)>
		HIERARCHY = '#HIERARCHY#.#CARE_CAT_CODE#'
	<cfelse>
		HIERARCHY = '#CARE_CAT_CODE#'
	</cfif>
</cfquery>
<!--- Aynı Kategori Kontrolü --->
<cfif check.recordCount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='44503.Bu Kod kullanılmakta başka kod kullanınız'>!");
		<cfif isDefined('attributes.draggable')>
			closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>,'item_add');
		<cfelse>
			history.back();
		</cfif>
	</script>
	<cfabort>
</cfif>

<!--- Hierarchy Belirle --->
<cfif len(form.hierarchy)>
	<cfset yer = "#form.hierarchy#.#form.care_cat_code#">
<cfelse>
	<cfset yer = form.care_cat_code>
</cfif>

<cfquery name="add_care_cat" datasource="#dsn#">
	INSERT INTO 
		SETUP_CARE_CAT
		(
		CARE_CAT,
		HIERARCHY,
		DETAIL,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.care_cat#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#yer#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
</cfquery>

<!--- Ust kategorinin alt kategorisi var --->
<cfif len(form.hierarchy)>
	<cfquery name="add_sub_care_cat" datasource="#dsn#">
		UPDATE 
			SETUP_CARE_CAT
		SET
			IS_SUB_CARE_CAT = 1
		WHERE
			HIERARCHY = '#form.hierarchy#'
	</cfquery>
	<cfquery name="get_sub_care_cat" datasource="#dsn#">
		SELECT
			HIERARCHY
		FROM
			SETUP_CARE_CAT
		WHERE
			HIERARCHY LIKE '#HIERARCHY#.#CARE_CAT_CODE#.'
	</cfquery>

<!--- eklenen kategorinin alt kategorisi var --->	
	<cfif get_sub_care_cat.recordCount>
		<cfquery name="upd_is_sub_care_cat" datasource="#dsn#">
			UPDATE 
				SETUP_CARE_CAT
			SET
				IS_SUB_CARE_CAT = 1
			WHERE
				HIERARCHY = '#HIERARCHY#.#CARE_CAT_CODE#'
		</cfquery>
	<cfelse>
	<!--- eklenen kategorinin alt kategorisi yok --->	
		<cfquery name="upd_is_sub_care_cat" datasource="#dsn#">
			UPDATE 
				SETUP_CARE_CAT
			SET
				IS_SUB_CARE_CAT = 0
			WHERE
				HIERARCHY = '#HIERARCHY#.#CARE_CAT_CODE#'
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="get_sub_cat" datasource="#dsn#">
		SELECT
			HIERARCHY
		FROM
			SETUP_CARE_CAT
		WHERE
			HIERARCHY LIKE '#CARE_CAT_CODE#.'
	</cfquery>
	<cfif get_sub_cat.recordCount>
	<!--- eklenen kategorinin alt kategorisi var --->	
		<cfquery name="upd_is_sub_care_cat" datasource="#dsn#">
			UPDATE 
				SETUP_CARE_CAT
			SET
				IS_SUB_CARE_CAT = 1
			WHERE
				HIERARCHY = '#CARE_CAT_CODE#'
		</cfquery>
	<cfelse>
	<!--- eklenen kategorinin alt kategorisi yok --->	
		<cfquery name="upd_is_sub_care_cat" datasource="#dsn#">
			UPDATE 
				SETUP_CARE_CAT
			SET
				IS_SUB_CARE_CAT = 0
			WHERE
				HIERARCHY = '#CARE_CAT_CODE#'
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	location.href = document.referrer;
</script>
