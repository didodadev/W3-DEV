<!---is istasyonu iliskili fiziki varlık ekleme --->
<cfif attributes.type eq 0>
	<cfquery name="add_assetp_relation" datasource="#dsn#">
		INSERT INTO	
			RELATION_PHYSICAL_ASSET_STATION 
		(
			STATION_ID,
			PHYSICAL_ASSET_ID
		)
		VALUES
		(
			#attributes.station_id#,
			#asset_id#
		) 
	</cfquery>
<cfelseif attributes.type eq 1>
	<cfquery name="add_assetp_relation_prod_result" datasource="#dsn#">
		INSERT INTO	
			ASSET_P_RESERVE 
		(
			PROD_RESULT_ID,
			ASSETP_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
            OUR_COMPANY_ID
		)
		VALUES
		(
			#attributes.station_id#,
			#asset_id#,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#',
            #session.ep.company_id#
		) 
	</cfquery>
<cfelseif attributes.type eq 2><!--- Anlaşmalar modülü sözleşme ile bağlantı Gramoni-Mahmut 19.11.2019 20:55--->
	<cfquery name="get_related_asset" datasource="#dsn#">
		SELECT CONTRACT_ID FROM RELATION_PHYSICAL_ASSET_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id# AND ASSETP_ID = #asset_id# AND OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cfif Not get_related_asset.recordCount>
		<cfquery datasource="#dsn#">
			INSERT INTO
				RELATION_PHYSICAL_ASSET_CONTRACT
			(
				CONTRACT_ID,
				ASSETP_ID,
				OUR_COMPANY_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.contract_id#,
				#asset_id#,
				#session.ep.company_id#,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cfif>
</cfif>
<script type="text/javascript">
	window.close();
</script>