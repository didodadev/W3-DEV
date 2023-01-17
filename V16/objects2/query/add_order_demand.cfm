<cfquery name="ADD_DEMAND" datasource="#DSN3#">
	INSERT INTO
		ORDER_DEMANDS
		(
			DEMAND_STATUS,
			CAMPAIGN_ID,
			STOCK_ID,
			PRICE,
			PRICE_KDV,
			PRICE_MONEY,
			DEMAND_TYPE,
			MEMBER_EMAIL,
			DEMAND_AMOUNT,
			DEMAND_UNIT_ID,
			DEMAND_NOTE,
			<!--- DOMAIN_NAME, --->
            MENU_ID,
			RECORD_CON,
			RECORD_PAR,
			RECORD_DATE,
			RECORD_IP,
            DEMAND_DATE				
		)
	VALUES
		(
			1,
			<cfif isdefined("attributes.campaign_id")>#attributes.campaign_id#<cfelse>NULL</cfif>,
			#attributes.stock_id#,
			<cfif attributes.demand_type neq 1>#attributes.price#<cfelse>NULL</cfif>,
			<cfif attributes.demand_type eq 2 and len(attributes.price_kdv)>#attributes.price_kdv#<cfelse>NULL</cfif>,
			<cfif attributes.demand_type neq 1>'#attributes.price_money#'<cfelse>NULL</cfif>,
			#attributes.demand_type#,
			<cfif attributes.demand_type eq 1 or attributes.demand_type eq 2>'#attributes.member_email#'<cfelse>NULL</cfif>,
			<cfif attributes.demand_type eq 2 or attributes.demand_type eq 3>#attributes.demand_amount#<cfelse>NULL</cfif>,
			<cfif attributes.demand_type eq 3>#attributes.demand_unit_id#<cfelse>NULL</cfif>,
			'#attributes.demand_note#',
			<!---'#cgi.http_host#',--->
            <cfif isDefined('session.pp.menu_id')>
            	#session.pp.menu_id#,
            <cfelseif isDefined('session.ww.menu_id')>
            	#session.ww.menu_id#,            
            </cfif>
			<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
			<cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
			#now()#,
			'#cgi.remote_addr#',
            #now()#
		)
</cfquery>
<script type="text/javascript">
	alert("<cf_get_lang no ='1434.Talebiniz alınmıştır! Teşekkürler'>");
	window.close();
</script>
