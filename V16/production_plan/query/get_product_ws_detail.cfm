<cfquery name="get_pro" datasource="#dsn3#">
	<cfif isdefined('attributes.STOCK_ID') or isdefined('attributes.upd')>
        SELECT
            0 AS TYPE,
            WSP.*,
            S.PROPERTY,
            S.PRODUCT_NAME,
            PU.MAIN_UNIT,
            W.STATION_NAME,
			W.COMMENT
        FROM
            WORKSTATIONS_PRODUCTS WSP,
            STOCKS S,
            PRODUCT_UNIT PU,
            WORKSTATIONS W
        WHERE
            W.STATION_ID=WSP.WS_ID AND 
            WSP.STOCK_ID=S.STOCK_ID AND
            S.PRODUCT_ID=PU.PRODUCT_ID AND
            PU.IS_MAIN=1
        <cfif isdefined('attributes.STOCK_ID')>
            AND S.STOCK_ID=#attributes.STOCK_ID#		
        </cfif>
        <cfif isdefined('attributes.upd')>
            AND WSP.WS_ID=#attributes.upd#
        </cfif>
    </cfif>
<cfif isdefined('attributes.upd')>
	UNION ALL
</cfif>
<cfif isdefined('attributes.operation_type_id') or isdefined('attributes.upd')>
	SELECT
        3 AS TYPE,
		WSP.*,
		O.OPERATION_CODE AS PROPERTY,
		O.OPERATION_TYPE AS PRODUCT_NAME,
		'dk' AS MAIN_UNIT,
		W.STATION_NAME,
		W.COMMENT
	FROM
		WORKSTATIONS_PRODUCTS WSP,
		OPERATION_TYPES O,
		WORKSTATIONS W
	WHERE
		W.STATION_ID=WSP.WS_ID AND 
		WSP.OPERATION_TYPE_ID=O.OPERATION_TYPE_ID
	<cfif isdefined('attributes.operation_type_id')>
		AND O.OPERATION_TYPE_ID=#attributes.operation_type_id#		
	</cfif>
	<cfif isdefined('attributes.upd')>
		AND WSP.WS_ID=#attributes.upd#
	</cfif>
</cfif>
</cfquery>


