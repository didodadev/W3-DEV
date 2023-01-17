<!--- Ust kategorisine bakarak tanimlarda kategori isminin olması engelleniyor. BK 20071003  --->
<!--- Ilgili urun kategorisinde iliskili urun kaydı var ise alt kategori tanımlanması engellenir  --->
<cfif isdefined('attributes.hierarchy')>
	<cfquery name="GET_PRODUCTS" datasource="#DSN3#">
		SELECT HIERARCHY FROM PRODUCT_CAT,PRODUCT WHERE PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.hierarchy#">
	</cfquery>
	<cfif get_products.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='250.Bu Kategoride Ürün Tanımlı Oldugu için Alt Kategori Açamazsınız !'> !");
	        history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- Ilgili urun kategorisinde iliskili urun kaydı var ise alt kategori tanımlanması engellenir  --->
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CAT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.product_cat#"> AND HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.hierarchy#.%">
</cfquery>
<cfif get_product_cat.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='884.Üst Kategori Altında Bu Kategori Tanımı Var! Başka Bir Kategori Tanımlayınız'>");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset list = "',""">
<cfset list2 = " , ">
<cfset attributes.product_cat = replacelist(attributes.product_cat,list,list2)>
<!--- image kontrol --->
<cfif isDefined("attributes.image_cat") and len(attributes.image_cat)>
	<cfset upload_folder = "#upload_folder##dir_seperator#product#dir_seperator#">
	<cftry>
		<cffile action="UPLOAD"
            filefield="image_cat"
            destination="#upload_folder#"
            mode="777"
            nameconflict="MAKEUNIQUE" accept="image/*">
		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset attributes.image_cat = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<!--- image kontrol --->
<cfquery name="CHECK" datasource="#DSN1#">
	SELECT
		HIERARCHY
	FROM
		PRODUCT_CAT
	WHERE
		<cfif len(hierarchy)>
        	HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#hierarchy#.#product_cat_code#">
        <cfelse>
        	HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#product_cat_code#">
        </cfif>
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='885.Bu Kod Kullanılmakta; Başka Kod Kullanınız'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<!--- hierarcyi belirle --->
<cfif len(form.hierarchy)>
	<cfset yer = "#form.hierarchy#.#form.product_cat_code#">
<cfelse>
	<cfset yer = form.product_cat_code>
</cfif>

<cflock name="#createUUID()#" timeout="20">
  	<cftransaction>
        <cfquery name="ADD_PRODUCT_CAT" datasource="#DSN1#" result="MAX_ID">
            INSERT INTO 
                PRODUCT_CAT
                (
                    LIST_ORDER_NO,
                    IS_PUBLIC,
                    WATALOGY_CAT_ID,
                    IS_CUSTOMIZABLE,
                    IS_INSTALLMENT_PAYMENT,
                    PRODUCT_CAT,
                    HIERARCHY,
                    DETAIL,
                    PROFIT_MARGIN,
                    PROFIT_MARGIN_MAX,
                    <cfif isDefined("attributes.image_cat") and len(attributes.image_cat)>
                        IMAGE_CAT,
                        IMAGE_CAT_SERVER_ID,
                    </cfif>
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_EMP_IP,
                    STOCK_CODE_COUNTER,
                    FORM_FACTOR,
                    IS_CASH_REGISTER
                )
                VALUES
                (
                    <cfif len(attributes.list_order_no)>#attributes.list_order_no#<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.is_public")>1<cfelse>0</cfif>,
                    <cfif isDefined("attributes.watalogy_cat_id") and len(attributes.watalogy_cat_id) and isDefined("attributes.watalogy_cat_name") and len(attributes.watalogy_cat_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.watalogy_cat_id#"><cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.is_customizable")>1,<cfelse>0,</cfif>
                    <cfif isDefined("attributes.is_installment_payment")>1,<cfelse>0,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.product_cat#">,
                    '#yer#',
                    '#detail#',
                    <cfif len(attributes.profit_margin_min)>#attributes.profit_margin_min#<cfelse>0</cfif>,
                    <cfif len(attributes.profit_margin_max)>#attributes.profit_margin_max#<cfelse>0</cfif>,
                    <cfif isDefined("attributes.image_cat") and len(attributes.image_cat)>
                        '#attributes.image_cat#',
                        #fusebox.server_machine#,
                    </cfif>
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#',
                    <cfif isDefined("attributes.stock_code_counter") and len(attributes.stock_code_counter)>#attributes.stock_code_counter#<cfelse>0</cfif>,
                    <cfif isDefined("attributes.form_factor") and len(attributes.form_factor)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_factor#"><cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.is_cash_register")>1<cfelse>0</cfif>
                )
        </cfquery>
        <cfloop from="1" to="#attributes.record_num_responsible#" index="i">
            <cfif evaluate("attributes.row_kontrol_responsibles#i#") eq 1>
                <cfquery name="ADD_RESPONSIBLE" datasource="#DSN1#">
                    INSERT INTO PRODUCT_CAT_POSITIONS 
                    (
                        PRODUCT_CAT_ID,
                        POSITION_CODE,
                        SEQUENCE_NO
                    )
                    VALUES
                    (
                        #max_id.identitycol#,
                        #evaluate("attributes.position_code#i#")#,
                        #evaluate("attributes.order_number#i#")#
                    )
                </cfquery>
            </cfif>
        </cfloop>
        <cfif len(form.hierarchy)>
            <!--- üst kategorinin alt kategorisi var --->
            <cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#DSN1#">
                UPDATE 
                    PRODUCT_CAT
                SET
                    IS_SUB_PRODUCT_CAT = 1
                WHERE
                    HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#form.hierarchy#">
            </cfquery>
            <cfquery name="HAS_SUB_CAT" datasource="#DSN1#">
                SELECT
                    HIERARCHY
                FROM
                    PRODUCT_CAT
                WHERE
                    HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#hierarchy#.#product_cat_code#.%">
            </cfquery>
            <cfif HAS_SUB_CAT.recordCount>
            <!--- eklenen kategorinin alt kategorisi var --->	
                <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
                    UPDATE 
                        PRODUCT_CAT
                    SET
                        IS_SUB_PRODUCT_CAT = 1
                    WHERE
                        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#hierarchy#.#product_cat_code#">
                </cfquery>
            <cfelse>
            <!--- eklenen kategorinin alt kategorisi yok --->	
                <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
                    UPDATE 
                        PRODUCT_CAT
                    SET
                        IS_SUB_PRODUCT_CAT = 0
                    WHERE
                        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#hierarchy#.#product_cat_code#">
                </cfquery>
            </cfif>
        <cfelse>
            <cfquery name="HAS_SUB_CAT" datasource="#DSN1#">
                SELECT
                    HIERARCHY
                FROM
                    PRODUCT_CAT
                WHERE
                    HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#product_cat_code#.%">
            </cfquery>
            <cfif has_sub_cat.recordCount>
            <!--- eklenen kategorinin alt kategorisi var --->	
                <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
                    UPDATE 
                        PRODUCT_CAT
                    SET
                        IS_SUB_PRODUCT_CAT = 1
                    WHERE
                        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#product_cat_code#">
                </cfquery>
            <cfelse>
            <!--- eklenen kategorinin alt kategorisi yok --->	
                <cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
                    UPDATE 
                        PRODUCT_CAT
                    SET
                        IS_SUB_PRODUCT_CAT = 0
                    WHERE
                        HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#product_cat_code#">
                </cfquery>
            </cfif>
        </cfif>
        <cfloop from="1" to="#attributes.rowCount_Brand#" index="i">
			<cfif isdefined('attributes.brand_id_#i#')>
				<cfset brand_id_ = evaluate("attributes.brand_id_#i#")>
                <cfset brand_name_ = evaluate("attributes.brand_name_#i#")>
                <cfif len(brand_id_) and len(brand_id_)>		  
                    <cfquery name="ADD_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
                        INSERT INTO
                            PRODUCT_CAT_BRANDS
                        (
                            PRODUCT_CAT_ID,
                            BRAND_ID
                        )				
                        VALUES
                        (
                            #max_id.identitycol#,
                            #brand_id_#
                        )
                    </cfquery>
                </cfif>
            </cfif>
        </cfloop>
        <cfif isdefined("attributes.our_company_ids") and listlen(attributes.our_company_ids)>
            <cfloop from="1" to="#listlen(attributes.our_company_ids)#" index="i">
                <cfquery name="ADD_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
                    INSERT INTO
                        PRODUCT_CAT_OUR_COMPANY
                    (
                        PRODUCT_CATID,
                        OUR_COMPANY_ID
                    )				
                    VALUES
                    (
                        #max_id.identitycol#,
                        #listgetat(attributes.our_company_ids,i)#
                    )
                </cfquery>
            </cfloop>
        </cfif>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.link_type") and attributes.link_type eq 1>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=product.list_product_cat&event=upd&id=#max_id.identitycol#</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=product.list_product_cat&event=upd&id=#max_id.identitycol#</cfoutput>';
	</script>
</cfif>
