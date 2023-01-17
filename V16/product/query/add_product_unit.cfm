<cfif isdefined("attributes.product_id")>
	<cfquery name="CHECK_UNIT" datasource="#DSN1#">
		SELECT 
			UNIT_ID
		FROM 
			PRODUCT_UNIT 
		WHERE 
			PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND 
			UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ADD_UNIT_ID#">
	</cfquery>
	<cfquery name="GET_UNIT" datasource="#DSN#">
		SELECT 
			UNIT
		FROM 
			SETUP_UNIT 
		WHERE 
			UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.add_unit_id#">
	</cfquery>
	<cfif isdefined('is_add_unit')><!--- 2.birim seçeneği seçilmişse başka birim 2.birim olamaz --->
		<cfquery name="UPD_UNIT" datasource="#DSN1#">
			UPDATE PRODUCT_UNIT SET IS_ADD_UNIT = 0 WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfquery>
	</cfif>
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
	<cfif not check_unit.recordcount>
		<cfquery name="ADD_UNIT" datasource="#DSN1#">
		  INSERT INTO 
		  	PRODUCT_UNIT 
			(
				  PRODUCT_ID,
				  MAIN_UNIT,
				  MAIN_UNIT_ID,
				  ADD_UNIT,
				  UNIT_ID,
				  MULTIPLIER,
                  QUANTITY,
				  DIMENTION,
				  WEIGHT,				  
				  UNIT_MULTIPLIER,
				  UNIT_MULTIPLIER_STATIC,
				  IS_SHIP_UNIT,
				  IS_ADD_UNIT,
				  VOLUME,
				  PACKAGES,
				  PACKAGE_CONTROL_TYPE,
				  INSTRUCTION,
				  PATH,
                  RECORD_EMP,
                  RECORD_DATE
                )
		  VALUES 
			  (
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_unit#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_unit_id#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_unit.unit#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.add_unit_id#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.multiplier#">,
                  <cfif isdefined('attributes.quantity') and len(attributes.quantity)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.quantity#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dimention#">,
				  <cfif len(attributes.WEIGHT)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weight#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				  <cfif isdefined('attributes.unit_multiplier') and len(attributes.unit_multiplier)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.unit_multiplier#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>, 
				  <cfif (isdefined('attributes.unit_multiplier') and len(attributes.unit_multiplier)) and (isdefined('attributes.multiplier_static') and len(attributes.multiplier_static))><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multiplier_static#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
			  	  <cfif isdefined('is_ship_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
			  	  <cfif isdefined('is_add_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				  <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.volume#" null="#not len(attributes.volume)#">,
				  <cfif isdefined('attributes.packages') and len(attributes.packages) ><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.packages#"><cfelse>NULL</cfif>,
				  <cfif isDefined("attributes.package_control_type")  and len(attributes.package_control_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.package_control_type#"><cfelse>NULL</cfif>,  
				  <cfif isDefined("attributes.instruction")  and len(attributes.instruction)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.instruction#"><cfelse>NULL</cfif>,  
				  <cfif isDefined("attributes.image_file")  and len(attributes.image_file)><cfqueryparam value = "#file_name#.#cffile.serverfileext#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,  
                  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			  )
		</cfquery>
	<cfelse>
		<script>
			alert("<cf_get_lang no='173.Seçtiğiniz birim bu ürüne zaten eklenmiş'>!");
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_product_unit_detail' );
		</script>
	</cfif>
	<script type="text/javascript">
		<cfif not isdefined("attributes.draggable")>
			wrk_opener_reload();
			window.close();
		<cfelse>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_product_unit_detail' );
		</cfif>
	</script>
	<cfabort>
</cfif>

