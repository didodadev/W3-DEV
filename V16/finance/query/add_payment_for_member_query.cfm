<cf_date tarih = 'attributes.start_dates'>
<cf_date tarih = 'attributes.finish_dates'>
<cfquery name="DEL_CREDITCARD_PAYMENT_TYPE_MEMBER" datasource="#DSN3#">
	DELETE CREDITCARD_PAYMENT_TYPE_MEMBER WHERE CC_PAYMENT_TYPE_ID = #attributes.cc_payment_type_id#
</cfquery>
<cfif isdefined('attributes.TO_COMP_IDS') and len(attributes.TO_COMP_IDS)>
	<cfset comp_id_list = listdeleteduplicates(attributes.TO_COMP_IDS)>
    <cfloop list="#comp_id_list#" index="comp_id">
        <cfquery name="add_member" datasource="#dsn3#">
            INSERT INTO CREDITCARD_PAYMENT_TYPE_MEMBER
            (
                CC_PAYMENT_TYPE_ID,
                COMPANY_ID,
                START_DATE,
                FINISH_DATE,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
            )
            VALUES
            (
                #attributes.cc_payment_type_id#,
                #comp_id#,
                <cfif isdate(attributes.start_dates)>#attributes.start_dates#</cfif>,
                <cfif isdate(attributes.finish_dates)>#attributes.finish_dates#</cfif>,
                #session.ep.userid#,
                #now()#,
                '#cgi.remote_addr#'
            )
        </cfquery>
    </cfloop>
</cfif>
<script type="text/javascript">
	this.close();
	history.back();
</script>
