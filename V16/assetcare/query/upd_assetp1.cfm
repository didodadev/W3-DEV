<cfquery name="UPD_ASSETP" datasource="#dsn#">
		UPDATE
			ASSET_P
		SET
			FIRST_KM = <cfif len(attributes.first_km)>#attributes.first_km#<cfelse>NULL</cfif>,
			FIRST_KM_DATE = <cfif len(attributes.get_date)>#attributes.get_date#<cfelse>NULL</cfif>,
			CARE_WARNING_DAY = <cfif len(attributes.care_warning_day)>#attributes.care_warning_day#<cfelse>NULL</cfif>,
			OPTION_KM = <cfif len(attributes.option_km)>#attributes.option_km#<cfelse>NULL</cfif>,
			FUEL_TYPE = <cfif len(attributes.fuel_type)>#attributes.fuel_type#<cfelse>NULL</cfif>,
			ASSETP_STATUS = <cfif len(attributes.assetp_status)>#attributes.assetp_status#<cfelse>NULL</cfif>,
			USAGE_PURPOSE_ID = <cfif len(attributes.usage_purpose_id)>#attributes.usage_purpose_id#<cfelse>NULL</cfif>,
			ASSETP_GROUP = <cfif len(attributes.assetp_group)>#attributes.assetp_group#<cfelse>NULL</cfif>,
			ASSETP_DETAIL = '#attributes.assetp_detail#'
</cfquery>
<cflocation url="#cgi.http_referer#" addtoken="no">
