<cfif len(attributes.sales_zone_id)>
	<cfquery name="get_all_quotes" datasource="#dsn#">
		SELECT
			SALES_QUOTE_ID
		FROM
			SALES_QUOTES_GROUP
		WHERE
			QUOTE_TYPE = 1 
			AND SALES_ZONE_ID IN (#attributes.sales_zone_id#)
		ORDER BY
			SALES_ZONE_ID
	</cfquery>
	
<cfloop list="#attributes.sz_ids#" index="m">
	<cfif len(get_all_quotes.SALES_QUOTE_ID[listfind(attributes.sales_zone_id,listfirst(m,"."),",")])>
		<cfset quote_id = get_all_quotes..SALES_QUOTE_ID[listfind(attributes.sales_zone_id,listfirst(m,"."),",")]>
			<cfquery name="upd_quotes" datasource="#dsn#">
				UPDATE SALES_QUOTES_GROUP SET 
					QUOTE_YEAR = #attributes.QUOTE_YEAR#,
					QUOTE_TYPE = 1,
					QUOTE_MONEY = '#attributes.MONEY#',
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#'
				WHERE
					SALES_QUOTE_ID = #quote_id#
			</cfquery>
			
			<cfquery name="del_quotes" datasource="#dsn#">
				DELETE FROM SALES_QUOTES_GROUP_ROWS WHERE SALES_QUOTE_ID = #quote_id#
			</cfquery>
				
			<cfloop from="1" to="12" index="i">
				<cfquery name="ADD_SALES_QUOTES_ROW" datasource="#dsn#">
					INSERT INTO
						SALES_QUOTES_GROUP_ROWS
						(
							SALES_QUOTE_ID,
							BRANCH_ID,
							QUOTE_MONTH,
							SALES_INCOME,
							ROW_MONEY
						)
						VALUES
						(
							#quote_id#,
							#listlast(m,".")#,
							#i#,
							#evaluate("attributes.team_#listfirst(m,".")#_#i#")#,
							'#attributes.money#'
						)
				</cfquery>
			</cfloop>
	<cfelse>
		<cfquery name="ADD_QUOTE" datasource="#dsn#" result="MAX_ID">
			INSERT INTO SALES_QUOTES_GROUP
				(
					SALES_ZONE_ID,
					QUOTE_YEAR,
					QUOTE_TYPE,
					QUOTE_MONEY,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					#listfirst(m,".")#,
					#attributes.QUOTE_YEAR#,
					1,
					'#attributes.MONEY#',
					#now()#,
					#session.ep.userid#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfloop from="1" to="12" index="i">
			<cfquery name="ADD_ROWS" datasource="#dsn#">
				INSERT INTO
					SALES_QUOTES_GROUP_ROWS
					(
						SALES_QUOTE_ID,
						BRANCH_ID,
						QUOTE_MONTH,						
						SALES_INCOME,
						ROW_MONEY
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#listlast(m,".")#,
						#i#,
						#evaluate("attributes.team_#listfirst(m,".")#_#i#")#,
						'#attributes.money#'
					)
			</cfquery>
		</cfloop>
	</cfif>
  </cfloop>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
