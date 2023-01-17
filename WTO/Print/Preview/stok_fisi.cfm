<cfset satir_sayisi=20>
<cfset satir_basla=1>
<cfset yazilan_satir=0>
<cfset genel_toplam = 0>
<cfquery name="GET_FIS_DET" datasource="#dsn2#">
	SELECT 
		STOCK_FIS.*,
		(SELECT STOCK_CODE FROM #dsn3_alias#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS STOCK_CODE,
		(SELECT BARCOD FROM #dsn3_alias#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS BARCOD,
		(SELECT PRODUCT_NAME FROM #dsn3_alias#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS PRODUCT_NAME,
		STOCK_FIS_ROW.*,
        CASE
			WHEN 
	    			STOCK_FIS.CONSUMER_ID IS NOT NULL 
			THEN
				(SELECT C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = STOCK_FIS.CONSUMER_ID) 
			WHEN
    				STOCK_FIS.PARTNER_ID IS NOT NULL
			THEN 
		    		(SELECT C.NICKNAME +' - '+CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME FROM #dsn_alias#.COMPANY_PARTNER CP,#dsn_alias#.COMPANY C WHERE CP.PARTNER_ID = STOCK_FIS.PARTNER_ID AND CP.COMPANY_ID=C.COMPANY_ID)
			WHEN 
    				STOCK_FIS.EMPLOYEE_ID IS NOT NULL 
			THEN
				(SELECT E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE E.EMPLOYEE_ID = STOCK_FIS.EMPLOYEE_ID) 
		END AS DELIVERED_TO 
	FROM 
		STOCK_FIS,
		STOCK_FIS_ROW
	WHERE 
		STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID
		AND STOCK_FIS.FIS_ID = #attributes.action_id#
	ORDER BY
		STOCK_FIS_ROW.STOCK_FIS_ROW_ID
</cfquery>
<cfset stock_id_list=''>
<cfoutput query="GET_FIS_DET">
	 <cfif not listfind(stock_id_list,get_fis_det.stock_id)>
		<cfset stock_id_list=listappend(stock_id_list,get_fis_det.stock_id)>
	 </cfif>
</cfoutput>
<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
<cfif GET_FIS_DET.recordcount>
	<cfset page=Ceiling((GET_FIS_DET.recordcount)/satir_sayisi)>
<cfelse>
	<cfset page=1>
</cfif>
<cfif get_fis_det.fis_type neq 110 and get_fis_det.fis_type neq 115>
	<cfif  not  len(get_fis_det.LOCATION_out)>
		<cfset attributes.department_id =get_fis_det.DEPARTMENT_out >
		<cfset attributes.department_out_id=get_fis_det.DEPARTMENT_out>
	<cfelse>
		<cfset attributes.loc_id =	get_fis_det.LOCATION_out >
		<cfset attributes.department_id = get_fis_det.DEPARTMENT_out  >
		<cfset attributes.department_out_id = get_fis_det.DEPARTMENT_out &  '-' & get_fis_det.LOCATION_out>
	</cfif>
	<cfif len(attributes.department_id) >
		<cfif  isDefined('attributes.loc_id')>
			<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
				SELECT  
					D.DEPARTMENT_HEAD,
					SL.COMMENT
				FROM 
					DEPARTMENT D,
					STOCKS_LOCATION SL
				WHERE 
					D.IS_STORE=1
					AND D.DEPARTMENT_ID =SL.DEPARTMENT_ID
					AND SL.LOCATION_ID=#attributes.loc_id#  
					AND SL.DEPARTMENT_ID=#attributes.department_id#
			</cfquery>
		<cfelse>
			<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
				SELECT  
					D.DEPARTMENT_HEAD,
					'' AS COMMENT
				FROM 
					DEPARTMENT D
				WHERE 
					D.IS_STORE=1
					AND D.DEPARTMENT_ID = #attributes.department_id#
			</cfquery>
		</cfif>
	<cfset attributes.DEPARTMENT_OUT_NAME=GET_STORE_LOCATION.DEPARTMENT_HEAD & " " & GET_STORE_LOCATION.COMMENT >
	</cfif>
</cfif>
<cfif not isDefined("attributes.department_out_id") or NOT  len(attributes.department_out_id)>
	<cfset attributes.DEPARTMENT_OUT_NAME="">
	<cfset attributes.department_out_id="">
</cfif>
<cfif get_fis_det.fis_type neq 111 and get_fis_det.fis_type neq 112>
	<cfif  not  len(get_fis_det.LOCATION_IN) >
		<cfset attributes.department_id =get_fis_det.department_in >
		<cfset attributes.department_in_id=get_fis_det.department_in>
	<cfelse>
		<cfset attributes.loc_id = get_fis_det.LOCATION_in >
		<cfset attributes.department_id = get_fis_det.department_in >
		<cfset attributes.department_in_id = get_fis_det.department_in &  '-' & get_fis_det.LOCATION_in>
	</cfif>
	<cfif len(attributes.department_in_id) >
		<cfif  isDefined('attributes.loc_id')>
			<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
				SELECT  
					D.DEPARTMENT_HEAD,
					SL.COMMENT
				FROM 
					DEPARTMENT D,
					STOCKS_LOCATION SL
				WHERE 
					D.IS_STORE=1
					AND D.DEPARTMENT_ID =SL.DEPARTMENT_ID
					AND SL.LOCATION_ID=#attributes.loc_id#  
					AND SL.DEPARTMENT_ID=#attributes.department_id#
			</cfquery>
		<cfelse>
			<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
				SELECT  
					D.DEPARTMENT_HEAD,
					'' AS COMMENT
				FROM 
					DEPARTMENT D
				WHERE 
					D.IS_STORE=1
					AND D.DEPARTMENT_ID = #attributes.department_id#
			</cfquery>
		</cfif>
	<cfset txt_department_in=GET_STORE_LOCATION.DEPARTMENT_HEAD & " " & GET_STORE_LOCATION.COMMENT>
	</cfif>
</cfif>
<cfif not isDefined("attributes.department_in_id") or NOT  len(attributes.department_in_id)>
<cfset attributes.department_in_id="">
<cfset txt_department_in="">
</cfif>

<cfloop from="1" to="#page#" index="i">
	<cf_woc_header>
		<cf_woc_elements>
			<cf_wuxi id="dep_out" data="#attributes.DEPARTMENT_OUT_NAME#" label="29428" type="cell">
			<cf_wuxi id="deli_to" data="#get_fis_det.delivered_to[1]#" label="57775" type="cell">
			<cf_wuxi id="fis_num" data="#get_fis_det.fis_number#" label="57946" type="cell">
			<cf_wuxi id="dep_in" data="#txt_department_in#" label="56969" type="cell">
			<cfif len(get_fis_det.record_date)>
				<cf_wuxi id="fis_date" data="#dateformat(get_fis_det.record_date,dateformat_style)#" label="47445" type="cell"></cfif>
			<cfif len(get_fis_det.PROD_ORDER_NUMBER)>
				<cf_wuxi id="order_num" data="#get_fis_det.PROD_ORDER_NUMBER#" label="29474" type="cell"></cfif>
		</cf_woc_elements>
		<cf_woc_elements>
			<cf_woc_list id="Prods">
				<thead>
					<tr>
						<cf_wuxi label="57633" type="cell" is_row="0" id="wuxi_57633"> 
						<cf_wuxi label="57518" type="cell" is_row="0" id="wuxi_57518"> 
						<cf_wuxi label="58221" type="cell" is_row="0" id="wuxi_58221"> 
						<cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
						<cf_wuxi label="57636" type="cell" is_row="0" id="wuxi_57636"> 
						<cf_wuxi label="57638" type="cell" is_row="0" id="wuxi_57638"> 
						<cf_wuxi label="57673" type="cell" is_row="0" id="wuxi_57673"> 
					</tr>
				</thead>
				<tbody>
					<cfoutput query="GET_FIS_DET" startrow="#satir_basla#" maxrows="#satir_sayisi#">
					<cfset yazilan_satir=yazilan_satir+1>
					<tr>
						<cf_wuxi data="#barcod#" type="cell" is_row="0">
						<cf_wuxi data="#stock_code#" type="cell" is_row="0">
						<cf_wuxi data="#product_name#" type="cell" is_row="0">
						<cf_wuxi data="#amount#" type="cell" is_row="0">         
						<cf_wuxi data="#unit#" type="cell" is_row="0">
						<cf_wuxi data="#tlformat(price)#" type="cell" is_row="0">
						<cf_wuxi data="#tlformat(total)#" type="cell" is_row="0">
					</tr>
					<cfset genel_toplam = genel_toplam + total>
				</cfoutput>
				</tbody>
			</cf_woc_list> 
		</cf_woc_elements>	
		<cf_woc_elements>
			<cfset mynumber = genel_toplam>
			<cfif session.ep.period_year eq 2004>
				<cf_n2txt number="mynumber" para_birimi="TL"> 
			<cfelse>
				<cf_n2txt number="mynumber"> 
			</cfif>
			<cf_wuxi id="only" data="#mynumber#" label="30017" type="cell" style="text-align: right">
			<cf_wuxi id="gra_tot" data="#TLFormat(genel_toplam)#" label="57680" type="cell">
		</cf_woc_elements>
	<cf_woc_footer>
	<cfset satir_basla=satir_sayisi+satir_basla>
</cfloop>