<!--- Eğerki Ürün İsmi Ürünün Alt Ürünlerinden Oluşturulmak istenmişse bu bloğa girer
ve ürünün içindeki bileşenlerden sadece congigüre edilenleri alarak ürün ismini oluşturur... M.ER 12.12.2008--->
<cfscript>
	if(not isdefined('configure_spec_name')) configure_spec_name ='';
	function _get_subs_(spect_main_id)
	{
		_SubSqlStr_ = '
				SELECT
					ISNULL(S.IS_PRODUCTION,0)IS_PRODUCTION,
					ISNULL(SMR.RELATED_MAIN_SPECT_ID,0)AS RELATED_ID,
					SMR.STOCK_ID,
					SMR.IS_CONFIGURE,
					S.PRODUCT_NAME 
				FROM 
					SPECT_MAIN_ROW SMR,
					STOCKS S
				WHERE 
					S.STOCK_ID = SMR.STOCK_ID AND
					SPECT_MAIN_ID = #spect_main_id# AND 
					IS_PROPERTY = 0 --SADECE SARF ÜRÜNLER GELSİN
				ORDER BY
					SMR.LINE_NUMBER,
					S.PRODUCT_NAME			
			';
		_SubSqlQuery_ = cfquery(SQLString : _SubSqlStr_, Datasource : dsn3);
		_stock_id_arry_= '';
		for (_str_i_=1; _str_i_ lte _SubSqlQuery_.recordcount; _str_i_ = _str_i_+1)
		{
			_stock_id_arry_=listappend(_stock_id_arry_,_SubSqlQuery_.RELATED_ID[_str_i_],'█');
			_stock_id_arry_=listappend(_stock_id_arry_,_SubSqlQuery_.STOCK_ID[_str_i_],'§');
			_stock_id_arry_=listappend(_stock_id_arry_,_SubSqlQuery_.PRODUCT_NAME[_str_i_],'§');
			_stock_id_arry_=listappend(_stock_id_arry_,_SubSqlQuery_.IS_PRODUCTION[_str_i_],'§');
			_stock_id_arry_=listappend(_stock_id_arry_,_SubSqlQuery_.IS_CONFIGURE[_str_i_],'§');
		}
		return _stock_id_arry_;
	}
	function GetProductConf(c_spect_main_id)
	{
		var i = 1;
		var _sub_products_ = _get_subs_(c_spect_main_id);
		for (i=1; i lte listlen(_sub_products_,'█'); i = i+1)
		{
			_c_spect_main_id_ = ListGetAt(ListGetAt(_sub_products_,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
			_c_stock_id_ = ListGetAt(ListGetAt(_sub_products_,i,'█'),2,'§');
			_c_product_name_ = ListGetAt(ListGetAt(_sub_products_,i,'█'),3,'§');
			_c_is_production_ = ListGetAt(ListGetAt(_sub_products_,i,'█'),4,'§');
			_c_is_configure_= ListGetAt(ListGetAt(_sub_products_,i,'█'),5,'§');
			if(_c_is_configure_ eq 1){
				//Ürün konfigüre ediliyorsa alternatifi varmı diye bakmamız lazım..
				Conf_SqlStr = 'SELECT TOP 1 AP.PRODUCT_ID FROM ALTERNATIVE_PRODUCTS AP,STOCKS S WHERE (S.PRODUCT_ID = AP.PRODUCT_ID OR S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID) AND S.STOCK_ID =#_c_stock_id_#';
				Conf_SqlQuery = cfquery(SQLString : Conf_SqlStr, Datasource : dsn3);
				if(Conf_SqlQuery.recordcount)
					configure_spec_name = '#configure_spec_name#,#_c_product_name_#';
			}	
			if(_c_spect_main_id_ gt 0 and _c_is_production_ eq 1)
				GetProductConf(_c_spect_main_id_);
		 }
		return  configure_spec_name;
	}
</cfscript>
