<cfif len(attributes.rent_start_date)><cf_date tarih='attributes.rent_start_date'></cfif>
<cfif len(attributes.rent_finish_date)><cf_date tarih='attributes.rent_finish_date'></cfif>
<cfquery name="get_vehicle_rent" datasource="#dsn#">
		SELECT RENT_ID FROM ASSET_P_RENT WHERE ASSETP_ID = #attributes.assetp_id# 
</cfquery>
<cfif get_vehicle_rent.recordCount>
<cfquery name="UPD_ASSETP_RENT" datasource="#DSN#">
	UPDATE
		ASSET_P_RENT
	SET
		RENT_AMOUNT = <cfif len(attributes.rent_amount)>#attributes.rent_amount#<cfelse>NULL</cfif>,
		RENT_AMOUNT_CURRENCY = <cfif len(attributes.rent_amount) and len(attributes.rent_amount_currency)>'#attributes.rent_amount_currency#'<cfelse>NULL</cfif>,
		RENT_PAYMENT_PERIOD = <cfif len(attributes.rent_payment_period)>#attributes.rent_payment_period#<cfelse>NULL</cfif>,
		RENT_START_DATE = <cfif len(attributes.rent_start_date)>#attributes.rent_start_date#<cfelse>NULL</cfif>,
		RENT_FINISH_DATE = <cfif len(attributes.rent_finish_date)>#attributes.rent_finish_date#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		ASSETP_ID = #attributes.assetp_id#
</cfquery>
<cfelse>
<cfquery name="ADD_RENT" datasource="#DSN#">
    INSERT INTO
    ASSET_P_RENT
    (
        ASSETP_ID,
        RENT_AMOUNT,
        RENT_AMOUNT_CURRENCY,
        RENT_PAYMENT_PERIOD,
        RENT_START_DATE,
        RENT_FINISH_DATE,
        STATUS,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP
    )
    VALUES
    (
        #attributes.assetp_id#,
        <cfif len(attributes.rent_amount)>#attributes.rent_amount#<cfelse>NULL</cfif>,
        <cfif len(attributes.rent_amount_currency) and len(attributes.rent_amount)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.rent_amount_currency#"><cfelse>NULL</cfif>,
        <cfif len(attributes.rent_payment_period)>#attributes.rent_payment_period#<cfelse>NULL</cfif>,
        <cfif len(attributes.rent_start_date)>#attributes.rent_start_date#<cfelse>NULL</cfif>,
        <cfif len(attributes.rent_finish_date)>#attributes.rent_finish_date#<cfelse>NULL</cfif>,
        1,
        #now()#,
        #session.ep.userid#,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
    )
</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=assetcare.upd_vehicle_rent&assetp_id=#attributes.assetp_id#" addtoken="no">

