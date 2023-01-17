<!--- Desi hesabi yapiliyor BK 20090120 --->
<cfif len(attributes.dimention) and listlen(attributes.dimention,'*') eq 3>
    <cfset temp_desi = replace(attributes.dimention,',','.','all')>
	<cfset temp_desi = (listgetat(temp_desi,1,'*') * listgetat(temp_desi,2,'*') *(listgetat(temp_desi,3,'*'))/3000)>
<cfelse>
	<cfset temp_desi = ''>
</cfif>
<cfif isdefined('attributes.is_add_unit')><!--- 2.birim seçeneği seçilmişse başka birim 2.birim olamaz --->
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
			   location.href = document.referrer;
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
		   location.href = document.referrer;
	   </script>
	   <cfabort>
   </cfif>
</cfif>
<cfif isDefined("attributes.product_unit_id")>
	<cfif not isDefined("attributes.add_unit")>
		<cfif old_main_unit neq listgetat(attributes.main_unit,3,',')>
			<cf_wrk_get_history  datasource='#DSN1#' source_table= 'PRODUCT_UNIT' target_table= 'PRODUCT_UNIT_HISTORY' record_id= '#attributes.product_unit_id#' record_name='PRODUCT_UNIT_ID'>
			<cfquery name="UPD_OLD_MAIN_UNIT" datasource="#DSN1#">
				UPDATE
					PRODUCT_UNIT
				SET
					PRODUCT_UNIT_STATUS = 0
				WHERE
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
					MAIN_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#old_main_unit#"> AND
					IS_MAIN <> <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
			</cfquery>
			<cfquery name="UPD_NEW_MAIN_UNIT" datasource="#DSN1#">
				UPDATE
					PRODUCT_UNIT
				SET
					PRODUCT_UNIT_STATUS = 1
				WHERE
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
					MAIN_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.main_unit,3,',')#"> AND
					IS_MAIN <> <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
			</cfquery>
			<cfquery name="UPD_PRODUCT_UNIT" datasource="#DSN1#">
				UPDATE
					PRODUCT_UNIT
				SET
					IS_SHIP_UNIT= <cfif isdefined('is_ship_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
					IS_ADD_UNIT= <cfif isdefined('attributes.is_add_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
					MAIN_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.main_unit,3,',')#">,
					MAIN_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.main_unit,2,',')#">,
					UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.main_unit,2,',')#">,
					ADD_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.main_unit,3,',')#">,
					UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				WHERE
					PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_unit_id#">
			</cfquery>
		<cfelse>
			<cf_wrk_get_history  datasource='#DSN1#' source_table= 'PRODUCT_UNIT' target_table= 'PRODUCT_UNIT_HISTORY' record_id= '#attributes.product_unit_id#' record_name='PRODUCT_UNIT_ID'>
			<cfquery name="UPD_PRODUCT_UNIT" datasource="#DSN1#">
				UPDATE
					PRODUCT_UNIT
				SET
					IS_SHIP_UNIT = <cfif isdefined('is_ship_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
					IS_ADD_UNIT= <cfif isdefined('attributes.is_add_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
					DIMENTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dimention#">,
					DESI_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(temp_desi,2)#" null="#not len(wrk_round(temp_desi,2))#">,
					WEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weight#" null="#not len(attributes.weight)#">,
				 	UNIT_MULTIPLIER = <cfif isdefined('attributes.unit_multiplier') and len(attributes.unit_multiplier)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.unit_multiplier#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				    UNIT_MULTIPLIER_STATIC = <cfif (isdefined('attributes.unit_multiplier') and len(attributes.unit_multiplier)) and (isdefined('attributes.multiplier_static') and len(attributes.multiplier_static))><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multiplier_static#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
					VOLUME = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.volume#" null="#not len(attributes.volume)#">,
					UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				WHERE
					PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_unit_id#">
			</cfquery>
		</cfif>
		<cfif not isdefined("is_karma_pro")>
			<script type="text/javascript">
				<cfif not isdefined("attributes.draggable")>
					wrk_opener_reload();
					window.close();
				<cfelse>
					closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_product_unit_detail');
				</cfif>
			</script>		
		</cfif>
	</cfif>
	<cfscript>
		if(isDefined("attributes.add_unit"))
		{
			attributes.unit_id = listgetat(attributes.add_unit,1,',');
			new_add_unit = listgetat(attributes.add_unit,2,',');
			attributes.add_unit = listgetat(attributes.add_unit,2,',');
		}
	</cfscript>

	<cfif isDefined("attributes.unit_id") and (not attributes.unit_id_ is attributes.unit_id)>
		<cfquery name="CHECK_UNIT" datasource="#DSN1#">
			SELECT
				*
			FROM
				PRODUCT_UNIT
			WHERE
				PRODUCT_UNIT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
				UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
		</cfquery>
		<cfscript>structdelete(attributes,"unit_id_");</cfscript>
		<cfif not check_unit.recordcount>
			<cf_wrk_get_history  datasource='#DSN1#' source_table= 'PRODUCT_UNIT' target_table= 'PRODUCT_UNIT_HISTORY' record_id= '#attributes.product_unit_id#' record_name='PRODUCT_UNIT_ID'>
			<cfquery name="UPD_PRODUCT_UNIT" datasource="#DSN1#">
				UPDATE
					PRODUCT_UNIT
				SET
					IS_ADD_UNIT= <cfif isdefined('attributes.is_add_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
					IS_SHIP_UNIT = <cfif isdefined('is_ship_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
					MAIN_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_unit#">,
					MAIN_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_unit_id#">,
					UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">,
					ADD_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_add_unit#">,
					MULTIPLIER = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.multiplier#">,
                    QUANTITY = <cfif isdefined('attributes.quantity')><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.quantity#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>, 
					DIMENTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dimention#">,
					VOLUME = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.volume#" null="#not len(attributes.volume)#">,
					DESI_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(temp_desi,2)#" null="#not len(wrk_round(temp_desi,2))#">,
					WEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weight#" null="#not len(attributes.weight)#">,
					UNIT_MULTIPLIER = <cfif isdefined('attributes.unit_multiplier') and len(attributes.unit_multiplier)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.unit_multiplier#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				    UNIT_MULTIPLIER_STATIC = <cfif (isdefined('attributes.unit_multiplier') and len(attributes.unit_multiplier)) and (isdefined('attributes.multiplier_static') and len(attributes.multiplier_static))><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multiplier_static#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                    UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
 				WHERE 
					PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_unit_id#">
			</cfquery>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no ='173.Seçtiginiz birim bu ürüne zaten eklenmiş Lütfen geri dönüp düzeltin'>!");
				location.href = document.referrer;
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<cfscript>
			structdelete(attributes,"unit_id_");
			structdelete(attributes,"old_main_unit");
		</cfscript>
		<cf_wrk_get_history  datasource='#DSN1#' source_table= 'PRODUCT_UNIT' target_table= 'PRODUCT_UNIT_HISTORY' record_id= '#attributes.product_unit_id#' record_name='PRODUCT_UNIT_ID'>
		<cfquery name="UPD_PRODUCT_UNIT" datasource="#DSN1#">
    		UPDATE
				PRODUCT_UNIT
			SET
				IS_ADD_UNIT= <cfif isdefined('attributes.is_add_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				IS_SHIP_UNIT = <cfif isdefined('is_ship_unit')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
				<cfif isdefined('attributes.multiplier')>MULTIPLIER = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.multiplier#">,</cfif>
                QUANTITY =<cfif isdefined('attributes.quantity') and len('attributes.quantity')><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.quantity#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				DIMENTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dimention#">,
				VOLUME = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.volume#" null="#not len(attributes.volume)#">,
				DESI_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(temp_desi,2)#" null="#not len(wrk_round(temp_desi,2))#">,
				WEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weight#" null="#not len(attributes.weight)#">,
				UNIT_MULTIPLIER = <cfif isdefined('attributes.unit_multiplier') and len(attributes.unit_multiplier)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.unit_multiplier#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
				UNIT_MULTIPLIER_STATIC = <cfif (isdefined('attributes.unit_multiplier') and len(attributes.unit_multiplier)) and (isdefined('attributes.multiplier_static') and len(attributes.multiplier_static))><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multiplier_static#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				PACKAGES=<cfif isdefined('attributes.packages') and len(attributes.packages) ><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.packages#"><cfelse>NULL</cfif>,
				PACKAGE_CONTROL_TYPE=<cfif isDefined("attributes.package_control_type")  and len(attributes.package_control_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.package_control_type#"><cfelse>NULL</cfif>,  
				INSTRUCTION=<cfif isDefined("attributes.instruction")  and len(attributes.instruction)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.instruction#"><cfelse>NULL</cfif>,  
				PATH=<cfif isDefined("attributes.image_file")  and len(attributes.image_file)><cfqueryparam value = "#file_name#.#cffile.serverfileext#" CFSQLType = "cf_sql_varchar"><cfelseif isdefined("attributes.old_image_file") and len(attributes.old_image_file)><cfqueryparam value = "#attributes.old_image_file#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,  
				UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			WHERE 
				PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_unit_id#">
		</cfquery>
	</cfif>
    <cfif not isdefined("is_karma_pro")>
		<script type="text/javascript">
			<cfif not isdefined("attributes.draggable")>
				wrk_opener_reload();
				window.close();
			<cfelse>
				closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_product_unit_detail');
			</cfif>
		</script>
	</cfif>	
</cfif>
