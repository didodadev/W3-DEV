<!---  #CreateodbcDateTime(CreateDate(attributes.years,attributes.months,1))#,  --->
<cfquery name="get_date_branch" datasource="#dsn#">
	SELECT
		SHIP_ID 
	FROM
		ASSET_P_SHIP_ANALYSIS 
	WHERE
		SHIP_DATE = #CreateODBCDateTime('#attributes.months# - 01 - #attributes.years#')# AND
		BRANCH_ID = #attributes.branch_id# AND
		SHIP_NUM =#attributes.ship_num#
</cfquery>
<cfif get_date_branch.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='755.Şubenin bu döneme ait kaydı var Dönemi kontrol ediniz'> !");
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_ship_analysis';
	</script>
	<cfabort>
<cfelse>
<cfquery name="ADD_SHIP_ANALYSIS" datasource="#DSN#">
	INSERT INTO
		ASSET_P_SHIP_ANALYSIS
	(
		SHIP_DATE,
		BRANCH_ID,
		SHIP_NUM,
		SHIP_AREA,
		DISTANCE,
		TOUR_NUMBER,
		ENDORSEMENT,
		CURRENCY,
		STORE_QUANTITY,
		DAYS,
		SPECIAL_CODE,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(
		#CreateODBCDateTime('#attributes.months# - 01 - #attributes.years#')#,
		#attributes.branch_id#,
		#attributes.ship_num#,
		'#attributes.ship_area#',
		#attributes.distance#,
		#attributes.tour_number#, 
		#attributes.endorsement#,
		'#attributes.currency#',
		#attributes.store_quantity#,
		#attributes.days#,
		<cfif len(attributes.special_code)>'#attributes.special_code#'<cfelse>NULL</cfif>,
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<script type="text/javascript">
	self.close();
	wrk_opener_reload();
</script>
</cfif>
