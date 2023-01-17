<cfif len(startdate)>
	<CF_DATE tarih="startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<CF_DATE tarih="attributes.finishdate">
</cfif>

<cfquery name="ADD_rival_prices" datasource="#dsn3#">
	INSERT INTO
		PRICE_RIVAL
		(
		R_ID,
		PRODUCT_ID,
		STARTDATE,
		<cfif len(attributes.finishdate)>
		FINISHDATE,
		</cfif>
		PRICE,
		MONEY,
		UNIT_ID, 
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
<!--- 		,STOCK_ID --->
		)
	VALUES
		(
		#R_ID#,
		#PID#,
		#STARTDATE#,
		<cfif len(attributes.finishdate)>
		#attributes.finishdate#,
		</cfif>
		#PRICE_#,
		'#MONEY#',
		#UNIT_ID#, 
		#now()#,
		#session.ep.userid#,
		'#cgi.REMOTE_ADDR#'
<!--- 		,#attributes.STOCK_ID# --->
		)
</cfquery>

<script type="text/javascript">
location.href = document.referrer;
window.close();	
</script>
