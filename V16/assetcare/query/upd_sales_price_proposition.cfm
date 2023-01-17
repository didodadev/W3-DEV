<cfquery name="GET_SOLD" datasource="#DSN#">
	SELECT
		ASSETP_ID 
	FROM
		ASSET_P_SOLD 
	WHERE
		ASSET_P_SOLD_ID <> #attributes.sold_id# AND
		ASSETP_ID = #attributes.assetp_id#
</cfquery>
<cfif get_sold.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='64300.Aracın Fiyat Önerisi Bulunmaktadır Kontrol Ediniz'> !");
		self.close();
	</script>
	<cfabort>
<cfelse>
<cfquery name="UPD_SOLD_PRICE_PROPOSITION" datasource="#DSN#">
	UPDATE 
		ASSET_P_SOLD
	SET
		ASSETP_ID = #attributes.assetp_id#,
		MIN_PRICE = #attributes.min_price#,
		MAX_PRICE = #attributes.max_price#,
		MIN_MONEY = '#attributes.min_currency#',
		MAX_MONEY = '#attributes.max_currency#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'		
	WHERE
		ASSET_P_SOLD_ID = #attributes.sold_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>
</cfif>
