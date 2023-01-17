<!--- summary tabbed menu kullanıldiginda ilişkili içeriklerde gözükmemesi için --->
<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy) and not isdefined("attributes.product_catid")>
	<cfquery name="GET_HIERARCY_CAT" datasource="#DSN1#">
		SELECT 
			PRODUCT_CAT,
			PRODUCT_CATID,
			HIERARCHY
		FROM
			PRODUCT_CAT
		WHERE
			HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">
	</cfquery>
</cfif>
<cfquery name="GET_SUMMARY_TABBED_CONTENT" datasource="#DSN#" maxrows="1">
    SELECT 
        C.CONTENT_ID
    FROM 
       	CONTENT C,
		CONTENT_RELATION PCR
    WHERE 
        C.CONTENT_STATUS = 1 AND
		C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
		PCR.CONTENT_ID = C.CONTENT_ID AND
		<cfif isdefined("attributes.pid") and len(attributes.pid)>
			PCR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
			PCR.ACTION_TYPE = 'PRODUCT_ID'
		<cfelseif isdefined("attributes.brand_id") and len(attributes.brand_id)>
			PCR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> AND
			PCR.ACTION_TYPE = 'BRAND_ID'
		<cfelseif isdefined("attributes.product_catid") and len(attributes.product_catid)>
			PCR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
			PCR.ACTION_TYPE = 'PRODUCT_CATID'
		<cfelseif isdefined("attributes.hierarchy") and len(attributes.hierarchy) and not isdefined("attributes.product_catid")>
			PCR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hierarcy_cat.product_catid#"> AND
			PCR.ACTION_TYPE = 'PRODUCT_CATID'	
		<cfelse>
			PCR.ACTION_TYPE_ID = ''
		</cfif>
		<cfif isdefined('attributes.is_content_type_id') and len(attributes.is_content_type_id)>
			AND C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_content_type_id#">
		</cfif>
	ORDER BY
		C.PRIORITY
</cfquery>

<cfquery name="GET_CONTENT_RELATION" datasource="#DSN#">
	SELECT 
		CONTENT_RELATION.*, 
		C.CONT_HEAD,
		C.CONT_SUMMARY,
		C.CONT_BODY,
		C.IS_DSP_HEADER,
		C.IS_DSP_SUMMARY,
		C.USER_FRIENDLY_URL,
		C.CONTENT_PROPERTY_ID
	FROM 
		CONTENT_RELATION, 
		CONTENT C,
	    CONTENT_CHAPTER CH,
	    CONTENT_CAT CC
	WHERE 
		C.CONTENT_STATUS = 1 AND
		C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
		C.CHAPTER_ID = CH.CHAPTER_ID AND
		CH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND	
		CONTENT_RELATION.CONTENT_ID = C.CONTENT_ID AND		
		<cfif isdefined("attributes.pid") and len(attributes.pid)>
			CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
			CONTENT_RELATION.ACTION_TYPE = 'PRODUCT_ID' AND
		<cfelseif isdefined("attributes.brand_id") and len(attributes.brand_id)>
			CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> AND
			CONTENT_RELATION.ACTION_TYPE = 'BRAND_ID' AND
		<cfelseif isdefined("attributes.product_catid") and len(attributes.product_catid)>
			CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
			CONTENT_RELATION.ACTION_TYPE = 'PRODUCT_CATID' AND
		<cfelseif isdefined("attributes.hierarchy") and len(attributes.hierarchy) and not isdefined("attributes.product_catid")>
			CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hierarcy_cat.product_catid#"> AND
			CONTENT_RELATION.ACTION_TYPE = 'PRODUCT_CATID' AND
		<cfelse>
			CONTENT_RELATION.ACTION_TYPE_ID = '' AND
		</cfif>
		<cfif isdefined("attributes.product_relation_content_type") and len(attributes.product_relation_content_type)>
			C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_relation_content_type#"> AND
		</cfif>
		<cfif isdefined('attributes.is_content_type_id') and len(attributes.is_content_type_id)>
			<cfif len(get_summary_tabbed_content.content_id)>
				C.CONTENT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_summary_tabbed_content.content_id#"> AND
			</cfif>
		</cfif>		
		INTERNET_VIEW = 1 		
	ORDER BY
		C.PRIORITY
</cfquery>
<cfif isdefined("attributes.pid") and len(attributes.pid) and not get_content_relation.recordcount>
	<cfquery name="GET_CONTENT_RELATION" datasource="#DSN#">
		SELECT 
			CONTENT_RELATION.*, 
			C.CONT_HEAD,
			C.CONT_SUMMARY,
			C.CONT_BODY,
			C.IS_DSP_HEADER,
			C.IS_DSP_SUMMARY,
			C.USER_FRIENDLY_URL,
			C.CONTENT_PROPERTY_ID
		FROM 
			CONTENT_RELATION, 
			CONTENT C,
			CONTENT_CHAPTER CH,
			CONTENT_CAT CC
		WHERE 
			C.CONTENT_STATUS = 1 AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			C.CHAPTER_ID = CH.CHAPTER_ID AND
			CH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND	
			CONTENT_RELATION.CONTENT_ID = C.CONTENT_ID AND		
			<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
				CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> AND 
				CONTENT_RELATION.ACTION_TYPE = 'BRAND_ID' AND
			<cfelseif isdefined("attributes.product_catid") and len(attributes.product_catid)>
				CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
				CONTENT_RELATION.ACTION_TYPE = 'PRODUCT_CATID' AND
			<cfelseif isdefined("attributes.hierarchy") and len(attributes.hierarchy) and not isdefined("attributes.product_catid")>
				CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hierarcy_cat.product_catid#"> AND
				CONTENT_RELATION.ACTION_TYPE = 'PRODUCT_CATID' AND
			<cfelse>
				CONTENT_RELATION.ACTION_TYPE_ID = '' AND
			</cfif>
			<cfif isdefined("attributes.product_relation_content_type") and len(attributes.product_relation_content_type)>
				C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_relation_content_type#"> AND
			</cfif>
			<cfif isdefined('attributes.is_content_type_id') and len(attributes.is_content_type_id)>
				<cfif len(get_summary_tabbed_content.content_id)>
					C.CONTENT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_summary_tabbed_content.content_id#"> AND
				</cfif>
			</cfif>	
				INTERNET_VIEW = 1 		
		ORDER BY
			C.PRIORITY
	</cfquery>
</cfif>
