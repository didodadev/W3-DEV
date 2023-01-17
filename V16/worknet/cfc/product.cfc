<cfcomponent>
	<cfset uploadFolder = application.systemParam.systemParam().upload_folder>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn1 = '#dsn#_product'>
	<cfset dsn1_alias= '#dsn1#'>
	<cfset dsn_alias= '#dsn#'>
	<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
	
	<cfscript>
		if (isDefined('session.ep.userid') and len(session.ep.language)) lang=ucase(session.ep.language);
		else if (isDefined('session.ww.language') and len(session.ww.language)) lang=ucase(session.ww.language);
		else if (isDefined('session.pp.userid') and len(session.pp.language)) lang=ucase(session.pp.language);
		else if (isDefined('session.pda.userid') and len(session.pda.language)) lang=ucase(session.pda.language);
		else if (isDefined('session.wp') and len(session.wp.language)) lang=ucase(session.wp.language);
	</cfscript>

	<!--- GET_PRODUCT_RELATION_SUPPLIER --->
	<cffunction name = "getRelationSupplier" access = "public" hint = "Get Relation Supplier">
		<cfargument name="pid" type="numeric">
		<cfargument name="cpid" type="numeric">
		<cfif isDefined("arguments.pid") and len(arguments.pid)>
			<cfquery name="get_comp" datasource="#dsn#">
				SELECT COMPANY_ID FROM WORKNET_PRODUCT_RELATION_SUPPLIER WHERE WORKNET_PRODUCT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
			</cfquery>
		</cfif>
        <cfquery name="get_relation_supplier" datasource="#dsn#">
            SELECT 
				CP.NICKNAME,
				CP.FULLNAME,
				CP.COMPANY_ID,
				WP.PRODUCT_NAME
            FROM WORKNET_PRODUCT_RELATION_SUPPLIER AS PRS
			LEFT JOIN #dsn1#.PRODUCT AS WP ON WP.PRODUCT_ID = PRS.WORKNET_PRODUCT_ID,
			COMPANY CP
            WHERE
                1=1 
				<cfif isDefined("arguments.pid") and len(arguments.pid)>
					AND PRS.WORKNET_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> 
					<cfif len(get_comp.COMPANY_ID)>AND CP.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_comp.COMPANY_ID)#" list="yes">)</cfif> 
				</cfif>
				<cfif isDefined("arguments.cpid") and len(arguments.cpid)>AND PRS.COMPANY_ID IN <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"></cfif>
        </cfquery>
        <cfreturn get_relation_supplier>
	</cffunction>
	
	<!--- GET WORKNET_RELATION_PRODUCT --->
	<cffunction name = "getRelationWorknet" access = "public" hint = "Get Relation Worknet">
		<cfargument name="pid" type="numeric" required="yes">
		<cfargument name="table" type="string" default="WORKNET_PRODUCT">
        <cfquery name="get_relation_worknet" datasource="#dsn#">
            SELECT 
				WRP.ID,
                WRP.WORKNET_ID,
                WRP.PRODUCT_ID,
                WRP.RECORD_EMP,
				WRP.RECORD_IP,
                WRP.RECORD_DATE,
                WRP.UPDATE_EMP,
				WRP.UPDATE_IP,
                WRP.UPDATE_DATE,
				WRK.WORKNET,
				WRK.IMAGE_PATH,
				WRK.SERVER_IMAGE_PATH_ID
            FROM WORKNET_RELATION_PRODUCT AS WRP
            JOIN #dsn1#.#arguments.table# AS WP ON WP.PRODUCT_ID = WRP.PRODUCT_ID
            JOIN WORKNET AS WRK ON WRK.WORKNET_ID = WRP.WORKNET_ID
            WHERE
                1=1 
                AND WRP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
        </cfquery>
        <cfreturn get_relation_worknet>
	</cffunction>

	<!--- GET NOT WORKNET_RELATION_PRODUCT --->
	<cffunction name = "getNotRelationWorknet" access = "public" hint = "Get Not Relation Worknet">
		<cfargument name="pid" type="numeric" required="no" default="0">
        <cfquery name="get_not_relation_worknet" datasource="#dsn#">
            SELECT 
                WRK.WORKNET_ID,
				WRK.WORKNET,
				WRK.IMAGE_PATH,
				WRK.SERVER_IMAGE_PATH_ID
            FROM WORKNET AS WRK
            WHERE
                1=1 
				<cfif len(arguments.pid)>
					AND WRK.WORKNET_ID NOT IN (
					SELECT WRP.WORKNET_ID FROM WORKNET_RELATION_PRODUCT AS WRP WHERE WRP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
				)
				</cfif>
				<cfif isdefined("arguments.status") and arguments.status eq 1>AND WRK.WORKNET_STATUS = 1</cfif>
                <cfif isdefined("arguments.status") and arguments.status eq 0>AND WRK.WORKNET_STATUS = 0</cfif>
				<cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND WRK.WORKNET LIKE '%#arguments.keyword#%'
                </cfif>
        </cfquery>
        <cfreturn get_not_relation_worknet>
	</cffunction>

	<cffunction name = "insertRelationSupplier" access = "remote" hint = "Insert Relation Worknet" returnformat="JSON">
		<cfargument name="pid" type="numeric" required="yes">
		<cfargument name="company_id" type="string" required="yes">
		<cfset response = structNew()>
		<cfset response.status = true>
		<cftry>
			<cfquery name="get_relation_supplier" datasource="#dsn#">
				SELECT WORKNET_PRODUCT_ID, COMPANY_ID FROM WORKNET_PRODUCT_RELATION_SUPPLIER WHERE WORKNET_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.pid#">
			</cfquery>
			<cfif len(get_relation_supplier.WORKNET_PRODUCT_ID)>
				<cfset cip = get_relation_supplier.COMPANY_ID & ',' & arguments.company_id>
				<cfquery name="insert_relation_supplier" datasource="#dsn#" result="result">
					UPDATE 
						WORKNET_PRODUCT_RELATION_SUPPLIER
					SET
						COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value = "#cip#">,
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					WHERE 
						WORKNET_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.pid#">
				</cfquery>
			<cfelse>
				<cfquery name="insert_relation_supplier" datasource="#dsn#" result="result">
					INSERT INTO
					WORKNET_PRODUCT_RELATION_SUPPLIER
					(
						COMPANY_ID,
						WORKNET_PRODUCT_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.company_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.pid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
			</cfif>
			
			<cfset response.message = "Ekleme başarılı">
			<cfcatch type = "any">
				<cfset response.status = false>
				<cfset response.message = "Ekleme hatalı">
			</cfcatch>
		</cftry>
		<cfreturn Replace( serializeJSON(response), "//", "" ) >
	</cffunction>
	<!--- ADD WORKNET_RELATION_PRODUCT --->
	<cffunction name = "insertRelationWorknet" access = "remote" hint = "Insert Relation Worknet" returnformat="JSON">
		<cfargument name="pid" type="numeric" required="yes">
		<cfargument name="wrkid" type="numeric" required="yes">
		<cfset response = structNew()>
		<cfset response.status = true>
		<cftry>
			<cfquery name="insert_relation_worknet" datasource="#dsn#" result="result">
				INSERT INTO
				WORKNET_RELATION_PRODUCT
				(
					WORKNET_ID,
					PRODUCT_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					<cfqueryparam value = "#arguments.wrkid#" CFSQLType = "cf_sql_integer">,
					<cfqueryparam value = "#arguments.pid#" CFSQLType = "cf_sql_integer">,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
			<cfset response.message = "Ekleme başarılı">
			<cfcatch type = "any">
				<cfset response.status = false>
				<cfset response.message = "Ekleme hatalı">
			</cfcatch>
		</cftry>
		<cfreturn Replace( serializeJSON(response), "//", "" ) >
	</cffunction>
	
	<!--- DELETE WORKNET_RELATION_PRODUCT --->
	<cffunction name = "deleteRelationWorknet" access = "remote" hint = "Delete Relation Worknet" returnformat="JSON">
		<cfargument name="pid" type="numeric" required="yes">
		<cfargument name="wrkid" type="numeric" required="yes">
		<cfset response = structNew()>
		<cfset response.status = true>
		<cftry>
			<cfquery name="delete_relation_worknet" datasource="#dsn#">
				DELETE FROM WORKNET_RELATION_PRODUCT WHERE WORKNET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wrkid#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
			</cfquery>
			<cfset response.message = "Silme işlemi başarılı">
			<cfcatch type = "any">
				<cfset response.status = false>
				<cfset response.message = "Silme işlemi hatalı">
			</cfcatch>
		</cftry>
		<cfreturn Replace( serializeJSON(response), "//", "" ) >
    </cffunction>

	<cffunction name = "imageSettings" returnType = "struct" access = "remote" description = "settings for thumbnails">
        
        <cfscript>

            imageSettings =	{///thumbnail Settings

                1	:	{
                    folderName	:	"icon",
                    PositionX	:	0,
                    PositionY	:	0,
                    newWidth	:	128,
                    newHeight	:	128
                },
                2	:	{
                    folderName	:	"middle",
                    PositionX	:	0,
                    PositionY	:	0,
                    newWidth	:	1024,
                    newHeight	:	512
                }
            }; 

        </cfscript>

        <cfreturn imageSettings>

    </cffunction>

    <cffunction name="createThumbnailFromImage" access="remote"  displayName="CREATE THUMB NAIL FROM IMAGE" returntype="any">
        <cfargument name="assetInfo" type="struct" required="false" />
        <cfset imageSettings = this.imageSettings() >

        <cftry>
            <cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system") />
            <cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> <!---upload folder --- /documents klasörü ---->
            <cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
            <cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />
            <cfset imageOperations = CreateObject("Component","cfc.image_operations") />
                
                <cfloop from="1" to="#imageSettings.count()#" index="row">
                    <cfset imageOperations.imageCrop(
                                    imagePath : "#assetInfo.uploadFolder##assetInfo.fileFullName#",
                                    imageThumbPath : "#uploadFolder#thumbnails/" & imageSettings[row]["folderName"] &"/#assetInfo.fileFullName#",
                                    imageCropType    :    1, <!--- Orantılı boyutlandır --->
                                    newWidth : #imageSettings[row]["newWidth"]#,
                                    newHeight : #imageSettings[row]["newHeight"]#
                                    ) />
                </cfloop>
            
            <cfcatch type="any"></cfcatch>
        </cftry>
	</cffunction>
	
	<!--- ADD PRODUCT --->
	<cffunction name="addProduct" access="public" returntype="any">
		<cfset response = structNew()>
        <cfset response.status = true>

		<!--- <cfargument name="company_id" type="numeric" required="yes">
		<cfargument name="partner_id" type="numeric" required="yes">
		<cfargument name="product_catid" type="numeric" required="yes">
		<cfargument name="product_stage" type="numeric" required="yes">
		<cfargument name="product_name" type="string" required="yes">
		<cfargument name="productKeyword" type="string" required="no">
		<cfargument name="product_brand" type="string" required="no">
		<cfargument name="product_code" type="string" required="no">
		<cfargument name="description" type="string" required="no">
		<cfargument name="product_detail" type="string" required="no">
		<cfargument name="product_image" type="string" required="no">
		<cfargument name="product_status" type="numeric" required="no" default="1">
		<cfargument name="is_online" type="numeric" required="no" default="0">
        <cfargument name="is_catalog" type="numeric" required="no" default="0"> --->
		<cftry>
			<cfquery name="ADD_PRODUCT" datasource="#dsn1#" result="MAX_ID">
				INSERT INTO WORKNET_PRODUCT
				(
					PRODUCT_STATUS,
					IS_ONLINE,
					IS_CATALOG,
					PRODUCT_STAGE,
					PRODUCT_NAME,
					PRODUCT_KEYWORD,
					BRAND_ID,
					BRAND_NAME,
					PRODUCT_CODE,
					PRODUCT_KEYWORD,
					PRODUCT_DESCRIPTION,
					PRODUCT_DETAIL_WOC,
					PRODUCT_CATID,
					COMPANY_ID,
					PARTNER_ID,
					OUR_COMPANY_ID,
					RECORD_MEMBER,
					RECORD_MEMBER_TYPE,
					RECORD_IP,
					RECORD_DATE,
					RELATED_PRODUCT_ID,
					WATALOGY_CON_ID
				)
				VALUES
				(
					1, <!--- --->
					1, <!--- --->
					0, <!--- --->
					<cfif isDefined(arguments.product_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_stage#">,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_keyword#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.brand_name#" null="#not len(arguments.brand_name)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#" null="#not len(arguments.product_code)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" null="#not len(arguments.description)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_detail#" null="#not len(arguments.product_detail)#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_catid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">,
					<cfif isdefined('session.ep')>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						'EMPLOYEE',
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
						'COMPANY',
					</cfif>
					'#cgi.REMOTE_ADDR#',
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.r_product_multi_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.watalogy_con_id#">
				)
			</cfquery>
			<cfset response.result = MAX_ID>
            <cfcatch type = "any">
                <cfset response.status = false>
            </cfcatch>
		</cftry>
		<cfreturn response>
	</cffunction>
	<!--- UPD PRODUCT --->
	<cffunction name="updProduct" access="public" returntype="any">
		<cfargument name="product_id" type="numeric" required="yes">
		<cfargument name="product_stage" type="numeric" required="yes">
		<cfargument name="product_name" type="string" required="yes">
		<cfargument name="productKeyword" type="string" required="no">
		<cfargument name="product_brand" required="no">
		<cfargument name="brand_name" required="no">
		<cfargument name="product_code" type="string" required="no">
		<cfargument name="description" type="string" required="no">
		<cfargument name="product_detail" type="string" required="no">
		<cfargument name="product_catid" type="string" required="yes">
		<cfargument name="company_id" type="numeric" required="yes">
		<cfargument name="partner_id" type="numeric" required="yes">
		<cfargument name="r_product_multi_id" type="string" required="no">
		<cfargument name="watalogy_con_id" type="numeric" required="no">
		<cfargument name="is_active" default="" required="no">
		<!--- <cfargument name="product_status" type="numeric" required="yes">
		<cfargument name="sort" type="string" required="no" default="">
		<cfargument name="is_homepage" type="numeric" required="no" default="0"> --->
		
		<!--- history --->
		<!--- <cfquery name="hist_cont" datasource="#dsn1#">
			SELECT
				WP.*
			FROM
				WORKNET_PRODUCT WP
			WHERE
				WP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
		</cfquery>
		<cfif 	arguments.company_id neq hist_cont.company_id or
				arguments.partner_id neq hist_cont.partner_id or 
				arguments.product_catid neq hist_cont.product_catid or
				arguments.product_stage neq hist_cont.product_stage or
				arguments.product_status neq hist_cont.product_status or 
				arguments.product_name neq hist_cont.product_name or
				arguments.productKeyword neq hist_cont.product_keyword or 
				arguments.product_brand neq hist_cont.brand_name or
				arguments.product_code neq hist_cont.product_code or 
				arguments.description neq hist_cont.product_description or
				arguments.product_detail neq hist_cont.product_detail>
				<cfoutput query="hist_cont">
					<cfquery name="ADD_PRODUCT_HISTORY" datasource="#dsn1#">
						INSERT INTO
							WORKNET_PRODUCT_HISTORY
						(
							PRODUCT_ID,
							PRODUCT_STATUS,
							PRODUCT_STAGE,
							PRODUCT_NAME,
							PRODUCT_KEYWORD,
							PRODUCT_DESCRIPTION,
							PRODUCT_DETAIL,
							PRODUCT_CATID,
							BRAND_NAME,
							PRODUCT_CODE,
							COMPANY_ID,
							PARTNER_ID,
							IS_ONLINE,
							OUR_COMPANY_ID,
							RECORD_DATE,
							RECORD_MEMBER,
							RECORD_MEMBER_TYPE,
							RECORD_IP
						)
						VALUES
						(
							#hist_cont.product_id#,
							<cfif len(hist_cont.product_status)>#hist_cont.product_status#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.product_stage)>#hist_cont.product_stage#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.product_name)>'#hist_cont.product_name#'<cfelse>NULL</cfif>,
							<cfif len(hist_cont.product_keyword)>'#hist_cont.product_keyword#'<cfelse>NULL</cfif>,
							<cfif len(hist_cont.product_description)>'#hist_cont.product_description#'<cfelse>NULL</cfif>,
							<cfif len(hist_cont.product_detail)>'#hist_cont.product_detail#'<cfelse>NULL</cfif>,
							<cfif len(hist_cont.product_catid)>#hist_cont.product_catid#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.brand_name)>'#hist_cont.brand_name#'<cfelse>NULL</cfif>,
							<cfif len(hist_cont.product_code)>'#hist_cont.product_code#'<cfelse>NULL</cfif>,
							<cfif len(hist_cont.company_id)>#hist_cont.company_id#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.partner_id)>#hist_cont.partner_id#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.is_online)>#hist_cont.is_online#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.our_company_id)>#hist_cont.our_company_id#<cfelse>NULL</cfif>,
							<cfif len(hist_cont.update_date)>'#hist_cont.update_date#'<cfelse>'#hist_cont.record_date#'</cfif>,
							<cfif len(hist_cont.update_member)>#hist_cont.update_member#<cfelse>#hist_cont.record_member#</cfif>,
							<cfif len(hist_cont.update_member_type)>'#hist_cont.update_member_type#'<cfelse>'#hist_cont.record_member_type#'</cfif>,
							<cfif len(hist_cont.update_ip)>'#hist_cont.update_ip#'<cfelse>'#hist_cont.record_ip#'</cfif>
						)
					</cfquery>
				</cfoutput>
		</cfif> --->
		
		<cfquery name="UPD_PRODUCT" datasource="#dsn1#">
			UPDATE
				WORKNET_PRODUCT
			SET
			   	PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">,
				PRODUCT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_stage#">,
				PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_name#">,
				PRODUCT_KEYWORD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.productKeyword#">,
				BRAND_ID = <cfif len(arguments.product_brand) and len(arguments.brand_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_brand#"><cfelse>NULL</cfif>,
				BRAND_NAME = <cfif len(arguments.product_brand) and len(arguments.brand_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.brand_name#"><cfelse>NULL</cfif>,
				PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_code#">,
			   	PRODUCT_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.description#">,
			   	PRODUCT_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_detail#">,
			   	PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_catid#">,
			    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">,
			    <cfif isdefined('session.ep')>
					UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_MEMBER_TYPE = 'EMPLOYEE',
				<cfelse>
					UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
					UPDATE_MEMBER_TYPE = 'COMPANY',
				</cfif>
			    UPDATE_IP = '#cgi.REMOTE_ADDR#',
			    UPDATE_DATE = #now()#,
				RELATED_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.r_product_multi_id#">,
				WATALOGY_CON_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.watalogy_con_id#">
			WHERE
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
		</cfquery>
	</cffunction>

	<!--- GET RELATED PRODUCT --->
	<cffunction name="getRelatedProduct" access="public" returntype="query">
		<cfargument name="r_product_id" type="string">
		<cfquery name="get_related_product" datasource="#dsn1#">
			SELECT * FROM PRODUCT WHERE PRODUCT_ID IN (#arguments.r_product_id#) ORDER BY PRODUCT_NAME
		</cfquery>
		<cfreturn get_related_product>
	</cffunction>
	<!--- GET PRODUCT CAT --->
	<cffunction name="getProductCat" access="public" returntype="query">
		<cfargument name="catid" type="string">
		<cfquery name="get_product_cat" datasource="#dsn1#">
			SELECT * FROM PRODUCT_CAT WHERE PRODUCT_CATID IN (#arguments.catid#)
		</cfquery>
		<cfreturn get_product_cat>
	</cffunction>
	<!--- GET PRODUCT --->
	<cffunction name="getProduct" access="public" returntype="query">
		<cfargument name="product_id" type="numeric" default="0">
		<cfargument name="product_id_list" type="string" required="no" default="">
		<cfargument name="keyword" type="string" default="">
		<cfargument name="sector" type="string" default="">
		<!--- <cfargument name="product_catid" type="string" default="">
		<cfargument name="product_cat" type="string" default=""> --->
		<cfargument name="company_id" type="string" default="">
		<cfargument name="company_name" type="string" default="">
		<cfargument name="product_status" type="string" required="no" default="">
		<cfargument name="product_stage" type="string" required="no" default="">
		<cfargument name="is_online" type="string" required="no" default="">
		<cfargument name="sortfield" type="string" required="no" default="WP.RECORD_DATE">
		<cfargument name="sortdir" type="string" required="no" default="desc">
		<cfargument name="recordCount" type="string" required="no" default="">
		<cfargument name="image_type" type="numeric" required="no" default="1">
        <cfargument name="is_catalog" type="string" required="no" default="">
		<cfargument name="is_homepage" type="numeric" required="no" default="0">
        <cfargument name="firm_type" type="string" required="no" default="">
        <cfargument name="photo_status" type="any" required="no" default="">
        <cfargument name="country" type="string" required="no" default="">
        <cfargument name="city" type="string" required="no" default="">
        <cfargument name="county" type="string" required="no" default="">
        
		
		<cfif len(arguments.product_id) and arguments.product_id neq 0>
			<cfquery name="GET_PRODUCT" datasource="#DSN1#">
				SELECT 
					WP.*,
					<!--- #dsn_alias#.Get_Dynamic_Language(PC.PRODUCT_CATID,'#lang#','PRODUCT_CAT','PRODUCT_CAT',NULL,NULL,PRODUCT_CAT) AS PRODUCT_CAT, --->
					<!--- PC.HIERARCHY, --->
					C.FULLNAME,
					C.NICKNAME,
					C.ASSET_FILE_NAME1,
					C.ASSET_FILE_NAME1_SERVER_ID,
                    C.FIRM_TYPE,
					CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME,
					#dsn_alias#.Get_Dynamic_Language(PROCESS_ROW_ID,'#lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
					WPI.PATH,
					WPI.PATH_SERVER_ID
				FROM
					WORKNET_PRODUCT WP
					<!--- LEFT JOIN PRODUCT_CAT PC ON WP.PRODUCT_CATID = PC.PRODUCT_CATID --->
					LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = WP.COMPANY_ID
					LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = WP.PARTNER_ID
					LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = WP.PRODUCT_STAGE
					LEFT JOIN WORKNET_PRODUCT_IMAGES WPI ON WPI.PRODUCT_ID = WP.PRODUCT_ID
				WHERE 
					WP.PRODUCT_ID = #arguments.product_id#
			</cfquery>
		<cfelse>
			<cfquery name="GET_PRODUCT" datasource="#DSN1#">
				SELECT 
					<cfif len(arguments.recordCount)>
						TOP #arguments.recordCount#
					</cfif>
					WP.PRODUCT_ID,
					WP.PRODUCT_NAME,
					WP.PRODUCT_DESCRIPTION,
					WP.COMPANY_ID,
					WP.PARTNER_ID,
					WP.RECORD_DATE,
					WP.BRAND_NAME,
					WP.PRODUCT_CATID,
					WP.PRODUCT_STATUS,
					WP.PRODUCT_STAGE,
					CASE WHEN (WP.SORT IS NOT NULL) THEN WP.SORT ELSE 1000 END AS SORT,
                    <!--- PC.PRODUCT_CATID,
					#dsn_alias#.Get_Dynamic_Language(PC.PRODUCT_CATID,'#lang#','PRODUCT_CAT','PRODUCT_CAT',NULL,NULL,PRODUCT_CAT) AS PRODUCT_CAT,
					PC.HIERARCHY, --->
					#dsn_alias#.Get_Dynamic_Language(PROCESS_ROW_ID,'#lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
					C.FULLNAME,
					C.NICKNAME,
                    C.FIRM_TYPE,
					C.ASSET_FILE_NAME1,
					C.ASSET_FILE_NAME1_SERVER_ID,
                    C.COUNTRY,
                    C.CITY,
                    C.COUNTY,
					WPI.PATH,
					WPI.PATH_SERVER_ID,
                    CASE WHEN (C.SORT IS NOT NULL) THEN C.SORT ELSE 1000 END AS COMPANY_SORT,
					CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME
					/* (SELECT PATH FROM WORKNET_PRODUCT_IMAGES WPI WHERE WPI.PRODUCT_ID = WP.PRODUCT_ID AND WPI.IMAGE_TYPE = #arguments.image_type#) AS PATH,
					(SELECT PATH_SERVER_ID FROM WORKNET_PRODUCT_IMAGES WPI WHERE WPI.PRODUCT_ID = WP.PRODUCT_ID AND WPI.IMAGE_TYPE = #arguments.image_type#) AS PATH_SERVER_ID */
				FROM
					WORKNET_PRODUCT WP
					<!--- LEFT JOIN PRODUCT_CAT PC ON WP.PRODUCT_CATID = PC.PRODUCT_CATID --->
					LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = WP.COMPANY_ID
					LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = WP.PARTNER_ID
					LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = WP.PRODUCT_STAGE
					LEFT JOIN WORKNET_PRODUCT_IMAGES WPI ON WPI.PRODUCT_ID = WP.PRODUCT_ID
				WHERE 
					1 = 1
					<cfif len(arguments.product_id_list)>
						AND WP.PRODUCT_ID IN (#arguments.product_id_list#)
					</cfif>
					<cfif len(arguments.product_status)>
						AND WP.PRODUCT_STATUS = #arguments.product_status#
					</cfif>
					<cfif len(arguments.is_online)>
						AND WP.IS_ONLINE = #arguments.is_online# 
					</cfif>
					<cfif len(arguments.is_catalog)>
						AND WP.IS_CATALOG = #arguments.is_catalog# 
					</cfif>
					<cfif arguments.is_homepage neq 0>
						AND WP.IS_HOMEPAGE = #arguments.is_homepage# 
					</cfif>
					<cfif len(arguments.product_catid) and len(arguments.product_cat)>
						AND WP.PRODUCT_CATID IN (#arguments.product_catid#)
					</cfif>
					<cfif len(arguments.company_id) and len(arguments.company_name)>
						AND WP.COMPANY_ID = #arguments.company_id#
					</cfif>
					<cfif len(arguments.product_stage)>
						AND WP.PRODUCT_STAGE = #arguments.product_stage#
					</cfif>
					<cfif len(arguments.keyword)>
					AND (
						WP.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
						WP.PRODUCT_KEYWORD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
						WP.PRODUCT_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
						WP.PRODUCT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
					)
					</cfif>
                    <cfif len (arguments.firm_type)>
                    	AND C.FIRM_TYPE LIKE '%#arguments.firm_type#%'
                    </cfif>
                    <cfif len (arguments.sector)>
                    	AND C.SECTOR_CAT_ID = #arguments.sector#
                    </cfif>
                    <cfif len(arguments.country)>
						AND C.COUNTRY = #arguments.country#
                    </cfif>
                    <cfif len(arguments.city)>
                        AND C.CITY = #arguments.city#
                    </cfif>
                    <cfif len(arguments.county)>
                        AND C.COUNTY = #arguments.county#
                    </cfif>
                    <cfif len(arguments.photo_status)>
                    	<cfif arguments.photo_status eq 1 >
                    		AND PRODUCT_ID IN (SELECT PRODUCT_ID FROM WORKNET_PRODUCT_IMAGES)
                        <cfelse>
                        	AND PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM WORKNET_PRODUCT_IMAGES)
                        </cfif>
                    </cfif>
				ORDER BY 
					#arguments.sortfield# #arguments.sortdir#
			</cfquery>
		</cfif>
		<cfreturn GET_PRODUCT>
	</cffunction>
    <!--- Delete Product --->
    <cffunction name="delProduct" access="public">
    	<cfargument name="product_id" required="yes">
        <cfquery name="delProduct" datasource="#dsn1#">
        	DELETE FROM WORKNET_PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
        </cfquery>
        <cfquery name="delProductHistory" datasource="#dsn1#">
        	DELETE FROM WORKNET_PRODUCT_HISTORY WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
        </cfquery>
        <cfquery name="delProductCost" datasource="#dsn1#">
        	DELETE FROM PRODUCT_COST WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
        </cfquery>
        <cfquery name="delProductUnitHistory" datasource="#dsn1#">
        	DELETE FROM PRODUCT_UNIT_HISTORY WHERE PRODUCT_UNIT_ID IN (SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">)
        </cfquery>
        <cfquery name="delProductUnit" datasource="#dsn1#">
        	DELETE FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
        </cfquery>
        <cfquery name="delStockBarcode" datasource="#dsn1#">
        	DELETE FROM STOCKS_BARCODES WHERE STOCK_ID IN (SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">)
        </cfquery>
        <cfquery name="delStocks_property" datasource="#dsn1#">
        	DELETE FROM STOCKS_PROPERTY WHERE STOCK_ID IN (SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">)
        </cfquery>
        <cfquery name="delStock" datasource="#dsn1#">
        	DELETE FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
        </cfquery>
        <cfquery name="deleteRelatedCat" datasource="#dsn1#">
        	DELETE FROM RELATED_PRODUCT_CAT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
        </cfquery>
    </cffunction>
	<!--- ADD PRODUCT IMAGE--->
	<cffunction name="addProductImage" access="public" returntype="string">		
		<!--- <cfif arguments.image_type eq 1>
			<cfquery name="updProductImageType" datasource="#dsn1#">
				UPDATE WORKNET_PRODUCT_IMAGES SET IMAGE_TYPE = 0 WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
			</cfquery>
		</cfif> --->

		<cfquery name="ADD_PRODUCT_IMAGE" datasource="#dsn1#">
		INSERT INTO WORKNET_PRODUCT_IMAGES
		   (
			PRODUCT_ID,
			PATH,
			PATH_SERVER_ID,
			DETAIL,
			RECORD_MEMBER,
			RECORD_MEMBER_TYPE,
			RECORD_IP,
			RECORD_DATE
		   )
		VALUES
		   (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_path_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
			<cfif isdefined('session.ep')>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				'EMPLOYEE',
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
				'COMPANY',
			</cfif>
			'#cgi.REMOTE_ADDR#',
			#now()#
		   )
	</cfquery>
	</cffunction>
	<!--- UPD PRODUCT IMAGE--->
	<cffunction name="updProductImage" access="public" returntype="string">
		<cfargument name="product_id" type="numeric" required="no">
		<cfargument name="path" type="string" required="no">
		<cfargument name="detail" type="string" required="no">
		
		<cfquery name="UPD_PRODUCT_IMAGE" datasource="#dsn1#">
			UPDATE 
				WORKNET_PRODUCT_IMAGES
			SET
				<cfif len(arguments.path)>
					PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path#">,
				</cfif>
				PATH_SERVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_path_id#">,
				DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
				<cfif isdefined('session.ep')>
					UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_MEMBER_TYPE = 'EMPLOYEE',
				<cfelse>
					UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
					UPDATE_MEMBER_TYPE = 'COMPANY',
				</cfif>
				UPDATE_IP = '#cgi.REMOTE_ADDR#',
				UPDATE_DATE = #now()#
			WHERE
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
		</cfquery>
	</cffunction>
	<!--- DEL PRODUCT IMAGE--->
	<cffunction name="delProductImage" access="public" returntype="string">
		<cfargument name="product_image_id" type="numeric" required="no" default="0">
		<cfargument name="product_id" type="numeric" required="no" default="0">

		<cfquery name="DEL_PRODUCT_IMAGE" datasource="#dsn1#">
			 DELETE FROM 
			 	WORKNET_PRODUCT_IMAGES 
			WHERE 
				<cfif len(arguments.product_image_id) and arguments.product_image_id neq 0>
					PRODUCT_IMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_image_id#">
				</cfif>
				<cfif len(arguments.product_id) and arguments.product_id neq 0>
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				</cfif>
		</cfquery>
	</cffunction>
	<!--- DEL PRODUCT RELATION ALL WORKNET--->
	<cffunction name="delProductWorknet" access="public" returntype="string">
		<cfargument name="product_id" type="numeric" required="no" default="0">

		<cfquery name="DEL_PRODUCT_WORKNET" datasource="#dsn#">
			DELETE FROM 
			 	WORKNET_RELATION_PRODUCT 
			WHERE 
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
		</cfquery>
	</cffunction>
	<!--- GET PRODUCT IMAGE --->
	<cffunction name="getProductImage" access="public" returntype="query">
		<cfargument name="product_id" type="numeric" default="0">
		<cfargument name="product_image_id" type="numeric" default="0">
		<cfargument name="image_type" type="string" default="">
		<cfargument name="recordCount" type="numeric" default="0">
		
		<cfquery name="GET_PRODUCT_IMAGE" datasource="#DSN1#">
			SELECT 
				<cfif arguments.recordCount gt 0>TOP #arguments.recordCount#</cfif>
				*
			FROM
				WORKNET_PRODUCT_IMAGES
			WHERE 
				1 = 1
				<cfif len(arguments.product_id) and arguments.product_id neq 0>
					AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> 
				</cfif>
				<cfif len(arguments.product_image_id) and arguments.product_image_id neq 0>
					AND PRODUCT_IMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_image_id#"> 
				</cfif>
				<cfif len(arguments.image_type)>
					AND IMAGE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.image_type#"> 
				</cfif>
			ORDER BY 
				DETAIL
		</cfquery>
		<cfreturn GET_PRODUCT_IMAGE>
	</cffunction>
	<!--- GET MAIN PRODUCT CAT --->
	<cffunction name="getMainProductCat" access="public" returntype="query">
		<cfargument name="hierarchy" type="any" default="">
		<cfargument name="is_internet" type="any" default="">
		
		<cfquery name="GET_MAIN_PRODUCT_CAT" datasource="#DSN1#">
			SELECT
				PC.HIERARCHY,
				#dsn_alias#.Get_Dynamic_Language(PC.PRODUCT_CATID,'#lang#','PRODUCT_CAT','PRODUCT_CAT',NULL,NULL,PRODUCT_CAT) AS PRODUCT_CAT,
				PC.IS_SUB_PRODUCT_CAT,
				PC.PRODUCT_CATID
			FROM
				PRODUCT_CAT PC,
				PRODUCT_CAT_OUR_COMPANY PCO
			WHERE 
				PCO.PRODUCT_CATID = PC.PRODUCT_CATID
				<cfif len(arguments.hierarchy)>
					AND PC.HIERARCHY = '#arguments.hierarchy#'
				<cfelse>
					AND PC.HIERARCHY NOT LIKE '%.%'
				</cfif>
				<cfif len(arguments.is_internet)>
					AND PC.IS_PUBLIC = #arguments.is_internet#
				</cfif>
				<cfif isdefined('session.ep')>
					AND PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfelseif isdefined('session.pp')>
					AND PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
				<cfelseif isdefined('session.wp')>
					AND PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.our_company_id#">
				</cfif>
			ORDER BY
				PC.HIERARCHY
		</cfquery>
		<cfreturn GET_MAIN_PRODUCT_CAT>
	</cffunction>
	<!--- GET PRODUCT HISTORY --->
	<cffunction name="getProductHistory" access="public" returntype="query">
		<cfargument name="product_id" type="numeric" default="0">
		<cfquery name="GET_PRODUCT_HISTORY" datasource="#dsn1#">
			SELECT
				WPH.*,
				C.FULLNAME COMPANY_NAME,
				C.NICKNAME,
				CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME,
				PTR.STAGE PROCESS_STAGE,
				(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE E.EMPLOYEE_ID = WPH.RECORD_MEMBER) AS RECORD_NAME,
				(SELECT PRODUCT_CAT FROM #dsn1_alias#.PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = WPH.PRODUCT_CATID) AS CATEGORY
			FROM
				WORKNET_PRODUCT_HISTORY WPH
				LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = WPH.COMPANY_ID
				LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = WPH.PARTNER_ID
				LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = WPH.PRODUCT_STAGE
			WHERE
				PRODUCT_ID = #arguments.product_id#
			ORDER BY 
				RECORD_DATE DESC
		</cfquery>
		<cfreturn GET_PRODUCT_HISTORY>
	</cffunction>
	<cffunction name="get_product_actions" access="public" returntype="query">
        <cfparam name="product_id" default="">
        <cfquery name="get_product_actions" datasource="#dsn3#">
            SELECT
				PRODUCT_ID
			FROM
            (
                    SELECT 
						S.PRODUCT_ID AS PRODUCT_ID
                    FROM 
						#dsn2#.EXPENSE_ITEM_PLANS EIP,
						#dsn2#.EXPENSE_ITEMS_ROWS EIPR
						LEFT JOIN STOCKS S ON S.STOCK_ID = EIPR.STOCK_ID_2
                    WHERE 
						EIP.EXPENSE_ID = EIPR.EXPENSE_ID AND
                        S.PRODUCT_ID = <cfqueryparam value = "#arguments.product_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
						S.PRODUCT_ID
                UNION ALL
                    SELECT 
						SRV.SERVICE_PRODUCT_ID AS PRODUCT_ID
                    FROM 
						SERVICE SRV        
						,SERVICE_OPERATION SO
						,STOCKS S 
                    WHERE 
						SRV.SERVICE_ID = SO.SERVICE_ID AND
						SO.STOCK_ID = S.STOCK_ID AND
						SRV.SERVICE_PRODUCT_ID = <cfqueryparam value = "#arguments.product_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
						SRV.SERVICE_PRODUCT_ID
                UNION ALL
                    SELECT 
					    S.PRODUCT_ID AS PRODUCT_ID
                    FROM 
						PRODUCTION_ORDERS PO,
						PRODUCTION_ORDER_RESULTS POR,
						PRODUCTION_ORDER_RESULTS_ROW PORR,
						STOCKS S
                    WHERE 
						PORR.TYPE= 1 AND
						PORR.PR_ORDER_ID = POR.PR_ORDER_ID AND
						POR.P_ORDER_ID = PO.P_ORDER_ID AND
						S.STOCK_ID = PORR.STOCK_ID AND
                        S.PRODUCT_ID  = <cfqueryparam value = "#arguments.product_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
						S.PRODUCT_ID
                UNION ALL
                    SELECT 
						S.PRODUCT_ID AS PRODUCT_ID
                    FROM 
						PRODUCTION_ORDERS PO,
						STOCKS S 
                    WHERE 
						S.STOCK_ID = PO.STOCK_ID AND
						PO.DP_ORDER_ID IS NULL AND 
						S.PRODUCT_ID  = <cfqueryparam value = "#arguments.product_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                    	S.PRODUCT_ID
                UNION ALL
                    SELECT 
						IR.PRODUCT_ID AS PRODUCT_ID
                    FROM 
						#dsn2#.INVOICE I,
						#dsn2#.INVOICE_ROW IR,
						STOCKS S 
                    WHERE
						ISNULL(I.IS_IPTAL,0) = 0 AND
						IR.STOCK_ID = S.STOCK_ID AND
						I.INVOICE_ID = IR.INVOICE_ID AND 
                        IR.PRODUCT_ID = <cfqueryparam value = "#arguments.product_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
						IR.PRODUCT_ID
                UNION ALL
                    SELECT 
						SR.PRODUCT_ID AS PRODUCT_ID 
                    FROM 
						#dsn2#.SHIP SH,
						#dsn2#.SHIP_ROW SR,
						STOCKS S        				
                    WHERE 
						SR.SHIP_ID = SH.SHIP_ID AND
            			SR.STOCK_ID = S.STOCK_ID AND
						SR.PRODUCT_ID = <cfqueryparam value = "#arguments.product_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
						SR.PRODUCT_ID
                UNION ALL
                    SELECT 
						ORR.PRODUCT_ID AS PRODUCT_ID
                    FROM 
						ORDERS O
						,STOCKS S
						,ORDER_ROW ORR
                    WHERE 
						ORR.STOCK_ID = S.STOCK_ID AND
						ORR.ORDER_ID = O.ORDER_ID AND
						O.ORDER_STATUS = 1 AND
                        ORR.PRODUCT_ID = <cfqueryparam value = "#arguments.product_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
						ORR.PRODUCT_ID
                UNION ALL
                    SELECT 
						ORR.PRODUCT_ID AS PRODUCT_ID
                    FROM 
						OFFER O
						,STOCKS S
						,OFFER_ROW ORR
                    WHERE 
						ORR.STOCK_ID = S.STOCK_ID AND
        				ORR.OFFER_ID = O.OFFER_ID AND
						OFFER_STATUS = 1 AND
                        ORR.PRODUCT_ID = <cfqueryparam value = "#arguments.product_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                    	ORR.PRODUCT_ID
						
            )MAIN_QUERY
			GROUP BY
            PRODUCT_ID
        </cfquery>
        <cfreturn get_product_actions>
    </cffunction>
</cfcomponent>
