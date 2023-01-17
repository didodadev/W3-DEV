<cfquery name="GET_VALUES" datasource="#DSN3#">
	SELECT
		*
	FROM
		PRODUCT_INFO_PLUS
	WHERE
		PRODUCT_ID = #attributes.ID#
</cfquery>
<cfif not GET_VALUES.recordcount>
	<cfquery name="get_pro_cat" datasource="#DSN3#">
		SELECT 
			PRODUCT_CATID,
			HIERARCHY AS ALL_CAT
		FROM
			PRODUCT_CAT
		WHERE
			PRODUCT_CATID=#attributes.PRODUCT_CATID#
	</cfquery>	
	<cfset pro_list=get_pro_cat.ALL_CAT & "." & PRODUCT_CATID>
	<cfloop from="#ListLen(pro_list,".")#" to="2" step="-1"  index="i">
		<cfquery datasource="#DSN3#" name="GET_LABELS">
			SELECT
				*
			FROM
				SETUP_PRO_INFO_PLUS_NAMES
			WHERE	
				OWNER_TYPE_ID = #attributes.TYPE_ID#
			AND
				PRODUCT_CATID LIKE '#ListGetAt(pro_list,i,".")#'
		</cfquery>
		<!--- IC 20060221  icin degistirildi
		PRODUCT_CATID = #ListGetAt(pro_list,i,".")# --->
		<cfif GET_LABELS.recordcount>
			<cfbreak>
		</cfif>
	</cfloop>

<cfelse>
		<cfset pro_list = "-">
		<cfquery datasource="#DSN3#" name="GET_LABELS">
			SELECT
				*
			FROM
				SETUP_PRO_INFO_PLUS_NAMES
			WHERE	
				OWNER_TYPE_ID =#attributes.TYPE_ID#
			AND
				PRO_INFO_ID=#GET_VALUES.PRO_INFO_ID#
		</cfquery> 

</cfif>
