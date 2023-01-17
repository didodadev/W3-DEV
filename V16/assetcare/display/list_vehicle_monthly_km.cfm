<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfparam name="attributes.fuel_month" default="">
<cfparam name="attributes.fuel_year" default="">
<cfparam name="attributes.depot" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.assetp" default="">
<cfset km_tarih = now()>
<cfif len(attributes.fuel_month) and len(attributes.fuel_year)>
  <cfset km_tarih = createodbcdatetime('#attributes.fuel_year#-#attributes.fuel_month#-01')>
  <cfset km_tarih = date_add('m', 1, km_tarih)>
</cfif>
  <cfquery name="get_km" datasource="#dsn#" maxrows="12">
	SELECT
		SUM(KM_FINISH - KM_START) AS KM,
		<cfif database_type is 'MSSQL'>
		DATEPART(yy,ASSET_P_KM_CONTROL.FINISH_DATE) AS YIL,
		DATEPART(mm,ASSET_P_KM_CONTROL.FINISH_DATE) AS AY_ID
		<cfelseif database_type is 'DB2'>
		YEAR(ASSET_P_KM_CONTROL.FINISH_DATE) AS YIL,
		MONTH(ASSET_P_KM_CONTROL.FINISH_DATE) AS AY_ID
		</cfif>
	FROM
		ASSET_P_KM_CONTROL
		<cfif len(attributes.department) or len(attributes.depot)>,DEPARTMENT</cfif>
		<cfif len(attributes.depot)>,BRANCH</cfif>
		<cfif len(attributes.assetp)>,ASSET_P</cfif>
	WHERE 
		FINISH_DATE <  #km_tarih#
		<cfif len(attributes.department)>
		AND ASSET_P_KM_CONTROL.DEPARTMENT_ID = #attributes.department_id#
		</cfif>
		<cfif len(attributes.depot)>
		AND BRANCH.BRANCH_ID = #attributes.depot_id#
		AND DEPARTMENT.BRANCH_ID  = BRANCH.BRANCH_ID
		</cfif>
		<cfif len(attributes.depot) or len(attributes.department)>
		AND ASSET_P_KM_CONTROL.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		</cfif>
		<cfif len(attributes.assetp)>
		AND ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#
		AND ASSET_P_KM_CONTROL.ASSETP_ID = ASSET_P.ASSETP_ID
		</cfif> 
	GROUP BY
		<cfif database_type is 'MSSQL'>
		DATEPART(yy,FINISH_DATE),
		DATEPART(mm,FINISH_DATE)
		<cfelseif database_type is 'DB2'>
		YEAR(FINISH_DATE),
		MONTH(FINISH_DATE)
		</cfif>
	ORDER BY
		YIL DESC,
		AY_ID DESC
</cfquery>
<cfset sutun = get_km.recordCount>
<cfif len(attributes.department) or len(attributes.depot)>
	<cfset sutun = sutun + 1>
</cfif>
<cfif len(attributes.assetp)>
	<cfset sutun = sutun + 1>
</cfif>
<cf_grid_list>
	<thead>
		<tr>
			<cfif len(attributes.department) or len(attributes.depot)>
				<cfquery name="get_dep_branch" datasource="#DSN#">
					SELECT 
						BRANCH.BRANCH_NAME,
						DEPARTMENT.DEPARTMENT_HEAD
					FROM
						DEPARTMENT,
						BRANCH,
						ASSET_P_KM_CONTROL
					WHERE
						DEPARTMENT.DEPARTMENT_ID IS NOT NULL 
						<cfif len(attributes.department)>
						AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id# 
						AND DEPARTMENT.DEPARTMENT_ID = ASSET_P_KM_CONTROL.DEPARTMENT_ID
						</cfif>
						<cfif len(attributes.depot)>
						AND BRANCH.BRANCH_ID = #attributes.depot_id#
						</cfif>
				</cfquery>
				<th width="100"><cf_get_lang_main no='2234.Lokasyon'></th>
			</cfif>
			<cfif len(attributes.assetp)>
				<cfquery name="get_assetp" datasource="#DSN#">
					SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#
				</cfquery>
				<th width="100"><cf_get_lang_main no='1656.Plaka'></th>
			</cfif>
			<cfif get_km.recordcount>
				<cfoutput query="get_km">
					<th width="100">#listGetAt(aylar,ay_id)# #yil#</th>
				</cfoutput>
			</cfif>
		</tr>
	</thead>
    <tbody>
		<tr>
			<cfif len(attributes.department) or len(attributes.depot)>
				<td width="100">
					<cfif len(attributes.depot)>
						<cfoutput>#get_dep_branch.branch_name#</cfoutput>
					</cfif>
					<cfif len(attributes.department)>
						<cfoutput><cfif len(attributes.depot)>-</cfif>#get_dep_branch.department_head#</cfoutput>
					</cfif>
				</td>
			</cfif>
			<cfif len(attributes.assetp)>
				<td width="100"><cfoutput>#get_assetp.assetp#</cfoutput></td>
			</cfif>
			<cfif get_km.recordcount>
				<cfoutput query="get_km">
					<td style="text-align:right" >#tlformat(km,0)#</td>
				</cfoutput>
			</cfif>
		</tr>
    </tbody>
</cf_grid_list>



