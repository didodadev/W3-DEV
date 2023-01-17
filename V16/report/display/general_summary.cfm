<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfquery name="get_member_count" datasource="#dsn#">
	SELECT 
		SUM(MEMBER_COUNT) MEMBER_COUNT
	FROM
	(
		SELECT
			COUNT(C.COMPANY_ID) MEMBER_COUNT
		FROM
			COMPANY	C
		WHERE
			C.COMPANY_STATUS = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND C.RECORD_DATE <= #attributes.finishdate#
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND C.RECORD_DATE >= #attributes.startdate#
			</cfif>
		UNION ALL
		SELECT
			COUNT(C.CONSUMER_ID) MEMBER_COUNT
		FROM
			CONSUMER C
		WHERE
			C.CONSUMER_STATUS = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND C.RECORD_DATE <= #attributes.finishdate#
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND C.RECORD_DATE >= #attributes.startdate#
			</cfif>
	)T1	
</cfquery>
<cfquery name="get_help_count" datasource="#dsn#">
	SELECT 
		COUNT(CUS_HELP_ID) HELP_COUNT 
	FROM 
		CUSTOMER_HELP 
	WHERE 
		1 = 1
		<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND INTERACTION_DATE <= #attributes.finishdate#
		</cfif>
		<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND INTERACTION_DATE >= #attributes.startdate#
		</cfif>
</cfquery>
<cfquery name="get_event_plan" datasource="#dsn#">
	SELECT 
		COUNT(EVENT_PLAN_ID) EVENT_COUNT 
	FROM 
		EVENT_PLAN
	WHERE 
		1 = 1
		<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND MAIN_FINISH_DATE <= #attributes.finishdate#
		</cfif>
		<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND MAIN_START_DATE >= #attributes.startdate#
		</cfif>
</cfquery>
<cfquery name="get_opp_count" datasource="#dsn3#">
	SELECT 
		COUNT(OPP_ID) OPP_COUNT 
	FROM 
		OPPORTUNITIES 
	WHERE 
		OPP_STATUS = 1
		<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND OPP_DATE <= #attributes.finishdate#
		</cfif>
		<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND OPP_DATE >= #attributes.startdate#
		</cfif>
</cfquery>
<cfquery name="get_offer_count" datasource="#dsn3#">
	SELECT 
		COUNT(OFFER_ID) OFFER_COUNT 
	FROM 
		OFFER 
	WHERE 
		OFFER_STATUS = 1 
		AND ((OFFER.PURCHASE_SALES = 1 AND OFFER.OFFER_ZONE = 0) OR (OFFER.PURCHASE_SALES = 0 AND OFFER.OFFER_ZONE = 1))
		<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND OFFER_DATE <= #attributes.finishdate#
		</cfif>
		<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND OFFER_DATE >= #attributes.startdate#
		</cfif>
</cfquery>
<cfquery name="get_order_count" datasource="#dsn3#">
	SELECT 
		COUNT(ORDER_ID) ORDER_COUNT 
	FROM 
		ORDERS 
	WHERE 
		ORDER_STATUS = 1 
		AND ((ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0) OR (ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1))
		<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND ORDER_DATE <= #attributes.finishdate#
		</cfif>
		<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND ORDER_DATE >= #attributes.startdate#
		</cfif>
</cfquery>
<div class="row">
	<div class="col col-12 col-xs-12">
		<cfset item1="#getLang('main',45)#"><cfset value1="#get_member_count.member_count#">
		<cfset item2="#getLang('call',80)#"><cfset value2="#get_help_count.help_count#">
		<cfset item3="#getLang('myhome',1606)#"><cfset value3="#get_event_plan.event_count#">
		<cfset item4="#getLang('main',200)#"><cfset value4="#get_opp_count.opp_count#">
		<cfset item5="#getLang('main',133)#"><cfset value5="#get_offer_count.offer_count#">
		<cfset item6="#getLang('main',199)#"><cfset value6="#get_order_count.order_count#">
		<canvas id="myChart1" style="height:100%;"></canvas>
		<script>
			var ctx = document.getElementById('myChart1');
			var myChart1 = new Chart(ctx, {
				type: 'horizontalBar',
				data: {
						labels: [<cfoutput>"#item1#","#item2#","#item3#","#item4#","#item5#","#item6#"</cfoutput>],
						datasets: [{
						label: "<cfoutput>#getLang('main',2157)# #getLang('report',31)#</cfoutput>",
						backgroundColor: [<cfloop from="1" to="6" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
						data: [<cfoutput>"#value1#","#value2#","#value3#","#value4#","#value5#","#value6#"</cfoutput>],
							}]
						},
				options: {}
			});
		</script> 
	</div>
</div>

