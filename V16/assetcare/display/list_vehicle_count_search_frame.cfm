<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.depot" default="">
<cfparam name="attributes.vehicle_type" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.model" default="">
<cfquery name="GET_VEHICLES" datasource="#DSN#">
	SELECT 
		COUNT(ASSET_P.ASSETP) AS SAYI,
		ASSET_P.MAKE_YEAR,
		ASSET_P_CAT.ASSETP_CAT,
		BRANCH.BRANCH_NAME,
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_ID
	FROM
		ASSET_P,
		ASSET_P_CAT,
		BRANCH,
		SETUP_BRAND,
		SETUP_BRAND_TYPE,
		DEPARTMENT
	WHERE 
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
		AND ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND ASSET_P_CAT.MOTORIZED_VEHICLE = 1
		<!--- Sadece yetkili olunan şubeler gözüksün. Onur P. --->
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		AND ASSET_P.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID
		AND SETUP_BRAND.BRAND_ID = SETUP_BRAND_TYPE.BRAND_ID
		<cfif isdefined("attributes.depot_id") and len(attributes.depot_id) and len(attributes.depot)>AND BRANCH.BRANCH_ID = #attributes.depot_id#</cfif>
		<cfif len(attributes.vehicle_type)>AND ASSET_P.ASSETP_CATID = #attributes.vehicle_type#</cfif>
		<cfif len(attributes.brand_name)>AND ASSET_P.BRAND_TYPE_ID = #attributes.brand_type_id#</cfif>
		<cfif len(attributes.model)>AND ASSET_P.MAKE_YEAR = #attributes.model#</cfif>
	GROUP BY
		ASSET_P.MAKE_YEAR,
		ASSET_P_CAT.ASSETP_CAT,
		BRANCH.BRANCH_NAME,
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_ID
</cfquery>
<cfset toplam=0>
<cfoutput query="get_vehicles">
	<cfset toplam = toplam + sayi>
</cfoutput>

<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='48271.Araç Sayısı'></th>
			<th><cf_get_lang dictionary_id='57453.Şube'></th>
			<th><cf_get_lang dictionary_id='47973.Araç Tipi'></th>
			<th><cf_get_lang dictionary_id='58847.Marka'> - <cf_get_lang dictionary_id='30041.Marka Tipi'></th>
			<th><cf_get_lang dictionary_id='58225.Model'></th>
		</tr>
	</thead>	
	<tbody>
		<cfif attributes.is_submitted eq 1>
			<cfif get_vehicles.recordcount>
				<cfoutput query="get_vehicles">
					<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" height="20">
						<td>#sayi#</td>	
						<td>#branch_name#</td>
						<td>#assetp_cat#</td>
						<td>#brand_name# - #brand_type_name#</td>
						<td>#make_year#</td>			
					</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row">
					<td colspan="11" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		<cfelse>
			<tr class="color-row">
				<td colspan="11" height="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>

