<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Pınar Yıldız			Developer	: Pınar Yıldız			
Analys Date : 01/06/2016			Dev Date	: 01/06/2016	
Description :
	Bu component ürün kategorisi objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset dsn1 = '#dsn#_product'>
    
    <!--- list, get --->
	<cffunction name="get" access="public" returntype="query">
    	<cfargument name="keyword" type="string" default="" required="no" hint="Kategori ve Hiyerarşiye Göre Filtreleme Amaçlı Kullanılır">
        <cfargument name="hier" type="string" default="" required="no" hint="Ürün Kategorisinin Hiyerarşi Bilgisine Göre Filtreleme Amaçlı Kullanılır">
        <cfargument name="categoryId" type="numeric" default="0" required="yes" hint="Ürün Kategori ID; Liste sayfasında 0 olarak gönderilir.">
        <cfargument name="class_category" required="no" hint="Sadece Ana Kategori Seçimi İçin Filtreleme Amaçlı Kullanılır">
        <cfargument name="our_company" type="numeric" required="no" hint="Şirket Bazlı Filtreleme Yapılması Amacıyla Kullanılır">
        <cfquery name="GET_PRODUCT_CAT" datasource="#dsn1#">
            SELECT 
                PRODUCT_CAT.PRODUCT_CATID, 
                PRODUCT_CAT.HIERARCHY, 
                PRODUCT_CAT.PRODUCT_CAT,
                PRODUCT_CAT.PROFIT_MARGIN,
                PRODUCT_CAT.PROFIT_MARGIN_MAX,
                PRODUCT_CAT.LIST_ORDER_NO,
                PRODUCT_CAT.USER_FRIENDLY_URL,
                PRODUCT_CAT.DETAIL,
                PRODUCT_CAT.IS_PUBLIC,
                PRODUCT_CAT.IS_CUSTOMIZABLE,
                PRODUCT_CAT.IS_INSTALLMENT_PAYMENT,
                PRODUCT_CAT.IMAGE_CAT,
                PRODUCT_CAT.IMAGE_CAT_SERVER_ID ,
                PRODUCT_CAT.UPDATE_DATE,
                PRODUCT_CAT.RECORD_DATE
            FROM
                #dsn3#.PRODUCT_CAT
            WHERE
                PRODUCT_CATID IS NOT NULL
                <cfif isDefined("arguments.categoryId") and arguments.categoryId neq 0>
                    AND PRODUCT_CATID = #arguments.categoryId#
                </cfif>
                <cfif (isDefined('arguments.cat') and len(arguments.cat)) or (isDefined("arguments.hier") and len(arguments.hier))>
                    AND HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cat#%">
                </cfif>
                <cfif isDefined('arguments.keyword') and len(arguments.keyword)>
                    AND ((PRODUCT_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">)
                   <!--- <cfif isDefined('sayfa_ad') and GET_EMPS.RecordCount>
                        OR POSITION_CODE IN (#ValueList(GET_EMPS.POSITION_CODE)#)
                        OR POSITION_CODE2 IN (#ValueList(GET_EMPS.POSITION_CODE)#)
                    </cfif>--->
                    )
                </cfif>
                <cfif isDefined('arguments.class_category') and len(arguments.class_category)>
                    AND HIERARCHY NOT LIKE '%.%'
                </cfif>
                <cfif isdefined("arguments.our_company") and len(arguments.our_company)>
                    AND PRODUCT_CATID IN (SELECT PRODUCT_CATID FROM PRODUCT_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #arguments.our_company#)
                </cfif>
            ORDER BY
                HIERARCHY
        </cfquery>
		<cfreturn GET_PRODUCT_CAT>
	</cffunction>
        
    <!--- add --->
	<cffunction name="add" access="public" returntype="numeric">
        <cfargument name="hierarchy" type="string" default="" required="yes" hint="Ürün Kategorisi Hiyerarşi Kodu">
		<cfargument name="product_cat_code" type="string" default="" required="yes" hint="Kategori Kodu">
        <cfargument name="list_order_no" type="string" default="" required="no" hint="Site tarafında alt kategorilerin listeleme sırasını belirtir">
        <cfargument name="is_public"  default="" required="no" hint="Web de gösterme seçeneği">
        <cfargument name="image_cat" type="string" default="" required="no" hint="Ürün Kategorisi İmajı">
		<cfargument name="is_customizable" type="string" default="" required="yes" hint="Konfigüre edilebilme seçeneği">
        <cfargument name="is_installment_payment" type="string" default="" required="no" hint="Ödeme Adımında Taksit Uygulaması Seçeneği">
        <cfargument name="product_cat" type="string" default="" required="yes" hint="Ürün Kategori İsmi">
        <cfargument name="detail" type="string" default="" required="yes" hint="Ürün Kategori Açıklama Bilgisi">
        <cfargument name="profit_margin_min" type="string" default="" required="no" hint="Minimum Marj">
		<cfargument name="profit_margin_max" type="string" default="" required="no" hint="Maksimum Marj">
        <cfargument name="record_num_responsible" type="numeric" default="0" required="no" hint="Ürün Kategori Sorumluları Sayısı">
		
		<!--- hierarcyi belirle --->
		<cfif len(arguments.hierarchy)>
			<cfset yer = "#arguments.hierarchy#.#arguments.product_cat_code#">
        <cfelse>
            <cfset yer = arguments.product_cat_code>
        </cfif>
        <cfquery name="ADD_PRODUCT_CAT" datasource="#dsn1#" result="MAX_ID">
            INSERT INTO 
                PRODUCT_CAT
                (
                    LIST_ORDER_NO,
                    IS_PUBLIC,
                    IS_CUSTOMIZABLE,
                    IS_INSTALLMENT_PAYMENT,
                    PRODUCT_CAT,
                    HIERARCHY,
                    DETAIL,
                    PROFIT_MARGIN,
                    PROFIT_MARGIN_MAX,
                    <cfif isDefined("arguments.image_cat") and len(arguments.image_cat)>
                        IMAGE_CAT,
                        IMAGE_CAT_SERVER_ID,
                    </cfif>
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_EMP_IP
                )
                VALUES
                (
                    <cfif len(arguments.list_order_no)>#arguments.list_order_no#<cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.is_public") and arguments.is_public eq 1>1<cfelse>0</cfif>,
                    <cfif isDefined("arguments.is_customizable") and arguments.is_customizable eq 1>1,<cfelse>0,</cfif>
                    <cfif isDefined("arguments.is_installment_payment") and is_installment_payment eq 1>1,<cfelse>0,</cfif>
                    '#arguments.product_cat#',
                    '#yer#',
                    '#arguments.detail#',
                    <cfif len(arguments.profit_margin_min)>#arguments.profit_margin_min#<cfelse>0</cfif>,
                    <cfif len(arguments.profit_margin_max)>#arguments.profit_margin_max#<cfelse>0</cfif>,
                    <cfif isDefined("arguments.image_cat") and len(arguments.image_cat)>
                        '#arguments.image_cat#',
                        #this.server_machine#,
                    </cfif>
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#'
                )
        </cfquery>
        <cfif len(arguments.hierarchy)>
            <!--- üst kategorinin alt kategorisi var --->
            <cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#dsn1#">
                UPDATE 
                    PRODUCT_CAT
                SET
                    IS_SUB_PRODUCT_CAT = 1
                WHERE
                    HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hierarchy#">
            </cfquery>
            <cfquery name="HAS_SUB_CAT" datasource="#dsn1#">
                SELECT
                    HIERARCHY
                FROM
                    PRODUCT_CAT
                WHERE
                    HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hierarchy#.#arguments.product_cat_code#.%">
            </cfquery>
            <cfif HAS_SUB_CAT.recordCount>
            <!--- eklenen kategorinin alt kategorisi var --->	
                <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#dsn1#">
                    UPDATE 
                        PRODUCT_CAT
                    SET
                        IS_SUB_PRODUCT_CAT = 1
                    WHERE
                        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy#.#product_cat_code#">
                </cfquery>
            <cfelse>
            <!--- eklenen kategorinin alt kategorisi yok --->	
                <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#dsn1#">
                    UPDATE 
                        PRODUCT_CAT
                    SET
                        IS_SUB_PRODUCT_CAT = 0
                    WHERE
                        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hierarchy#.#arguments.product_cat_code#">
                </cfquery>
            </cfif>
        <cfelse>
            <cfquery name="HAS_SUB_CAT" datasource="#dsn1#">
                SELECT
                    HIERARCHY
                FROM
                    PRODUCT_CAT
                WHERE
                    HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_cat_code#.%">
            </cfquery>
            <cfif has_sub_cat.recordCount>
            <!--- eklenen kategorinin alt kategorisi var --->	
                <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#dsn1#">
                    UPDATE 
                        PRODUCT_CAT
                    SET
                        IS_SUB_PRODUCT_CAT = 1
                    WHERE
                        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_cat_code#">
                </cfquery>
            <cfelse>
            <!--- eklenen kategorinin alt kategorisi yok --->	
                <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#dsn1#">
                    UPDATE 
                        PRODUCT_CAT
                    SET
                        IS_SUB_PRODUCT_CAT = 0
                    WHERE
                        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_cat_code#">
                </cfquery>
            </cfif>
        </cfif>
		<cfreturn MAX_ID.IDENTITYCOL>
	</cffunction>
    
    <!--- Kategori ile İlişkili Şirket Ekleme---->
    <cffunction name="addCompanies" access="public" returntype="numeric">
    	<cfargument name="product_catid" type="numeric" default="0" required="yes" hint="Ürün Kategori Id">
        <cfargument name="our_company_ids" type="string" default="0" required="yes" hint="Kategori İle İlişkili Şirket Id Bilgisi">
        <cfif arguments.product_catid neq 0>
            <cfquery name="DEL_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
                DELETE FROM PRODUCT_CAT_OUR_COMPANY WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
            </cfquery>
        </cfif>
        <cfif arguments.product_catid neq 0>
        	<cfset CategoryId = arguments.product_catid>
        <cfelse>
        	<cfset CategoryId = max_id.identitycol>
        </cfif>
        <cfif isdefined("arguments.our_company_ids") and listlen(arguments.our_company_ids)>
            <cfloop from="1" to="#listlen(arguments.our_company_ids)#" index="i">
                <cfquery name="ADD_PRODUCT_CAT_COMPANY" datasource="#dsn1#">
                    INSERT INTO
                        PRODUCT_CAT_OUR_COMPANY
                    (
                        PRODUCT_CATID,
                        OUR_COMPANY_ID
                    )				
                    VALUES
                    (
                       #CategoryId#,
                       #listgetat(arguments.our_company_ids,i)#
                    )
                </cfquery>
            </cfloop>
        </cfif>
        <cfreturn CategoryId>
    </cffunction>
    
    <!--- Kategori Sorumlusu Ekleme---->
    <cffunction name="addResponsibles" access="public" returntype="numeric">
    	<cfargument name="product_catid" type="numeric" default="0" required="yes" hint="Ürün Kategori Id">
        <cfargument name="position_code" type="numeric" default="0" required="no" hint="Ürün Kategori Sorumluları Pozisyon Kodu">
        <cfargument name="order_number" type="numeric" default="0" required="no" hint="Ürün Kategori Sorumluları Sıra Numarası">
        <cfargument name="is_del" type="numeric" default="0" required="no" hint="Silme Kontrolü">
        <cfif arguments.product_catid neq 0 and is_del eq 1>
            <cfquery name="DELETE_POSITION_RELATIONS" datasource="#DSN1#">
                DELETE FROM PRODUCT_CAT_POSITIONS WHERE PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
            </cfquery>
        </cfif>
        <cfif arguments.product_catid neq 0>
        	<cfset CategoryId = arguments.product_catid>
        <cfelse>
        	<cfset CategoryId = max_id.identitycol>
        </cfif>
        <cfquery name="ADD_RESPONSIBLE" datasource="#dsn1#">
            INSERT INTO PRODUCT_CAT_POSITIONS 
            (
                PRODUCT_CAT_ID,
                POSITION_CODE,
                SEQUENCE_NO
            )
            VALUES
            (
                #CategoryId#,
                #arguments.position_code#,
                #arguments.order_number#
            )
        </cfquery>
        <cfreturn CategoryId>
    </cffunction>
    
    <!--- İlişkili Marka Ekleme---->
    <cffunction name="addBrand" access="public" returntype="numeric">
    	<cfargument name="product_catid" type="numeric" default="0" required="yes" hint="Ürün Kategori Id">
       <cfargument name="brand_id" type="numeric" default="0" required="no" hint="Kategori Marka Id Numarası">
       <cfargument name="is_del" type="numeric" default="0" required="no" hint="Silme Kontrolü">
       <cfif arguments.product_catid neq 0 and is_del eq 1>
           <cfquery name="DEL_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
                DELETE FROM PRODUCT_CAT_BRANDS WHERE PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
           </cfquery>
       </cfif>
       <cfif arguments.product_catid neq 0>
        	<cfset CategoryId = arguments.product_catid>
        <cfelse>
        	<cfset CategoryId = max_id.identitycol>
        </cfif>
       <cfquery name="ADD_PRODUCT_CAT_BRANDS" datasource="#dsn1#">
            INSERT INTO
                PRODUCT_CAT_BRANDS
            (
                PRODUCT_CAT_ID,
                BRAND_ID
            )				
            VALUES
            (
                #CategoryId#,
                #arguments.brand_id#
            )
        </cfquery>
        <cfreturn CategoryId>
    </cffunction>
    
    <!--- upd --->
	<cffunction name="upd" access="public" returntype="numeric">
    	<cfargument name="product_catid" type="numeric" default="0" required="yes" hint="Ürün Kategori Id">
    	<cfargument name="hierarchy" type="string" default="" required="yes" hint="Ürün Kategorisi Hiyerarşi Kodu">
		<cfargument name="product_cat_code" type="string" default="" required="yes" hint="Kategori Kodu">
        <cfargument name="list_order_no" type="string" default="" required="no" hint="Site tarafında alt kategorilerin listeleme sırasını belirtir">
        <cfargument name="is_public"  default="" required="no" hint="Web de gösterme seçeneği">
        <cfargument name="image_cat" type="string" default="" required="no" hint="Ürün Kategorisi İmajı">
		<cfargument name="is_customizable" type="string" default="" required="no" hint="Konfigüre edilebilme seçeneği">
        <cfargument name="is_installment_payment" type="string" default="" required="no" hint="Ödeme Adımında Taksit Uygulaması Seçeneği">
        <cfargument name="product_cat" type="string" default="" required="yes" hint="Ürün Kategori İsmi">
        <cfargument name="detail" type="string" default="" required="yes" hint="Ürün Kategori Açıklama Bilgisi">
        <cfargument name="profit_margin_min" type="string" default="" required="no" hint="Minimum Marj">
		<cfargument name="profit_margin_max" type="string" default="" required="no" hint="Maksimum Marj">
        <cfargument name="file_name_image_cat" type="string" default="" required="no" hint="Ürün Kategori İmaj İsmi">
        <cfargument name="old_image_cat" type="string" default="" required="no" hint="Ürün Kategori Daha Önce Kaydedilen İmaj">
        <cfargument name="del_photo" type="boolean" default="0" required="no" hint="İmaj Sil Parametresi">
        
        
        <cfif isdefined("arguments.user_friendly_url") and len(arguments.user_friendly_url)> 
            <cf_workcube_user_friendly user_friendly_url='#arguments.user_friendly_url#' action_type='PRODUCT_CATID' action_id='#arguments.product_catid#' action_page='objects2.view_product_list&product_catid=#arguments.product_catid#'>
        </cfif>
        <cfif len(hierarchy)>
            <cfset appendix = "#hierarchy#.#product_cat_code#">
        <cfelse>
            <cfset appendix = "#product_cat_code#">
        </cfif>
        <cfif isDefined("is_public") and is_public eq 1>
            <cfset is_public = 1>
        <cfelse>
            <cfset is_public = 0>
        </cfif>
        <cfif isDefined("is_customizable") and is_customizable eq 1>
            <cfset is_customizable = 1>
        <cfelse>
            <cfset is_customizable = 0>
        </cfif>
        <cfif isDefined("is_installment_payment") and is_installment_payment eq 1>
            <cfset is_installment_payment = 1>
        <cfelse>
            <cfset is_installment_payment = 0>
        </cfif>
        <!--- önce kategori update edilir --->
        <cfquery name="UPDATE_PRODUCT_CAT" datasource="#DSN1#">
            UPDATE
                PRODUCT_CAT
            SET
                USER_FRIENDLY_URL = <cfif isdefined("arguments.user_friendly_url") and len(arguments.user_friendly_url)>'#user_friendly_#'<cfelse>NULL</cfif>,
                LIST_ORDER_NO = <cfif len(arguments.list_order_no)>#arguments.list_order_no#<cfelse>NULL</cfif>,
                IS_PUBLIC = #is_public#,
                IS_CUSTOMIZABLE = #is_customizable#,
                IS_INSTALLMENT_PAYMENT = #is_installment_payment#,
                HIERARCHY = '#APPENDIX#',
                PRODUCT_CAT = '#arguments.product_cat#',
                DETAIL = '#detail#',
                PROFIT_MARGIN = <cfif isDefined("arguments.profit_margin_min") and len(arguments.profit_margin_min)>#arguments.profit_margin_min#<cfelse>0</cfif>,
                PROFIT_MARGIN_MAX = <cfif isDefined("arguments.profit_margin_max") and len(arguments.profit_margin_max)>#arguments.profit_margin_max#<cfelse>0</cfif>,
                <cfif isDefined("arguments.del_photo") and arguments.del_photo eq 1>
                    IMAGE_CAT = NULL,
                <cfelse>
                    IMAGE_CAT = <cfif len(arguments.image_cat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name_image_cat#">,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.old_image_cat#">,</CFIF>
                </cfif>
                <cfif len(arguments.image_cat)>IMAGE_CAT_SERVER_ID = #this.server_machine#,</CFIF>				
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_EMP_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#
            WHERE
                PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#">
        </cfquery>
        <cfset eski_len = len(oldhierarchy)>
        <!--- alt elemanlar update edilir --->
        <cfquery name="UPDATE_PRODUCT_CATS" datasource="#DSN1#">
            UPDATE
                PRODUCT_CAT
            SET
                HIERARCHY = '#appendix#.' + SUBSTRING(HIERARCHY, #len(oldhierarchy)#+2, LEN(HIERARCHY)-#len(oldhierarchy)#),
                IS_PUBLIC = #is_public#,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_EMP_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#
            WHERE
                HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldhierarchy#.%"> AND
                PRODUCT_CATID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#">
        </cfquery>
        <!--- ürünler update edilir --->
        <cfquery name="UPDATE_PRODUCTS" datasource="#DSN1#">
            UPDATE
                PRODUCT
            SET
                PRODUCT_CODE = '#appendix#.'+ SUBSTRING(PRODUCT_CODE, #len(oldhierarchy)#+2, LEN(PRODUCT_CODE)-#len(oldhierarchy)#)
            WHERE
                PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldhierarchy#.%">
        </cfquery>
        <!--- stoklar update edilir --->
        <cfquery name="UPDATE_STOCKS" datasource="#DSN1#">
            UPDATE
                STOCKS
            SET
                STOCK_CODE = '#appendix#.'+ SUBSTRING(STOCK_CODE, #len(oldhierarchy)#+2, LEN(STOCK_CODE)-#len(oldhierarchy)#),
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#				
            WHERE
                STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldhierarchy#.%">
        </cfquery>
        <cfif appendix neq oldhierarchy>
            <cfif len(form.hierarchy)>
                <cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#DSN1#">
                    UPDATE PRODUCT_CAT SET IS_SUB_PRODUCT_CAT = 1 WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hierarchy#">
                </cfquery>
            </cfif>
            <cfif oldhierarchy contains '.'>
                <cfset oldhierarchy_root = listdeleteat(oldhierarchy,listlen(oldhierarchy,'.'),'.')>
            <cfelse>
                <cfset oldhierarchy_root = oldhierarchy>
            </cfif>
            <cfquery name="GET_SUB_PRODUCT_CAT" datasource="#DSN1#">
                SELECT HIERARCHY FROM PRODUCT_CAT WHERE HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldhierarchy_root#.%">
            </cfquery>
            <cfif not get_sub_product_cat.RecordCount>
                <cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#DSN1#">
                    UPDATE PRODUCT_CAT SET IS_SUB_PRODUCT_CAT = 0 WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldhierarchy_root#">
                </cfquery>
            </cfif>
        </cfif>
        <cfquery name="HAS_SUB_CAT" datasource="#DSN1#">
            SELECT HIERARCHY FROM PRODUCT_CAT WHERE HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#appendix#.%">
        </cfquery>
        <cfif has_sub_cat.recordCount>
            <!--- update edilen kategorinin alt kategorisi var --->	
            <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
                UPDATE PRODUCT_CAT SET IS_SUB_PRODUCT_CAT = 1 WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#appendix#">
            </cfquery>
        <cfelse>
            <!--- update edilen kategorinin alt kategorisi yok --->	
            <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
                UPDATE PRODUCT_CAT SET IS_SUB_PRODUCT_CAT = 0 WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#appendix#">
            </cfquery>
        </cfif>
		<cfreturn arguments.product_catid>
	</cffunction>
    
    <!--- del --->
	<cffunction name="del" access="public" returntype="numeric">
        <cfargument name="product_catid" type="numeric" default="0" required="yes" hint="Ürün Kategori ID">
        <cfquery name="GET_PRODUCTCAT" datasource="#dsn1#">
            SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=#arguments.product_catid#
        </cfquery>
        <cfquery name="DELPRODUCTCAT" datasource="#dsn1#">
            DELETE FROM PRODUCT_CAT WHERE PRODUCT_CATID=#arguments.product_catid#
        </cfquery>
        <cfquery name="DEL_PRODUCT_CAT_BRANDS" datasource="#dsn1#">
            DELETE FROM PRODUCT_CAT_BRANDS WHERE PRODUCT_CAT_ID=#arguments.product_catid#
        </cfquery>
        <cfquery name="DEL_PRODUCT_CAT_OUR_COMPANY" datasource="#dsn1#">
            DELETE FROM PRODUCT_CAT_OUR_COMPANY WHERE PRODUCT_CATID=#arguments.product_catid#
        </cfquery>	
        <!--- VE TÜM ALT DALLARDA SILINIR --->
        <cfquery name="DELPRODUCTCAT" datasource="#dsn1#">
            DELETE FROM PRODUCT_CAT	WHERE HIERARCHY LIKE '#arguments.oldhierarchy#.%'
        </cfquery>
        <cfif GET_PRODUCTCAT.HIERARCHY contains '.'>
            <cfset son_alan_len = len(ListLast(GET_PRODUCTCAT.HIERARCHY,'.'))>
            <cfset tum_len = len(GET_PRODUCTCAT.HIERARCHY)>
            <cfset oldhierarchy_root = Left(GET_PRODUCTCAT.HIERARCHY,tum_len-son_alan_len-1)>
        <cfelse>
            <cfset oldhierarchy_root = GET_PRODUCTCAT.HIERARCHY>
        </cfif>
        <cfquery name="GET_SUB_PRODUCT_CAT" datasource="#DSN1#">
            SELECT  HIERARCHY FROM PRODUCT_CAT WHERE HIERARCHY LIKE '#oldhierarchy_root#.%'
        </cfquery>
        <cfif not GET_SUB_PRODUCT_CAT.RecordCount>
            <cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#DSN1#">
                UPDATE 
                    PRODUCT_CAT
                SET
                    IS_SUB_PRODUCT_CAT = 0
                WHERE
                    HIERARCHY = '#oldhierarchy_root#'
            </cfquery>
        </cfif>
		<cfreturn arguments.product_catid>
	</cffunction>
</cfcomponent>