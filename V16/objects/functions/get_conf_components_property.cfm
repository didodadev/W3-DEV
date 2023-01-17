<!--- Eğerki Ürün İsmi Ürünün Özelliklerinden Oluşsun Denilmiş ise bu bloğa girecek... M.ER 12.12.2008--->
<cfscript>
	if(not isdefined('configure_spec_name')) configure_spec_name ='';
	function GetProductConf_comp(c_spec_id)
	{
		_SubSqlStr2_ = '
			SELECT
				SMR.PRODUCT_NAME,
				PP.PROPERTY_ID,
				PP.PROPERTY,
				(SELECT PROPERTY_DETAIL FROM #dsn1_alias#.PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = SMR.VARIATION_ID ) AS VARITATION
			FROM 
				SPECT_MAIN_ROW SMR,
				#dsn1_alias#.PRODUCT_PROPERTY PP
			WHERE 
				PP.PROPERTY_ID = SMR.PROPERTY_ID AND
				SPECT_MAIN_ID = #c_spec_id# AND 
				IS_PROPERTY = 1 --SADECE ÖZELLİKLER GELSİN
			ORDER BY
				SMR.LINE_NUMBER,
				PP.PROPERTY	
			';
		_SubSqlQuery_2 = cfquery(SQLString : _SubSqlStr2_, Datasource : dsn3);
		for (_str_i_=1; _str_i_ lte _SubSqlQuery_2.recordcount; _str_i_ = _str_i_+1){
			//varyasyon yoksa yada varsada seçilmedi ise özellik olarak açıklama kısmını alsın....
			if(not len(_SubSqlQuery_2.VARITATION[_str_i_]))
				_pro_prort_name_ = _SubSqlQuery_2.PRODUCT_NAME[_str_i_];
			else
				_pro_prort_name_ = _SubSqlQuery_2.VARITATION[_str_i_];
			if(len(_pro_prort_name_) and _pro_prort_name_ neq '-')//ürün adı olarak seçilen her neyse (varyasyon yada açıklama) boş değilse ve '-'(spec listeleri oluştururken boş ise '-' değeri attığımız için ekledik buraya) değilse
				configure_spec_name = '#configure_spec_name#,#_SubSqlQuery_2.PROPERTY[_str_i_]#=#_pro_prort_name_#';
		}	
		return  configure_spec_name;
	}
</cfscript>

