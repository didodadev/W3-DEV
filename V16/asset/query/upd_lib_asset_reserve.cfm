<cfquery name="MAKE_FINISH_LIB" datasource="#dsn#">
	SELECT
		LIBRARY_RESERVE_ID,
		FINISHDATE
	FROM
		LIBRARY_ASSET_RESERVE
	WHERE
		LIBRARY_ASSET_ID = #URL.lib_asset_id#
	AND
		STATUS = 0
</cfquery>

<cfquery name="MAKE_FINISH_LIB_RESERVATION" datasource="#dsn#">
	UPDATE
		LIBRARY_ASSET_RESERVE
	SET
		RETURN_DATE = #NOW()#,
		STATUS		= 1
	WHERE
		LIBRARY_ASSET_ID = #URL.lib_asset_id#
	AND
		STATUS = 0
</cfquery>

<cfquery name="RESEARCH_RES_LIB_ASSET" datasource="#dsn#">
	SELECT
		LIBRARY_RESERVE_ID,
		FINISHDATE
	FROM
		LIBRARY_ASSET_RESERVE
	WHERE
		LIBRARY_ASSET_ID = #URL.lib_asset_id#
	AND
		RESERVE_STEP = (SELECT MIN(RESERVE_STEP) FROM LIBRARY_ASSET_RESERVE WHERE RESERVE_STEP > 0)
	AND
		STATUS = 2
</cfquery>

<cfif RESEARCH_RES_LIB_ASSET.RecordCount>
	
	<cfquery name="UPD_RES_LIB_ASSET" datasource="#dsn#">
		UPDATE
			LIBRARY_ASSET_RESERVE
		SET
		    STARTDATE = #NOW()# ,
			RESERVE_STEP = 0    ,
			STATUS	  = 3
		WHERE
			LIBRARY_ASSET_ID = #URL.lib_asset_id#
		AND
			RESERVE_STEP = (SELECT MIN(RESERVE_STEP) FROM LIBRARY_ASSET_RESERVE WHERE RESERVE_STEP > 0)	
		AND
			STATUS = 2
	</cfquery>
	
</cfif>

<script type="text/javascript">
	 location.href = document.referrer;
</script>
