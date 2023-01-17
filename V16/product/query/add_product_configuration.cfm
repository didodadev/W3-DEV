<cflock timeout="80">
	<cftransaction>
    	<cfif isdefined("attributes.startdate") and  len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
			<cfif isDefined("attributes.image_file")  and len(attributes.image_file)>
				<cftry>
				   <cfset file_name = createUUID()>
				   <cffile action="UPLOAD" 
						   destination="#upload_folder#product#dir_seperator#" 
						   filefield="image_file"  
						   nameconflict="MAKEUNIQUE"> 
				   <cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
				   <cfcatch type="any">
					   <script type="text/javascript">
						   alert("Lütfen imaj dosyası giriniz!");
						   history.back();
					   </script>
					   <cfabort>
				   </cfcatch>
			   </cftry>
			   <cfset assetTypeName = listlast(cffile.serverfile,'.')>
			   <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			   <cfif listfind(blackList,assetTypeName,',')>
				   <cffile action="delete" file="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
				   <script type="text/javascript">
					   alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					   history.back();
				   </script>
				   <cfabort>
			   </cfif>
		   </cfif>
		<cfif len(attributes.product_name) and len(attributes.stock_id)>
            <cfquery name="get_product_conf" datasource="#dsn3#">
                SELECT CONFIGURATOR_NAME,PRODUCT_CONFIGURATOR_ID FROM SETUP_PRODUCT_CONFIGURATOR WHERE FINISH_DATE IS NULL AND CONFIGURATOR_STOCK_ID = #attributes.stock_id# AND IS_ACTIVE = 1
            </cfquery>
            <cfif get_product_conf.recordcount>
                <cfquery name="upd_conf" datasource="#dsn3#">
                    UPDATE
                    	SETUP_PRODUCT_CONFIGURATOR
                    SET
                    	FINISH_DATE = #attributes.startdate#
                    WHERE
                    	PRODUCT_CONFIGURATOR_ID = #get_product_conf.product_configtator_id#
                </cfquery>
            </cfif>
        </cfif>
		<cfquery name="add_product_conf" datasource="#dsn3#" result="MAX_ID">
			INSERT INTO SETUP_PRODUCT_CONFIGURATOR
			(
				IS_ACTIVE,
				CONFIGURATOR_NAME,
				CONFIGURATOR_DETAIL,
				CONFIGURATOR_STOCK_ID,
				BRAND_ID,
				PRODUCT_CAT_ID,
				ORIGIN,
				PATH,
				WIDGET_ID,
				START_DATE,
				FINISH_DATE,
				RECORD_EMP, 
				RECORD_IP, 
				RECORD_DATE
			)
			VALUES
			(
				<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.configuration_name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.configuration_detail#">,
				<cfif IsDefined("attributes.stock_id") and len(attributes.stock_id) and IsDefined("attributes.product_name") and len(attributes.product_name)><cfqueryparam value = "#attributes.stock_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
				<cfif IsDefined("attributes.brand_id") and len(attributes.brand_id) and IsDefined("attributes.brand_name") and len(attributes.brand_name)><cfqueryparam value = "#attributes.brand_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
				<cfif IsDefined("attributes.cat_id") and len(attributes.cat_id) and IsDefined("attributes.category_name") and len(attributes.category_name)><cfqueryparam value = "#attributes.cat_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
				<cfif IsDefined("attributes.origin") and len(attributes.origin)><cfqueryparam value = "#attributes.origin#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.image_file")  and len(attributes.image_file)><cfqueryparam value = "#file_name#.#cffile.serverfileext#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,  
				<cfif IsDefined("attributes.widget_id") and len(attributes.widget_id) and IsDefined("attributes.widget_friendly_name") and len(attributes.widget_friendly_name)><cfqueryparam value = "#attributes.widget_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)><cfqueryparam value = "#attributes.startdate#" CFSQLType = "cf_sql_timestamp"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)><cfqueryparam value = "#attributes.finishdate#" CFSQLType = "cf_sql_timestamp"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
				#now()#
			)
		</cfquery>
	</cftransaction>
</cflock>
<cfset attributes.actionid = MAX_ID.IDENTITYCOL />