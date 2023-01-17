<!--- Saat başı çalışan bir schedule dır, 
eğer ileri tarihli ve saatli bir kayıt girilmişse onu setup_money e update eder... Ayşenur20060721 --->
<!--- 2007 BK kapatti gerektiginde mail gonderimi icin acilabilir.
 --->

<cfquery name="get_periods" datasource="#dsn#">
	SELECT PERIOD_ID, OUR_COMPANY_ID FROM SETUP_PERIOD
</cfquery>
<cfloop query="get_periods">
	<cfquery name="GET_CURRENCY_INFO" datasource="#dsn#">
		SELECT 
			* 
		FROM
			MONEY_HISTORY
		WHERE
			MONEY_HISTORY_ID IN
				(
					SELECT 
						MAX(MONEY_HISTORY_ID)
					FROM
						MONEY_HISTORY
					WHERE
						COMPANY_ID = #get_periods.OUR_COMPANY_ID# AND
						PERIOD_ID = #get_periods.PERIOD_ID# AND
						VALIDATE_DATE = #CreateODBCDateTime('#year(now())#-#month(now())#-#day(now())#')# AND
						VALIDATE_S_HOUR = '#TimeFormat(now(),"HH")#'
					GROUP BY 
						MONEY
				)
	</cfquery>
	<cfif get_currency_info.recordcount>
		<cfoutput query="GET_CURRENCY_INFO">
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfquery name="UPD_CURRENCY_INFO" datasource="#dsn#">
						UPDATE
							SETUP_MONEY
						SET
							RATE1 = #GET_CURRENCY_INFO.RATE1#,
							RATE2 = #GET_CURRENCY_INFO.RATE2#,
							RATE3 = #GET_CURRENCY_INFO.RATE3#,
							RATEPP2 = #GET_CURRENCY_INFO.RATEPP2#,
							RATEPP3 = #GET_CURRENCY_INFO.RATEPP3#,
							RATEWW2 = #GET_CURRENCY_INFO.RATEWW2#,
							RATEWW3 = #GET_CURRENCY_INFO.RATEWW3#,
							UPDATE_DATE = #now()#,
							UPDATE_EMP = #GET_CURRENCY_INFO.RECORD_EMP#,
							UPDATE_IP = '#GET_CURRENCY_INFO.RECORD_IP#'
						WHERE
							COMPANY_ID = #GET_CURRENCY_INFO.COMPANY_ID# AND
							PERIOD_ID = #GET_CURRENCY_INFO.PERIOD_ID# AND
							MONEY = '#GET_CURRENCY_INFO.MONEY#'
					</cfquery>
				</cftransaction>
			</cflock>
			<!--- Mail blogu BK 20060703 Zamani gelince kapat --->
			<cfsavecontent variable="insert_error_message">
				<html>
				<style type="text/css">
					.form-title {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; }
					.form-title1 {font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;font-weight: bold;	}
				</style>
				<body>
					UPDATE
						SETUP_MONEY
					SET
						RATE1 = #GET_CURRENCY_INFO.RATE1#,
						RATE2 = #GET_CURRENCY_INFO.RATE2#,
						RATE3 = #GET_CURRENCY_INFO.RATE3#,
						RATEPP2 = #GET_CURRENCY_INFO.RATEPP2#,
						RATEPP3 = #GET_CURRENCY_INFO.RATEPP3#,
						RATEWW2 = #GET_CURRENCY_INFO.RATEWW2#,
						RATEWW3 = #GET_CURRENCY_INFO.RATEWW3#,
						UPDATE_DATE = #now()#,
						UPDATE_EMP = #GET_CURRENCY_INFO.RECORD_EMP#,
						UPDATE_IP = '#GET_CURRENCY_INFO.RECORD_IP#'
					WHERE
						COMPANY_ID = #GET_CURRENCY_INFO.COMPANY_ID# AND
						PERIOD_ID = #GET_CURRENCY_INFO.PERIOD_ID# AND
						MONEY = '#GET_CURRENCY_INFO.MONEY#'
					<br/>
				</body>
				</html>
			</cfsavecontent>
		</cfoutput>
	</cfif>
</cfloop>
