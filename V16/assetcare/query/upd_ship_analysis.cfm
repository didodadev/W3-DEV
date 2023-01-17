<!--- <cfdump var='#attributes.ship_id#' abort> --->
<cfquery name="GET_SHIP" datasource="#dsn#">
	SELECT
		* 
	FROM
		ASSET_P_SHIP_ANALYSIS 
	WHERE
		SHIP_ID <> #attributes.ship_id# AND
		SHIP_DATE = #CreateODBCDateTime('#attributes.months# - 01 - #attributes.years#')# AND
		BRANCH_ID = #attributes.branch_id# AND		
		SHIP_NUM = #attributes.ship_num#
</cfquery>
<cfif get_ship.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='755.Şubenin bu döneme ait kaydı var Dönemi kontrol ediniz'>!");
		self.close();
		<!--- history.back(); --->
	</script>
	<cfabort>
<cfelse>
	<cfquery name="UPD_SHIP_ANALYSIS" datasource="#dsn#">
		UPDATE 
			ASSET_P_SHIP_ANALYSIS
		SET
			SHIP_DATE = #CreateODBCDateTime('#attributes.months# - 01 - #attributes.years#')#,
			BRANCH_ID = #attributes.branch_id#,
			SHIP_NUM = #attributes.ship_num#,
			SHIP_AREA = '#attributes.ship_area#',
			DISTANCE = #attributes.distance#,
			TOUR_NUMBER = #attributes.tour_number#,
			STORE_QUANTITY = #attributes.store_quantity#,
			ENDORSEMENT = #attributes.endorsement#,
			CURRENCY = '#attributes.currency#',
			DAYS = #attributes.days#,
			SPECIAL_CODE = <cfif len(attributes.special_code)>'#attributes.special_code#'<cfelse>NULL</cfif>,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#
		WHERE
			SHIP_ID = #attributes.ship_id#
	</cfquery>
	<script type="text/javascript">
		wrk_opener_reload(); 
		self.close();
	</script>
</cfif>
