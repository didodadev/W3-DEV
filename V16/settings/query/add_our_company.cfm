<!--- 
Oluşturulacak veritabanı collation a dikkat edilsin ve bu uyarıyı comment içine alarak sayfanızı refresh edin..HS 20030429
COLLATE Turkish_CI_AS 
COLLATE SQL_Latin1_General_CP1_CI_AS
COLLATE Latin1_General_CI_AS
<cfabort>
--->
<cflock name="CreateUUID()" timeout="20">
	<cftransaction>
		<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
			SELECT 
				MAX(COMP_ID) AS MAX_COMP_ID
			FROM
				OUR_COMPANY
		</cfquery>
		<cfif get_our_company.recordCount eq 1 and IsNumeric(get_our_company.max_comp_id)>
			<cfset new_comp_id = get_our_company.max_comp_id+1>
		<cfelse>
			<cfset new_comp_id = 1>
		</cfif>
		<cfquery name="ADD_OUR_COMPANY" datasource="#DSN#">
			INSERT INTO 
				OUR_COMPANY
			(
				IS_ORGANIZATION,
				COMP_ID,
				COMPANY_NAME,
				NICK_NAME,
				MANAGER,
				MANAGER_POSITION_CODE,
				MANAGER_POSITION_CODE2,
				TAX_OFFICE,
				TAX_NO,
				TEL_CODE,
				TEL,
				FAX,
				WEB,
				EMAIL,
				ADDRESS,
				ADMIN_MAIL,
				TEL2,
				TEL3,
				TEL4,
				FAX2,
				T_NO,
				HIERARCHY,
				HIERARCHY2,
				SERMAYE,
				CHAMBER,
				CHAMBER_NO,
				CHAMBER2,
				CHAMBER2_NO,
				HEADQUARTERS_ID,
				COMP_STATUS,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
                COUNTRY_ID,
                POSTAL_CODE,
                CITY_ID,
                COUNTY_ID, 
                CITY_SUBDIVISION_NAME, 
                BUILDING_NUMBER,
                STREET_NAME,
                DISTRICT_NAME,
                MERSIS_NO,
                <!---Nace kodu Alanı için ekleme --->
                NACE_CODE,
				KEP_ADRESS,
				ACCOUNTER_KEY
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_organization#">,
				#new_comp_id#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPANY_NAME#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#NICK_NAME#">,
				<cfif len(MANAGER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#MANAGER#"><cfelse>NULL</cfif>,
				<cfif len(attributes.manager_name) and len(attributes.manager_pos_code)>#attributes.manager_pos_code#<cfelse>NULL</cfif>,
				<cfif len(attributes.manager_name2) and len(attributes.manager_pos_code2)>#attributes.manager_pos_code2#<cfelse>NULL</cfif>,
				<cfif len(TAX_OFFICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TAX_OFFICE#"><cfelse>NULL</cfif>,
				<cfif len(TAX_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TAX_NO#"><cfelse>NULL</cfif>,
				<cfif len(TEL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TEL_CODE#"><cfelse>NULL</cfif>,
				<cfif len(TEL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TEL#"><cfelse>NULL</cfif>,
				<cfif len(FAX)><cfqueryparam cfsqltype="cf_sql_varchar" value="#FAX#"><cfelse>NULL</cfif>,
				<cfif len(WEB)><cfqueryparam cfsqltype="cf_sql_varchar" value="#WEB#"><cfelse>NULL</cfif>,
				<cfif len(EMAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EMAIL#"><cfelse>NULL</cfif>,
				<cfif len(ADDRESS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ADDRESS#"><cfelse>NULL</cfif>,
				<cfif len(ADMIN_MAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ADMIN_MAIL#"><cfelse>NULL</cfif>,
				<cfif len(TEL2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TEL2#"><cfelse>NULL</cfif>,
				<cfif len(TEL3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TEL3#"><cfelse>NULL</cfif>,
				<cfif len(TEL4)><cfqueryparam cfsqltype="cf_sql_varchar" value="#TEL4#"><cfelse>NULL</cfif>,
				<cfif len(FAX2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#FAX2#"><cfelse>NULL</cfif>,
				<cfif len(t_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#t_no#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HIERARCHY#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HIERARCHY2#">,
				<cfif len(SERMAYE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#SERMAYE#"><cfelse>NULL</cfif>,
				<cfif len(CHAMBER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CHAMBER#"><cfelse>NULL</cfif>,
				<cfif len(CHAMBER_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CHAMBER_NO#"><cfelse>NULL</cfif>,
				<cfif len(CHAMBER2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CHAMBER2#"><cfelse>NULL</cfif>,
				<cfif len(CHAMBER2_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CHAMBER2_NO#"><cfelse>NULL</cfif>,
				<cfif len(HEAD_ID)>#HEAD_ID#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.comp_status')>1<cfelse>0</cfif>,
				#session.ep.userid#,
				#now()#,
    			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#" null="#not len(attributes.country_id)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.postal_code#" null="#not len(attributes.postal_code)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#" null="#not len(attributes.city_id)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#" null="#not len(attributes.county_id)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CITY_SUBDIVISION_NAME#" null="#not len(attributes.CITY_SUBDIVISION_NAME)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BUILDING_NUMBER#" null="#not len(attributes.BUILDING_NUMBER)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STREET_NAME#" null="#not len(attributes.STREET_NAME)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DISTRICT_NAME#" null="#not len(attributes.DISTRICT_NAME)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mersis_no#" null="#not len(attributes.mersis_no)#">,
                <!---Nace kodu Alanı için ekleme --->
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.NACE_CODE#" null="#not len(attributes.NACE_CODE)#">,
                <cfif len(attributes.KEP_ADRESS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.KEP_ADRESS#"><cfelse>NULL</cfif>,
				<cfif len(attributes.ACCOUNTER_KEY)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.ACCOUNTER_KEY#"><cfelse>NULL</cfif>
            )
		</cfquery>
        
       <cfquery name="ADD_OUR_COMPANY" datasource="#DSN#">
			INSERT INTO 
				OUR_COMPANY_INFO
			(
				COMP_ID,
				IS_BARCOD_REQUIRED,
				WORKCUBE_SECTOR,
				LOGO_TYPE,
				IS_GUARANTY_FOLLOWUP,
				IS_PROJECT_FOLLOWUP,
				IS_ASSET_FOLLOWUP,
				IS_SALES_ZONE_FOLLOWUP,
				IS_STORE_FOLLOWUP,
				IS_SMS,
				IS_UNCONDITIONAL_LIST,
				IS_SUBSCRIPTION_CONTRACT,
				IS_BRAND_TO_CODE,
				SPECT_TYPE,
				IS_COST,
				IS_TIME,
				IS_RATE,
				IS_RATE_FROM_PRE_PAPER,
				IS_PAPER_CLOSER,
				IS_SERIAL_CONTROL,
				IS_SHIP_CONTROL,
				IS_CONTENT_FOLLOW,
				IS_ORDER_UPDATE,
				IS_SHIP_UPDATE,
                IS_LOT_NO,
				RATE_ROUND_NUM,
				PURCHASE_PRICE_ROUND_NUM,
				SALES_PRICE_ROUND_NUM,
                IS_ADD_INFORMATIONS,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				IS_PRODUCT_COMPANY
			)
			VALUES
			(
				#new_comp_id#,
				0,
				NULL,
				NULL,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				1,
				0,
				0,
				0,
				0,
				0,
				1,
                0,
				4,
				4,
				2,
                0,
				#session.ep.userid#,
				#now()#,
    			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				0
			)
		</cfquery>
		<cf_wrk_get_history  datasource='#DSN#' source_table= 'OUR_COMPANY' target_table= 'OUR_COMPANY_HISTORY' record_id= '#new_comp_id#' record_name='COMP_ID'>
	</cftransaction>
</cflock>
<cfif fusebox.use_period>
	<cftry>
		<cfset upload_folder = '#index_folder#admin_tools#dir_seperator#'>
		<cfif isdefined("attributes.db_username")>
			<cfset db_user_ = attributes.db_username>
			<cfset db_pass_ = attributes.db_password>
            <cfset cf_admin_password = attributes.cf_admin_password>
		<cfelse>
			<cfset db_user_ = database_username>
			<cfset db_pass_ = database_password>
		</cfif>
			<cfif database_type IS "MSSQL">
				<cf_add_company_db username="#db_user_#" password="#db_pass_#" company_id="#new_comp_id#" dsn="#dsn#" host="#database_host#" upload_folder="#upload_folder#">
			<cfelseif database_type IS "DB2">
				<cf_add_company_db_db2 username="#db_user_#" password="#db_pass_#" company_id="#new_comp_id#" dsn="#dsn#" host="#database_host#" upload_folder="#upload_folder#">
			</cfif>
		<cfcatch type="any">
        	<cfset new_dsn_ = '#dsn#_#new_comp_id#'>
        
			<cfquery name="del_" datasource="#dsn#">
				DELETE FROM OUR_COMPANY WHERE COMP_ID = #new_comp_id#
			</cfquery>
			<cfquery name="del_2" datasource="#dsn#">
				DELETE FROM OUR_COMPANY_INFO WHERE COMP_ID = #new_comp_id#
			</cfquery>
			
            
            <cfquery name="getActiveLogin" datasource="_#dsn#">
            	SELECT spid FROM sys.sysprocesses where loginame = '#new_dsn_#'
            </cfquery>	
            <cfif getActiveLogin.recordcount>
            	<cfquery name="killActiveLogin" datasource="_#dsn#">
                   kill #getActiveLogin.spid#
                </cfquery>
            </cfif>
            
            <cfquery name="delUser" datasource="_#dsn#">
            	DROP USER #new_dsn_#
            </cfquery>
            <cfquery name="delLogin" datasource="_#dsn#">
				DROP LOGIN #new_dsn_#
            </cfquery>
            
            <cfquery name="getSchemaTables" datasource="_#dsn#">
                SELECT  'DROP TABLE #new_dsn_#.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13) AS DEL_TABLE
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = '#new_dsn_#'
                    AND TABLE_TYPE = 'BASE TABLE'
            </cfquery>
            
            <cfif getSchemaTables.recordcount>
                <cfquery name="delSchemaTables" datasource="_#dsn#">
                    <cfloop query="getSchemaTables">
                        #DEL_TABLE#
                    </cfloop>
                </cfquery>
            </cfif>
            
            <cfquery name="getSchemaViews" datasource="_#dsn#">
                SELECT  'DROP VIEW #new_dsn_#.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13) AS DEL_TABLE
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = '#new_dsn_#'
                    AND TABLE_TYPE = 'VIEW'
            </cfquery>
            
            <cfif getSchemaViews.recordcount>
                <cfquery name="delSchemaViews" datasource="_#dsn#">
                    <cfloop query="getSchemaViews">
                        #DEL_TABLE#
                    </cfloop>
                </cfquery>
            </cfif>
            
            <cfquery name="getSchemaProcedures" datasource="_#dsn#">
                SELECT  'DROP PROCEDURE #new_dsn_#.' + QUOTENAME(ROUTINE_NAME) + ';' + CHAR(13) AS DEL_TABLE
                FROM INFORMATION_SCHEMA.ROUTINES
                WHERE ROUTINE_SCHEMA = '#new_dsn_#'
                    AND ROUTINE_TYPE = 'PROCEDURE'
            </cfquery>
            
            <cfif getSchemaProcedures.recordcount>
                <cfquery name="delSchemaProcedures" datasource="_#dsn#">
                    <cfloop query="getSchemaProcedures">
                        #DEL_TABLE#
                    </cfloop>
                </cfquery>
            </cfif>

            <cfquery name="getSchemaFunctions" datasource="_#dsn#">
                SELECT  'DROP FUNCTION #new_dsn_#.' + QUOTENAME(ROUTINE_NAME) + ';' + CHAR(13) AS DEL_TABLE
                FROM INFORMATION_SCHEMA.ROUTINES
                WHERE ROUTINE_SCHEMA = '#new_dsn_#'
                    AND ROUTINE_TYPE = 'FUNCTION'
            </cfquery>
            
            <cfif getSchemaFunctions.recordcount>
                <cfquery name="delSchemaFunctions" datasource="_#dsn#">
                    <cfloop query="getSchemaFunctions">
                        #DEL_TABLE#
                    </cfloop>
                </cfquery>
            </cfif>
            <cfquery name="delSchema" datasource="_#dsn#">
            	DROP SCHEMA #new_dsn_#
            </cfquery>
            
			<script type="text/javascript">
				alert("Şirket Veritabanı Oluşturulamadı! Kullanıcı Adı - Şifre ve Veritabanı Yolu Bilgilerini Kontrol Ediniz!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cfset images_folder = "#ExpandPath('./images')##dir_seperator#">

<!--- 1.asset baslangic--->
<cfif isdefined("attributes.asset1") and len(attributes.asset1)>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
		  filefield = "asset1" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<cfcatch type="Any">
			<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>

	<cfset file_name = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cftry>
		<cffile action = "upload" 
			  filefield = "asset1" 
			  destination = "#images_folder#" 
			  nameconflict = "MakeUnique" 
			  mode="777">
		<cfcatch type="Any">
			<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>

	<cffile action="rename" source="#images_folder##cffile.serverfile#" destination="#images_folder##file_name#.#cffile.serverfileext#">
	<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			UPDATE 
				OUR_COMPANY
			SET
				ASSET_FILE_NAME1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
				ASSET_FILE_NAME1_SERVER_ID = #fusebox.server_machine# 
			WHERE
				COMP_ID = #new_comp_id#				
		</cfquery>
	</cfif>
</cfif>

<!--- 2.asset baslangic--->
<cfif isdefined("attributes.asset2") and len(attributes.asset2)>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
		  filefield = "asset2" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<cfcatch type="Any">
			<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cfset file_name = createUUID()>
	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cftry>
		<cffile action = "upload" 
		  filefield = "asset2" 
		  destination = "#images_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<cfcatch type="Any">
			<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
		
	<cffile action="rename" source="#images_folder##cffile.serverfile#" destination="#images_folder##file_name#.#cffile.serverfileext#">
	<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			UPDATE 
				OUR_COMPANY
			SET
				ASSET_FILE_NAME2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
				ASSET_FILE_NAME2_SERVER_ID = #fusebox.server_machine# 
			WHERE
				COMP_ID = #new_comp_id#		
		</cfquery>
	</cfif>
</cfif>

<!--- 3.asset baslangic--->
<cfif isdefined("attributes.asset3") and len(attributes.asset3)>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">	
	<cftry>
		<cffile action = "upload" 
		  filefield = "asset3" 
		  destination = "#upload_folder#" 
		  nameconflict = "MakeUnique" 
		  mode="777">
		<cfcatch type="Any">
			<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cfset file_name = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cftry>
		<cffile action = "upload" 
			  filefield = "asset3" 
			  destination = "#images_folder#" 
			  nameconflict = "MakeUnique" 
			  mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cffile action="rename" source="#images_folder##cffile.serverfile#" destination="#images_folder##file_name#.#cffile.serverfileext#">
	
	<cfif not isdefined("error")>
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			UPDATE 
				OUR_COMPANY
			SET
				ASSET_FILE_NAME3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
				ASSET_FILE_NAME3_SERVER_ID = #fusebox.server_machine#
			WHERE
				COMP_ID = #new_comp_id#		
		</cfquery>
	</cfif>
</cfif>
<script type="text/javascript">
<cfif isdefined("attributes.callAjax") and attributes.callAjax eq 1><!--- Organizasyon Yönetimi sayfasından geldiyse 20190912ERU --->
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.organization_management&event=ajaxSub&type=1&head_id=#attributes.head_id#</cfoutput>','<cfoutput>headQuerterAlt#attributes.head_id#</cfoutput>');
        $('#CompanyElements<cfoutput>#attributes.head_id#</cfoutput>').toggle();
<cfelse>
	<cfoutput>
		window.location= '#request.self#?fuseaction=settings.form_upd_our_company&ourcompany_id=#new_comp_id#';
	</cfoutput>
</cfif>
</script>