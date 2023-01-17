<!--- 
	amac            : BRAND_NAME vererek BRAND_ID,BRAND_NAME bilgisini getirmek
	parametre adi   : brand_name
	ayirma isareti  : YOK
	kullanim        : get_brand('Asu') 
	Yazan           : A.Selam Karatas
	Tarih           : 16.5.2007
	Guncelleme      : 16.5.2007
 --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">	
		<cfquery name="GET_BRAND" datasource="#DSN#_product">
			SELECT 
				0 AS TYPE,
				'' AS BRAND_ID,
				'Seçiniz' AS BRAND_NAME,
                '' AS BRAND_CODE
			FROM 
				PRODUCT_BRANDS
			UNION
			SELECT 
				1 AS TYPE,
				BRAND_ID,
				BRAND_NAME,
                BRAND_CODE
			FROM 
				PRODUCT_BRANDS
			ORDER BY 
				TYPE,BRAND_NAME
		</cfquery>
	<cfreturn get_brand>
</cffunction>
</cfcomponent>
