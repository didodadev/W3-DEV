<!---  action_date pay_method amount detail  --->
<cf_date  tarih="attributes.action_date">
<cflock name="#createUUID()#" timeout="60">
<cftransaction>
		<cfif isdefined('attributes.upd_id')>
			<cfquery name="UPD_PM" datasource="#DSN#">
					UPDATE
						PAYMENT_ORDERS
					SET
						 PAY_REQUEST_ID=#attributes.ID#
						,VALID_EMP= #SESSION.EP.USERID# 
						,PAYMENT_DATE=#attributes.action_date#                                          
						,DETAIL ='#attributes.detail#'
						,PAYMENT_VALUE=#attributes.amount#
						,UPDATE_EMP=#SESSION.EP.USERID#
						,UPDATE_DATE=#NOW()#
						 UPDATE_IP='#CGI.REMOTE_ADDR#'
					WHERE
						RESULT_ID=#attributes.result_id#					
			</cfquery>
		<cfelse>
			<cfquery name="ADD_PM" datasource="#DSN#">
					INSERT 
						INTO 
							PAYMENT_ORDERS
						(
							PAY_REQUEST_ID 
							,VALID_EMP  
							,VALID_DATE                                             
							,PAYMENT_DATE                                           
							,DETAIL  
							,PAYMENT_VALUE  
							,RECORD_EMP
							,RECORD_DATE
							 ,RECORD_IP                                                                                           
						)
						VALUES
						(
							#attributes.ID#,
							#SESSION.EP.USERID#,
							#NOW()#,
							#attributes.action_date#,
							'#attributes.detail#',
							#attributes.amount#,
							#SESSION.EP.USERID#,
							#NOW()#,
							'#CGI.REMOTE_ADDR#'
						)
			</cfquery>
		</cfif>
		</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();		
</script>

