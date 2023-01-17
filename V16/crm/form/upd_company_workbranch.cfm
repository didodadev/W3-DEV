<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT 
		COMPANY.FULLNAME,
		COMPANY.IMS_CODE_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
	FROM
		COMPANY,
		COMPANY_PARTNER
	WHERE
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
</cfquery>
<cfquery name="GET_RESOURCE" datasource="#DSN#">
	SELECT RESOURCE_ID,RESOURCE FROM COMPANY_PARTNER_RESOURCE ORDER BY RESOURCE
</cfquery>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES ORDER BY TR_NAME 
</cfquery>
<cfquery name="GET_RELATION" datasource="#DSN#">
	SELECT PARTNER_RELATION_ID, PARTNER_RELATION FROM SETUP_PARTNER_RELATION ORDER BY PARTNER_RELATION_ID 
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY DESC
</cfquery>
<cfquery name="GET_RELATED" datasource="#DSN#">
	SELECT 
		*
	FROM 
		COMPANY_BRANCH_RELATED 
	WHERE 
		MUSTERIDURUM IS NOT NULL AND
		<cfif isdefined("attributes.cpid")>
			COMPANY_ID = #attributes.cpid# AND
		</cfif>
		RELATED_ID = #attributes.related_id#	
	ORDER BY 
		BRANCH_ID
</cfquery>
<cfquery name="GET_COM_BRANCH" datasource="#DSN#">
	SELECT 
		OUR_COMPANY.COMP_ID, 
		OUR_COMPANY.COMPANY_NAME, 
		BRANCH.BRANCH_NAME, 
		BRANCH.BRANCH_ID
	FROM 
		BRANCH, 
		OUR_COMPANY,
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND
        EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL AND
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
		BRANCH.BRANCH_ID = #get_related.branch_id#
</cfquery>

<cfif len(get_related.our_company_id)>
	<cfquery name="GET_CREDIT" datasource="#DSN#">
		SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE BRANCH_ID = #attributes.related_id#
	</cfquery>
	<cfscript>
		total_risk_limit_value = get_credit.total_risk_limit;
		money_value = get_credit.money;
	</cfscript>
<cfelse>
	<cfscript>
		total_risk_limit_value = 0;
		money_value = session.ep.money;
	</cfscript>
</cfif>

<cfquery name="GET_CUSTOMER_TYPE" datasource="#DSN#">
	SELECT CUSTOMER_TYPE_ID,CUSTOMER_TYPE FROM SETUP_CUSTOMER_TYPE ORDER BY CUSTOMER_TYPE
</cfquery>
<cfquery name="GET_MAIN_LOCATION_CAT" datasource="#DSN#">
	SELECT MAIN_LOCATION_CAT_ID,MAIN_LOCATION_CAT FROM SETUP_MAIN_LOCATION_CAT ORDER BY MAIN_LOCATION_CAT
</cfquery>
<cfquery name="GET_ENDORSEMENT_CAT" datasource="#DSN#">
	SELECT ENDORSEMENT_CAT_ID,ENDORSEMENT_CAT FROM SETUP_ENDORSEMENT_CAT ORDER BY ENDORSEMENT_CAT
</cfquery>
<cfquery name="GET_PROFITABILITY_CAT" datasource="#DSN#">
	SELECT PROFITABILITY_CAT_ID,PROFITABILITY_CAT FROM SETUP_PROFITABILITY_CAT ORDER BY PROFITABILITY_CAT	
</cfquery>
<cfquery name="GET_RISK_CAT" datasource="#DSN#">
	SELECT RISK_CAT_ID,RISK_CAT FROM SETUP_RISK_CAT ORDER BY RISK_CAT
</cfquery>
<cfquery name="GET_SPECIAL_STATE_CAT" datasource="#DSN#">
	SELECT SPECIAL_STATE_CAT_ID,SPECIAL_STATE_CAT FROM SETUP_SPECIAL_STATE_CAT ORDER BY SPECIAL_STATE_CAT
</cfquery>
<cfsavecontent variable="title_">
    <cf_get_lang_main no='45.Müşteri'> : <cfoutput>#get_comp.fullname#</cfoutput>
    (<cf_get_lang no='601.Eczacı'> : <cfoutput>#get_comp.company_partner_name# #get_comp.company_partner_surname#</cfoutput>)
</cfsavecontent>
<cf_popup_box title="#title_#">
		<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_consumer_branch">
		<input name="cpid" id="cpid" type="hidden" value="<cfoutput>#attributes.cpid#</cfoutput>">
		<input type="hidden" name="related_id" id="related_id" value="<cfoutput>#attributes.related_id#</cfoutput>">
		<input type="hidden" name="our_company_id" id="our_company_id" value="<cfoutput>#attributes.our_company_id#</cfoutput>">
		<table>	
            <tr>
				<td><cf_get_lang_main no='41.Şube'> *</td>
				<td colspan="4">
					<input type="hidden" name="store_id" id="store_id" value="<cfoutput>#get_com_branch.comp_id#,#get_com_branch.branch_id#</cfoutput>">
					<cfoutput><b>#get_com_branch.company_name#/#get_com_branch.branch_name#</b></cfoutput>
				</td>
			</tr>
			<tr>
				<td style="width:100px;"><cf_get_lang_main no='722.IMS Bölge Kodu'> *</td>
				<td style="width:190px;">
					<input name="old_ims_code" id="old_ims_code" type="hidden" value="<cfoutput>#get_comp.ims_code_id#</cfoutput>">
					<cfif len(get_comp.ims_code_id)>
						<cfquery name="GET_IMS_CODE" datasource="#dsn#">
							SELECT IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #get_comp.ims_code_id#
						</cfquery>
						<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#get_comp.ims_code_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang no='68.IMS Bölge Kodu Giriniz !'></cfsavecontent>
						<cfinput type="text" name="ims_code_name" readonly="yes" required="yes" message="#message#" value="#get_ims_code.ims_code# #GET_ims_code.ims_code_name#" tabindex="4" style="width:140px;">
					<cfelse>
						<input type="hidden" name="ims_code_id" id="ims_code_id" value="">
						<cfsavecontent variable="message"><cf_get_lang no='68.IMS Bölge Kodu Giriniz !'></cfsavecontent>
						<cfinput type="text" name="ims_code_name" readonly="yes" required="yes" message="#message#" value="" style="width:140px;">
					</cfif>
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id','list');return false" tabindex="4"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
				</td>
				<td style="width:40px;">&nbsp;</td>
				<td><cf_get_lang_main no='482.Statü'></td>
				<td><select name="cat_status" id="cat_status" style="width:140px;" disabled="disabled">
					<cfoutput query="get_status">
						<option value="#tr_id#" <cfif get_related.musteridurum eq tr_id> selected</cfif>>#tr_name#</option>
					</cfoutput>
					</select> 
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no="1447.Süreç"></td>
				<td><cf_workcube_process is_upd='0' select_value = '#get_related.depo_status#' process_cat_width='140' is_detail='1'></td>
				<td></td>
				<td><cf_get_lang no='293.Uzaklık'>(<cf_get_lang no="316.KM">) /<cf_get_lang_main no='715.Dakika'> *</td>
				<td><input name="depot_km" id="depot_km" value="<cfoutput>#tlFormat(get_related.depot_km,0)#</cfoutput>" maxlength="3" onkeyup="return(FormatCurrency(this,event,0));" style="width:66px;">
					<input name="depot_dak" id="depot_dak" value="<cfoutput>#tlFormat(get_related.depot_dak,0)#</cfoutput>" maxlength="3" onkeyup="return(FormatCurrency(this,event,0));" style="width:66px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='226.Cari Hesap Kodu'> *</td>
				<td><input type="text" name="carihesapkod" id="carihesapkod" value="<cfoutput>#get_related.carihesapkod#</cfoutput>" maxlength="10" readonly style="width:140px;"></td>
				<td></td>
				<td><cf_get_lang no='236.Şube Açılış Tarihi'> *</td>
				<td nowrap>
					<cfsavecontent variable="message"><cf_get_lang no='237.Şube Açılış Tarihi Girmelisiniz '>!</cfsavecontent>
					<cfinput type="text" name="open_date" value="#dateformat(get_related.open_date,dateformat_style)#" required="yes" message="#message#" style="width:140px;" validate="#validate_style#">
					<cf_wrk_date_image date_field="open_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1399.Muhasebe Kod'> *</td>
				<td><input type="text" name="muhasebekod" id="muhasebekod" value="<cfoutput>#get_related.muhasebekod#</cfoutput>" maxlength="10" readonly style="width:140px;"></td>
				<td><cf_get_lang_main no='301.Boyut'></td>
				<td><cf_get_lang no='317.Şube Kapanış Tarihi'></td>
				<td nowrap>
					<cfsavecontent variable="message"><cf_get_lang no='473.Depo Kapanış Tarihi Formatını Doğru Giriniz !'></cfsavecontent>
					<cfinput type="text" name="close_date" value="#dateformat(get_related.close_date,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:140px;">
					<cf_wrk_date_image date_field="close_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='102.Bölge Satış Müdürü'> *</td>
				<td>
					<input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="<cfoutput>#get_related.sales_director#</cfoutput>">
					<input type="text" name="satis_muduru" id="satis_muduru" value="<cfoutput>#get_emp_info(get_related.sales_director,1,0)#</cfoutput>" readonly style="width:140px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.satis_muduru_id&field_name=form_add_company.satis_muduru&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>','list');return false"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
					<a href="javascript://" onClick="del_gorevli('satis_muduru_id','satis_muduru');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
				</td>
				<td><input type="text" name="boyut_satis" id="boyut_satis" style="width:30px;" maxlength="3" value="<cfoutput>#get_related.boyut_bsm#</cfoutput>"></td>
				<td><cf_get_lang no='193.Toplam Risk Limiti'> *</td>
				<td><cfsavecontent variable="message"><cf_get_lang no='203.Vadeli Ödeme Aracı Limiti Girmelisiniz !'></cfsavecontent>
					<cfinput type="text" name="risk_limit" value="#tlformat(total_risk_limit_value)#" style="width:100px;" readonly="yes" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
					<select name="money" id="money" disabled="disabled" style="width:38px;">
						<cfoutput query="get_money">
                            <option value="#money#" <cfif money eq money_value>selected</cfif>>#money#</option>
                        </cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='101.Saha Satis Gorevlisi'></td>
				<td>
					<input type="hidden" name="plasiyer_id" id="plasiyer_id" value="<cfoutput>#get_related.plasiyer_id#</cfoutput>">
					<input type="text" name="plasiyer" id="plasiyer" value="<cfoutput>#get_emp_info(get_related.plasiyer_id,1,0)#</cfoutput>" readonly style="width:140px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.plasiyer_id&field_name=form_add_company.plasiyer&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>','list');return false"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
					<a href="javascript://" onClick="del_gorevli('plasiyer_id','plasiyer');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
				</td>
				<td><input type="text" name="boyut_plasiyer" id="boyut_plasiyer" style="width:30px;" maxlength="3" value="<cfoutput>#get_related.boyut_plasiyer#</cfoutput>"></td>
				<td><cf_get_lang_main no='449.Ortalama Vade'>*</td>
				<td><input type="text" name="average_due_date" id="average_due_date" value="<cfoutput>#get_related.average_due_date#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="49" style="width:38px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='430.Tel Satış Görevlisi'>*</td>
				<td><input type="hidden" name="telefon_satis_id" id="telefon_satis_id" value="<cfoutput>#get_related.tel_sale_preid#</cfoutput>">
					<input type="text" name="telefon_satis" id="telefon_satis" value="<cfoutput>#get_emp_info(get_related.tel_sale_preid,1,0)#</cfoutput>" readonly style="width:140px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.telefon_satis_id&field_name=form_add_company.telefon_satis&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>','list');return false"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
					<a href="javascript://" onClick="del_gorevli('telefon_satis_id','telefon_satis');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
				</td>
				<td><input type="text" name="boyut_telefon" id="boyut_telefon" maxlength="3" value="<cfoutput>#get_related.boyut_telefon#</cfoutput>" style="width:30px;"></td>
				<td><cf_get_lang no='647.Açılış Sür'> *</td>
				<td><input type="text" name="opening_period" id="opening_period" value="<cfoutput>#get_related.opening_period#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="2" tabindex="50" style="width:38px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='205.Tahsilatçı'></td>
				<td><input type="hidden" name="tahsilatci_id" id="tahsilatci_id" value="<cfoutput>#get_related.tahsilatci#</cfoutput>">
					<input type="text" name="tahsilatci" id="tahsilatci" value="<cfoutput>#get_emp_info(get_related.tahsilatci,1,0)#</cfoutput>" readonly style="width:140px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.tahsilatci_id&field_name=form_add_company.tahsilatci&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>','list');return false"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
					<a href="javascript://" onClick="del_gorevli('tahsilatci_id','tahsilatci');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
				</td>
				<td><input type="text" name="boyut_tahsilat" id="boyut_tahsilat" maxlength="3" value="<cfoutput>#get_related.boyut_tahsilat#</cfoutput>" style="width:30px;"></td>
				<td><cf_get_lang no='649.MF Gün'> * </td>
				<td><input type="text" name="mf_day" id="mf_day" value="<cfoutput>#get_related.mf_day#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="51" style="width:38px;"></td>			
			</tr>
			<tr>
				<td><cf_get_lang no='646.Itriyat Satış Görevlisi'></td>
				<td><cfif len(get_related.itriyat_gorevli)>
						<input type="hidden" name="itriyat_id" id="itriyat_id" value="<cfoutput>#get_related.itriyat_gorevli#</cfoutput>">
						<input type="text" name="itriyat" id="itriyat" value="<cfoutput>#get_emp_info(get_related.itriyat_gorevli,1,0)#</cfoutput>" readonly style="width:140px;">
					<cfelse>
						<input type="hidden" name="itriyat_id" id="itriyat_id" value="">
						<input type="text" name="itriyat" id="itriyat" readonly style="width:140px;">
					</cfif>
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.itriyat_id&field_name=form_add_company.itriyat&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>','list');return false"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
					<a href="javascript://" onClick="del_gorevli('itriyat_id','itriyat');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
				</td>
				<td><input type="text" name="boyut_itriyat" id="boyut_itriyat" maxlength="3" value="<cfoutput>#get_related.boyut_itriyat#</cfoutput>" style="width:30px;"></td>
				<td><cf_get_lang no ='782.CP Oran'>/<cf_get_lang no ='783.OPS Gün'>/<cf_get_lang no='1080.PSF Oran'></td>
				<td>
					<input type="text" name="ops_rate" id="ops_rate" value="<cfoutput>#TLFormat(get_related.ops_rate)#</cfoutput>" class="moneybox" readonly tabindex="53" style="width:38px;">
					<input type="text" name="ops_day" id="ops_day" value="<cfoutput>#get_related.ops_day#</cfoutput>" class="moneybox" readonly tabindex="52" style="width:38px;">
					<!--- <input type="text" name="ops_rate" value="<cfoutput>#TLFormat(get_related.ops_rate)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));" onBlur="hesapla();" tabindex="53" style="width:38px;">&nbsp;
					<input type="text" name="ops_day" value="<cfoutput>#get_related.ops_day#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="52" style="width:38px;"> --->
					<input type="text" name="psf_rate" id="psf_rate" value="<cfoutput>#TLFormat(get_related.psf_rate)#</cfoutput>" class="moneybox" readonly tabindex="53" style="width:38px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='152.Sevkiyat Bölge Kodu'></td>
				<td><input type="text" name="shipping_zone_code" id="shipping_zone_code" style="width:140px;" value="<cfif len(get_related.shipping_zone_code)><cfoutput>#get_related.shipping_zone_code#</cfoutput></cfif>"></td>
				<td>&nbsp;</td>
				<td>FAT.ALTI - <cf_get_lang_main no="1572.Puan"></td>
				<td><input type="text" name="box_ops_rate" id="box_ops_rate" value="<cfoutput>#TLFormat(get_related.box_ops_rate)#</cfoutput>" class="moneybox" readonly tabindex="54" style="width:38px;">
					<cfif len(get_related.ops_update_date)><cfoutput>&nbsp;#dateformat(get_related.ops_update_date,dateformat_style)#</cfoutput></cfif>
				</td>
				<!--- <input type="text" name="box_ops_rate" value="<cfoutput>#TLFormat(get_related.box_ops_rate)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));" onBlur="hesapla2();" tabindex="54" style="width:38px;"> --->	
			</tr>
			<tr>
				<td><cf_get_lang no='229.İlişki Tipi'> *</td>
				<td>
                	<select name="resource" id="resource" style="width:140px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_resource">
                            <option value="#resource_id#" <cfif resource_id eq get_related.relation_start> selected</cfif>>#resource#</option>
                        </cfoutput>
					</select>
				</td>
				<td>&nbsp;</td>
				<td rowspan="2" valign="top"><cf_get_lang no='238.Satış Statüsü/Notlar'></td>
				<td rowspan="2" valign="top"><textarea name="status" id="status" style="width:140px;height:35px;"><cfoutput>#get_related.comp_status#</cfoutput></textarea></td>			
			</tr>
			<tr>
				<td><cf_get_lang no='230.Şube ile İlişkileri'></td>
				<td><select name="depot_relation" id="depot_relation" style="width:140px">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_relation">
                            <option value="#partner_relation_id#" <cfif partner_relation_id eq get_related.relation_status>selected</cfif>>#partner_relation#</option>
                        </cfoutput>
					</select>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><cf_get_lang no='450.Bölge Kodu'> *</td>
				<td><input type="text" name="bolge_kodu" id="bolge_kodu" style="width:140px;" maxlength="5" value="<cfoutput>#get_related.bolge_kodu#</cfoutput>"></td>
				<td>&nbsp;</td>
				<td><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
				<td><input type="text" name="calisma_sekli" id="calisma_sekli" style="width:140px;" maxlength="10" value="<cfoutput>#get_related.calisma_sekli#</cfoutput>"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='474.Alt Bölge Kodu'> *</td>
				<td><input type="text" name="altbolge_kodu" id="altbolge_kodu" style="width:140px;" maxlength="5" value="<cfoutput>#get_related.altbolge_kodu#</cfoutput>"></td>
				<td>&nbsp;</td>
				<td><cf_get_lang no='477.Cep Sıra No'></td>
				<td><input type="text" name="cep_sira_no" id="cep_sira_no" maxlength="14" value="<cfoutput>#get_related.cep_sira#</cfoutput>" style="width:45px;">
					<input type="text" name="puan" id="puan" value="<cfoutput>#tlFormat(get_related.puan)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" maxlength="5" readonly style="width:45px;">
            	</td>
			</tr>
			<tr>
				<td><cf_get_lang no="1027.Logo Müşteri Tip"></td>
				<td><input type="text" name="logo_musteri_tip" id="logo_musteri_tip" value="<cfoutput>#get_related.logo_musteri_tip#</cfoutput>" maxlength="10" style="width:140px;"></td>
				<td></td>
				<td><cf_get_lang no="4.Anlaşma Müşteri Statü"> </td>
				<td><input type="checkbox" value="1" name="customer_contract_statute" id="customer_contract_statute" <cfif get_related.customer_contract_statute eq 1>checked</cfif>><b>(A)</b></td>
			</tr>					
		</table>
        <cfquery name="GET_BRANCH_NOTE" datasource="#DSN#">
            SELECT 
                COMPANY_BRANCH_NOTES.NOTE_ID,
                COMPANY_BRANCH_NOTES.NOTE_DETAIL,
                COMPANY_BRANCH_NOTES.NOTE_MONTH,
                COMPANY_BRANCH_NOTES.NOTE_YEAR,
                COMPANY_BRANCH_NOTES.RECORD_DATE,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME
            FROM 
                COMPANY_BRANCH_NOTES,
                EMPLOYEES
            WHERE 
                COMPANY_BRANCH_NOTES.BRANCH_ID = #attributes.related_id# AND 
                COMPANY_BRANCH_NOTES.COMPANY_ID = #attributes.cpid# AND
                COMPANY_BRANCH_NOTES.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
        </cfquery>
        <cf_medium_list>
        	<thead>
                <tr>
                    <th width="25"><cf_get_lang_main no='75.No'></th>
                    <th><cf_get_lang_main no='55.Not'></th>
                    <th width="70"><cf_get_lang_main no='1060.Dönem'></th>
                    <th width="180"><cf_get_lang_main no='71.Kayıt'></th>
                    <th width="19"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_add_company_period_note&cpid=#attributes.cpid#&related_id=#related_id#','small');"><img src="/images/add_not.gif" border="0" title="<cf_get_lang no='651.Şube Notu'>"></a></cfoutput></th>
                </tr>
            </thead>
            <tbody>
            <cfif get_branch_note.recordcount>
              <cfoutput query="get_branch_note">
                <tr>
                    <td>#currentrow#</td>
                    <td>#note_detail#</td>
                    <td>#listgetat('Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık',note_month,',')# #note_year#</td>
                    <td>#employee_name# #employee_surname# - #dateformat(record_date,dateformat_style)#</td>
                    <td width="19"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_period_note&note_id=#note_id#','small');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang no='651.Şube Notu'>"></a></td>
                  </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
                </tr>
            </cfif>
            </tbody>
        </cf_medium_list>
      <cf_popup_box_footer>
      	<div style="float:left;"><cf_record_info query_name="get_related"></div>
        <div style="float:left;">
            <table cellpadding="1" cellspacing="0">
                <tr>
                	<td width="25">&nbsp;</td>
                    <td valign="top" style="font-size:10px;"><cf_get_lang no='648.Onay Tarihi'>: <cfoutput><cfif len(get_related.valid_date)>#dateformat(get_related.valid_date,dateformat_style)#</cfif></cfoutput></td>
                </tr>
                <tr>
                    <td width="25">&nbsp;</td>
                    <td  style="font-size:10px;">Onay Veren :<cfif len(get_related.valid_emp)>- <cfoutput>#get_emp_info(get_related.valid_emp,0,0)#</cfoutput></cfif></td>
                </tr>
            </table>
       </div>
       <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0' type_format="1">
     </cf_popup_box_footer>	
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function del_gorevli(field1,field2)
{
	var deger1 = eval("document.form_add_company." + field1);
	var deger2 = eval("document.form_add_company." + field2);
	deger1.value="";
	deger2.value="";
}
function kontrol()
{
	if(form_add_company.carihesapkod.value == "")
	{
		alert("<cf_get_lang no='751.Lütfen Cari Hesap Kodu Giriniz'>!");
		return false;
	}
	else if(form_add_company.carihesapkod.value.length != 10)
	{
		alert("<cf_get_lang no='589.Cari Hesap Kodu 10 Hane Olmalıdır'>!");
		return false;
	}
	if(form_add_company.muhasebekod.value == "")
	{
		alert("<cf_get_lang no='752.Lütfen Muhasebe Kodu Giriniz'>!");
		return false;
	}
	else if(form_add_company.muhasebekod.value.length != 10)
	{
		alert("<cf_get_lang no='591.Özel Kod Alanı 10 Karakter Olmalıdır'>!");
		return false;
	}
	if(document.form_add_company.satis_muduru.value == "")
	{
		alert("<cf_get_lang no ='728.Lütfen Bölge Satış Müdürü Seçiniz'> !");
		return false; 
	}
	if(document.form_add_company.boyut_satis.value == "")
	{
		alert("<cf_get_lang no ='729.Lütfen Bölge Satış Müdürü Boyut Kodu Seçiniz'>!");
		return false;
	}
	if(document.form_add_company.telefon_satis.value == "")
	{
		alert("<cf_get_lang no ='579.Lütfen Telefonla Satış Görevlisi Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.boyut_telefon.value == "")
	{
		alert("<cf_get_lang no ='582.Lütfen Telefonla Satış Görevlisi Boyut Kodu Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.tahsilatci.value.length == "")
	{
		alert("<cf_get_lang no ='580.Lütfen Tahsilat Görevlisi Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.boyut_tahsilat.value.length == "")
	{
		alert("<cf_get_lang no ='581.Lütfen Tahsilat Görevlisi Boyut Kodu Giriniz'> !");
		return false;
	}
	if(document.form_add_company.open_date.value == "")
	{
		alert("<cf_get_lang no ='730.Lütfen Depo Açılış Tarihi Giriniz'> !");
		return false;
	}
	if(document.form_add_company.bolge_kodu.value == "")
	{
		alert("<cf_get_lang no ='731.Lütfen Bölge Kodu Giriniz'> !");
		return false; 
	}
	if(document.form_add_company.altbolge_kodu.value == "")
	{
		alert("<cf_get_lang no ='732.Lütfen Alt Bölge Kodu Giriniz'> !");
		return false;
	}
	x = document.form_add_company.resource.selectedIndex;
	if (document.form_add_company.resource[x].value == "")
	{
		alert ("<cf_get_lang no ='733.Lütfen İlişki Başlangıcı Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.risk_limit.value == "")
	{
		document.form_add_company.risk_limit.value = 0;
	}
	
	if(document.form_add_company.depot_dak.value == "")
	{
		alert("<cf_get_lang no ='734.Lütfen Depoya Uzaklık ( Dakika ) Giriniz'> !");
		return false;
	}
	else
	{
		depot_dak_ = filterNum(form_add_company.depot_dak.value);
		if(depot_dak_ >300)
		{
			alert("<cf_get_lang no ='785.Depoya Uzaklık ( Dakika ) 300 den Büyük Olamaz'>!");
			return false; 
		}	
	}
	
	if(document.form_add_company.depot_km.value == "")
	{
		alert("<cf_get_lang no ='735.Lütfen Depoya Uzaklık ( Km ) Giriniz'> !");
		return false; 
	}
	else
	{
		depot_km_ = filterNum(form_add_company.depot_km.value);
		if(depot_km_ >300)
		{
			alert("<cf_get_lang no ='786.Depoya Uzaklık ( Km ) 300 den Büyük Olamaz'> !");
			return false; 
		}		
	}
	if(form_add_company.risk_limit.value.indexOf(',') > -1)
	{
		form_add_company.risk_limit.value = filterNum(form_add_company.risk_limit.value);
		form_add_company.depot_dak.value = filterNum(form_add_company.depot_dak.value);
		form_add_company.depot_km.value = filterNum(form_add_company.depot_km.value);	
		
		form_add_company.cat_status.disabled = false;
		form_add_company.money.disabled = false;
	}

	return process_cat_control();
}
</script>
