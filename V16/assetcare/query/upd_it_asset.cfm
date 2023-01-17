<cf_date tarih='attributes.get_date'>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_HISTORY" datasource="#DSN#">
			INSERT INTO
				ASSET_P_HISTORY
			(
				ASSETP_ID,
				ASSETP_CATID,
				ASSETP_STATUS,
				DEPARTMENT_ID,
				POSITION_CODE,
				POSITION_CODE2,
				ASSETP,
				INVENTORY_NUMBER,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_IP
			)
			VALUES
			(
				#attributes.assetp_id#,
				#attributes.assetp_catid#,
				#attributes.support_cat#,
				#attributes.department_id#,
				#attributes.position_code#,
				<cfif len(attributes.position_code2)>#attributes.position_code2#,<cfelse>null,</cfif> 
				'#attributes.assetp#',
				'#attributes.inventory_number#',
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfquery name="UPD_ASSETP" datasource="#dsn#">
			UPDATE
				ASSET_P
			SET
				DEPARTMENT_ID = #attributes.department_id#,
				POSITION_CODE = #attributes.position_code#,
				POSITION_CODE2 = <cfif len(attributes.position_code2)>#attributes.position_code2#,<cfelse>null,</cfif>
				ASSETP_CATID = #attributes.assetp_catid#,
				ASSETP = '#attributes.assetp#',
				ASSETP_DETAIL = '#attributes.assetp_detail#',
				STATUS = <cfif isDefined("attributes.status")>1,<cfelse>0,</cfif>
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				INVENTORY_NUMBER = '#attributes.inventory_number#',
				ASSETP_STATUS = #attributes.support_cat#,
				BARCODE = <cfif len(attributes.barcode)>'#attributes.barcode#',<cfelse>null,</cfif>
				USAGE_PURPOSE_ID = <cfif len(attributes.usage_purpose_id)>#attributes.usage_purpose_id#,<cfelse>null,</cfif>
				SERIAL_NO = <cfif len(attributes.serial_number)>'#attributes.serial_number#',<cfelse>null,</cfif>
				BRAND_ID = <cfif len(attributes.brand)>'#attributes.brand#',<cfelse>null,</cfif>
				MODEL = <cfif len(attributes.model)>'#attributes.model#',<cfelse>null,</cfif>
				PRIMARY_CODE = <cfif len(attributes.ozel_kod)>'#attributes.ozel_kod#',<cfelse>null,</cfif>
				SERVICE_EMPLOYEE_ID = <cfif len(attributes.employee_id)>'#attributes.employee_id#',<cfelse>null,</cfif>
				SUP_COMPANY_ID = <cfif len(attributes.get_company_id)>#attributes.get_company_id#,<cfelse>null,</cfif>
				SUP_COMPANY_DATE = <cfif len(attributes.get_date)>#attributes.get_date#<cfelse>null</cfif>
			WHERE
				ASSETP_ID = #attributes.assetp_id#
		</cfquery>
		
		<!--- BK kapatti 20080213 120 gune siline
		<cfquery name="UPD_PHYSICAL_ACHINE_INFO" datasource="#dsn#">
			UPDATE
				PHYSICAL_ASSET_INFO
			SET
				STATUS = <cfif isDefined("attributes.status")>1,<cfelse>0,</cfif>
				IS_ACTIVE = <cfif isDefined("attributes.status")>1<cfelse>0</cfif>
			WHERE
				ASSET_ID = #attributes.assetp_id#
		</cfquery> --->
	</cftransaction>
</cflock>
<cfif isdefined("attributes.status")>
	<cflocation url="#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#attributes.assetp_id#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=assetcare.list_it_asset" addtoken="no">
</cfif>
