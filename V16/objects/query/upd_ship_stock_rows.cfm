<cflock name="#CreateUUID()#" timeout="30">
	<cftransaction> 
		<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif isdefined("attributes.row_kontrol#i#") and isdefined("attributes.product_name#i#") and isdefined('attributes.stock_id#i#') and len(evaluate("attributes.stock_id#i#"))>
			<cfif isdefined("attributes.stock_row_id#i#")>
				<cfif evaluate("attributes.row_kontrol#i#") eq 2>
					<cfquery name="upd_stocks" datasource="#dsn2#">
						UPDATE STOCKS_ROW SET
							STOCK_ID=#evaluate("attributes.stock_id#i#")#,
							PRODUCT_ID=#evaluate("attributes.product_id#i#")#,
							<cfif evaluate("attributes.in_or_out#i#") eq 1>
							STOCK_IN=#evaluate("attributes.amount#i#")#
							<cfelse>
							STOCK_OUT=#evaluate("attributes.amount#i#")#
							</cfif>
						WHERE
							STOCKS_ROW_ID=#evaluate("attributes.stock_row_id#i#")#
					</cfquery>
					<cfif isdefined('attributes.old_stock_id#i#') and len(evaluate('attributes.old_stock_id#i#'))>
						<cfquery name="GET_SERI" datasource="#dsn2#">
							DELETE FROM 
								#dsn3_alias#.SERVICE_GUARANTY_NEW 
							WHERE 
								PROCESS_ID = #attributes.upd_id# AND 
								PROCESS_CAT = #attributes.process_cat_id# AND
								PERIOD_ID =  #session.ep.period_id# AND
								STOCK_ID=#evaluate("attributes.old_stock_id#i#")#
						</cfquery>
					</cfif>
				<cfelseif evaluate("attributes.row_kontrol#i#") eq 0>
					<cfquery name="upd_stocks" datasource="#dsn2#">
						DELETE FROM STOCKS_ROW WHERE STOCKS_ROW_ID=#evaluate("attributes.stock_row_id#i#")#
					</cfquery>
					<cfquery name="GET_SERI" datasource="#dsn2#">
						DELETE FROM 
							#dsn3_alias#.SERVICE_GUARANTY_NEW 
						WHERE 
							PROCESS_ID = #attributes.upd_id# AND 
							PROCESS_CAT = #attributes.process_cat_id# AND
							PERIOD_ID =  #session.ep.period_id# AND
							STOCK_ID=#evaluate("attributes.stock_id#i#")#
					</cfquery>
				</cfif>
			<cfelse>
				<cfif evaluate("attributes.row_kontrol#i#") eq 2>
					 <cfquery name="upd_stocks" datasource="#dsn2#">
						INSERT INTO STOCKS_ROW
							(
								STOCK_ID,
								PRODUCT_ID,
								STOCK_IN,
								STOCK_OUT,
								UPD_ID,
								PROCESS_TYPE,
								STORE,
								STORE_LOCATION,
								PROCESS_DATE
							
							)
							VALUES
							(
								#evaluate("attributes.stock_id#i#")#,
								#evaluate("attributes.product_id#i#")#,
							<cfif evaluate("attributes.in_or_out#i#") eq 1>
								#evaluate("attributes.amount#i#")#,
							<cfelse>
								0,
							</cfif>
							<cfif evaluate("attributes.in_or_out#i#") eq 1>
								0,
							<cfelse>
								#evaluate("attributes.amount#i#")#,
							</cfif>
							<cfif len(attributes.upd_id)>#attributes.upd_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.process_cat_id)>#attributes.process_cat_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.dep)>#attributes.dep#<cfelse>NULL</cfif>,
							<cfif len(attributes.location)>#attributes.location#<cfelse>NULL</cfif>,
							<cfif len(attributes.process_date)>#CreateODBCDate(attributes.process_date)#<cfelse>NULL</cfif>
						
							)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		</cfloop>
		<cfquery name="add_stock_row_upd" datasource="#dsn2#">
			INSERT INTO STOCKS_ROW_UPD
			(
				PROCESS_TYPE,
				ACTION_ID,
				UPDATE_EMP,
				UPDATE_DATE,
				UPDATE_IP
			)
			VALUES
			(
				#process_cat_id#,
				#attributes.upd_id#,
				#session.ep.userid#,
				#now()#,
				'#CGI.REMOTE_ADDR#'
			)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.close();
	location.href = document.referrer;

</script>
