<cfquery name="CONTROL" datasource="#DSN3#">
	SELECT 
		TMARKET_ID
	FROM 
		CAMPAIGN_TARGET_MARKETS 
	WHERE 
		CAMP_ID = #attributes.camp_id# AND 
		TMARKET_ID =  #attributes.tmarket_id#
</cfquery>
<cfif control.recordcount>
	<script type="text/javascript">
		alert("Kampanyaya aynı hedef kitle daha önce kaydedilmiş !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_TMARKET_TO_CAMP" datasource="#dsn3#">
	INSERT INTO
		CAMPAIGN_TARGET_MARKETS
		(CAMP_ID, TMARKET_ID, RECORD_EMP, RECORD_DATE, RECORD_IP)
	VALUES
		(#attributes.CAMP_ID#, #attributes.tmarket_id#,#session.ep.userid#,#now()#,'#cgi.remote_addr#')			
</cfquery>
<cfinclude template="../query/get_target_markets.cfm">
<!--- bir hedef kitledeki kişi diğer hedef kitledede olabilir o yüzden kampanya bazlı kontrol koydum py --->
<cfif tmarket.target_market_type eq 2 or tmarket.target_market_type eq 0>
	<cfinclude template="get_tmarket_consumer_count.cfm">
	<cfloop query="GET_TMARKET_CONSUMER">
		<cfquery name="CONTROL" datasource="#DSN3#">
			SELECT 
				TMARKET_ID
			FROM 
				CAMPAIGN_TARGET_PEOPLE 
			WHERE
				CAMP_ID = #attributes.camp_id# AND
				TMARKET_ID = #attributes.tmarket_id# AND
				CON_ID = #consumer_id#
		</cfquery>
		<cfif not CONTROL.RECORDCOUNT>
			<cfquery name="ADD_TARGET_PEOPLE" datasource="#DSN3#">
				INSERT INTO
					CAMPAIGN_TARGET_PEOPLE
				(
					CAMP_ID,
					TMARKET_ID,
					CON_ID,
					RECORD_EMP,
					RECORD_DATE
				)
				VALUES
				(
					#attributes.camp_id#,
					#attributes.tmarket_id#,
					#consumer_id#,
					#session.ep.userid#,
					#now()#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<cfif tmarket.target_market_type eq 1 or tmarket.target_market_type eq 0>
	<cfinclude template="get_tmarket_partners_count.cfm">
	<cfloop query="GET_TMARKET_PARTNERS">
		<cfquery name="CONTROL" datasource="#DSN3#">
			SELECT 
				TMARKET_ID
			FROM 
				CAMPAIGN_TARGET_PEOPLE 
			WHERE
				CAMP_ID = #attributes.camp_id# AND
				TMARKET_ID = #attributes.tmarket_id# AND
				PAR_ID = #partner_id#
		</cfquery>
		<cfif not control.recordcount>
			<cfquery name="ADD_TARGET_PEOPLE" datasource="#DSN3#">
				INSERT INTO 
					CAMPAIGN_TARGET_PEOPLE
				(
					CAMP_ID,
					TMARKET_ID,
					PAR_ID,
					RECORD_EMP,
					RECORD_DATE
				)
				VALUES
				(
					#attributes.camp_id#,
					#attributes.tmarket_id#,
					#partner_id#,
					#session.ep.userid#,
					#now()#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">

	window.location.href = '<cfoutput>#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.camp_id#</cfoutput>';
</script>
