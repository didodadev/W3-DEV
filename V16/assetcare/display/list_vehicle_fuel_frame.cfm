<cfsetting showdebugoutput="no">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_fuel" datasource="#dsn#">
	SELECT 
		ASSET_P_FUEL.FUEL_COMPANY_ID,
		COMPANY.FULLNAME,
		ASSET_P_FUEL.FUEL_ID,
		ASSET_P_FUEL.DOCUMENT_NUM,
		ASSET_P_FUEL.FUEL_DATE,		
		ASSET_P_FUEL.FUEL_AMOUNT,
		ASSET_P.ASSETP,
		ASSET_P_FUEL.TOTAL_AMOUNT,
		ASSET_P_FUEL.TOTAL_CURRENCY,
		ASSET_P_FUEL.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		SETUP_FUEL_TYPE.FUEL_NAME,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		ZONE.ZONE_NAME
	FROM 
		ASSET_P_FUEL, 
		ASSET_P,
		BRANCH,
		DEPARTMENT,
		ZONE,
		EMPLOYEES,
		COMPANY,
		SETUP_FUEL_TYPE
 	WHERE 
		ASSET_P.ASSETP_ID = #attributes.assetp_id# AND
		ASSET_P.ASSETP_ID = ASSET_P_FUEL.ASSETP_ID AND
		ASSET_P_FUEL.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND		
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.ZONE_ID = ZONE.ZONE_ID AND
		EMPLOYEES.EMPLOYEE_ID = ASSET_P_FUEL.EMPLOYEE_ID AND
		ASSET_P_FUEL.FUEL_COMPANY_ID = COMPANY.COMPANY_ID AND
		ASSET_P_FUEL.FUEL_TYPE_ID = SETUP_FUEL_TYPE.FUEL_ID
        <cfif len(attributes.keyword)>
		AND (
				COMPANY.FULLNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
				EMPLOYEES.EMPLOYEE_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
                SETUP_FUEL_TYPE.FUEL_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
			)
		</cfif>
	ORDER BY 
		ASSET_P_FUEL.FUEL_ID DESC
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_fuel.recordcount#'>
<cfquery name="get_sum_fuel" datasource="#dsn#">
	SELECT 
		SUM(FUEL_AMOUNT) AS TOTAL_FUEL_AMOUNT,
        SUM(TOTAL_AMOUNT) AS TOTAL_TOTAL_AMOUNT
	FROM 
		ASSET_P_FUEL
	WHERE 
		ASSETP_ID = #attributes.assetp_id# 
</cfquery>
<cfquery name="get_sum_km" datasource="#dsn#">
	SELECT
		 SUM(KM_START) AS TOTAL_KM
	FROM 
		ASSET_P_KM_CONTROL
	WHERE 
		ASSETP_ID = #attributes.assetp_id#
</cfquery>
<cfquery name="get_km_fuel" datasource="#dsn#">
    SELECT 
        ASSET_P.ASSETP_ID,
        ASSET_P.ASSETP,
        SUM(ASSET_P_FUEL.FUEL_AMOUNT) as FA,
        MONTH(ASSET_P_FUEL.FUEL_DATE)AS MFUEL
    FROM
        ASSET_P_FUEL,
        ASSET_P
    WHERE
        ASSET_P_FUEL.ASSETP_ID = ASSET_P.ASSETP_ID 
	
    GROUP BY
        ASSET_P.ASSETP,
        ASSET_P.ASSETP_ID,
        MONTH(ASSET_P_FUEL.FUEL_DATE)
    ORDER BY 
        ASSET_P.ASSETP_ID,
        MONTH(ASSET_P_FUEL.FUEL_DATE)
</cfquery>
<cf_box>
    <cfform name="form" action="#request.self#?fuseaction=assetcare.list_vehicles&event=fuel&assetp_id=#attributes.assetp_id#&iframe=1" method="post">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
        <cf_box_search title="#getLang('','yakıt harcamaları',47252)# #getLang('main',1656)# : #get_assetp.assetp#">
            <table> 
                <tr>
                    <cfif isdefined("attributes.form_submitted")>
                        <cfoutput>
                            <div class="form-group">
                                <td class="txtbold"><cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='261.Tutar'> :<cfif len(get_sum_fuel.total_total_amount)>#TLFormat(get_sum_fuel.total_total_amount,2)#<cfelse>0</cfif> TL.</td>
                                <td class="txtbold"><cf_get_lang_main no='80.Toplam'> :<cfif len(get_sum_fuel.total_fuel_amount)>#TLFormat(get_sum_fuel.total_fuel_amount,2)#<cfelse>0</cfif> lt.</td>
                                <cfif len(get_sum_fuel.total_fuel_amount) and (len(get_sum_km.total_km) and get_sum_km.total_km neq 0)>
                                    <td class="txtbold"> <cf_get_lang no='437.Birim Tüketim'> : #tlformat((get_sum_fuel.total_fuel_amount / get_sum_km.total_km) * 100)# lt / <cf_get_lang no='467.100 KM'></td>
                                <cfelse>
                                    <td class="txtbold"><cf_get_lang no='440.Km Girişi Yok'>!</td>  
                                </cfif> 
                        </cfoutput>
                    <cfelse>
                    </cfif>
                    <div class="form-group"><cfinput type="text" placeholder="#getLang('','filtre',57460)#"name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></div>
                    <div class="form-group small"><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module='vehicles'>
                    </div>
                </tr>
            </table>
        </cf_box_search>
        
    </cfform>
</cf_box>
<cf_box>
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang_main no="1165. Sıra"></th>
            <th><cf_get_lang_main no='330.Tarih'></th>
            <th><cf_get_lang_main no='1656.Plaka'></th>
            <th><cf_get_lang no='229.Kullanan Şube'></th>
            <th><cf_get_lang_main no='132.Sorumlu'></th>
            <th><cf_get_lang_main no='2320.Yakıt Şirketi'></th>
            <th><cf_get_lang_main no='2316.Yakıt Tipi'></th>
            <th><cf_get_lang_main no='468.Belge No'></th>
            <th><cf_get_lang_main no='330.Tarih'></th>
            <th><cf_get_lang_main no='223.Miktar'>/LT</th>
            <th><cf_get_lang_main no='261.Tutar'></th>		
        </tr>
    </thead>
    <tbody>
        <cfif isdefined("attributes.form_submitted") and get_fuel.recordcount>
            <cfoutput query="get_fuel" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td>#dateformat(fuel_date,dateformat_style)#</td>
                    <td>#assetp#</td>
                    <td>#zone_name# - #branch_name# - #department_head#</td>
                    <td>#employee_name# #employee_surname#</td>
                    <td>#fullname#</td>
                    <td>#fuel_name#</td>
                    <td>#document_num#</td>
                    <td>#dateformat(fuel_date,dateformat_style)#</td>
                    <td>#tlformat(fuel_amount,2)#</td>
                    <td>#tlformat(total_amount)# #total_currency#</td>
                    </tr>
            </cfoutput>
        <cfelse>
            <tr>
             <td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
<cfif isdefined("attributes.form_submitted")>
<cfset url_str = "&assetp_id=#attributes.assetp_id#&iframe=1">
<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
    <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
    <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="assetcare.list_vehicle_fuel#url_str#">
</cfif>
</cf_box>

