<CFQUERY name="GET_CATALOG_HEAD" datasource="#DSN3#">
	SELECT #dsn#.Get_Dynamic_Language(CATALOG_PROMOTION.CATALOG_ID,'#session.ep.language#','CATALOG_PROMOTION','CATALOG_HEAD',NULL,NULL,CATALOG_PROMOTION.CATALOG_HEAD) AS CATALOG_HEAD
	 FROM CATALOG_PROMOTION WHERE CATALOG_ID = #ATTRIBUTES.CATALOG_ID#
</CFQUERY>
