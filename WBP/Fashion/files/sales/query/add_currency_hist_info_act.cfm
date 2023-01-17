<cf_date tarih='attributes.record_date'>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_MONEY" datasource="#dsn#" result="Max_id">
			INSERT INTO 
				TEXTILE_MONEY_HISTORY
				(
					MONEY,
					RATE1,
					RATE2,
					RATE3,
					RATEPP2,
					RATEPP3,
					RATEWW2,
					RATEWW3,
					EFFECTIVE_PUR,
					EFFECTIVE_SALE,
					VALIDATE_DATE,
					VALIDATE_HOUR,
					VALIDATE_S_HOUR,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					PERIOD_ID,
					COMPANY_ID
				) 
			VALUES 
				(
					'#attributes.money#',
					#attributes.rate1#,
					#attributes.amount#,
					#attributes.amount2#,
					#attributes.amountpp#,
					#attributes.amountpp2#,
					#attributes.amountww#,
					#attributes.amountww2#,
					#attributes.amount3#,
					#attributes.amount4#,
					#attributes.record_date#,
					'#event_start_clock#',
					'#TimeFormat(date_add('h',-session.ep.time_zone,"#event_start_clock#:00:00"),"HH")#',
					#now()#,
					#session.ep.userid#,
					'#CGI.REMOTE_ADDR#',
					#session.ep.period_id#,
					#session.ep.company_id#
				)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
