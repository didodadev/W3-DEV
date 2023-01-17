<!--- 
	Bu sayfadan objects*query icindede var orayida update ediniz.arzubt 051122003
--->
<cfquery name="GET_PRICE_CHANGE_DET" datasource="#DSN3#">
	(
	SELECT
		PCH.PRODUCT_ID,
		PCH.PRICE_CHANGE_ID,
		PCH.SAME_CHANGE_ID,
		PCH.STARTDATE AS STARTDATE,
		PCH.FINISHDATE AS FINISHDATE,
		PCH.PRICE_CATID,
		PCH.PRICE,
		PCH.PRICE_KDV,
		PCH.IS_KDV,
		PCH.IS_VALID,
		PCH.MONEY,
		PCH.UNIT,
		PCH.REASON,
		PCH.RECORD_EMP,
		PCH.RECORD_DATE,
		PC.PRICE_CAT,
		PCH.UPDATE_EMP,
		PCH.UPDATE_DATE
	FROM
		PRICE_CHANGE PCH,
		PRICE_CAT PC
	WHERE
		PC.PRICE_CATID=PCH.PRICE_CATID 
		AND PCH.PRICE_CATID > 0
	<cfif isDefined('attributes.valid_only') and attributes.valid_only eq 1>
		AND IS_VALID IS NULL
	</cfif>
	
	<cfif isDefined('attributes.pid')>
		AND PCH.PRODUCT_ID=#attributes.pid#			
	</cfif>
	<cfif isDefined('attributes.id')>
		AND PCH.PRICE_CHANGE_ID=#attributes.id#
	</cfif>
	)
UNION ALL
	(
	SELECT
		PCH.PRODUCT_ID,
		PCH.PRICE_CHANGE_ID,
		PCH.SAME_CHANGE_ID,
		PCH.STARTDATE AS STARTDATE,
		PCH.FINISHDATE AS FINISHDATE,
		PCH.PRICE_CATID,
		PCH.PRICE,
		PCH.PRICE_KDV,
		PCH.IS_KDV,
		PCH.IS_VALID,
		PCH.MONEY,
		PCH.UNIT,
		PCH.REASON,
		PCH.RECORD_EMP,
		PCH.RECORD_DATE,
		'' AS PRICE_CAT,
		PCH.UPDATE_EMP,
		PCH.UPDATE_DATE
	FROM
		PRICE_CHANGE PCH
	WHERE
		PCH.PRICE_CATID < 0
	<cfif isDefined('attributes.valid_only') and attributes.valid_only eq 1>
		AND IS_VALID IS NULL
	</cfif>
	<cfif isDefined('attributes.pid')>
		AND PCH.PRODUCT_ID=#attributes.pid#			
	</cfif>
	<cfif isDefined('attributes.id')>
		AND PCH.PRICE_CHANGE_ID=#attributes.id#
	</cfif>
	)
	ORDER BY
		STARTDATE,FINISHDATE DESC
</cfquery>
