<cfquery name="GET_NOTE" datasource="#dsn#">
	SELECT
		*
	FROM
		NOTES
	WHERE
	<cfif isDefined("attributes.c_id")><!--- üye notlar --->
		ACTION_SECTION = 'COMPANY_ID' AND 
		ACTION_ID = #attributes.c_id# AND
	<cfelseif isDefined("attributes.subs_id")><!--- sistem notlar --->
		ACTION_SECTION = 'SUBSCRIPTION_ID' AND 
		ACTION_ID = #attributes.subs_id# AND
	<cfelseif isDefined("attributes.cheque_id")><!--- çek notlar --->
		ACTION_SECTION = 'CHEQUE_ID' AND 
		ACTION_ID = #attributes.cheque_id# AND
	<cfelseif isDefined("attributes.voucher_id")><!--- senet notlar --->
		ACTION_SECTION = 'VOUCHER_ID' AND 
		ACTION_ID = #attributes.voucher_id# AND
	<cfelseif isDefined("attributes.stock_id")><!--- ürün ağacı notlar --->
		ACTION_SECTION = 'PRODUCT_TREE' AND 
		ACTION_ID = #attributes.stock_id# AND
	<cfelseif isDefined("attributes.emp_id")><!--- ürün ağacı notlar --->
		ACTION_SECTION = 'EMPLOYEE_ID' AND 
		ACTION_ID = #attributes.emp_id# AND
	<cfelseif isDefined("attributes.cons_id")><!--- bireysel notlar --->
		ACTION_SECTION = 'CONSUMER_ID' AND 
		ACTION_ID = #attributes.cons_id# AND
	</cfif>
		IS_WARNING = 1
	ORDER BY 
		ACTION_ID DESC
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
	<cf_box title="#getLang('','Uyarı',57425)#" scroll="1" settings="0" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12 tour_box_masonry">
				<div style="background-color:#cbf0f8;" class="tour_box tour_box-type2">
					<cfif GET_NOTE.recordcount>
						<div class="tour_box_text">
							<p>
								<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="1" height="1">
									<param name="movie" value="/images/new_message.swf">
									<param name="quality" value="high">
									<embed src="/images/new_message.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="1" height="1"></embed>
								</object>
							</p>
							<cfoutput query="GET_NOTE">
								<div style="text-align:center;">
									<p>#NOTE_HEAD#</p>
									<p>#NOTE_BODY#</p>
								</div>
							</cfoutput>
						</div>
					</cfif>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="GET_NOTE">
		</cf_box_footer>
	</cf_box>
