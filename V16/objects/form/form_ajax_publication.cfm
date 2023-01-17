<cfsetting showdebugoutput="no">
<cfquery name="GET_PARTNER_CATS" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		CONSCAT	
</cfquery>
<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT POSITION_CAT,POSITION_CAT_ID FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT 
</cfquery>
<!--- site domain alanı kullanılmamakta, kapatıldı 2013-07-01 --->
<!--- <cfquery name="get_domains" datasource="#dsn#">
	SELECT SITE_DOMAIN FROM COMPANY_CONSUMER_DOMAINS 
</cfquery>
<cfset site_list = valuelist(get_domains.SITE_DOMAIN)> --->
<cfquery name="get_publish" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE,TARGET_COMPANY,TARGET_CONSUMER,TARGET_EMPLOYEE,TARGET_WEBSITE FROM PUBLISH WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> 
</cfquery>
<div id="div_add_publication"></div><!--- AjaxFormSubmit icin kullaniliyor --->
<cfform name="add_publication" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_publication">
	<input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
   	<cf_big_list_search>
    	<cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang dictionary_id='58467.Başlama'></td>
                    <td><cfinput type="text" name="start_date" value="#dateformat(get_publish.start_date,dateformat_style)#" style="width:65px" validate="#validate_style#"></td>
                    <td><cf_wrk_date_image date_field="start_date" date_form="add_publication"></td>
                    <td><cf_get_lang dictionary_id='57502.Bitiş'></td>
                    <td><input type="text" name="finish_date" id="finish_date" value="<cfoutput>#dateformat(get_publish.finish_date,dateformat_style)#</cfoutput>" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px"></td>
                    <td><cf_wrk_date_image date_field="finish_date" date_form="add_publication"></td>
                </tr>
            </table>
    	</cf_big_list_search_area>
    </cf_big_list_search>
    <table width="99%" align="center">
        <tr class="color-header" style="height:20px"> 
            <td class="form-title"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></td>
            <td class="form-title"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></td>
            <td class="form-title"><cf_get_lang dictionary_id='58875.Çalışanlar'></td>
            <td class="form-title"><cf_get_lang dictionary_id='47050.Web Site'></td>
        </tr>
        <tr valign="top">
            <td>
                <cfoutput query="GET_PARTNER_CATS">
                    <input type="checkbox" name="target_company" id="target_company" value="#companycat_id#" <cfif ListFind(get_publish.target_company,companycat_id)>checked</cfif>>#companycat#<br/>
                </cfoutput>
            </td>
            <td>
                <cfoutput query="get_consumer_cat">
                    <input type="checkbox" name="target_consumer" id="target_consumer" value="#conscat_id#" <cfif ListFind(get_publish.target_consumer,conscat_id)>checked</cfif>>#conscat#<br/>
                </cfoutput>
            </td>
            <td>
                <cfoutput query="get_position_cats">
                    <input type="checkbox" name="target_employee" id="target_employee" value="#position_cat_id#" <cfif ListFind(get_publish.target_employee,position_cat_id)>checked</cfif>>#position_cat#<br/>
                </cfoutput>
            </td>
            <td>
                <table>
                    <tr>
                        <td class="txtbold">
                            <cf_get_lang dictionary_id='34307.Partner Adresleri'>
                        </td>
                    </tr>
                    <cfloop list="#partner_url#" index="pu" delimiters=";">
                        <tr>
                            <td><cfoutput><input type="checkbox" name="target_website" id="target_website" value="#pu#" <cfif ListFind(get_publish.target_website,pu)>checked</cfif>> #pu#</cfoutput></td>
                        </tr>
                    </cfloop>
                    <tr>
                        <td class="txtbold">
                            <cf_get_lang dictionary_id='34308.Public Adresleri'>
                        </td>
                    </tr>
                    <cfloop list="#server_url#" index="su" delimiters=";">
                        <tr>
                            <td><cfoutput><input type="checkbox" name="target_website" id="target_website" value="#su#" <cfif ListFind(get_publish.target_website,su)>checked</cfif>>#su#</cfoutput></td>
                        </tr>
                    </cfloop>
                </table>
            </td>
        </tr>
    </table>
    <table width="100%" style="text-align:right;">
        <tr>
            <td style="text-align:right;">
                <cf_get_lang dictionary_id="58859.Süreç"> <cf_workcube_process is_upd='0' process_cat_width='100' is_detail='0'>&nbsp;
                <cf_workcube_buttons is_upd='0' add_function='kontrol_publication()' is_cancel='0'>
            </td>
        </tr>
    </table>
</cfform>
<script type="text/javascript">
	function kontrol_publication()
	{
		AjaxFormSubmit('add_publication','div_add_publication',0,'','','<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopupajax_form_publication</cfoutput>','div_related_public');
		return false;
	}
</script>
