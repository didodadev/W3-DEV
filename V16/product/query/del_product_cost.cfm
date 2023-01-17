<!--- bu maliyete daha once bir fiyat koruma yapilmis mi --->
<cfquery name="GET_COMPARISON" datasource="#dsn2#">
	SELECT
		CONTRACT_COMPARISON_ROW_ID,
		COMPANY_ID,
		DIFF_INVOICE_ID
	FROM
		INVOICE_CONTRACT_COMPARISON
	WHERE
		COST_ID=#attributes.cost_id#
</cfquery>
<cfif GET_COMPARISON.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no ='893.Fiyat Koruma Girilmiş Maliyeti Silemezsiniz! Öncelikle Fiyat Korumalarını Siliniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>

<!--- bir sonraki maliyet alınıyorki ordan güncelleme yapılacak --->
<cfquery name="GET_LAST_COST" datasource="#dsn1#" maxrows="1">
	SELECT 
		* 
	FROM 
		PRODUCT_COST 
	WHERE 
		START_DATE <=(SELECT START_DATE FROM PRODUCT_COST WHERE PRODUCT_COST_ID=#attributes.cost_id#) AND
		PRODUCT_ID = #attributes.product_id#
		<cfif len(attributes.spec_main_id)>
			AND SPECT_MAIN_ID =#attributes.spec_main_id#
		</cfif>
	ORDER BY
	START_DATE ,RECORD_DATE , PRODUCT_COST_ID
</cfquery>
<cfquery name="UPD_COST" datasource="#dsn1#">
	DELETE FROM PRODUCT_COST WHERE PRODUCT_COST_ID = #attributes.cost_id#
</cfquery>

<cfif GET_LAST_COST.RECORDCOUNT>
	<!--- FONKSİON İÇİND KULLAILIYOR --->
	<cfquery name="GET_NOT_DEP_COST" datasource="#DSN#">
		SELECT 
			DEPARTMENT_ID,LOCATION_ID 
		FROM 
			STOCKS_LOCATION STOCKS_LOCATION
		WHERE 
			ISNULL(IS_COST_ACTION,0)=1
	</cfquery>
	<cfquery name="GET_COMPS_PER" datasource="#DSN#">
		SELECT 
			SP2.PERIOD_ID,
			SP2.PERIOD_YEAR,
			SP2.OUR_COMPANY_ID
		FROM 
			SETUP_PERIOD SP,
			SETUP_PERIOD SP2
		WHERE 
			SP.PERIOD_ID=#session.ep.period_id#
			AND SP.OUR_COMPANY_ID=SP2.OUR_COMPANY_ID
	</cfquery>
	<cfif GET_COMPS_PER.RECORDCOUNT>
		<cfset comp_period_list=ValueList(GET_COMPS_PER.PERIOD_ID)><!--- sirket bazli maliyet oldugu icin sirkete ait priodlar bir listeye aliniyor ve o periodlardaki maliyetlerde islemler yapiliyor --->
		<cfset comp_period_year_list=ValueList(GET_COMPS_PER.PERIOD_YEAR)><!--- sirket bazli maliyet oldugu icin sirkete ait priodlar bir listeye aliniyor ve o periodlardaki maliyetlerde islemler yapiliyor --->
	</cfif>
	<cfif not isdefined('comp_period_list') or not len(comp_period_list)><!--- bu ihtimal yok ama yinede olsun --->
		<cfset comp_period_list=session.ep.period_id>
		<cfset comp_period_year_list=year(now())>
	</cfif>
	<cfif len(attributes.spec_main_id)>
		<cfset newer_spec_id=attributes.spec_main_id>
	<cfelse>
		<cfset newer_spec_id=''>
	</cfif>
	<cfscript>
	form.dsn1=dsn1;
	upd_newer_cost(
						newer_action_id=0,
						newer_action_row_id=0,
						newer_product_cost_id=attributes.cost_id,
						newer_spec_main_id=newer_spec_id,
						newer_product_id=attributes.product_id,
						newer_action_date=CreateODBCDateTime(GET_LAST_COST.START_DATE),
						newer_record_date=CreateODBCDateTime(GET_LAST_COST.RECORD_DATE),
						newer_comp_period_list='#comp_period_list#',
						newer_comp_period_year_list='#comp_period_year_list#',
						newer_dsn=dsn,
						newer_dsn3=dsn3,
						newer_period_dsn_type=dsn2,
						newer_our_company_id=GET_COMPS_PER.OUR_COMPANY_ID
					);
	</cfscript>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
