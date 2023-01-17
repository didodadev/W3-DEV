<!--- Ust kategorisine bakarak tanimlarda kategori isminin olması engelleniyor. BK 20071003  --->
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT
	FROM
		PRODUCT_CAT
	WHERE
		PRODUCT_CAT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.product_cat#"> AND
		HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.hierarchy#.%"> AND
		PRODUCT_CATID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
</cfquery>

<cfif get_product_cat.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='884.Üst Kategori Altında Bu Kategori Tanımı Var! Başka Bir Kategori Tanımlayınız'>");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.product_cat=replacelist(attributes.product_cat,list,list2)>
<cfif isdefined("attributes.image_cat") and len(attributes.image_cat)>		
	<cfif len(attributes.old_image_cat)>
		<cf_del_server_file output_file="product/#attributes.old_image_cat#" output_server="#attributes.old_image_cat_server_id#">
	</cfif>		
	<cftry>
		<cffile action = "upload" filefield = "image_cat" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
				history.back();
			</script>
		</cfcatch>
	</cftry>
	<cfset file_name = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cfset file_name_image_cat = '#file_name#.#cffile.serverfileext#'>
</cfif>

<cfquery name="CHECK" datasource="#DSN1#">
	SELECT
		HIERARCHY
	FROM
		PRODUCT_CAT
	WHERE
		<cfif len(hierarchy)>
			HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#hierarchy#.#product_cat_code#"> AND
		<cfelse>
			HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#product_cat_code#"> AND
		</cfif>
		PRODUCT_CATID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='885.Bu Kod Kullanılmakta; Başka Kod Kullanınız'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.user_friendly_url") and len(attributes.user_friendly_url)> 
	<cf_workcube_user_friendly user_friendly_url='#attributes.user_friendly_url#' action_type='PRODUCT_CATID' action_id='#attributes.product_catid#' action_page='objects2.view_product_list&product_catid=#attributes.product_catid#'>
</cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfif len(hierarchy)>
			<cfset appendix = "#hierarchy#.#product_cat_code#">
		<cfelse>
			<cfset appendix = "#product_cat_code#">
		</cfif>
		<cfif isDefined("is_public")>
			<cfset is_public = 1>
		<cfelse>
			<cfset is_public = 0>
		</cfif>
		<cfif isDefined("is_customizable")>
			<cfset is_customizable = 1>
		<cfelse>
			<cfset is_customizable = 0>
		</cfif>
		<cfif isDefined("attributes.is_installment_payment")>
			<cfset is_installment_payment = 1>
		<cfelse>
			<cfset is_installment_payment = 0>
		</cfif>
		<!--- önce kategori update edilir --->
		<cfquery name="UPDATE_PRODUCT_CAT" datasource="#DSN1#">
			UPDATE
				PRODUCT_CAT
			SET
				USER_FRIENDLY_URL = <cfif isdefined("attributes.user_friendly_url") and len(attributes.user_friendly_url)>'#user_friendly_#'<cfelse>NULL</cfif>,
				LIST_ORDER_NO = <cfif len(attributes.list_order_no)>#attributes.list_order_no#<cfelse>NULL</cfif>,
				IS_PUBLIC = <cfif len(is_public)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_public#"><cfelse>0</cfif>,
				WATALOGY_CAT_ID = <cfif isDefined("attributes.watalogy_cat_id") and len(attributes.watalogy_cat_id) and isDefined("attributes.watalogy_cat_name") and len(attributes.watalogy_cat_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.watalogy_cat_id#"><cfelse>NULL</cfif>,
				IS_CUSTOMIZABLE = <cfif len(is_customizable)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_customizable#"><cfelse>0</cfif>,
				IS_INSTALLMENT_PAYMENT = <cfif len(is_installment_payment)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_installment_payment#"><cfelse>0</cfif>,
				IS_CASH_REGISTER = <cfif isdefined("attributes.is_cash_register")>1<cfelse>0</cfif>,
				HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#APPENDIX#">,
				PRODUCT_CAT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.product_cat#">,
				DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#detail#">,
				PROFIT_MARGIN = <cfif isDefined("attributes.profit_margin_min") and len(attributes.profit_margin_min)>#attributes.profit_margin_min#<cfelse>0</cfif>,
				PROFIT_MARGIN_MAX = <cfif isDefined("attributes.profit_margin_max") and len(attributes.profit_margin_max)>#attributes.profit_margin_max#<cfelse>0</cfif>,
				<cfif isDefined("attributes.del_photo")>
					IMAGE_CAT = NULL,
				<cfelse>
					IMAGE_CAT = <cfif len(attributes.image_cat)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#file_name_image_cat#">,<cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.old_image_cat#">,</cfif>
				</cfif>
				<cfif len(attributes.image_cat)>IMAGE_CAT_SERVER_ID = #fusebox.server_machine#,</CFIF>
				STOCK_CODE_COUNTER = <cfif isDefined("attributes.stock_code_counter") and len(attributes.stock_code_counter)>#attributes.stock_code_counter#<cfelse>0</cfif>,				
				<cfif isDefined("attributes.form_factor") and len(attributes.form_factor)>FORM_FACTOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_factor#">,</cfif>
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_EMP_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#">
		</cfquery>

		<cfquery name="DELETE_POSITION_RELATIONS" datasource="#DSN1#">
			DELETE FROM PRODUCT_CAT_POSITIONS WHERE PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
		</cfquery>

		<cfloop from="1" to="#attributes.record_num_responsible#" index="i">
			<cfif evaluate("attributes.row_kontrol_responsibles#i#") eq 1>
        		<cfquery name="DELETE_POSITION_RELATIONS" datasource="#DSN1#">
                    INSERT INTO 
                    	PRODUCT_CAT_POSITIONS 
                        (
                            PRODUCT_CAT_ID,
                            POSITION_CODE,
                            SEQUENCE_NO
                        )
                        VALUES
                        (
                            #product_catid#,
                            #evaluate("attributes.position_code#i#")#,
                            #evaluate("attributes.order_number#i#")#
                        )
                </cfquery>
            </cfif>
        </cfloop>
		<cfset eski_len = len(oldhierarchy)>
	
		<!--- alt elemanlar update edilir --->
		<cfquery name="UPDATE_PRODUCT_CATS" datasource="#DSN1#">
			UPDATE
				PRODUCT_CAT
			SET
				<cfif database_type IS 'MSSQL'>
                    HIERARCHY = '#appendix#.' + SUBSTRING(HIERARCHY, #len(oldhierarchy)#+2, LEN(HIERARCHY)-#len(oldhierarchy)#),
                <cfelseif database_type IS 'DB2'>
                    HIERARCHY = '#appendix#.' || SUBSTR(HIERARCHY, #len(oldhierarchy)#+2, LENGTH(HIERARCHY)-#len(oldhierarchy)#),
                </cfif>
				IS_PUBLIC = <cfif len(is_public)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_public#"><cfelse>0</cfif>,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_EMP_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			WHERE
				HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#oldhierarchy#.%"> AND
				PRODUCT_CATID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#">
		</cfquery>
		
		<!--- ürünler update edilir --->
		<cfquery name="UPDATE_PRODUCTS" datasource="#DSN1#">
			UPDATE
				PRODUCT
			SET
				<cfif database_type IS 'MSSQL'>
                    PRODUCT_CODE = '#appendix#.'+ SUBSTRING(PRODUCT_CODE, #len(oldhierarchy)#+2, LEN(PRODUCT_CODE)-#len(oldhierarchy)#)
                <cfelseif database_type IS 'DB2'>
                    PRODUCT_CODE = '#appendix#.' || SUBSTR(PRODUCT_CODE, #len(oldhierarchy)#+2, LENGTH(PRODUCT_CODE)-#len(oldhierarchy)#)
                </cfif>
			WHERE
				PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#oldhierarchy#.%">
		</cfquery>
		
		<!--- stoklar update edilir --->
		<cfquery name="UPDATE_STOCKS" datasource="#DSN1#">
			UPDATE
				STOCKS
			SET
				<cfif database_type IS 'MSSQL'>
                    STOCK_CODE = '#appendix#.'+ SUBSTRING(STOCK_CODE, #len(oldhierarchy)#+2, LEN(STOCK_CODE)-#len(oldhierarchy)#),
                <cfelseif database_type IS 'DB2'>
                    STOCK_CODE = '#appendix#.' || SUBSTR(STOCK_CODE, #len(oldhierarchy)#+2, LENGTH(STOCK_CODE)-#len(oldhierarchy)#),
                </cfif>
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	
			WHERE
				STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#oldhierarchy#.%">
		</cfquery>
	
		<cfif appendix neq oldhierarchy>
			<cfif len(form.hierarchy)>
				<cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#DSN1#">
					UPDATE PRODUCT_CAT SET IS_SUB_PRODUCT_CAT = 1 WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#form.hierarchy#">
				</cfquery>
			</cfif>
			<cfif oldhierarchy contains '.'>
				<cfset oldhierarchy_root = listdeleteat(oldhierarchy,listlen(oldhierarchy,'.'),'.')>
			<cfelse>
				<cfset oldhierarchy_root = oldhierarchy>
			</cfif>
			<cfquery name="GET_SUB_PRODUCT_CAT" datasource="#DSN1#">
				SELECT HIERARCHY FROM PRODUCT_CAT WHERE HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#oldhierarchy_root#.%">
			</cfquery>
			<cfif not get_sub_product_cat.RecordCount>
				<cfquery name="ADD_SUB_PRODUCT_CAT" datasource="#DSN1#">
					UPDATE PRODUCT_CAT SET IS_SUB_PRODUCT_CAT = 0 WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#oldhierarchy_root#">
				</cfquery>
			</cfif>
		</cfif>
		
		<cfquery name="HAS_SUB_CAT" datasource="#DSN1#">
			SELECT HIERARCHY FROM PRODUCT_CAT WHERE HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#appendix#.%">
		</cfquery>
		<cfif has_sub_cat.recordCount>
			<!--- update edilen kategorinin alt kategorisi var --->	
			<cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
				UPDATE PRODUCT_CAT SET IS_SUB_PRODUCT_CAT = 1 WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#appendix#">
			</cfquery>
		<cfelse>
			<!--- update edilen kategorinin alt kategorisi yok --->	
			<cfquery name="ADD_IS_SUB_PRODUCT_CAT" datasource="#DSN1#">
				UPDATE PRODUCT_CAT SET IS_SUB_PRODUCT_CAT = 0 WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#appendix#">
			</cfquery>
		</cfif>
	
		<cfquery name="DEL_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
			DELETE FROM PRODUCT_CAT_BRANDS WHERE PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
		</cfquery>
	
		<cfloop from="1" to="#attributes.rowcount_brand#" index="i">
			<cfset brand_id_ = evaluate("attributes.brand_id_#i#")>
			<cfset brand_name_ = evaluate("attributes.brand_name_#i#")>
			<cfif len(brand_id_) and len(brand_name_)>		  
				<cfquery name="ADD_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
					INSERT INTO
						PRODUCT_CAT_BRANDS
					(
						PRODUCT_CAT_ID,
						BRAND_ID
					)				
					VALUES
					(
						#attributes.product_catid#,
						#brand_id_#
					)
				</cfquery>
			</cfif>
		</cfloop>
		
		<cfquery name="DEL_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
			DELETE FROM PRODUCT_CAT_OUR_COMPANY WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
		</cfquery>
		<cfif isdefined("attributes.our_company_ids") and listlen(attributes.our_company_ids)>
			<cfloop list="#attributes.our_company_ids#" index="m">
				<cfquery name="ADD_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
					INSERT INTO
						PRODUCT_CAT_OUR_COMPANY
					(
						PRODUCT_CATID,
						OUR_COMPANY_ID
					)	
					VALUES
					(
						#attributes.product_catid#,
						#m#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=product.list_product_cat&event=upd&id=#attributes.product_catid#" addtoken="no">
