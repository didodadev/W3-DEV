<cfsetting showdebugoutput="no">
<cfsetting requesttimeout="3000">
<cfparam name="attributes.branch_state" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.transfer_status" default="0">
<cfparam name="attributes.caritip" default="">
<cfset list_caritip = "E,H,M,P,R,U">

<cfset denied_list = '17'>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		B.BRANCH_NAME,
		B.BRANCH_ID,
		BTD.BRANCH_NAME BRANCH_NAME2,
		BTD.TABLE_NAME
	FROM 
		BRANCH B,
		COMPANY_BOYUT_DEPO_KOD CBDK,
		BRANCH_TRANSFER_DEFINITION BTD
	WHERE
		CBDK.W_KODU = B.BRANCH_ID AND
		B.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
		BTD.BRANCH_ID = B.BRANCH_ID
	ORDER BY
		B.BRANCH_NAME
</cfquery>

<cfset url_str = "">
<cfif isdefined("attributes.form_submitted") and len(attributes.branch_state)>
	<cfset url_str = "#url_str#&form_submitted=1">
	<cfif len(attributes.branch_state)>
		<cfset url_str = "#url_str#&branch_state=#attributes.branch_state#">
	</cfif>
	<cfif len(attributes.transfer_status)>
		<cfset url_str = "#url_str#&transfer_status=#attributes.transfer_status#">
	</cfif>
	<cfif len(attributes.caritip)>
		<cfset url_str = "#url_str#&caritip=#attributes.caritip#">
	</cfif>
	<cfset TABLENAME = listlast(attributes.branch_state)>
	<cfquery name="GET_TRANSFER_COMPANY" datasource="mushizgun">
		SELECT
			KAYITNO,
			ISYERIADI,
			ADI,
			SOYADI,
			TCKIMLIKNO,
			VERGINO,
			IL,
			ILCE,
			SEMT,
			TELEFON,
			CARITIP,
			IS_TRANSFER,
			COMPANY_ID
		FROM
			#TABLENAME# 
		WHERE
			CARITIP NOT IN ('X','K') AND
			<cfif len(attributes.transfer_status) and attributes.transfer_status eq 1>
				IS_TRANSFER = 1 AND
			<cfelseif len(attributes.transfer_status) and attributes.transfer_status eq 0>
				IS_TRANSFER = 0 AND
			</cfif>
			<cfif len(attributes.keyword)>
				(
					ISYERIADI LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
					KAYITNO LIKE '#attributes.keyword#%'
					
				) AND
			</cfif>
			<cfif len(attributes.caritip)>
				CARITIP = '#attributes.caritip#' AND
			</cfif>
			(LEFT(HESAPKODU,3) = 120 OR LEFT(HESAPKODU,3) = 320)
		ORDER BY
			ISYERIADI
	</cfquery>
	<cfquery name="GET_COMP_KONTROL" datasource="#DSN#">
		SELECT 
			COMPANY.FULLNAME,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY.TAXNO,
			COMPANY.COMPANY_TEL1,
			COMPANY_PARTNER.TC_IDENTITY
		FROM 
			COMPANY,
			COMPANY_PARTNER,
			COMPANY_CAT
		WHERE 
			COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
			COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
			COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID	
	</cfquery>
<cfelse>
	<cfset get_transfer_company.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_transfer_company.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <table border="0" width="98%" align="center">
        <cfform name="list_branch_transfer" method="post" action="#request.self#?fuseaction=crm.list_branch_transfer">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <tr>
                <td class="headbold"><cf_get_lang no ='790.Şube Aktarım Listesi'></td>
                <tdstyle="text-align:right;">
                <cfoutput>
                <table cellspacing="1" cellpadding="2" border="0" class="color-border">
                    <tr class="color-row" height="23">
                        <td width="15" align="center"><a class="tableyazi" href="##" onClick="alphabet('A');">A</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('B');">B</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('C');">C</a><a class="tableyazi" href="##" onClick="alphabet('Ç');">Ç</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('D');">D</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('E');">E</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('F');">F</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('G');">G</a><a class="tableyazi" href="##" onclick="alphabet('Ğ');">Ğ</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('H');">H</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('I');">I</a><a class="tableyazi" href="##" onclick="alphabet('İ');">İ</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('J');">J</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('K');">K</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('L');">L</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('M');">M</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('N');">N</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('O');">O</a><a class="tableyazi" href="##" onClick="alphabet('Ö');">Ö</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('P');">P</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('Q');">Q</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('R');">R</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('S');">S</a><a class="tableyazi" href="##" onClick="alphabet('Ş');">Ş</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('T');">T</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('U');">U</a><a class="tableyazi" href="##" onClick="alphabet('Ü');">Ü</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('V');">V</a><a class="tableyazi" href="##" onClick="alphabet('W');">W</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('Y');">Y</a></td>
                        <td align="center" width="15"><a class="tableyazi" href="##" onClick="alphabet('Z');">Z</a></td>
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </tr>
                </table>
                </cfoutput>
                </td>
            </tr>
            <tr class="color-border">
                <td colspan="2"style="text-align:right;">
                <table class="color-list" width="100%">
                    <tr>
                        <tdstyle="text-align:right;">
                        <table>
                            <tr>
                                <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#"></td>
                                <td><select name="branch_state" id="branch_state" style="width:120px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_branch">
                                            <option value="#branch_id#,#table_name#" <cfif listfirst(attributes.branch_state) eq branch_id>selected</cfif>>#branch_name#-#branch_name2#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                                <td><select name="transfer_status" id="transfer_status" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='296.Tümü'></option>
                                        <option value="1" <cfif len(attributes.transfer_status) and attributes.transfer_status eq 1>selected</cfif>><cf_get_lang no='1041.Aktarılanlar'></option>
                                        <option value="0" <cfif (len(attributes.transfer_status) and attributes.transfer_status eq 0) or not len(attributes.transfer_status)>selected</cfif>><cf_get_lang no='1042.Aktarılmayanlar'></option>
                                    </select>
                                </td>
                                <td><select name="caritip" id="caritip">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop from="1" to="#listlen(list_caritip)#" index="loop_i">
                                            <cfoutput>
                                            <option value="#listgetat(list_caritip,loop_i)#" <cfif attributes.caritip eq listgetat(list_caritip,loop_i)>selected</cfif>>#listgetat(list_caritip,loop_i)#</option>
                                            </cfoutput>
                                        </cfloop>
                                    </select>
                                </td>
                                <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                                </td>
                                <td><cf_wrk_search_button search_function='kontrol()'></td> 
                            </tr>
                        </table>
                        </td>
                    </tr>
                </table>
        </td>
    </tr>
    </cfform>	
</table>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr class="color-border">
				<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="2">
					<tr class="color-header" height="22">
						<td class="form-title" width="25"><cf_get_lang_main no='75.No'></td>
						<td class="form-title" width="40"><cf_get_lang no='1043.Kayıt No'></td>
						<td class="form-title" width="20"><cf_get_lang_main no='218.Tip'></td>
						<td class="form-title"><cf_get_lang_main no='338.İşyeri'></td>
						<td class="form-title" width="75"><cf_get_lang_main no='485.Adi'></td>
						<td class="form-title" width="75"><cf_get_lang_main no='1138.Soyadi'></td>
						<td class="form-title" width="70"><cf_get_lang_main no='613.TC Kimlik No'></td>
						<td class="form-title" width="70"><cf_get_lang_main no='340.Vergi No'></td>
						<td class="form-title" width="100"><cf_get_lang_main no='1196.İl'></td>
						<td class="form-title" width="80"><cf_get_lang_main no='720.Semt'></td>
						<td class="form-title" width="80"><cf_get_lang no='613.Tel No'></td>
						<td width="2%"></td>
						<td width="2%"></td>
						<td width="2%"></td>
					</tr>
					<cfif get_transfer_company.recordcount>
						<form name="add_to_admin" action="<cfoutput>#request.self#?fuseaction=crm.emptypopup_add_companys_to_admin</cfoutput>" method="post">
						<cfoutput query="get_transfer_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
							<cfquery name="GET_COMP_KONTROL_ROW" dbtype="query">
								SELECT 
									FULLNAME
								FROM 
									GET_COMP_KONTROL
								WHERE
								(
									1=0
									<cfif len(trim(get_transfer_company.isyeriadi))>OR FULLNAME LIKE '#trim(get_transfer_company.isyeriadi)#%'</cfif>
									<cfif len(trim(get_transfer_company.adi)) gt 1 and len(trim(get_transfer_company.adi)) gt 1>OR (COMPANY_PARTNER_NAME LIKE '#trim(get_transfer_company.adi)#%' AND COMPANY_PARTNER_SURNAME LIKE '#trim(get_transfer_company.soyadi)#%')</cfif>
									<cfif len(get_transfer_company.telefon)>OR COMPANY_TEL1 = '#get_transfer_company.telefon#'</cfif>
									<cfif len(get_transfer_company.vergino)>OR (TC_IDENTITY = '#get_transfer_company.vergino#' OR TAXNO = '#get_transfer_company.vergino#')</cfif>
									<cfif len(get_transfer_company.tckimlikno)>OR (TC_IDENTITY = '#get_transfer_company.tckimlikno#' OR TAXNO = '#get_transfer_company.tckimlikno#')</cfif>
								)
							</cfquery>
							<cfif 1 eq 1></cfif>
	
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td>#currentrow#</td>
								<td>#kayitno#<cfif len(company_id)>-#company_id#</cfif></td>
								<td>#caritip#</td>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_dsp_check_company_transfer&kayitno=#kayitno#&transfer_branch_id=#listfirst(attributes.branch_state)#&fullname=#trim(isyeriadi)#&company_partner_name=#trim(get_transfer_company.adi)#&company_partner_surname=#trim(get_transfer_company.soyadi)#&tax_num=#trim(vergino)#&tc_identity_no=#trim(tckimlikno)#&tel=#telefon#&il=#get_transfer_company.il#<cfif is_transfer eq 1>&is_transfer=1</cfif>','page_horizantal','popup_dsp_check_company_transfer');" class="tableyazi">#isyeriadi#</a></td>
								<td>#adi#</td>
								<td>#soyadi#</td>
								<td>#tckimlikno#</td>
								<td>#vergino#</td>
								<td>#il#</td>
								<td>#semt#</td>
								<td>#telefon#</td>
							<cfif get_transfer_company.is_transfer eq 0>
								<td>
									<cfif listfindnocase(denied_list,session.ep.userid)>
										<cfif get_comp_kontrol_row.recordcount>
											<a href="#request.self#?fuseaction=crm.form_add_company&transfer_branch_id=#listfirst(attributes.branch_state)#&id=#kayitno#&caritip=#attributes.caritip#&keyword=#attributes.keyword#"><img src="/images/plus_list.gif" align="absmiddle" title="<cf_get_lang no ='183.Müşteri Ekle'>" border="0" style="filter:alpha(opacity=50);"></a>
										<cfelse>
											<a href="#request.self#?fuseaction=crm.form_add_company&transfer_branch_id=#listfirst(attributes.branch_state)#&id=#kayitno#&caritip=#attributes.caritip#&keyword=#attributes.keyword#"><img src="/images/plus_list.gif" align="absmiddle" title="<cf_get_lang no ='183.Müşteri Ekle'>" border="0"></a>
										</cfif>
								    </cfif>
								</td>
								<td>
									<cfif get_comp_kontrol_row.recordcount>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_dsp_check_company_transfer&kayitno=#kayitno#&transfer_branch_id=#listfirst(attributes.branch_state)#&fullname=#trim(isyeriadi)#&company_partner_name=#trim(get_transfer_company.adi)#&company_partner_surname=#trim(get_transfer_company.soyadi)#&tax_num=#trim(vergino)#&tc_identity_no=#trim(tckimlikno)#&tel=#telefon#&il=#get_transfer_company.il#','wide');"><img src="/images/copy_list.gif" align="absmiddle" title="<cf_get_lang no ='318.Şube Ekle'>" border="0"></a>
									<cfelse>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_dsp_check_company_transfer&kayitno=#kayitno#&transfer_branch_id=#listfirst(attributes.branch_state)#&fullname=#trim(isyeriadi)#&company_partner_name=#trim(get_transfer_company.adi)#&company_partner_surname=#trim(get_transfer_company.soyadi)#&tax_num=#trim(vergino)#&tc_identity_no=#trim(tckimlikno)#&tel=#telefon#&il=#get_transfer_company.il#','wide');"><img src="/images/copy_list.gif" align="absmiddle" title="<cf_get_lang no ='318.Şube Ekle'>" border="0" style="filter:alpha(opacity=50);"></a>
									</cfif>
								</td>
								<td><cfif session.ep.admin eq 1><input type="button" value="- " title="Tip Değiştir" onClick="cancel_transfer(#kayitno#);"></cfif></td>
							<cfelse>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</cfif>
							</tr>
						</cfoutput>
						</form>
					<cfelse>
						<tr class="color-row">
							<td colspan="14" height="20"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
						</tr>
					</cfif>
				</table>
				</td>
			</tr>
		</table>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<table width="98%" align="center" height="35" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="3">
						<cf_pages page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="crm.list_branch_transfer&#url_str#&keyword=#attributes.keyword#">
					</td>
					<!-- sil -->
					<td colspan="5" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'> : #attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'> : #attributes.page#/#lastpage#</cfoutput></td>
					<!-- sil -->
				</tr>
			</table>
		</cfif>

<script type="text/javascript">
function pencere_ac_onay()
{
	windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_companys_to_admin&company_values=</cfoutput>','page');
}
function alphabet(x)
{
	if(document.list_branch_transfer.branch_state.value == '')
	{
		alert("<cf_get_lang_main no='1167.Lütfen Şube Seçiniz'>!");
		return false;
	}
	else
		window.location.href='<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction##url_str#</cfoutput>&keyword='+x;
}
function kontrol()
{
	if(document.list_branch_transfer.branch_state.value == '')
	{
		alert("<cf_get_lang_main no='1167.Lütfen Şube Seçiniz'>!");
		return false;
	}
	return true;	
}
function cancel_transfer(deger)
{
	document.list_branch_transfer.action="<cfoutput>#request.self#?fuseaction=crm.emptypopup_cancel_transfer&transfer_branch_id=#listfirst(attributes.branch_state)#&kayitno=</cfoutput>"+ deger;
	document.list_branch_transfer.submit();
}
</script>
