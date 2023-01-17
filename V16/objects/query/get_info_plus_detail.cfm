<cfif isdefined ("attributes.type_id") and ((attributes.type_id eq -1) or (attributes.type_id eq -2) or (attributes.type_id eq -3) or (attributes.type_id eq -4) or (attributes.type_id eq -13) or (attributes.type_id eq -19) or (attributes.type_id eq -20) or (attributes.type_id eq -15) or (attributes.type_id eq -18) or (attributes.type_id eq -24) or (attributes.type_id eq -21))>
	<cfset tablo_adi = "INFO_PLUS">
	<cfset kolon_adi = "OWNER_ID">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("attributes.type_id") and (attributes.type_id eq -5)>
	<cfset tablo_adi = "PRODUCT_INFO_PLUS">
	<cfset kolon_adi = "PRODUCT_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and (attributes.type_id eq -6)>
	<cfset tablo_adi = "PRODUCT_TREE_INFO_PLUS">
	<cfset kolon_adi = "STOCK_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -7) or (attributes.type_id eq -12))><!--- Satis ve satinalma siparisleri --->
	<cfset tablo_adi = "ORDER_INFO_PLUS">
	<cfset kolon_adi = "ORDER_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -8) or (attributes.type_id eq -32))>
	<cfset tablo_adi = "INVOICE_INFO_PLUS">
	<cfset kolon_adi = "INVOICE_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -9) or (attributes.type_id eq -30))>
	<cfset tablo_adi = "OFFER_INFO_PLUS">
	<cfset kolon_adi = "OFFER_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined("attributes.type_id") and ((attributes.type_id) eq -16)>
	<cfset tablo_adi = "OPPORTUNITIES_INFO_PLUS">
	<cfset kolon_adi = "OPP_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -10))>
	<cfset tablo_adi = "PROJECT_INFO_PLUS">
	<cfset kolon_adi = "PROJECT_ID">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -11))>
	<cfset tablo_adi = "SUBSCRIPTION_INFO_PLUS">
	<cfset kolon_adi = "SUBSCRIPTION_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -14) or (attributes.type_id eq -31))>
	<cfset tablo_adi = "SHIP_INFO_PLUS">
	<cfset kolon_adi = "SHIP_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -17))>
	<cfset tablo_adi = "EXPENSE_ITEM_PLANS_INFO_PLUS">
	<cfset kolon_adi = "EXPENSE_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -22))>
	<cfset tablo_adi = "STOCK_FIS_INFO_PLUS">
	<cfset kolon_adi = "FIS_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("attributes.type_id") and ((attributes.type_id eq -28) or (attributes.type_id eq -29))>
	<cfset tablo_adi = "INTERNALDEMAND_INFO_PLUS">
	<cfset kolon_adi = "INTERNAL_ID">
	<cfset dsn_adi = dsn3>
</cfif>
<cfif isdefined ("attributes.type_id") and ((attributes.type_id eq -1) or (attributes.type_id eq -2) or (attributes.type_id eq -3) or (attributes.type_id eq -4) or (attributes.type_id eq -10) or (attributes.type_id eq -13) or (attributes.type_id eq -19) or (attributes.type_id eq -20) or (attributes.type_id eq -15) or (attributes.type_id eq -18) or (attributes.type_id eq -21))>
	<cfquery name="GET_LABELS" datasource="#DSN#">
		SELECT
		<cfloop from="1" to="40" index="i">
                #dsn#.Get_Dynamic_Language(INFO_ID,'#session.ep.language#','SETUP_INFOPLUS_NAMES','PROPERTY#i#_NAME',NULL,NULL,PROPERTY#i#_NAME) AS PROPERTY#i#_NAME,
        </cfloop>
		*
		FROM
			SETUP_INFOPLUS_NAMES
		WHERE	
			OWNER_TYPE_ID = #attributes.type_id#
			<cfif isdefined("attributes.assetp_catid") and len(attributes.assetp_catid)>
				AND MULTI_ASSETP_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.assetp_catid#,%">
			</cfif>
			<cfif isdefined("attributes.work_catid") and len(attributes.work_catid)>
				AND MULTI_WORK_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.work_catid#,%">
			</cfif>
	</cfquery>
	<cfif GET_LABELS.recordcount>
		<cfquery name="GET_SELECT_VALUES" datasource="#DSN#">
			SELECT
				*
			FROM
				SETUP_INFOPLUS_VALUES
			WHERE	
				INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_LABELS.INFO_ID#">
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="GET_LABELS" datasource="#DSN3#">
		SELECT
			*
		FROM
			SETUP_PRO_INFO_PLUS_NAMES
		WHERE	
			OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
			<cfif isdefined("attributes.product_catid")>
				AND MULTI_PRODUCT_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.product_catid#,%">
			</cfif>
			<cfif isdefined("attributes.sub_catid")>
				AND MULTI_SUB_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.sub_catid#,%">
			</cfif>
	</cfquery>
    <cfif GET_LABELS.recordcount>
		<cfquery name="GET_SELECT_VALUES" datasource="#DSN3#">
			SELECT
				*
			FROM
				SETUP_PRO_INFO_PLUS_VALUES
			WHERE	
				PRO_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_LABELS.PRO_INFO_ID#">
		</cfquery>
	</cfif>
</cfif>
<cfquery name="GET_VALUES" datasource="#dsn_adi#">
	SELECT
		PROPERTY1,
		PROPERTY2,
		PROPERTY3,
		PROPERTY4,
		PROPERTY5,
		PROPERTY6,
		PROPERTY7,
		PROPERTY8,
		PROPERTY9,
		PROPERTY10,
		PROPERTY11,
		PROPERTY12,
		PROPERTY13,
		PROPERTY14,
		PROPERTY15,
		PROPERTY16,
		PROPERTY17,
		PROPERTY18,
		PROPERTY19,
		PROPERTY20,
		PROPERTY21,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE
	FROM
		#tablo_adi#
	WHERE
		#kolon_adi# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.info_id#">
 		<cfif isdefined("attributes.type_id") and ((attributes.type_id eq -1) or (attributes.type_id eq -2) or (attributes.type_id eq -3) or (attributes.type_id eq -4 ) or (attributes.type_id eq -10) or (attributes.type_id eq -13) or (attributes.type_id eq -18) or (attributes.type_id eq -19) or (attributes.type_id eq -20) or (attributes.type_id eq -15) or (attributes.type_id eq -21))>
			AND INFO_OWNER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
		<cfelseif (isdefined("get_labels.pro_info_id") and len(get_labels.pro_info_id)) and (isdefined("attributes.type_id") and attributes.type_id eq -5)>
			AND PRO_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_labels.pro_info_id#">
		</cfif>
 </cfquery>
