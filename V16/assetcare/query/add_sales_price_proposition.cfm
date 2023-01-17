<cfquery name="GET_SOLD" datasource="#DSN#">
	SELECT
		ASSETP_ID 
	FROM
		ASSET_P_SOLD
	WHERE
		ASSETP_ID = #attributes.assetp_id#
</cfquery>
<cfif get_sold.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='64300.Aracın Fiyat Önerisi Bulunmaktadır Kontrol Ediniz'> !");
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_sales_price_proposition';
	</script>
	<cfabort>
<cfelse>
<cfquery name="ADD_SOLD_PRICE_PROPOSITION" datasource="#DSN#"> 
	INSERT INTO 
        ASSET_P_SOLD
        (
            ASSETP_ID,
            MIN_PRICE, 
            MAX_PRICE,
            MAX_MONEY,
            MIN_MONEY,
            REQUEST_ROW_ID,
            REQUEST_ID,
            IS_TRANSFERED,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
        ) 
        VALUES 
        (
            #attributes.assetp_id#,
            <cfif len(attributes.min_price)>#attributes.min_price#<cfelse>0</cfif>,
            <cfif len(attributes.max_price)>#attributes.max_price#<cfelse>0</cfif>,
            '#attributes.max_currency#',
            '#attributes.min_currency#',
            <cfif len(attributes.request_row_id)>#attributes.request_row_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.request_id)>#attributes.request_id#<cfelse>NULL</cfif>,
            0,
            #session.ep.userid#,
            #now()#,
            '#cgi.remote_addr#' 
        )
</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>


