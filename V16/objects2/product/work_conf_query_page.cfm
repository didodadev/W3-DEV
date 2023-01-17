<cfif isdefined('attributes.danismanlik_urun_info') and len(attributes.danismanlik_urun_info)>
	<cfquery name="GET_DANISMANLIK_DETAY" datasource="#DSN3#">
          SELECT 
            S.STOCK_ID,
            S.PRODUCT_ID,
            S.PRODUCT_NAME,
            PS.PRICE,
            PS.PRICE_KDV,
            PU.PRODUCT_UNIT_ID
        FROM
            STOCKS S,
            PRICE_STANDART PS,
            PRODUCT_UNIT PU
        WHERE
            S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.danismanlik_urun_info,2,'█')#"> AND
            S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.danismanlik_urun_info,1,'█')#"> AND
            PU.PRODUCT_ID = S.PRODUCT_ID AND
            PU.IS_MAIN = 1 AND
            PS.PRODUCT_ID = S.PRODUCT_ID AND
            PS.PRICESTANDART_STATUS = 1 AND
            PS.PURCHASESALES = 1
    </cfquery>
    <cfscript>
		
		attributes.product_id_list = Left(attributes.product_id_list,len(attributes.product_id_list)-1);
		attributes.stock_id_list = Left(attributes.stock_id_list,len(attributes.stock_id_list)-1);
		attributes.product_name_list = Left(attributes.product_name_list,len(attributes.product_name_list)-1);
		attributes.amount_list = Left(attributes.amount_list,len(attributes.amount_list)-1);
		attributes.product_price_list = Left(attributes.product_price_list,len(attributes.product_price_list)-1);
		attributes.product_price_kdv_list = Left(attributes.product_price_kdv_list,len(attributes.product_price_kdv_list)-1);
		attributes.product_unit_id_list = Left(attributes.product_unit_id_list,len(attributes.product_unit_id_list)-1);
		//once sonranlarinki ,'den kurtarıyoruz...
		//sonra query'den gelen değeri ekliyoruz.
		
		attributes.product_id_list = ListAppend(attributes.product_id_list,get_danismanlik_detay.stock_id,',');
		attributes.stock_id_list = ListAppend(attributes.stock_id_list,get_danismanlik_detay.stock_id,',');
		attributes.product_name_list = ListAppend(attributes.product_name_list,get_danismanlik_detay.product_name,'|@|');
		attributes.amount_list = ListAppend(attributes.amount_list,(attributes.get_danismanlik_detay/get_danismanlik_detay.price),',');
		attributes.product_price_list = ListAppend(attributes.product_price_list,get_danismanlik_detay.price,',');
		attributes.product_price_kdv_list = ListAppend(attributes.product_price_kdv_list,get_danismanlik_detay.price_kdv,',');
		attributes.product_unit_id_list = ListAppend(attributes.product_unit_id_list,get_danismanlik_detay.product_unit_id,',');
    </cfscript>
</cfif>
<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
<cfelseif IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
    <cfquery name="DELETE_ORDER_PRE_ROWS" datasource="#DSN3#">
    	DELETE ORDER_PRE_ROWS WHERE COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
    </cfquery>    
</cfif>
<cfloop from="1" to="#listlen(attributes.stock_id_list,',')#"index="_ind_">
	<cftransaction>
		<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
			INSERT INTO
				ORDER_PRE_ROWS
					(
                        PRODUCT_ID,
                        PRODUCT_NAME,
                        QUANTITY,
                        PRICE,
                        PRICE_KDV,
                        PRICE_MONEY,
                        TAX,
                        STOCK_ID,
                        PRODUCT_UNIT_ID,
                        PRICE_STANDARD,
                        PRICE_STANDARD_KDV,
                        PRICE_STANDARD_MONEY,
                        IS_PROM_ASIL_HEDIYE,
                        PROM_STOCK_AMOUNT,
                        IS_NONDELETE_PRODUCT,
                        RECORD_PERIOD_ID,
                        RECORD_PAR,
                        RECORD_CONS,
                        RECORD_GUEST,
                        COOKIE_NAME,
                        RECORD_IP,
                        RECORD_DATE
					)
					VALUES
					(
                        #ListGetAt(attributes.product_id_list,_ind_,',')#,
                        '#ListGetAt(attributes.product_name_list,_ind_,'|@|')#',
                        #ListGetAt(attributes.amount_list,_ind_,',')#,<!--- miktar --->
                        #ListGetAt(attributes.product_price_list,_ind_,',')#,<!--- Fiyat --->
                        #ListGetAt(attributes.product_price_kdv_list,_ind_,',')#,<!--- kdvli fiyat --->
                        '#attributes.main_product_money#',<!--- system 2.ci para biriminden alınsın denildi. --->
                        #(((ListGetAt(attributes.product_price_kdv_list,_ind_,',') / ListGetAt(attributes.product_price_list,_ind_,','))*100)-100)#,<!--- KDV ORANI --->
                        #ListGetAt(attributes.stock_id_list,_ind_,',')#,<!--- Stok id --->
                        #ListGetAt(attributes.product_unit_id_list,_ind_,',')#,<!--- product_unit_id --->
                        #ListGetAt(attributes.product_price_list,_ind_,',')#,<!--- fiyat --->
                        #ListGetAt(attributes.product_price_kdv_list,_ind_,',')#,<!--- kdvli fiyat --->
                        '#attributes.main_product_money#',
                        0,<!--- IS_PROM_ASIL_HEDIYE --->
                       	1,<!--- PROM_STOCK_AMOUNT --->
                        0,<!--- IS_NONDELETE_PRODUCT --->
                        #session_base.period_id#,
                        <cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
                        <cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                        <cfif not isdefined("session.pp") and not isdefined("session.ww.userid")>1<cfelse>0</cfif>,
                        <cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
                        '#cgi.remote_addr#',
                        #now()#
					)
		</cfquery>
	</CFTRANSACTION>
</cfloop>
<cflocation url="#request.self#?fuseaction=objects2.list_basket" addtoken="no">
SEPETE EKLENDİ!
