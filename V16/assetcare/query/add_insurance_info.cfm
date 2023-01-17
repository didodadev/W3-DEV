	<cf_date tarih = 'attributes.payment_date'>
	<cf_date tarih = 'attributes.denounce_date'>
	<cfquery name="ADD_CARE_PERIOD" datasource="#DSN#">
		UPDATE
			ASSET_P_ACCIDENT
		SET 
			DENOUNCE_DATE = #attributes.denounce_date#,
			APPROXIMATE_DAMAGE = #attributes.approximate_damage#,
			PAYMENT_DATE = <cfif len(attributes.payment_date)>#attributes.payment_date#<cfelse>NULL</cfif>,
			PAYMENT_TOTAL = <cfif len(attributes.payment_total)>#attributes.payment_total#<cfelse>NULL</cfif>,
			SERVICE_COMPANY_ID = <cfif len(attributes.service_company_id)>#attributes.service_company_id#<cfelse>NULL</cfif>,
			SERVICE_NUM = <cfif len(attributes.service_num)>#attributes.service_num#<cfelse>NULL</cfif>,
			INSURANCE_DETAIL = <cfif len(attributes.insurance_detail)>'#attributes.insurance_detail#'<cfelse>NULL</cfif>,
			IS_PAYMENT = <cfif isdefined('attributes.is_payment')>1<cfelse>0</cfif>,
			DAMAGE_CURRENCY = <cfif len(attributes.damage_currency)>'#attributes.damage_currency#'<cfelse>NULL</cfif>,
			PAYMENT_CURRENCY = <cfif len(attributes.payment_currency)>'#attributes.payment_currency#'<cfelse>NULL</cfif>,
            REPORT=<cfif isdefined('attributes.report') and len(attributes.report)>#attributes.report#<cfelse>NULL</cfif>,
            EXPERT=<cfif isdefined('attributes.expert') and len(attributes.expert)>#attributes.expert#<cfelse>NULL</cfif>,
            FILE_NUM=<cfif isdefined('attributes.file_no') and len(attributes.file_no)>'#attributes.file_no#'<cfelse>NULL</cfif>,
            POLICY_NUM=<cfif isdefined('attributes.policy_no') and len(attributes.policy_no)>'#attributes.policy_no#'<cfelse>NULL</cfif>,
            SERVICE_CITY=<cfif isdefined('attributes.service_city') and len(attributes.service_city)>#attributes.service_city#<cfelse>NULL</cfif>,
            SERVICE_FAX=<cfif isdefined('attributes.service_fax') and len(attributes.service_fax)>'#attributes.service_fax#'<cfelse>NULL</cfif>,
            EXPERT_NAME=<cfif isdefined('attributes.expert_name') and len(attributes.expert_name)>'#attributes.expert_name#'<cfelse>NULL</cfif>,
			RECORD_DATE = #now()#,					
			RECORD_EMP = #session.ep.userid#,
			RECORD_IP = '#cgi.remote_addr#'
		WHERE
			ACCIDENT_ID = #attributes.accident_id#
	</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>

