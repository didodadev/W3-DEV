<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="add_price" returntype="any" output="false">
	<!---
	by :20040119
	notes : Bir ürüne o ürünün bir birimine ait ve belli bir fiyat listesi icin fiyat ekler.
	Önemli : Kullanılırken mutlaka bir transaction icinde calisiyor olmalı.
	usage :
	add_price
		(
		product_id : fiyat yapilan urun (int),
		product_unit_id : fiyat yapilan urun birimi (int),
		price_cat : ilgili fiyat listesi (int),
		start_date : fiyat baslangic tarihi (date),
		price : kdv siz fiyat (float),
		price_money : fiyat para birimi (TL,USD),
		price_with_kdv : kdv li fiyat ////// ESKİDEN YANDAKİ GEÇERLİYDİ ARTIK DİİL: AK20051003(eger bu arguman gelmisse IS_KDV de 1 olarak set edilecek),
		catalog_id : Fiyat bir Aksiyon'dan set ediliyorsa o Aksiyonun ID si
		is_kdv : formdan gelen değer kdv li fiyat içinmi yoksa kdv siz fiyat içinmi AK20051003
		);
	revisions : 
	--->
	<cfargument name="product_id" required="true" type="numeric">
	<cfargument name="product_unit_id" required="true" type="numeric">
	<cfargument name="price_cat" required="true" type="numeric">
	<cfargument name="start_date" required="true" type="date">
	<cfargument name="price" required="true" type="numeric">
	<cfargument name="price_money" required="true" type="string">
	<cfargument name="price_with_kdv" required="true" type="numeric">
	<cfargument name="catalog_id" type="numeric" required="false">
	<cfargument name="is_kdv" type="numeric" required="yes">
	<cfargument name="price_discount" required="no" type="numeric">
	<cfargument name="stock_id" type="string" required="no">
	<cfargument name="spect_var_id" type="string" required="no">
	<cfif len(arguments.product_id) and len(arguments.price_cat) and isdate(arguments.start_date) and len(arguments.product_unit_id) and len(arguments.price) and len(arguments.price_money)>
		<cfif database_type is 'MSSQL'>
			<cfquery name="ADD_PRODUCT_PRICE" datasource="#dsn3#" timeout="180">
				add_price 
						#arguments.product_id#,
						#arguments.product_unit_id#,
						#arguments.price_cat#,
						#arguments.start_date#,
						#arguments.price#,
						'#arguments.price_money#',
						#arguments.is_kdv#,
						#arguments.price_with_kdv#,
					<cfif isDefined('arguments.catalog_id')>
						#arguments.catalog_id#,
					<cfelse>
						-1,
					</cfif>
						#session.ep.userid#,
						'#cgi.remote_addr#',
					<cfif isDefined('arguments.price_discount')>
						#arguments.price_discount#
					<cfelse>
						0
					</cfif>
					<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>
						,#arguments.stock_id#
					<cfelse>
						,0
					</cfif>
					<cfif isDefined('arguments.spect_var_id') and len(arguments.spect_var_id)>
						,#arguments.spect_var_id#
					<cfelse>
						,0
					</cfif>
			</cfquery>
		<cfelse>
			<cfquery name="DELETE_PRICE_THIS_PRODUCT" datasource="#dsn3#">
				DELETE FROM 
					PRICE
				WHERE
					PRICE_CATID = #arguments.price_cat# 
					AND STARTDATE=#arguments.start_date#
					AND PRODUCT_ID=#arguments.product_id#
					AND UNIT=#arguments.product_unit_id#
					<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>
						AND STOCK_ID=#arguments.stock_id#
					<cfelse>
						AND STOCK_ID IS NULL
					</cfif>
					<cfif isDefined('arguments.spect_var_id') and len(arguments.spect_var_id)>
						AND SPECT_VAR_ID=#arguments.spect_var_id#
					<cfelse>
						AND SPECT_VAR_ID IS NULL
					</cfif>
			</cfquery>
			<cfquery name="DELETE_PRICE_HISTORY_THIS_PRODUCT" datasource="#dsn3#">
				DELETE FROM 
					PRICE_HISTORY 
				WHERE
					PRICE_CATID = #arguments.price_cat#
					AND STARTDATE=#arguments.start_date# 
					AND PRODUCT_ID=#arguments.product_id# 
					AND UNIT=#arguments.product_unit_id#
					<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>
						AND STOCK_ID=#arguments.stock_id#
					<cfelse>
						AND STOCK_ID IS NULL
					</cfif>
					<cfif isDefined('arguments.spect_var_id') and len(arguments.spect_var_id)>
						AND SPECT_VAR_ID=#arguments.spect_var_id#
					<cfelse>
						AND SPECT_VAR_ID IS NULL
					</cfif>
			</cfquery>
			<cfquery name="DELETE_ALL_OLD_PRODUCT_PRICE" datasource="#dsn3#">
				DELETE FROM PRICE WHERE FINISHDATE < #DATEADD('d',-1,now())#
			</cfquery>
			<cfquery name="UPDATE_PREVIOUS_PRODUCT_PRICE" datasource="#dsn3#" maxrows="1">
				UPDATE 
					PRICE 
				SET 
					FINISHDATE=#DATEADD('s',-1,arguments.start_date)#
				WHERE
					PRODUCT_ID=#arguments.product_id#
					AND UNIT=#arguments.product_unit_id#
					AND PRICE_CATID=#arguments.price_cat#
					AND STARTDATE < #arguments.start_date#
					AND (FINISHDATE IS NULL OR FINISHDATE > #arguments.start_date#)
					<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>
						AND STOCK_ID=#arguments.stock_id#
					<cfelse>
						AND STOCK_ID IS NULL
					</cfif>
					<cfif isDefined('arguments.spect_var_id') and len(arguments.spect_var_id)>
						AND SPECT_VAR_ID=#arguments.spect_var_id#
					<cfelse>
						AND SPECT_VAR_ID IS NULL
					</cfif>
			</cfquery>
			<cfquery name="UPDATE_PREVIOUS_PRODUCT_PRICE_HISTORY" datasource="#dsn3#" maxrows="1">
				UPDATE 
					PRICE_HISTORY
				SET
					FINISHDATE=#DATEADD('s',-1,arguments.start_date)#
				WHERE
					PRODUCT_ID=#arguments.product_id#
					AND UNIT=#arguments.product_unit_id#
					AND PRICE_CATID=#arguments.price_cat#
					AND STARTDATE < #arguments.start_date# 
					AND (FINISHDATE IS NULL OR FINISHDATE > #arguments.start_date#)
					<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>
						AND STOCK_ID=#arguments.stock_id#
					<cfelse>
						AND STOCK_ID IS NULL
					</cfif>
					<cfif isDefined('arguments.spect_var_id') and len(arguments.spect_var_id)>
						AND SPECT_VAR_ID=#arguments.spect_var_id#
					<cfelse>
						AND SPECT_VAR_ID IS NULL
					</cfif>
			</cfquery>
			<cfquery name="SELECT_NEXT_PRODUCT_STARTDATE" datasource="#dsn3#" maxrows="1">
				SELECT 
					STARTDATE 
				FROM
					PRICE
				WHERE
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
					AND UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_unit_id#">
					AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_cat#">
					AND STARTDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
					<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>
						AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
					<cfelse>
						AND STOCK_ID IS NULL
					</cfif>
					<cfif isDefined('arguments.spect_var_id') and len(arguments.spect_var_id)>
						AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_var_id#">
					<cfelse>
						AND SPECT_VAR_ID IS NULL
					</cfif>
				ORDER BY STARTDATE
			</cfquery>
			<cfquery name="ADD_PRODUCT_PRICE" datasource="#dsn3#">
				INSERT INTO
					PRICE
				(
					PRICE_CATID,
					PRODUCT_ID,
					STOCK_ID,
					SPECT_VAR_ID,
					STARTDATE,
				<cfif len(SELECT_NEXT_PRODUCT_STARTDATE.STARTDATE)>
					FINISHDATE,
				</cfif>
					PRICE,
					IS_KDV,
					PRICE_KDV,
					PRICE_DISCOUNT,
					MONEY,
					UNIT,
				<cfif isDefined('arguments.catalog_id')>
					CATALOG_ID,
				</cfif>
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#arguments.price_cat#,
					#arguments.product_id#,
				<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>#arguments.stock_id#<cfelse>NULL</cfif>,
				<cfif isDefined('arguments.spect_var_id') and len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
					#arguments.start_date#,
				<cfif len(SELECT_NEXT_PRODUCT_STARTDATE.STARTDATE)>
					#date_add('s',-1,SELECT_NEXT_PRODUCT_STARTDATE.STARTDATE)#,
				</cfif>
					#arguments.price#,
					#arguments.is_kdv#,
					#arguments.price_with_kdv#,
				<cfif isDefined('arguments.price_discount')>
					#arguments.price_discount#,
				<cfelse>
					0,
				</cfif>
					'#arguments.price_money#',
					#arguments.product_unit_id#,
				<cfif isDefined('arguments.catalog_id')>
					#arguments.catalog_id#,
				</cfif>
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
			<cfquery name="ADD_PRODUCT_PRICE_HISTORY" datasource="#dsn3#">
				INSERT INTO	
					PRICE_HISTORY
				(
					PRICE_CATID,
					PRODUCT_ID,
					STOCK_ID,
					SPECT_VAR_ID,
					STARTDATE,
				<cfif len(SELECT_NEXT_PRODUCT_STARTDATE.STARTDATE)>
					FINISHDATE,
				</cfif>
					PRICE,
					IS_KDV,
					PRICE_KDV,
					PRICE_DISCOUNT,
					MONEY,
					UNIT,
				<cfif isDefined('arguments.catalog_id')>
					CATALOG_ID,
				</cfif>
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)					 
				VALUES
				(
					#arguments.price_cat#,
					#arguments.product_id#,
				<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>#arguments.stock_id#<cfelse>NULL</cfif>,
				<cfif isDefined('arguments.spect_var_id') and len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
					#arguments.start_date#,
				<cfif len(SELECT_NEXT_PRODUCT_STARTDATE.STARTDATE)>
					#date_add('s',-1,SELECT_NEXT_PRODUCT_STARTDATE.STARTDATE)#,
				</cfif>
					#arguments.price#,
					#arguments.is_kdv#,
					#arguments.price_with_kdv#,
				<cfif isDefined('arguments.price_discount')>
					#arguments.price_discount#,
				<cfelse>
					0,
				</cfif>
					'#arguments.price_money#',
					#arguments.product_unit_id#,
				<cfif isDefined('arguments.catalog_id')>
					#arguments.catalog_id#,
				</cfif>
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
