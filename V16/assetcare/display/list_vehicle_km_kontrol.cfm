<cfsetting showdebugoutput="no">
<cfparam name="attributes.usage_purpose_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="GET_KMS" datasource="#DSN#">
	SELECT 
		ASSET_P_KM_CONTROL.*, 
		ASSET_P.ASSETP,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		ASSET_P_KM_CONTROL,
		ASSET_P,
		BRANCH,
		DEPARTMENT,
		EMPLOYEES
	WHERE
		ASSET_P_KM_CONTROL.START_DATE IS NOT NULL AND
		<cfif database_type is 'MSSQL'>
			ISNULL(ASSET_P_KM_CONTROL.IS_COUNTER_CHANGE,0) <> 1 AND
		<cfelseif database_type is 'DB2'>
			COALESCE(ASSET_P_KM_CONTROL.IS_COUNTER_CHANGE,0) <> 1 AND
		</cfif>		
		ASSET_P_KM_CONTROL.ASSETP_ID = ASSET_P.ASSETP_ID AND
		ASSET_P_KM_CONTROL.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID	AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		ASSET_P_KM_CONTROL.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#
	ORDER BY 
		KM_CONTROL_ID DESC
</cfquery>
<cfquery name="GET_KM_CHANGE" datasource="#DSN#">
	SELECT SUM(KM_START-KM_FINISH) SUM_KM FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #attributes.assetp_id# AND IS_COUNTER_CHANGE = 1
</cfquery>
<cfquery name="GET_OTHERS" datasource="#DSN#">
	SELECT SUP_COMPANY_DATE,FIRST_KM FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#
</cfquery>
<cfquery name="GET_KM" datasource="#DSN#">
	SELECT KM_FINISH FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #attributes.assetp_id# ORDER BY KM_CONTROL_ID DESC
</cfquery>
<cfset liste_km = ValueList(get_km.km_finish)>
<cfif not len(get_others.first_km)>
	<cfset get_others.first_km = 0>
</cfif>
<cfif not len(get_km.km_finish)>
	<cfset get_km.km_finish = 0>
</cfif>
<cfset  pageHead="#getLang('assetcare',132)# : #getLang('main',1656)# : #get_assetp.assetp#">
<cf_catalystHeader>
<div id="km_kontrol_div">
	<cf_medium_list_search_area>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<cfoutput>
			<cfif get_km.km_finish neq 0>
				<td class="txtbold"><cf_get_lang_main no='215.Kayıt Tarihi'>:#dateFormat(get_others.sup_company_date,dateformat_style)#</td>
				<td class="txtbold"><cf_get_lang no='357.Onceki kilometre'>: #tlFormat(get_others.first_km,0)#</td>
				<td class="txtbold"><cf_get_lang no='219.Son KM'>: #tlFormat(get_km.km_finish,0)#</td>
			<cfif len(get_km_change.sum_km)>
				<td class="txtbold"><cf_get_lang no ='699.Sayaç Değişim Farkı'>: #tlFormat(get_km_change.sum_km,0)#</td>
			</cfif>
				
				<td class="txtbold"><cf_get_lang no='220.Yapılan KM'>: 
				<cfif (isNumeric(get_others.first_km) and isNumeric(get_km.km_finish))>
					<cfset deger = get_km.km_finish - get_others.first_km>
					<cfif len(get_km_change.sum_km)>
						<cfset deger = deger + get_km_change.sum_km>
					
					</cfif>
					#tlFormat(deger,0)#
				</cfif></td>
			<cfelse>
				<td colspan="2"></td>
				<td class="txtbold" style="text-align:right;"><cf_get_lang no='221.Aracın Tahsis Bitiş KM si Henüz Girilmemiş'>!</td>
			</cfif>
				</cfoutput>
			</tr>
		</table>
	</cf_medium_list_search_area>
<cf_medium_list>
	<thead>
		<tr>
        	<th><cf_get_lang_main no="1165. Sıra"></th>
			<th class="form-title"><cf_get_lang_main no='1656.Plaka'></th>
			<th class="form-title"><cf_get_lang_main no='132.Sorumlu'></th>
			<th class="form-title"><cf_get_lang no='229.Kullanan Şube'></th>
			<th class="form-title"><cf_get_lang_main no='243.Baş Tarihi'></th>
			<th class="form-title"><cf_get_lang_main no='288.Bit Tarihi'></th>
			<cfif isdefined("attributes.x_vahicle_detail") and attributes.x_vahicle_detail eq 1>
				<th width="80" class="form-title"><cf_get_lang_main no='217.Açıklama'></th>
			</cfif>
			<th class="form-title" style="text-align:right;"><cf_get_lang no='219.Son Km'></th>
			<th class="form-title" style="text-align:right;"><cf_get_lang no='357.Onceki kilometre'></th>
			<th class="form-title" style="text-align:right;"><cf_get_lang no='220.Yapılan KM'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_kms.recordcount>
        <cfoutput query="get_kms">
			<tr>
                <td>#currentrow#</td>
                <td>#assetp#</td>
                <td>#employee_name# #employee_surname#</td>
                <td width="150">#branch_name# - #department_head#</td>
                <td>#dateformat(start_date,dateformat_style)#</td>
                <td>#dateformat(finish_date,dateformat_style)#</td>
                <cfif isdefined("attributes.x_vahicle_detail") and attributes.x_vahicle_detail eq 1>
                	<td>#left(detail,25)#</td>
                </cfif>
                <td style="text-align:right;">#tlformat(km_finish,0)#</td>
                <td style="text-align:right;">#tlformat(km_start,0)#</td>
                <td style="text-align:right;"><cfif len(km_finish) and (km_start)>#tlformat((km_finish) - (km_start),0)#</cfif></td>
            </tr>
          </cfoutput>
		  <cfelse>
          	<cfif isdefined("attributes.x_vahicle_detail") and attributes.x_vahicle_detail eq 1>
	            <cfset colspan=11>
            <cfelse>
	            <cfset colspan=10>
            </cfif>
          	<tr height="20" class="color-row">
            	<td colspan="<cfoutput>#colspan#</cfoutput>"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
         	</tr>
	    </cfif>
	</tbody>
</cf_medium_list>
</div>
