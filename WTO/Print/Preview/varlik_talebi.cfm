<!--- STANDART VARLIK TALEBİ 20121023 ST --->
<cfquery name="Get_Assetp_Demand" datasource="#dsn#">
	SELECT * FROM ASSET_P_DEMAND WHERE DEMAND_ID = #attributes.iid#
</cfquery>
<cfset attributes.department_id = get_assetp_demand.department_id>
<cfquery name="GET_BRANCHS_DEPS" datasource="#dsn#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME
	FROM 
		BRANCH,
		DEPARTMENT 
	WHERE
		BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
		AND	DEPARTMENT_ID = #attributes.department_id#
		</cfif>
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfset attributes.cat_id = get_assetp_demand.assetp_catid>
<cfquery name="GET_ASSETP_CATS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		ASSET_P_CAT
	<cfif isdefined("attributes.cat_id")>
	WHERE
		ASSETP_CATID = #attributes.cat_id#
	</cfif>	
</cfquery>
<cfset attributes.purpose_id=get_assetp_demand.usage_purpose_id>
<cfquery name="GET_USAGE_PURPOSE" datasource="#dsn#">
	SELECT 
		USAGE_PURPOSE_ID, 
		USAGE_PURPOSE 
	FROM 
		SETUP_USAGE_PURPOSE
	<cfif isdefined("attributes.purpose_id")>
	WHERE
		USAGE_PURPOSE_ID = #attributes.purpose_id#
	</cfif>
	ORDER BY 
		USAGE_PURPOSE
</cfquery>
<style>
	.bold{ font-weight:bold;}
	.baslik{font-size:18px;}
</style>
<table border="0" cellpadding="0" cellspacing="0" style="width:180mm;">
	<tr>
    	<td style="width:12mm;" rowspan="20">&nbsp;</td>
        <td style="height:15mm;">&nbsp;</td>
    </tr>
    <tr>
    	<td valign="top">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr><td style="text-align:center; height:15mm;" class="baslik"><strong><cf_get_lang dictionary_id='32267.Varlık Talebi'></strong></td></tr>
                <tr>
                <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <cfoutput>
                	<tr>
                        <td style="width:20mm;height:6mm;" class="bold"><cf_get_lang dictionary_id='30829.Talep Eden'></td>
                        <td style="width:45mm;">#get_emp_info(get_assetp_demand.Employee_id,0,0,0)#</td>
                        <td style="width:20mm;" class="bold"><cf_get_lang_main no="160.Departman"></td>
                        <td style="width:45mm;">#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#</td>
                    </tr>
                    <tr>
                        <td style="height:6mm;" class="bold"><cf_get_lang dictionary_id='57486.Kategori'></td>
                        <td>#get_assetp_cats.assetp_cat#</td>
                        <td class="bold"><cf_get_lang dictionary_id='31020.Kullanım Amacı'></td>
                        <td>#get_usage_purpose.usage_purpose#</td>
                    </tr>
                    <tr>
                        <td style="height:6mm;" class="bold"><cf_get_lang dictionary_id='31023.Talep Tarihi'></td>
                        <td>#dateformat(get_assetp_demand.request_date,dateformat_style)#</td>
                        <td style="height:6mm;" class="bold"><cf_get_lang dictionary_id='57756.Durum'></td>
                        <td>
                        <cfswitch expression="#Get_Assetp_Demand.result_id#">
                            <cfcase value="1"><cf_get_lang dictionary_id='30974.Kabul'> (+)</cfcase>
                            <cfcase value="0"><cf_get_lang dictionary_id='29537.Red'> (-)</cfcase>
                            <cfdefaultcase><cf_get_lang dictionary_id='48075.Değerlendirme Aşamasında'></cfdefaultcase>
                        </cfswitch>
                        </td>
                    </tr>
                    <tr>
                        <td style="height:6mm;" class="bold"><cf_get_lang dictionary_id='57578.Yetkili'></td>
                        <td>#get_emp_info(get_assetp_demand.validator_pos_code,1,0)#</td>
                        <td class="bold"><cf_get_lang dictionary_id='41580.Sonuç'></td>
                        <td>
                        <cfif get_assetp_demand.result_id eq 1>
                            <cf_get_lang dictionary_id='58699.Onaylandı'> !
                            <cfoutput>#dateformat(get_assetp_demand.valid_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_assetp_demand.valid_date),timeformat_style)#</cfoutput>
                        <cfelseif get_assetp_demand.result_id eq 0>
                            <cf_get_lang dictionary_id='57617.Reddedildi'> !
                            <cfoutput>#dateformat(get_assetp_demand.valid_date,dateformat_style)# #timeformat(get_assetp_demand.valid_date,timeformat_style)#</cfoutput>
                        <cfelse>
                            <cf_get_lang dictionary_id='57615.Onay Bekliyor'> !
                            <cfsavecontent variable="onay_doc"><cf_get_lang dictionary_id='31575.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Onaylamak istediğinizden emin misiniz?'></cfsavecontent>
                            <cfsavecontent variable="red_doc"><cf_get_lang dictionary_id='31576.Onaylamakta olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Reddetmek istediğinizden emin misiniz?'></cfsavecontent>
                            <cfif session.ep.position_code eq get_assetp_demand.validator_pos_code>
                                <input type="Image" src="/images/valid.gif" alt="<cf_get_lang_main no='1063.'>" onClick="if (confirm('#onay_doc#')) {upd_assetp_demand.result_id.value='1'} else {return false}" border="0">
                                <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang_main no='1049.Reddet'>" onClick="if (confirm('#red_doc#')) {upd_assetp_demand.result_id.value='0'} else {return false}" border="0">
                            </cfif>
                        </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td style="height:6mm;" class="bold"><cf_get_lang dictionary_id='36199.Açıklama'></td>
                        <td>#get_assetp_demand.Detail#</td>
                        <td></td>
                        <td></td>
                    </tr>
				</cfoutput>
                </table>
                </td>
           </tr>
        </table>
        </td>
    </tr>
</table>
