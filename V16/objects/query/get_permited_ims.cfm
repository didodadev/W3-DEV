<!--- IMS KODLARINA GORE IZINLERIN BELIRLENMESI ICIN YAZILAN FUNCTION
	  CREATED BY N.OMER HAMZAOGLU 20/10/2004
	  USAGE : get_permited_ims(position_code : emp_position_code) --->
<cffunction name="get_permited_ims" access="public" returntype="any">
	<cfargument name="output" type="string" required="true">
	<cfargument name="position_code" type="numeric" required="true">
	<cfargument name="company_id" type="numeric" required="true">
	<cfparam name="attributes.position_id" default="0">
	<cfset attributes.position_id = arguments.position_code>
	<!--- OUTPUT DEGISKENINE GORE FARKLI ISLEMLER YAPILIYOR --->
	<cfswitch expression="#arguments.output#">
		<cfcase value="ims_code_id">
			<cfreturn get_all_ims_ids(position_id : attributes.position_id)>
		</cfcase>
		<cfcase value="related_id">
			<cfreturn get_all_related_companies(position_id : attributes.position_id, company_id : arguments.company_id)>
		</cfcase>
		<cfcase value="sz_ids_list">
			<cfreturn get_all_sz_ids(position_id : attributes.position_id)>
		</cfcase>
	</cfswitch>
</cffunction>

<!--- KULLANICININ TUM SZ_ID'LERININ BULUNMASI --->
<cffunction name="get_all_sz_ids" access="public" returntype="any">
	<cfargument name="position_id" type="numeric" required="true">
	<cfparam name="attributes.func_sz_ids" default="-1">
		<cfquery name="get_all_hierarchy" datasource="#dsn#">
			SELECT 
				SZ_HIERARCHY 
			FROM 
				SALES_ZONES 
			WHERE 
				SZ_ID IN
				(
					SELECT 
						SZ_ID 
					FROM 
						SALES_ZONES 
					WHERE 
						RESPONSIBLE_POSITION_CODE = #arguments.position_id# 
				UNION
					SELECT 
						SALES_ZONE_GROUP.SZ_ID 
					FROM  
						EMPLOYEE_POSITIONS,	
						SALES_ZONE_GROUP
					WHERE 
						EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND 
						EMPLOYEE_POSITIONS.POSITION_ID = SALES_ZONE_GROUP.POSITION_CODE AND 
						EMPLOYEE_POSITIONS.POSITION_ID = #arguments.position_id#
				UNION
					SELECT SALES_ZONES AS SZ_ID FROM SALES_ZONES_TEAM WHERE TEAM_ID IN
					(
						SELECT TEAM_ID FROM SALES_ZONES_TEAM_ROLES WHERE POSITION_CODE = #arguments.position_id#
					)
				)
		</cfquery>
		<!--- KULLANICININ KAYITLI OLMADIGI ANCAK HIERARSISINDE BULUNAN SZ_ID'LERININ  BULUNMASI VE sz_ids DEGISKENINE SET EDILMESI--->
	<cfif get_all_hierarchy.recordcount gt 0>
		<cfquery name="get_all_sz_id" datasource="#dsn#">
			SELECT 
				SZ_ID
			FROM 
				SALES_ZONES 
			WHERE 
 				SZ_ID IN 
				(
					SELECT SZ_ID FROM SALES_ZONES WHERE RESPONSIBLE_POSITION_CODE = #arguments.position_id#
					UNION
					SELECT SALES_ZONE_GROUP.SZ_ID FROM  EMPLOYEE_POSITIONS,SALES_ZONE_GROUP WHERE EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND EMPLOYEE_POSITIONS.POSITION_ID = SALES_ZONE_GROUP.POSITION_CODE AND EMPLOYEE_POSITIONS.POSITION_ID = #arguments.position_id#
				)
			<cfif get_all_hierarchy.recordcount>
				OR <cfloop query="get_all_hierarchy"><cfif currentrow gt 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#SZ_HIERARCHY#%'</cfloop>
			</cfif>
		</cfquery>
	</cfif>
	<cfif isdefined("get_all_sz_id.recordcount") and get_all_sz_id.recordcount>
		<cfset attributes.func_sz_ids = ValueList(get_all_sz_id.SZ_ID)>
	</cfif>
	<cfreturn attributes.func_sz_ids>
</cffunction>
<!--- KULLANICININ KAYITLI OLDUGU TUM IMS_CODE'LARIN BULUNMASI --->
<cffunction name="get_all_ims_ids" access="public" returntype="any">
	<cfargument name="position_id" type="numeric" required="true">
	<cfparam name="attributes.func_ims_ids" default="-1">
	<cfparam name="attributes.all_sz_ids" default="#get_all_sz_ids(position_id : arguments.position_id)#">
	<cfquery name="GET_SZ_ID_REPONSIBLE" datasource="#dsn#">
			(
			SELECT 
				SZ_ID AS SZ_ID
			FROM 
				SALES_ZONES 
			WHERE 
				RESPONSIBLE_POSITION_CODE = #arguments.position_id# 
			)
		UNION
			(
			SELECT 
				SALES_ZONE_GROUP.SZ_ID AS SZ_ID
			FROM  
				EMPLOYEE_POSITIONS,	
				SALES_ZONE_GROUP 
			WHERE 
				EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
				EMPLOYEE_POSITIONS.POSITION_ID = SALES_ZONE_GROUP.POSITION_CODE AND 
				EMPLOYEE_POSITIONS.POSITION_ID = #arguments.position_id#
			)
	</cfquery>
	<cfif GET_SZ_ID_REPONSIBLE.recordcount>
		<cfquery name="GET_SZ_HIERARCHY" datasource="#dsn#">
			SELECT SZ_HIERARCHY FROM SALES_ZONES WHERE SZ_ID = #GET_SZ_ID_REPONSIBLE.sz_id#
		</cfquery>
		<cfquery name="GET_HIERARCHY" datasource="#dsn#">
			SELECT SZ_ID FROM SALES_ZONES WHERE SZ_HIERARCHY+'.' LIKE '%#GET_SZ_HIERARCHY.SZ_HIERARCHY#%'
		</cfquery>
	</cfif>
	<cfquery name="get_ims_list" datasource="#dsn#">
		SELECT 
			SETUP_IMS_CODE.IMS_CODE_ID
		FROM 
			SETUP_IMS_CODE,
			SALES_ZONES_TEAM_IMS_CODE AS SALES_ZONES_TEAM_IMS_CODE
		WHERE 
			SALES_ZONES_TEAM_IMS_CODE.IMS_ID = SETUP_IMS_CODE.IMS_CODE_ID AND
			(
				(
					SALES_ZONES_TEAM_IMS_CODE.TEAM_ID IN 
					(
					SELECT TEAM_ID FROM SALES_ZONES_TEAM WHERE SALES_ZONES IN 
						(
							<cfif GET_SZ_ID_REPONSIBLE.recordcount>
								#valuelist(GET_HIERARCHY.SZ_ID)#
							<cfelse>
								0
							</cfif>
						)
					)
				)
				OR SALES_ZONES_TEAM_IMS_CODE.TEAM_ID IN 
				(
					SELECT TEAM_ID FROM SALES_ZONES_TEAM_ROLES WHERE POSITION_CODE = #arguments.position_id#		
				)
			)
	</cfquery>
	<cfif get_ims_list.recordcount>
		<cfset attributes.func_ims_ids = ValueList(get_ims_list.IMS_CODE_ID)>
	</cfif>
	<cfreturn attributes.func_ims_ids>
</cffunction>
<!--- POSITION CODE'A GORE KULLANICININ PLASIYER, TELEFONLA SATIS GOREVLISI 
	  VE/VEYA SATIS DIREKTORU OLARAK IMS'LERDEN FARKLI OLARAK BAGLI OLDUGU 
	  FIRMALARIN BULUNMASI VE related_companies DEGISKENINE SET EDILMESI. --->
<cffunction name="get_all_related_companies" access="public" returntype="any">
	<cfargument name="position_id" type="numeric" required="true">
	<cfargument name="company_id" type="numeric" required="true">
	<cfparam name="related_companies" default="-1">
	<cfquery name="get_related_list" datasource="#dsn#">
		SELECT
			COMPANY_ID
		FROM
			COMPANY_BRANCH_RELATED
		WHERE
			OUR_COMPANY_ID = #arguments.company_id# AND
			(
				ZONE_DIRECTOR = #arguments.position_id# OR
				TEL_SALE_PREID = #arguments.position_id# OR
				PLASIYER_ID = #arguments.position_id#
			)
	</cfquery>
	<cfif get_related_list.recordcount>
		<cfset related_companies = ValueList(get_related_list.COMPANY_ID)>
	</cfif>
	<!--- OUTPUT ARGUMANINA GORE CIKISLARIN GONDERILMESI --->
	<cfreturn related_companies>
</cffunction>


<!--- IMS KODLARINA GORE IZINLERIN BELIRLENMESI ICIN YAZILAN FUNCTION //-END-// --->
