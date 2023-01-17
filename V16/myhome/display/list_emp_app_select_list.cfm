<!--- bu sayfaının nerde ise aynısı hr modülündede var bu sayfada yapılan değişiklikler hr deki dosyayada taşınsın--->
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
	<cfquery name="get_list_authority" datasource="#dsn#">
		SELECT
			LIST_ID
		FROM
			EMPLOYEES_APP_AUTHORITY
		WHERE
			POS_CODE=#session.ep.position_code# AND
			LIST_ID IS NOT NULL AND
			AUTHORITY_STATUS = 1
	</cfquery>
	<cfif get_list_authority.recordcount>
		<cfset list_authority=valuelist(get_list_authority.list_id,',')>
	<cfelse>
		<cfset list_authority=0>
	</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfquery name="get_list" datasource="#dsn#">
	SELECT
		EL.LIST_ID,
		EL.LIST_NAME,
		EL.LIST_DETAIL,
		EL.LIST_STATUS,
		EL.NOTICE_ID,
		EL.OUR_COMPANY_ID,
		EL.DEPARTMENT_ID,
		EL.BRANCH_ID,
		EL.COMPANY_ID,
		EL.RECORD_DATE,
		EL.RECORD_EMP,
		COUNT(ER.LIST_ROW_ID) SATIR_SAYISI
	FROM
		EMPLOYEES_APP_SEL_LIST EL,
		EMPLOYEES_APP_SEL_LIST_ROWS ER
	WHERE
		ER.LIST_ID=EL.LIST_ID
	<cfif isdefined("list_authority")><!---sadece yetkisi olan listeleri görsün--->
		AND EL.LIST_ID IN(#list_authority#)
	</cfif>
	<cfif len(attributes.keyword)>
		AND EL.LIST_NAME LIKE '#attributes.keyword#%'
	</cfif>
	<cfif len(attributes.status)>
		AND EL.LIST_STATUS=#attributes.status#
	</cfif>
	<cfif isdefined('attributes.notice_head') and len(attributes.notice_head) and len(attributes.notice_id)>
		AND EL.NOTICE_ID=#attributes.notice_id#
	</cfif>
	<cfif isdefined('attributes.company_id') and isdefined('attributes.company') and len(attributes.company)>
		AND EL.COMPANY_ID=#attributes.company_id#
	</cfif>
	<cfif isdefined('attributes.branch_id') and isdefined('attributes.branch') and len(attributes.branch)>
		AND EL.BRANCH_ID=#attributes.branch_id#
	</cfif>
	<cfif isdefined('attributes.position_cat') and isdefined('attributes.position_cat_id') and len(attributes.position_cat)>
		AND EL.POSITION_CAT_ID=#attributes.position_cat_id#
	</cfif>
	<cfif isdefined('attributes.position') and isdefined('attributes.position_id') and len(attributes.position)>
		AND EL.POSITION_ID=#attributes.position_id#
	</cfif>
	GROUP BY
		EL.LIST_ID,
		EL.LIST_NAME,
		EL.LIST_DETAIL,
		EL.LIST_STATUS,
		EL.NOTICE_ID,
		EL.OUR_COMPANY_ID,
		EL.DEPARTMENT_ID,
		EL.BRANCH_ID,
		EL.COMPANY_ID,
		EL.RECORD_DATE,
		EL.RECORD_EMP
	ORDER BY
		EL.LIST_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_list.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfform name="list_app" action="#request.self#?fuseaction=myhome.emp_app_select_list" method="post">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='31337.Seçim Listeleri'></cfsavecontent>
        <cf_big_list_search title="#message#">
            <cf_big_list_search_area>
                <table>
                    <tr>
                    <cfinput type="hidden" name="is_form_submitted" value="1">
                        <td><cf_get_lang dictionary_id='57460.Filtre'></td>
                        <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
                        <td><select name="status" id="status">
                                <option value="" <cfif not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
                                <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                                <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
                            </select>
                        </td>
                        <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                       		 <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button></td>
                    </tr>
                </table>
            </cf_big_list_search_area>
            <cf_big_list_search_detail_area>
                <table>
                        <tr>
                            <td><cf_get_lang dictionary_id='31334.İlan'></td>
                            <td><input type="hidden" name="notice_id" id="notice_id" value="<cfif isdefined('attributes.notice_head') and IsDefined('attributes.notice_id') and len(attributes.notice_id)><cfoutput>#attributes.notice_id#</cfoutput></cfif>">
                                <input type="text" name="notice_head" id="notice_head" value="<cfif isdefined('attributes.notice_head')><cfoutput>#attributes.notice_head#</cfoutput></cfif>" style="width:100px;">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=list_app.notice_id&field_name=list_app.notice_head','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" align="top"></a> </td>
                            <td><cf_get_lang dictionary_id='57585.Kurumsal Üye'></td>
                            <td><input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <input type="text" name="company" id="company" style="width:100px;" value="<cfif isdefined("attributes.company_id") and isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=list_app.company&field_comp_id=list_app.company_id&select_list=2&keyword='+encodeURIComponent(document.list_app.company.value),'list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" align="top"></a> </td>
                            <td><cf_get_lang dictionary_id='57453.Şube'></td>
                            <td><input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
                                <input type="text" name="branch" id="branch" value="<cfif IsDefined('attributes.branch') and len(attributes.branch)><cfoutput>#attributes.branch#</cfoutput></cfif>" style="width:100px;">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_name=list_app.branch&field_branch_id=list_app.branch_id</cfoutput>','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" align="top"></a> </td>
                            <td><cf_get_lang dictionary_id='31335.Pozisyon Kat'></td>
                            <td><input type="Hidden" name="POSITION_CAT_ID" id="POSITION_CAT_ID" value="<cfif isdefined('attributes.position_cat') and len(attributes.position_cat)><cfoutput>#attributes.position_cat_id#</cfoutput></cfif>">
                                <input type="text" name="POSITION_CAT" id="POSITION_CAT" style="width:100px;" value="<cfif IsDefined('attributes.POSITION_CAT')><cfoutput>#attributes.POSITION_CAT#</cfoutput></cfif>">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats&field_cat_id=list_app.POSITION_CAT_ID&field_cat=list_app.POSITION_CAT','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" align="top"></a> </td>
                        </tr>
                    </table>
			</cf_big_list_search_detail_area>
        </cf_big_list_search>
    </cfform>
    <cf_big_list>
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='57509.Liste'></th>
                <th><cf_get_lang dictionary_id='31336.Aday'></th>
                <th><cf_get_lang dictionary_id='31334.İlan'></th>
                <th><cf_get_lang dictionary_id='57453.Şube'></th>
                <th><cf_get_lang dictionary_id='57585.Kurumsal Üye'></th>
                <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                <th><cf_get_lang dictionary_id='57756.Durum'></th>
            </tr>
        </thead>
        <tbody>
			<cfif get_list.recordcount and form_varmi eq 1>
                <cfoutput query="get_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="35">#currentrow#></td>
                        <td><a href="#request.self#?fuseaction=myhome.upd_emp_app_select_list&list_id=#get_list.list_id#" class="tableyazi">#get_list.list_name#</a></td>
                        <td>#get_list.satir_sayisi#</td>
                        <td><cfif len(get_list.notice_id)>
                                <cfquery name="get_notice" datasource="#dsn#">
                                    SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID=#get_list.notice_id#
                                </cfquery>
                                #get_notice.notice_no#/#get_notice.notice_head#
                            </cfif>
                        </td>
                        <td><cfif len(get_list.department_id) and len(get_list.our_company_id)>
                                <cfquery name="get_branch" datasource="#dsn#">
                                    SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID=#get_list.branch_id#
                                </cfquery>
                                #get_branch.branch_name#
                            </cfif>
                        </td>
                        <td><cfif len(get_list.company_id)>
                                <cfquery name="get_company" datasource="#dsn#">
                                    SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID=#get_list.company_id#
                                </cfquery>
                            #get_company.FULLNAME#
                            </cfif>
                        </td>
                        <td>#get_emp_info(get_list.record_emp,0,1)#</td>
                        <td>#dateformat(get_list.record_date,dateformat_style)#</td>
                        <td><cfif get_list.list_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'></cfif></td>
                    </tr>
            </cfif>
        </tbody>
    </cf_big_list>
<cfset url_str = "">
<cfset url_str = "#url_str#&keyword=#attributes.keyword#&status=#attributes.status#">
<cfscript>
	if (isdefined('attributes.company') and len(attributes.company)) 
		url_str="#url_str#&company_id=#attributes.company_id#";
	if (isdefined('attributes.notice_head') and len(attributes.notice_head))
		url_str="#url_str#&notice_head=#attributes.notice_head#&notice_id=#attributes.notice_id#";
	if (isdefined('attributes.branch') and len(attributes.branch))
		url_str="#url_str#&branch=#attributes.branch#&branch_id=#attributes.branch_id#";
	if (isdefined('attributes.position') and len(attributes.position))
		url_str="#url_str#&position=#attributes.position#&position_id=#attributes.position_id#";
	if (isdefined('attributes.position_cat') and len(attributes.position_cat))
		url_str="#url_str#&position_cat=#attributes.position_cat#&position_cat_id=#attributes.position_cat_id#";
</cfscript>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table width="99%">
    <tr>
      <td><cf_pages page="#attributes.page#"
					  maxrows="#attributes.maxrows#"
					  totalrecords="#attributes.totalrecords#"
					  startrow="#attributes.startrow#"
					  adres="myhome.emp_app_select_list#url_str#"> </td>
      <td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	document.list_app.keyword.select();
</script>
