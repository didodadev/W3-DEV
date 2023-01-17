<!--- wrk_not : yetkiye bakılmadan fiyat siliniyor !!!! --->
<!--- wrk_not : Burada PRICE_HISTORY ile ilgili olarak fiyatın silindiği ve kimin sildiği belli olmalı ! 20040121 --->
<!--- <cfabort> --->
<!--- 
is_stck_price : stok için tanımlanmış fiyat silinecekse gönderilir 
is_spc_price :  spec için tanımlanmış fiyat silinecekse gönderilir 
20091112 --->
<cfif len(URL.PRICE_ID)>
	<cftransaction>
	<cfloop list="#URL.PRICE_ID#" index="sayac"><!--- Burada loop kullandık çünkü karma kolide bir başlangıç birde bitiş fiyatı olmak üzere 2 fiyat ekleniyor ve silinmek istendiğinde de 2 fiyat gönderiyoruz. --->
	<cfset url.price_id = sayac>
		<cfquery name="GET_PRICE" datasource="#dsn3#">
			SELECT * FROM PRICE WHERE PRICE_ID = #URL.PRICE_ID#
		</cfquery>
		<cfif GET_PRICE.recordcount and not (isdefined('attributes.is_stck_price') and attributes.is_stck_price eq 1) and not (isdefined('attributes.is_spc_price') and attributes.is_spc_price eq 1)>
			<cfquery name="GET_PREVIOUS_PRODUCT_PRICE" datasource="#dsn3#" maxrows="1">
				SELECT 
					PRICE_ID
				FROM
					PRICE
				WHERE
					PRODUCT_ID=#GET_PRICE.PRODUCT_ID#
					AND UNIT=#GET_PRICE.UNIT#
					AND PRICE_CATID=#GET_PRICE.PRICE_CATID#
					AND FINISHDATE < #CreateODBCDateTime(GET_PRICE.STARTDATE)#
					<!---AND ISNULL(STOCK_ID,0)=0--->
					AND ISNULL(SPECT_VAR_ID,0)=0
				ORDER BY FINISHDATE DESC
			</cfquery>
			<cfquery name="GET_PREVIOUS_PRODUCT_PRICE_HISTORY" datasource="#dsn3#" maxrows="1">
				SELECT
					PRICE_HISTORY_ID
				FROM
					PRICE_HISTORY
				WHERE
					PRODUCT_ID=#GET_PRICE.PRODUCT_ID#
					AND UNIT=#GET_PRICE.UNIT#
					AND PRICE_CATID=#GET_PRICE.PRICE_CATID#
					AND FINISHDATE < #CreateODBCDateTime(GET_PRICE.STARTDATE)#
					AND ISNULL(STOCK_ID,0)=0
					AND ISNULL(SPECT_VAR_ID,0)=0
				ORDER BY FINISHDATE DESC
			</cfquery>
		<cfelse>
			<cfset GET_PREVIOUS_PRODUCT_PRICE.RecordCount= 0>
			<cfset GET_PREVIOUS_PRODUCT_PRICE_HISTORY.RecordCount= 0>	
		</cfif>
		<cfif GET_PREVIOUS_PRODUCT_PRICE.RecordCount AND GET_PREVIOUS_PRODUCT_PRICE_HISTORY.RecordCount>
			<cfif not len(GET_PRICE.FINISHDATE)>
				<cfquery name="UPDATE_PREVIOUS_PRODUCT_PRICE" datasource="#dsn3#">
					UPDATE PRICE SET FINISHDATE=NULL WHERE PRICE_ID=#GET_PREVIOUS_PRODUCT_PRICE.PRICE_ID#
				</cfquery>
				<cfquery name="UPDATE_PREVIOUS_PRODUCT_PRICE_HISTORY" datasource="#dsn3#">
					UPDATE PRICE_HISTORY SET FINISHDATE=NULL WHERE PRICE_HISTORY_ID=#GET_PREVIOUS_PRODUCT_PRICE_HISTORY.PRICE_HISTORY_ID#
				</cfquery>
			<cfelse>
				<cfquery name="UPDATE_PREVIOUS_PRODUCT_PRICE" datasource="#dsn3#">
					UPDATE PRICE SET FINISHDATE=#CreateODBCDateTime(GET_PRICE.FINISHDATE)# WHERE PRICE_ID=#GET_PREVIOUS_PRODUCT_PRICE.PRICE_ID#
				</cfquery>
				<cfquery name="UPDATE_PREVIOUS_PRODUCT_PRICE_HISTORY" datasource="#dsn3#">
					UPDATE PRICE_HISTORY SET FINISHDATE=#CreateODBCDateTime(GET_PRICE.FINISHDATE)# WHERE PRICE_HISTORY_ID=#GET_PREVIOUS_PRODUCT_PRICE_HISTORY.PRICE_HISTORY_ID#
				</cfquery>
			</cfif>
		</cfif>
		<cfquery name="INS_PRICE_DELETED_ROWS" datasource="#dsn3#">
			INSERT INTO PRICE_DELETED_ROWS
			(PRICE_ID,PRICE_CATID,PRODUCT_ID,STOCK_ID,SPECT_VAR_ID,FINISHDATE,STARTDATE,PRICE,PRICE_KDV,IS_KDV,PRICE_DISCOUNT,ROUNDING,UNIT,MONEY,CATALOG_ID,PRICE_RECORD_DATE,PRICE_RECORD_EMP,PRICE_RECORD_IP,RECORD_DATE,RECORD_IP,RECORD_EMP)
			SELECT PRICE_ID,PRICE_CATID,PRODUCT_ID,STOCK_ID,SPECT_VAR_ID,FINISHDATE,STARTDATE,PRICE,PRICE_KDV,IS_KDV,PRICE_DISCOUNT,ROUNDING,UNIT,MONEY,CATALOG_ID,RECORD_DATE,RECORD_EMP,RECORD_IP,#now()#,'#remote_addr#',#session.ep.userid#
			FROM PRICE WHERE PRICE.PRICE_ID = #URL.PRICE_ID#
		</cfquery>
		<cfif GET_PRICE.recordcount>
			<cfquery name="DEL_PRICE" datasource="#dsn3#">
				DELETE FROM PRICE WHERE PRICE.PRICE_ID = #URL.PRICE_ID#
			</cfquery>
			<cfquery name="DEL_PRICE_HISTORY" datasource="#dsn3#">
				DELETE FROM 
					PRICE_HISTORY
				WHERE
					PRODUCT_ID=#GET_PRICE.PRODUCT_ID#
					AND UNIT=#GET_PRICE.UNIT#
					AND PRICE_CATID=#GET_PRICE.PRICE_CATID#
					AND STARTDATE = #CreateODBCDateTime(GET_PRICE.STARTDATE)#
					<cfif isdefined('attributes.is_spc_price') and attributes.is_spc_price eq 1 and len(GET_PRICE.SPECT_VAR_ID)>
						AND ISNULL(SPECT_VAR_ID,0)=#GET_PRICE.SPECT_VAR_ID#
					<cfelse>
						AND ISNULL(SPECT_VAR_ID,0)=0
					</cfif>
					<cfif isdefined('attributes.is_stck_price') and attributes.is_stck_price eq 1 and len(GET_PRICE.STOCK_ID)>
						AND ISNULL(STOCK_ID,0)=#GET_PRICE.STOCK_ID#
					<cfelse>
						AND ISNULL(STOCK_ID,0)=0
					</cfif>
			</cfquery>
		</cfif>
	</cfloop>
	</cftransaction>
</cfif>
<cfif isdefined('attributes.price_catid') and isdefined('attributes.pid')><!--- Karma product'dan silme yapılıyorsa ilgili karma ürünün liste fiyatıda siliniyor. --->
	<cfquery name="DEL_KARMA_PRODUCT_PRICE" datasource="#DSN3#">
		DELETE FROM KARMA_PRODUCTS_PRICE WHERE PRICE_CATID = #attributes.price_catid# AND KARMA_PRODUCT_ID = #attributes.pid#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
