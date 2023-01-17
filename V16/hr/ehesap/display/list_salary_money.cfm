<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<cfif not isdefined('attributes.salary_year')>
	<cfset attributes.salary_year = year(now())>
</cfif>
<cfif not isdefined('attributes.salary_mon')>
	<cfset attributes.salary_mon = month(now())>
</cfif>
<cfinclude template="../query/get_moneys.cfm">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_salary_moneys.cfm">
<cfelse>
	<cfset get_salary_moneys.recordcount = 0>
</cfif>
<cfquery name="get_xml_zone_control" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'ehesap.popup_form_add_salary_money' AND
		PROPERTY_NAME = 'xml_zone_control'
        </cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_salary_moneys.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.list_salary_money" method="post" name="filter_list_salary_money">
            <input type="hidden" name="is_submit" id="is_submit" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <select name="salary_year" id="salary_year" style="width:75px;" >
                        <option value="0" <cfif attributes.salary_year IS 0>selected</cfif>><cf_get_lang dictionary_id='58081.hepsi'>
                        <cfloop from="#session.ep.period_year-3#" to="#session.ep.period_year+3#" index="i">
                            <cfoutput>
                                <option value="#i#"<cfif attributes.salary_year eq i> selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="salary_mon" id="salary_mon" style="width:100px;">
                        <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop from="1" to="12" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif isdefined("attributes.salary_mon") and attributes.salary_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="salary_money" id="salary_money" style="width:100px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_moneys">
                            <option value="#money#" <cfif isdefined("attributes.salary_money") and attributes.salary_money eq money>selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <!--- <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'> 	 --->
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53081.Döviz Karşılıkları"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
                    <th><cf_get_lang dictionary_id='58455.Yıl'></th>
                    <th><cf_get_lang dictionary_id='58724.Ay'></th>
                    <cfif get_xml_zone_control.property_value eq 1>
                        <th><cf_get_lang dictionary_id='57992.Bölge'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='53138.Para'></th>
                    <th><cf_get_lang dictionary_id='58660.Değeri'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_add_salary_money</cfoutput>','small')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id="57582.Ekle">" alt="<cf_get_lang dictionary_id="57582.Ekle">"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_salary_moneys.recordcount>
                    <cfoutput query="GET_SALARY_MONEYS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#salary_year#</td>
                            <td>
                                <cfswitch expression = "#salary_month#">
                                    <cfcase value="1"><cf_get_lang dictionary_id='57592.Ocak'></cfcase>
                                    <cfcase value="2"><cf_get_lang dictionary_id='57593.Şubat'></cfcase>
                                    <cfcase value="3"><cf_get_lang dictionary_id='57594.Mart'></cfcase>
                                    <cfcase value="4"><cf_get_lang dictionary_id='57595.Nisan'></cfcase>
                                    <cfcase value="5"><cf_get_lang dictionary_id='57596.Mayıs'></cfcase>
                                    <cfcase value="6"><cf_get_lang dictionary_id='57597.Haziran'></cfcase>
                                    <cfcase value="7"><cf_get_lang dictionary_id='57598.Temmuz'></cfcase>
                                    <cfcase value="8"><cf_get_lang dictionary_id='57599.Ağustos'></cfcase>
                                    <cfcase value="9"><cf_get_lang dictionary_id='57600.Eylül'></cfcase>
                                    <cfcase value="10"><cf_get_lang dictionary_id='57601.Ekim'></cfcase>
                                    <cfcase value="11"><cf_get_lang dictionary_id='57602.Kasım'></cfcase>
                                    <cfcase value="12"><cf_get_lang dictionary_id='57603.Aralık'></cfcase>
                                </cfswitch>
                            </td>
                            <cfif get_xml_zone_control.property_value eq 1>
                                <td>#zone_name#</td>
                            </cfif>
                            <td>#money#</td>
                            <td>#TLFormat(worth,8)#</td>
                            <!-- sil -->
                            <td style="text-align:center;"><a href="JAVASCRIPT://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_salary_money&salary_year=#salary_year#&salary_month=#salary_month#&zone_id=#zone_id#','small')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="57464.Güncelle">" alt="<cf_get_lang dictionary_id="57464.Güncelle">"></i></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="7"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                        </tr>
                </cfif>
            </tbody>
        </cf_flat_list>

        <cfset url_str = "">
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.salary_year") and len(attributes.salary_year)>
            <cfset url_str = "#url_str#&salary_year=#attributes.salary_year#">
        </cfif>
        <cfif isdefined("attributes.salary_mon") and len(attributes.salary_mon)>
            <cfset url_str = "#url_str#&salary_mon=#attributes.salary_mon#">
        </cfif>
        <cfif isdefined("attributes.salary_money") and len(attributes.salary_money)>
            <cfset url_str = "#url_str#&salary_money=#attributes.salary_money#">
        </cfif>
        <cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
            <cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="ehesap.list_salary_money#url_str#">
    </cf_box>
</div>
