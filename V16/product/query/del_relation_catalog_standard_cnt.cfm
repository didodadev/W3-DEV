<cfquery name="upd_cnt_catalog" datasource="#dsn#">
UPDATE 
	CONTENT 
SET 
	IS_CATALOG_CONTENT = 0,
	CATALOG_PROMOTION_ID = 0
WHERE 
	CONTENT_ID = #URL.CID#  		
</cfquery>

<cflocation addtoken="no" url="#CGI.HTTP_REFERER#">
