<!--- 
	Amaç            : stock_id verilerek,ürünün ağacında bulunan ürünlere göre main_spect_id'sini almak
	parametre adi_1 : stock_id
	kullanim        : 
					JAvaScript ==> var deger = workdata('get_main_spect_id',stock_id);
					CfScript   ==> deger = get_main_spect_id(stock_id);
					2 kullanımda da #get_main_spect_id.SPECT_MAIN_ID# diyerek fonksiyondan gelen değer alınabilir!
	Yazan           : Mahmut ER
	Tarih           : 06.03.2008
	Guncelleme      : 06.06.2008---Ürün Ağacından En Son Varyasyonlanan Spect Maın ID'yı getirme eklendi!
 --->
<cfsetting enablecfoutputonly="no">
<cfprocessingdirective suppresswhitespace="yes">
<cffunction name="get_main_spect_id" returnType="query" output="false">
	<cfargument name="stock_id" required="yes" type="numeric">
	<cfargument name="is_record" default="1" type="numeric">
	<cfquery name="_GET_MAIN_SPECT_ID_FROM_P_TREE" datasource="#DSN3#"><!--- Ürün Ağacından En Son Varyasyonlanan yani kaydedilen SPECT_MAIN_ID'yi getiriyor. --->
 		SELECT TOP 1 SPECT_MAIN_ID,SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
    </cfquery>
    <cfif _get_main_spect_id_from_p_tree.recordcount>
        <cfreturn _get_main_spect_id_from_p_tree>
        <cfexit method="exittemplate">
    <cfelse>
		<!--- Eğer yukardan kayıt dönmezse bu sefer varolan MAIN_SPECLER arasında varmı diye bakıyoruz. --->
        <cfquery name="_GET_MAIN_SPECT_ID_" datasource="#DSN3#">
            SELECT 
                TOP 1 SPECT_MAIN.SPECT_MAIN_ID,
				SPECT_MAIN.SPECT_MAIN_NAME
            FROM 
                SPECT_MAIN_ROW SPECT_MAIN_ROW,
                SPECT_MAIN SPECT_MAIN,
                PRODUCT_TREE
            WHERE
                SPECT_MAIN.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
                PRODUCT_TREE.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
                SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND 
                PRODUCT_TREE.RELATED_ID = SPECT_MAIN_ROW.STOCK_ID AND 
                SPECT_MAIN_ROW.AMOUNT = PRODUCT_TREE.AMOUNT AND
                SPECT_MAIN_ROW.IS_SEVK = PRODUCT_TREE.IS_SEVK AND 
                SPECT_MAIN_ROW.IS_CONFIGURE = PRODUCT_TREE.IS_CONFIGURE AND
                SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID = PRODUCT_TREE.SPECT_MAIN_ID AND
                (SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">)=(SELECT COUNT(SMR.SPECT_MAIN_ID) FROM SPECT_MAIN_ROW SMR WHERE SMR.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID)
            GROUP 
                BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME
            HAVING 
                COUNT(SPECT_MAIN.SPECT_MAIN_ID) = (SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">)
            ORDER 
                BY 	SPECT_MAIN.SPECT_MAIN_ID ASC
        </cfquery>
    </cfif>
	<cfif not _get_main_spect_id_.recordcount and arguments.is_record eq 1><!--- Eğer main spect id bulamadıysa ağaç bileşenlerinden,ürünün ağacındaki ürünleri kullanarak yeni bir spect oluştur. --->
		<cfquery name="GET_PRODUCT_TREE" datasource="#DSN3#">
			SELECT 
				PT.IS_CONFIGURE,
				PT.IS_SEVK,
				PT.AMOUNT,
				PT.UNIT_ID,
				PT.RELATED_ID STOCK_ID_,
				S.PRODUCT_ID AS PRODUCT_ID_,
				S.PRODUCT_NAME AS PRODUCT_NAME_,
				P.PRICE PRICE_,
				P.MONEY AS MONEY_,
				PT.SPECT_MAIN_ID
			FROM 
				PRODUCT_TREE PT,
				STOCKS S,
				PRICE_STANDART P
			WHERE
				S.PRODUCT_ID = P.PRODUCT_ID AND
				S.STOCK_ID =PT.RELATED_ID AND
				PT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
				P.PRICESTANDART_STATUS = 1 AND
				P.PURCHASESALES = 1--alis/satis
		</cfquery>
		<cfif get_product_tree.recordcount><!--- Ürünün ağacında ürün varsa --->
			<cfquery name="GET_MAIN_PRODUCT_INFO" datasource="#DSN3#"><!--- Ana ürünün bilgilerini getir --->
				SELECT 
					S.PRODUCT_NAME,
					S.PRODUCT_UNIT_ID,
					P.MONEY,
					S.PRODUCT_ID,
					P.PRICE
				FROM 
					STOCKS S,
					PRICE_STANDART P
				WHERE
					S.PRODUCT_ID = P.PRODUCT_ID AND
					S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
					P.PRICESTANDART_STATUS = 1 AND
					P.PURCHASESALES = 0
			</cfquery>
			<cfscript>
				main_stock_id = arguments.stock_id;
				main_product_id = get_main_product_info.product_id;
				spec_name = get_main_product_info.product_name;
				row_count=0;
				spec_total_value = 0;
				spec_other_total_value = 0;
				other_money = session.ep.money2;
				main_prod_price = get_main_product_info.price;
				main_product_money = get_main_product_info.money;
				stock_id_list="";
				product_id_list="";
				product_name_list="";
				amount_list="";
				sevk_list="";
				product_price_list="";
				product_money_list="";
				is_property_list ="";
				property_id_list ="";
				variation_id_list="";
				total_min_list = "";
				total_max_list = "";
				tolerance_list="";
				is_configure_list="";
				diff_price_list = "";
				related_spect_main_id_list ="";
			</cfscript>
			<cfoutput query="get_product_tree">
				<cfscript>
					row_count=row_count+1;
					product_id_list = listappend(product_id_list,product_id_,',');
					stock_id_list =  listappend(stock_id_list,stock_id_,',');
					product_name_list =  listappend(product_name_list,product_name_,',');
					amount_list = listappend(amount_list,amount,',');//sarfların miktarı bölü ana ürünün miktarı
					sevk_list = listappend(sevk_list,is_sevk,',');
					product_price_list = 	listappend(product_price_list,price_,',');
					product_money_list = listappend(product_money_list,money_,',');
					is_property_list = listappend(is_property_list,0,',');
					property_id_list = listappend(property_id_list,0,',');
					variation_id_list = listappend(variation_id_list,0,',');
					total_min_list = listappend(total_min_list,0,',');
					total_max_list = listappend(total_max_list,0,',');
					tolerance_list = listappend(tolerance_list,'-',',');
					is_configure_list = listappend(is_configure_list,is_configure,',');
					diff_price_list = listappend(diff_price_list,0,',');
					if(len(spect_main_id))
						related_spect_main_id_list  = listappend(related_spect_main_id_list,spect_main_id,',');
					else
						related_spect_main_id_list  = listappend(related_spect_main_id_list,0,',');
				</cfscript>
			</cfoutput>
			<cfscript>
				a=specer(
				dsn_type : dsn3,
				spec_is_tree : 1,
				only_main_spec: 1,
				spec_row_count : row_count,
				spec_type : session.ep.our_company_info.spect_type,
				main_stock_id : main_stock_id ,
				main_product_id : main_product_id,
				spec_name : spec_name,
				spec_total_value : spec_total_value,
				spec_other_total_value : spec_other_total_value,
				other_money : other_money,
				main_prod_price : main_prod_price,
				main_product_money:main_product_money,
				product_id_list : product_id_list,
				stock_id_list : stock_id_list,
				product_name_list:product_name_list,
				amount_list:amount_list,
				is_sevk_list:sevk_list,
				product_price_list:product_price_list,
				product_money_list:product_money_list,
				is_property_list:is_property_list,
				property_id_list : property_id_list,
				variation_id_list : variation_id_list,
				total_max_list : total_max_list,
				total_min_list : total_min_list,
				tolerance_list:tolerance_list,
				is_configure_list : is_configure_list,
				diff_price_list :diff_price_list,
				related_spect_id_list : related_spect_main_id_list
				);	
			</cfscript>
			<cfquery name="_GET_MAIN_SPECT_ID_" datasource="#DSN3#">
				SELECT SPECT_MAIN_ID,SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(a,1,',')#">
			</cfquery>
		</cfif>
	</cfif>
	<cfreturn _get_main_spect_id_>
</cffunction>
</cfprocessingdirective>
