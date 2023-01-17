<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_onay" default="1">
<cfquery name="GET_CLIENTS" datasource="#DSN#">
	SELECT 
		COMPANY.COMPANY_ID, 
		COMPANY.TAXNO,
		COMPANY.FULLNAME, 
		COMPANY.IMS_CODE_ID,
		SETUP_IMS_CODE.IMS_CODE,
		COMPANY_CAT.COMPANYCAT,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.ISPOTANTIAL,
		SETUP_COUNTY.COUNTY_NAME,
		SETUP_CITY.CITY_NAME
	FROM 
		COMPANY,
		SETUP_IMS_CODE,
		COMPANY_CAT,
		COMPANY_PARTNER,
		SETUP_COUNTY,
		SETUP_CITY
	WHERE 
		SETUP_CITY.CITY_ID = COMPANY.CITY AND
		SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
		COMPANY.IMS_CODE_ID = SETUP_IMS_CODE.IMS_CODE_ID AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND 
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		COMPANY.COMPANY_ID IN
		(
			SELECT
				CBR.COMPANY_ID
			FROM
				COMPANY_BRANCH_RELATED CBR,
				EMPLOYEE_POSITION_BRANCHES EPB
			WHERE
				CBR.MUSTERIDURUM IS NOT NULL AND
				CBR.IS_SELECT = 1 AND
				EPB.POSITION_CODE = #session.ep.position_code# AND
				EPB.BRANCH_ID = CBR.BRANCH_ID
				<cfif len(attributes.is_onay) and attributes.is_onay eq 1>AND CBR.VALID_EMP IS NOT NULL
				<cfelseif len(attributes.is_onay) and attributes.is_onay eq 2>AND CBR.VALID_EMP IS NULL</cfif>
		)
		<cfif len(attributes.keyword)>AND COMPANY.FULLNAME LIKE '#attributes.keyword#%'</cfif>
	 ORDER BY 
		COMPANY.FULLNAME
</cfquery>
<cfquery name="GET_POSITION_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			COMPANY_BRANCH_RELATED.CARIHESAPKOD,
			COMPANY_BRANCH_RELATED.VALID_EMP,
			COMPANY_BRANCH_RELATED.VALID_DATE,
			SETUP_MEMBERSHIP_STAGES.TR_NAME AS TR_NAME
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED,
			SETUP_MEMBERSHIP_STAGES
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
			SETUP_MEMBERSHIP_STAGES.TR_ID = COMPANY_BRANCH_RELATED.MUSTERIDURUM AND
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
		  <cfif get_position_branch.recordcount>
			BRANCH.BRANCH_ID IN (#valuelist(get_position_branch.branch_id,',')#)
		  <cfelse>
			BRANCH.BRANCH_ID = 0
		  </cfif>
	UNION ALL
		SELECT
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			COMPANY_BRANCH_RELATED.CARIHESAPKOD,
			COMPANY_BRANCH_RELATED.VALID_EMP,
			COMPANY_BRANCH_RELATED.VALID_DATE,
			'' AS TR_NAME
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NULL AND
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
			<cfif get_position_branch.recordcount>BRANCH.BRANCH_ID IN (#valuelist(get_position_branch.branch_id,',')#)
			<cfelse>BRANCH.BRANCH_ID = 0</cfif>
</cfquery>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_clients.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=crm.my_buyers" method="post">
            <cf_box_search>
                <div class="form-group">
                	<cfinput type="text" name="keyword" value="#attributes.keyword#" placeHolder="#getLang('','filtre',57460)#">
				</div>
                <div class="form-group">
                    <select name="is_onay" id="is_onay">
                        <option value="1" <cfif len(attributes.is_onay) and attributes.is_onay eq 1>selected</cfif>><cf_get_lang_main no='204.Onaylı'></option>
                        <option value="2" <cfif len(attributes.is_onay) and attributes.is_onay eq 2>selected</cfif>><cf_get_lang no='508.Onaysız'></option>
                        <option value="0" <cfif len(attributes.is_onay) and attributes.is_onay eq 0>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_search_company');"><i class="fa fa-plus" title="<cf_get_lang no='289.Müşteri Ara'> -<cf_get_lang no ='667.Şubem İle İlişkilendir'> "></i></a>
				</div>  
                <div class="form-group">
					<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_print_my_buyers');"><i class="fa fa-print" title="<cf_get_lang no='509.Onayladığım Müşterileri Print Et'>"></i></a>
				</div>
                <div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_print_myvalid_buyers');"><i class="catalyst-printer " title="<cf_get_lang no='510.Şube Bazında Onaylanan Müşterileri Print Et'>"></i></a>
				</div>                               
				<cfif not listfindnocase(denied_pages,'crm.popup_add_new_ims_code')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_new_ims_code');"><i class="fa fa-exclamation" title="<cf_get_lang no ='791.IMS Lokasyon Değişikliği'>"></i></a>
					</div>
				</cfif>				
                <cfif not listfindnocase(denied_pages,'crm.popup_dsp_company_boyut_depo_kod_control')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_company_boyut_depo_kod_control');"><i class="icon-times" title="<cf_get_lang no ='944.Boyuta Aktarılmamış Eczaneler'>"></i></a>
					</div>
				</cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_add_company_values')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_company_values','medium');"><i class="icon-download" title="<cf_get_lang no ='792.Müşteri Bilgisi İmport'>"></i></a>
					</div>
				</cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_add_company_to_boyut')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_company_to_boyut');"><i class="icon-info-circle" title="<cf_get_lang no ='680.Toplu Müşteri Aktarım'>"></i></a>
					</div>
				</cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_add_chance_position_mission')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_chance_position_mission');"><img src="/images/chair_change.gif" border="0" align="absmiddle" title="<cf_get_lang no ='686.Toplu Pozisyon Görevi Değiştir'>"></a>
					</div>
				</cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_form_add_change_company_info')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_form_add_change_company_info');"><img src="/images/partner_change.gif" border="0" align="absmiddle" title="<cf_get_lang no ='705.Toplu Müşteri Bilgisi Değiştir'>"></a>
					</div>
				</cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_form_add_change_branch_info')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_form_add_change_branch_info');"><img src="/images/branch_change.gif" border="0" align="absmiddle" title="<cf_get_lang no ='714.Toplu Şube Bilgisi Aktar'>"></a>
					</div>
				</cfif>
            </cf_box_search>
        </cfform>
    </cf_box>
	<cf_box title="#getLang('','müşterilerim',51628)#" uidrop="1" hide_table_column="1" scroll="1"> 
		<cf_grid_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang_main no='75.No'></th>
					<th><cf_get_lang_main no='338.İşyeri'></th>
					<th><cf_get_lang_main no='158.Ad Soyad'></th>
					<th><cf_get_lang_main no='722.Mikro Bolge Kodu'></th>
					<th><cf_get_lang_main no='340.Vergi No'></th>
					<th><cf_get_lang_main no='1196.İl'></th>
					<th><cf_get_lang_main no='1226.İlçe'></th>
					<th><cf_get_lang_main no='41.Şube'></th>
					<th><cf_get_lang_main no='1268.İlişki'></th>
					<th><cf_get_lang_main no='88.Onay'></th>
					<th width="20" class="header_icn_none"><a><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.sil'>"></i></a></th>
				</tr>
			</thead>
				<form name="add_to_admin" action="<cfoutput>#request.self#?fuseaction=crm.emptypopup_add_companys_to_admin</cfoutput>" method="post">
				<cfif get_clients.recordcount>
					<cfoutput query="get_clients" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfquery name="GET_BRANCH_INFO" dbtype="query">
							SELECT BRANCH_NAME, TR_NAME, BRANCH_ID, VALID_EMP, VALID_DATE FROM GET_BRANCH WHERE COMPANY_ID = #company_id#
						</cfquery>
						<tbody>
							<tr>
								<cfsavecontent variable="del_message"><cf_get_lang no ='945.Kayıtlı Onay Bilgisini Siliyorsunuz ! Emin misiniz'></cfsavecontent>								
								<td>#currentrow#</td>
								<td><a href="javascript://" onclick="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_upd_company_infos&cpid=#company_id#&branch_id=#get_branch_info.branch_id#');" class="tableyazi">#fullname#</a></td>
								<td>#company_partner_name# #company_partner_surname#</td>
								<td>#ims_code#</td>
								<td>#taxno#</td>
								<td>#city_name#</td>
								<td>#county_name#</td>
								<td><cfif get_branch_info.recordcount>#get_branch_info.branch_name#<cfelse><font color="##CC0000"><a href="javascript://" onclick="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_add_company_valid&cpid=#company_id#');" class="tableyazi"><cf_get_lang no='667.Şubem İle İlişkilendir'> </a></font></cfif></td>
								<td><cfif len(get_branch_info.tr_name)>#get_branch_info.tr_name#<cfelse></cfif></td>
								<td><cfif len(get_branch_info.valid_emp)><font color="##990000">#get_emp_info(get_branch_info.valid_emp,0,1)#</font> - #dateformat(get_branch_info.valid_date,dateformat_style)#</cfif></td>
								<td width="19"><cfif len(get_branch_info.valid_emp)><a href="javascript://" onClick="javascript:if(confirm('#del_message#')) openBoxDraggable('#request.self#?fuseaction=crm.emptypopup_del_valid_info&branch_id=#get_branch_info.branch_id#&company_id=#company_id#'); else return false;"><img src="/images/killme.gif" border="0" align="absmiddle" title="<cf_get_lang no ='946.Onay Bilgisini İptal Et'>"></a></cfif></td>
							</tr>
						</tbody>
					</cfoutput>
					<tfoot>
						<tr>
							<td colspan="15" style="text-align:right;"><input type="button" name="buton2" value=" <cf_get_lang no='512.Onayladığım Müşterileri Yöneticiye Bildir'> " onClick="pencere_ac_onay();"></td>
						</tr>
					</tfoot>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="15"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
						</tr>
					</tbody>
				</cfif>
			</form>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.is_onay)>
				<cfset url_str = "#url_str#&is_onay=#attributes.is_onay#">
			</cfif>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="crm.my_buyers#url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
function pencere_ac_onay()
{
	openBoxDraggable('<cfoutput>#request.self#?fuseaction=crm.popup_add_companys_to_admin&company_values=</cfoutput>');
}
</script>
