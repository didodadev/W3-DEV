<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cf_date tarih='attributes.get_date'>
		<cfif len(attributes.km_date_first)><cf_date tarih='attributes.km_date_first'></cfif>
		<cfif len(attributes.exit_date)><cf_date tarih='attributes.exit_date'></cfif>
		<cfif attributes.property eq 2>
			<cfif len(attributes.rent_start_date)><cf_date tarih='attributes.rent_start_date'></cfif>
			<cfif len(attributes.rent_start_date)><cf_date tarih='attributes.rent_finish_date'></cfif>
		</cfif>
		<cfparam name="attributes.status" default="0">
		<cfquery name="UPD_ASSETP" datasource="#DSN#">
			UPDATE
				ASSET_P
			SET
				DEPARTMENT_ID = #attributes.old_department_id#,
				DEPARTMENT_ID2 = #attributes.old_department_id2#,
				POSITION_CODE = <cfif len(attributes.position_code)>#attributes.position_code#</cfif>,
				POSITION_CODE2 = <cfif len(attributes.position_code2)>#attributes.position_code2#<cfelse>NULL</cfif>,
				COMPANY_PARTNER_ID = <cfif len(attributes.company_partner_id)>#attributes.company_partner_id#</cfif>,
				COMPANY_PARTNER_ID2 = <cfif len(attributes.company_partner_id2)>#attributes.company_partner_id2#</cfif>,
				ASSETP_CATID = #attributes.assetp_catid#,
				ASSETP_GROUP = <cfif len(attributes.assetp_group)>#attributes.assetp_group#<cfelse>NULL</cfif>,
				USAGE_PURPOSE_ID = <cfif len(attributes.usage_purpose_id)>#attributes.usage_purpose_id#<cfelse>NULL</cfif>,
				ASSETP = '#attributes.assetp#',
				ASSETP_DETAIL = '#attributes.assetp_detail#',
				STATUS = <cfif len(attributes.exit_date) or not isDefined("attributes.status")>0<cfelse>#attributes.status#</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				ASSETP_STATUS = <cfif len(attributes.assetp_status)>#attributes.assetp_status#<cfelse>NULL</cfif>,
				BRAND_TYPE_ID = <cfif len(attributes.brand_type_id)>#attributes.brand_type_id#<cfelse>NULL</cfif>,
				FIRST_KM_DATE = <cfif len(attributes.get_date)>#attributes.get_date#<cfelse>NULL</cfif>,
				SUP_COMPANY_DATE = <cfif len(attributes.km_date_first)>#attributes.km_date_first#<cfelse>NULL</cfif>,
				EXIT_DATE = <cfif len(attributes.exit_date)>#attributes.exit_date#<cfelse>NULL</cfif>,
				SUP_COMPANY_ID = <cfif len(attributes.get_company)>#attributes.get_company_id#<cfelse>NULL</cfif>,
				MAKE_YEAR = <cfif len(attributes.make_year)>#attributes.make_year#<cfelse>NULL</cfif>,
				FUEL_TYPE = <cfif len(attributes.fuel_type)>#attributes.fuel_type#<cfelse>NULL</cfif>,
				PRIMARY_CODE = <cfif len(attributes.ozel_kod)>'#attributes.ozel_kod#'<cfelse>NULL</cfif>,
				OPTION_KM = <cfif len(attributes.option_km)>#attributes.option_km#<cfelse>NULL</cfif>,
				FIRST_KM = <cfif len(attributes.first_km)>#attributes.first_km#<cfelse>NULL</cfif>,
				CARE_WARNING_DAY = <cfif len(attributes.care_warning_day)>#attributes.care_warning_day#<cfelse>NULL</cfif>,
				<cfif attributes.property eq 2>
				RENT_AMOUNT = <cfif len(attributes.rent_amount)>#attributes.rent_amount#<cfelse>NULL</cfif>,
				RENT_AMOUNT_CURRENCY = <cfif len(attributes.rent_amount_currency)>'#attributes.rent_amount_currency#'<cfelse>NULL</cfif>,
				RENT_PAYMENT_PERIOD = <cfif len(attributes.rent_payment_period)>#attributes.rent_payment_period#<cfelse>NULL</cfif>,
				RENT_START_DATE = <cfif len(attributes.rent_start_date)>#attributes.rent_start_date#<cfelse>NULL</cfif>,
				RENT_FINISH_DATE = <cfif len(attributes.rent_finish_date)>#attributes.rent_finish_date#<cfelse>NULL</cfif>,
				</cfif>
				INVENTORY_NUMBER = <cfif len(attributes.inventory_number)>'#attributes.inventory_number#'<cfelse>NULL</cfif>
			WHERE
				ASSETP_ID = #attributes.assetp_id#
		</cfquery>
		<cfif (attributes.first_km is not attributes.o_first_km)>
		<cfquery name="GET_KM" datasource="#DSN#">
			SELECT MIN(KM_CONTROL_ID) AS KM_CONTROL_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #attributes.assetp_id#
		</cfquery>
		<cfif len(get_km.km_control_id)>
		<cfquery name="upd_first_km" datasource="#DSN#">
			UPDATE
				ASSET_P_KM_CONTROL
				SET 
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				KM_FINISH = <cfif len(attributes.first_km)>#attributes.first_km#<cfelse>NULL</cfif>
			WHERE 
				KM_CONTROL_ID = #get_km.km_control_id#
		</cfquery>
		<cfelse>
		<cfquery name="add_first_km" datasource="#DSN#">
			INSERT INTO
				ASSET_P_KM_CONTROL
			(
				KM_START,
				KM_FINISH,
				START_DATE,
				FINISH_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
				VALUES 
			(
				0,
				<cfif len(attributes.first_km)>#attributes.first_km#<cfelse>0</cfif>,
				NULL,
				#attributes.get_date#,
				#session.ep.userid#,
				#now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		</cfif>
		</cfif>
		<cfif attributes.old_first_km_date is not attributes.km_date_first>
			<cfquery name="GET_KM" datasource="#DSN#">
				SELECT MIN(KM_CONTROL_ID) AS KM_CONTROL_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #attributes.assetp_id#
			</cfquery>
		<cfquery name="upd_first_km_date" datasource="#DSN#">
			UPDATE
				ASSET_P_KM_CONTROL
			SET
				FINISH_DATE = #attributes.km_date_first#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#
			WHERE 
				KM_CONTROL_ID = #get_km.km_control_id#
		</cfquery>
		</cfif>
		<cfif (attributes.old_department_id neq attributes.department_id) or (attributes.old_department_id2 neq attributes.department_id2) or 
		(attributes.old_position_code neq attributes.position_code) or (attributes.old_status neq attributes.status) or (attributes.old_assetp_status neq attributes.assetp_status)>
		<cfquery name="ADD_HISTORY" datasource="#DSN#">
			INSERT INTO
				ASSET_P_HISTORY
			(
				ASSETP_ID,
				DEPARTMENT_ID,
				DEPARTMENT_ID2,
				POSITION_CODE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				STATUS,
				ASSETP_STATUS
			)
				VALUES
			(
				#attributes.assetp_id#,
				#attributes.department_id#,
				#attributes.department_id2#,
				#attributes.position_code#,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				<cfif len(attributes.exit_date) or not isDefined("attributes.status")>0<cfelse>#attributes.status#</cfif>,
				<cfif len(attributes.assetp_status)>#attributes.assetp_status#<cfelse>NULL</cfif>
			)
		</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#cgi.http_referer#" addtoken="no">

