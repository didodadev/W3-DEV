<cfsetting showdebugoutput="no">
<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="Yes">
    <cfquery name="get_brands" datasource="#dsn1#">
        SELECT BRAND_ID,BRAND_LOGO,BRAND_LOGO_SERVER_ID FROM PRODUCT_BRANDS WHERE IS_INTERNET = 1 AND IS_ACTIVE = 1 AND BRAND_LOGO IS NOT NULL
    </cfquery>
    <cfscript>
        upload_folder = "#upload_folder#product#dir_seperator#";
        file_name = "marka.xml";
        my_doc = XmlNew();
        my_doc.xmlRoot = XmlElemNew(my_doc,"Brands");
		for(i=1;i lte get_brands.recordcount; i++)
		{
			my_doc.xmlRoot.XmlChildren[i] = XmlElemNew(my_doc,"brand");
			my_doc.xmlRoot.XmlChildren[i].XmlChildren[1] = XmlElemNew(my_doc,"brand_id");
			my_doc.xmlRoot.XmlChildren[i].XmlChildren[1].XmlText = get_brands.brand_id[i];
			my_doc.xmlRoot.XmlChildren[i].XmlChildren[2] = XmlElemNew(my_doc,"logo");
			my_doc.xmlRoot.XmlChildren[i].XmlChildren[2].XmlAttributes["output_file"] =  "product/#get_brands.brand_logo[i]#";
			my_doc.xmlRoot.XmlChildren[i].XmlChildren[2].XmlAttributes["output_server"] =  get_brands.brand_logo_server_id[i];
		}
	</cfscript>
    <!---<cfxml variable="my_doc">
        <Brands baseURL="" baseHREF="index.cfm?fuseaction=objects2.view_product_list&amp;brand_id=__BRANDID__">
            <cfoutput query="get_brands">
            <brand>
                <brand_id>#get_brands.brand_id#</brand_id>
                <logo><cf_get_server_file output_file='product/#brand_logo#' output_server='#brand_logo_server_id#' output_type='4'></logo>
            </brand>
            </cfoutput>
        </Brands>
    </cfxml>--->
<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc)#" charset="utf-8">
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
<script type="text/javascript">
	alert("<cf_get_lang no ='2521.XML oluşturuldu'> !");
	window.close();
</script>

