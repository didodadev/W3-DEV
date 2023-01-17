<cfif isdefined('attributes.bskt_list') and attributes.bskt_list eq 1>
	<cfquery name="GET_BASKET" datasource="#DSN3#">
		SELECT
			BASKET_ID AS ID,
			B_TYPE,
			BASKET_ID
		FROM
			SETUP_BASKET
		WHERE
			B_TYPE = #attributes.b_type#
		ORDER BY
			BASKET_ID
	</cfquery>
<cfelse>
	<cfquery name="GET_BASKET" datasource="#DSN3#">
		SELECT
			*
		FROM
			SETUP_BASKET
		WHERE
			B_TYPE = #attributes.b_type#
		<cfif isdefined('attributes.basket_id')>
			AND BASKET_ID = #attributes.basket_id#
		</cfif>
	 	ORDER BY
	   		BASKET_ID
	</cfquery>
</cfif>
