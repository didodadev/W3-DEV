<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Emin Yaşartürk			Developer	: Emin Yaşartürk		
Analys Date : 27/05/2016				Dev Date	: 27/05/2016		
Description :
	Bu component garanti objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
    
    <!--- list --->
	<cffunction name="list" access="public" returntype="query">
        <cfargument name="category" type="string" default="" required="no" hint="Kategori">
		<cfargument name="stock_id" type="string" default="" required="no" hint="Stok ID değeri">
        <cfargument name="product_name" type="string" default="" required="no" hint="Ürün Adı. Stock ID'li beraber gönderilmelidir">
        <cfargument name="keyword" type="string" default="" required="no" hint="Filtre alanı. Seri No üzerinde filtreleme yapar">
        <cfargument name="lot_no" type="string" default="" required="no" hint="Lot Numarası">
        <cfargument name="belge_no" type="string" default="" required="no" hint="Belge Numarası">
        <cfargument name="start_date" type="string" default="" required="no" hint="Başlangıç Tarihi">
        <cfargument name="finish_date" type="string" default="" required="no" hint="Bitiş Tarihi">
        <cfargument name="startrow" type="string" default="" required="no" hint="Sayfalamanın başlayacağı kayıt">
        <cfargument name="maxrows" type="string" default="" required="no" hint="Kaç kayıt listeleneceği">
        
        <cfquery name="GET_CONSUMER_GUARANTIES" datasource="#dsn3#">
            WITH CTE1 AS (
            SELECT
                SERVICE_GUARANTY_NEW.GUARANTY_ID,
                SERVICE_GUARANTY_NEW.IN_OUT,
                SERVICE_GUARANTY_NEW.STOCK_ID,
                SERVICE_GUARANTY_NEW.SERIAL_NO,
                SERVICE_GUARANTY_NEW.LOT_NO,
                SERVICE_GUARANTY_NEW.CERTIFICA_NO,
                SERVICE_GUARANTY_NEW.SALE_START_DATE,
                SERVICE_GUARANTY_NEW.SALE_FINISH_DATE,
                SERVICE_GUARANTY_NEW.PROCESS_NO,
                SERVICE_GUARANTY_NEW.PURCHASE_START_DATE,
                SERVICE_GUARANTY_NEW.PURCHASE_FINISH_DATE,
                SERVICE_GUARANTY_NEW.PURCHASE_GUARANTY_CATID,
                SERVICE_GUARANTY_NEW.SALE_GUARANTY_CATID,
                DATEDIFF(DAY,SERVICE_GUARANTY_NEW.SALE_START_DATE,SERVICE_GUARANTY_NEW.SALE_FINISH_DATE) AS TIME,
				S.GUARANTYCAT AS SGUARANTYCAT,
				P.GUARANTYCAT AS PGUARANTYCAT,
                STOCKS.PRODUCT_ID,
                STOCKS.PRODUCT_NAME,
                STOCKS.PROPERTY
            FROM
                SERVICE_GUARANTY_NEW WITH (NOLOCK)
                LEFT JOIN #dsn#.SETUP_GUARANTY AS S ON SERVICE_GUARANTY_NEW.SALE_GUARANTY_CATID = S.GUARANTYCAT_ID
                LEFT JOIN #dsn#.SETUP_GUARANTY AS P ON SERVICE_GUARANTY_NEW.PURCHASE_GUARANTY_CATID = P.GUARANTYCAT_ID
                LEFT JOIN STOCKS ON STOCKS.STOCK_ID = SERVICE_GUARANTY_NEW.STOCK_ID
            WHERE
                SERVICE_GUARANTY_NEW.GUARANTY_ID IS NOT NULL
                <cfif isDefined("arguments.category") and len(arguments.category)>
                    AND
                    (
                        SERVICE_GUARANTY_NEW.SALE_GUARANTY_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.category#"> OR
                        SERVICE_GUARANTY_NEW.PURCHASE_GUARANTY_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.category#">
                    )
                </cfif>
                <cfif isDefined("arguments.stock_id") and Len(arguments.stock_id) and len(arguments.product_name)>
                    AND	SERVICE_GUARANTY_NEW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                </cfif>
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                    AND SERVICE_GUARANTY_NEW.SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isDefined("arguments.lot_no") and len(arguments.lot_no)>
                    AND SERVICE_GUARANTY_NEW.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#">
                </cfif>
                <cfif isDefined("arguments.belge_no") and len(arguments.belge_no)>
                    AND SERVICE_GUARANTY_NEW.PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.belge_no#">
                </cfif>
                <cfif isdefined("arguments.start_date") and len(arguments.start_date)>
                    AND (
                        SERVICE_GUARANTY_NEW.SALE_START_DATE >= #arguments.start_date# OR
                        SERVICE_GUARANTY_NEW.PURCHASE_START_DATE >= #arguments.start_date#
                        )
                </cfif>
                <cfif  isdefined("arguments.finish_date") and  len(arguments.finish_date)>
                    AND (
                        SERVICE_GUARANTY_NEW.SALE_START_DATE <= #arguments.finish_date# OR
                        SERVICE_GUARANTY_NEW.PURCHASE_START_DATE <= #arguments.finish_date#
                        )
                </cfif>
                ),
                CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (	ORDER BY
                                                    SERIAL_NO ASC
                                            ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>
		<cfreturn GET_CONSUMER_GUARANTIES>
	</cffunction>
    
    <!--- serialControl --->
    <cffunction name="serialNoControl" access="public" returntype="query" hint="Seri Numarası değiştirilmişse DB'de aynı seri numarasına ait işlem yaptırmaz">
    	<cfargument name="serialNo" type="string" default="" required="yes" hint="Seri Numarası">
        <cfargument name="stockId" type="numeric" default="" required="yes" hint="Stok ID'si">
        <cfquery name="serialControl" datasource="#DSN3#">
            SELECT GUARANTY_ID FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serialNo#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.stockID#">
        </cfquery>
        <cfreturn serialControl>
    </cffunction>
    
    <!--- guarantyDetail --->
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="guarantyId" type="string" default="" required="yes" hint="Kayıt ID'si">
        <cfquery name="GET_GUARANTY_DETAIL" datasource="#DSN3#">
            SELECT
            	DISTINCT
                SERVICE_GUARANTY_NEW.*,
                STOCKS.PRODUCT_NAME,
                STOCKS.PROPERTY
            FROM
                SERVICE_GUARANTY_NEW
                LEFT JOIN STOCKS ON STOCKS.STOCK_ID = SERVICE_GUARANTY_NEW.STOCK_ID
            WHERE
                GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.guarantyId#">
        </cfquery>
        <cfreturn GET_GUARANTY_DETAIL>
    </cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="numeric">
    	<cfargument name="guarantyId" type="string" default="" required="yes" hint="Kayıt ID'si">
        <cfargument name="inOut" type="string" default="" required="no" hint="Garantinin Satılabilir Olup Olmama Durumu">
        <cfargument name="isPurchaseSales" type="string" default="" required="no" hint="Garantinin Alış Satış Durumu : 1 - Satış ,0 - Alış">
        <cfargument name="isReturn" type="string" default="" required="no" hint="Garantinin Iade Olup Olmama Durumu">
        <cfargument name="isRma" type="string" default="" required="no" hint="Garantinin Üreticide Olup Olmama Durumu">
        <cfargument name="isService" type="string" default="" required="no" hint="Garantinin Serviste Olup Olmama Durumu">
        <cfargument name="isTrash" type="string" default="" required="no" hint="Garantinin Fire Olup Olmama Durumu">
        <cfargument name="stockId" type="string" default="" required="yes" hint="Ürün">
        <cfargument name="serialNo" type="string" default="" required="yes" hint="Garantinin Seri Nosu">
        <cfargument name="lotNo" type="string" default="" required="no" hint="Garantinin Lot Numarası">
        <cfargument name="departmentId" type="string" default="" required="no" hint="Garantinin Departmanı">
        <cfargument name="locationId" type="string" default="" required="no" hint="Lokasyon">
        <cfargument name="guarantyCatId" type="string" default="" required="no" hint="Alış Garanti Kategorisi">
        <cfargument name="startDate" type="string" default="" required="no" hint="Alış Garanti Başlama Tarihi">
        <cfargument name="finishDate" type="string" default="" required="no" hint="Alış Garanti Bitiş Tarihi">
        <cfargument name="saleGuarantyCatId" type="string" default="" required="no" hint="Satış Garanti Kategorisi">
        <cfargument name="saleStartDate" type="string" default="" required="no" hint="Satış Garanti Başlama Tarihi">
        <cfargument name="saleFinishDate" type="string" default="" required="no" hint="Satış Garanti Bitiş Tarihi">        
        <cfquery name="updSeriNo" datasource="#dsn3#">
            UPDATE 
                SERVICE_GUARANTY_NEW 
            SET 
                IN_OUT 					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.inOut#">,
                IS_PURCHASE 			= <cfif arguments.isPurchaseSales eq 0>1<cfelse>0</cfif>, 
                IS_SALE 				= <cfif arguments.isPurchaseSales eq 1>1<cfelse>0</cfif>,
                IS_RETURN 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isReturn#">,
                IS_RMA 					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isRma#">,
                IS_SERVICE 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isService#">,
                IS_TRASH 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isTrash#">,
                STOCK_ID 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.stockId#">,
                SERIAL_NO 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serialNo#">,
                LOT_NO 					= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lotNo#">,
                DEPARTMENT_ID 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.departmentId#">,
                LOCATION_ID 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.locationId#">,
                PURCHASE_GUARANTY_CATID = <cfif len(arguments.guarantyCatId)><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.guarantyCatId#"><cfelse>NULL</cfif>,
                PURCHASE_START_DATE 	= <cfif len(arguments.startDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startDate#"><cfelse>NULL</cfif>,
                PURCHASE_FINISH_DATE 	= <cfif len(arguments.finishDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishDate#"><cfelse>NULL</cfif>,
                SALE_GUARANTY_CATID 	= <cfif len(arguments.saleGuarantyCatId)><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.saleGuarantyCatId#"><cfelse>NULL</cfif>,
                SALE_START_DATE 		= <cfif len(arguments.saleStartDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.saleStartDate#"><cfelse>NULL</cfif>,
                SALE_FINISH_DATE 		= <cfif len(arguments.saleFinishDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.saleFinishDate#"><cfelse>NULL</cfif>,
                UPDATE_DATE 			= #NOW()#,
                UPDATE_EMP 				= #SESSION.EP.USERID#,
                UPDATE_IP 				= '#CGI.REMOTE_ADDR#'
            WHERE
                GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.guarantyId#">
        </cfquery>
        <cfreturn arguments.guarantyId>
    </cffunction>
    
    <!--- seriCont --->
    <cffunction name="seriCont" access="public" returntype="string" hint="Seri Numaralarını liste olarak kontrol eder">
    	<cfargument name="seriNoList" required="yes" default="" type="string" hint="Seri Numaraları">
        
        <cfquery name="GET_SERIAL_NO" datasource="#dsn3#">
            SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(arguments.seriNoList)#">)
        </cfquery>
		<cfreturn valuelist(GET_SERIAL_NO.SERIAL_NO)>
	</cffunction>
    
    <cffunction name="add_one" access="public" returntype="string">
    	<cfargument name="gelen" type="string" default="" required="yes" hint="Ayrıştırılacak İfade">
		<cfscript>
			elde = 0;
			uz = len(arguments.gelen);
			for (i=uz; i gt 0;i=i-1)
				{
				eleman = mid(arguments.gelen,i,1);
		
				if ( (i eq uz) or (elde) )
					eleman = eleman + 1;
		
				if (eleman gt 9)
					elde = 1;
				else
					elde = 0;
		
				if (i eq 1)
					{
					if (elde)
						bas = '1';
					else
						bas = '';
					}
				else
					bas = left(arguments.gelen,i-1);
				
				if (i neq uz)
					son = right(arguments.gelen,uz-i);
				else
					son = '';
					
				arguments.gelen = '#bas##right(eleman,1)##son#';
				if (not elde)
					return arguments.gelen;
				}
			return arguments.gelen;
        </cfscript>
    </cffunction>
    
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
        <cfargument name="inOut" type="string" default="" required="no" hint="Garantinin Satılabilir Olup Olmama Durumu">
        <cfargument name="isPurchaseSales" type="string" default="" required="no" hint="Garantinin Alış Satış Durumu : 1 - Satış ,0 - Alış">
        <cfargument name="isReturn" type="string" default="" required="no" hint="Garantinin Iade Olup Olmama Durumu">
        <cfargument name="isRma" type="string" default="" required="no" hint="Garantinin Üreticide Olup Olmama Durumu">
        <cfargument name="isService" type="string" default="" required="no" hint="Garantinin Serviste Olup Olmama Durumu">
        <cfargument name="isTrash" type="string" default="" required="no" hint="Garantinin Fire Olup Olmama Durumu">
        <cfargument name="stockId" type="string" default="" required="yes" hint="Ürün">
        <cfargument name="serialNo" type="string" default="" required="yes" hint="Garantinin Seri Nosu">
        <cfargument name="lotNo" type="string" default="" required="no" hint="Garantinin Lot Numarası">
        <cfargument name="departmentId" type="string" default="" required="no" hint="Garantinin Departmanı">
        <cfargument name="locationId" type="string" default="" required="no" hint="Lokasyon">
        <cfargument name="guarantyCatId" type="string" default="" required="no" hint="Alış Garanti Kategorisi">
        <cfargument name="startDate" type="string" default="" required="no" hint="Alış Garanti Başlama Tarihi">
        <cfargument name="finishDate" type="string" default="" required="no" hint="Alış Garanti Bitiş Tarihi">
        <cfargument name="saleGuarantyCatId" type="string" default="" required="no" hint="Satış Garanti Kategorisi">
        <cfargument name="saleStartDate" type="string" default="" required="no" hint="Satış Garanti Başlama Tarihi">
        <cfargument name="saleFinishDate" type="string" default="" required="no" hint="Satış Garanti Bitiş Tarihi">
        <cfargument name="updateTime" type="string" default="" required="no" hint="Garanti Süresi">  
        
        <cfquery name="addSeriNo" datasource="#dsn3#" result="MAXID">
			INSERT INTO
				SERVICE_GUARANTY_NEW
			(
				IN_OUT,
				IS_PURCHASE,
				IS_SALE,
            	IS_RETURN,
                IS_RMA,
                IS_SERVICE,
				IS_TRASH,
                STOCK_ID,
            	SERIAL_NO,
				LOT_NO,
				DEPARTMENT_ID,
				LOCATION_ID,
				PURCHASE_GUARANTY_CATID,
				PURCHASE_START_DATE,
				PURCHASE_FINISH_DATE,
				SALE_GUARANTY_CATID,
				SALE_START_DATE,
				SALE_FINISH_DATE,
                UPDATE_TIME,
				PROCESS_CAT,
				PERIOD_ID,
                RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
                PROCESS_ID
			)
			VALUES
			(
	            <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.inOut#">
            	<cfif attributes.is_purchase_sales eq 0>1<cfelse>0</cfif>,
				<cfif attributes.is_purchase_sales eq 1>1<cfelse>0</cfif>,
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isReturn#">,
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isRma#">,
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isService#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isTrash#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.stockId#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serialNo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lotNo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.departmentId#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.locationId#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.guarantyCatId#">,
                <cfif len(arguments.startDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startDate#"><cfelse>NULL</cfif>,
                <cfif len(arguments.finishDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishDate#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.saleGuarantyCatId#">,
                <cfif len(arguments.saleStartDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.saleStartDate#"><cfelse>NULL</cfif>,
                <cfif len(arguments.saleFinishDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.saleFinishDate#"><cfelse>NULL</cfif>,
                <cfif len(attributes.update_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.updateTime#"><cfelse>NULL</cfif>,
				114,
				#session.ep.period_id#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#,
                0
			)
        </cfquery>
        <cfreturn MAXID.IdentityCol>
    </cffunction>
</cfcomponent>