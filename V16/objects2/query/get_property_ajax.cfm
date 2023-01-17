<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
	<cfquery name="GET_PROPERTY" datasource="#DSN1#">
		SELECT DISTINCT
			PP.PROPERTY,
			PP.PROPERTY_ID
		FROM 
			PRODUCT_PROPERTY PP,
			PRODUCT_CAT_PROPERTY PCP,
			PRODUCT_PROPERTY_OUR_COMPANY PPO
		WHERE
			PCP.PROPERTY_ID = PP.PROPERTY_ID AND
			PCP.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
			PP.PROPERTY_ID = PPO.PROPERTY_ID AND
			PPO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PP.IS_INTERNET = 1 AND
			PP.IS_ACTIVE = 1
	</cfquery>
    <cfquery name="GET_LANGUAGE_INFOS" datasource="#DSN#">
        SELECT
            ITEM,
            UNIQUE_COLUMN_ID
        FROM
            SETUP_LANGUAGE_INFO
        WHERE
            <cfif isdefined('session.pp')>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
            <cfelse>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
            </cfif>
            COLUMN_NAME = 'PROPERTY' AND
            TABLE_NAME = 'PRODUCT_PROPERTY'
    </cfquery>
    <cfquery name="GET_LANGUAGE_INFOS2" datasource="#DSN#">
        SELECT
            ITEM,
            UNIQUE_COLUMN_ID
        FROM
            SETUP_LANGUAGE_INFO
        WHERE
            <cfif isdefined('session.pp')>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
            <cfelse>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
            </cfif>
            COLUMN_NAME = 'PROPERTY_DETAIL' AND
            TABLE_NAME = 'PRODUCT_PROPERTY_DETAIL'
    </cfquery>
	<cfquery name="GET_ALL_PROPERTY_DETAIL" datasource="#DSN1#">
		SELECT
			PRPT_ID,
			PROPERTY_DETAIL_ID,
			PROPERTY_DETAIL
		FROM
			PRODUCT_PROPERTY_DETAIL PPD,
			PRODUCT_CAT_PROPERTY PCP
		WHERE
			PCP.PROPERTY_ID = PPD.PRPT_ID AND 
			PCP.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
	</cfquery>
	<cfset mystr = '<table border="0" valing="top">'>
	<cfoutput query="get_property">
        <cfquery name="GET_LANGUAGE_INFO" dbtype="query">
            SELECT
                *
            FROM
                GET_LANGUAGE_INFOS
            WHERE
                UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
        </cfquery>
		<cfquery name="GET_VARIATION" dbtype="query">
            SELECT
                PROPERTY_DETAIL_ID,
                PROPERTY_DETAIL
            FROM
                GET_ALL_PROPERTY_DETAIL
            WHERE
                PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_property.property_id#">
      	</cfquery>
        <cfparam name="attributes.mode" default="3">
        <cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
            <cfset mystr = mystr & '<tr id="frm_row#currentrow#">'>
        </cfif>
        <cfif get_language_info.recordcount>
			<cfset mystr = mystr & '<td>#get_language_info.item#</td>'>		
        <cfelse>
			<cfset mystr = mystr & '<td>#property#</td>'>		
        </cfif>
        <cfset mystr = mystr & '<td width="160">'>
		<cfset mystr = mystr & '<select name="variation_select" style="width:150px;">'>
        <cfset mystr = mystr & '<option value="">Tümü</option>'>
        <cfif get_variation.recordcount>
            <cfloop query="get_variation">
                <cfquery name="GET_LANGUAGE_INFO2" dbtype="query">
                    SELECT
                        *
                    FROM
                        GET_LANGUAGE_INFOS2
                    WHERE
                        UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_variation.property_detail_id#">
                </cfquery>
                <cfif get_language_info2.recordcount>
					<cfif listlen(list_variation_id) and listfindnocase(list_variation_id,property_detail_id)>
                        <cfset mystr = mystr & '<option value="#get_property.property_id#*#property_detail_id#" selected>#get_language_info2.item#</option>'>
                    <cfelse>
                        <cfset mystr = mystr & '<option value="#get_property.property_id#*#property_detail_id#">#get_language_info2.item#</option>'>
                    </cfif>
                <cfelse>
					<cfif listlen(list_variation_id) and listfindnocase(list_variation_id,property_detail_id)>
                        <cfset mystr = mystr & '<option value="#get_property.property_id#*#property_detail_id#" selected>#property_detail#</option>'>
                    <cfelse>
                        <cfset mystr = mystr & '<option value="#get_property.property_id#*#property_detail_id#">#property_detail#</option>'>
                    </cfif>
                </cfif>
            </cfloop>
        </cfif>
        <cfset mystr = mystr & '</select>'>
        <cfset mystr = mystr & '</td>'>
        <cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)><cfset mystr = mystr & '</tr>'></cfif>
    </cfoutput>
	<cfset mystr = mystr & '</table>'>
	<cfoutput>#mystr#</cfoutput>
</cfif>


