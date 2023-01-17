<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<script type="text/javascript">
	function kontrol()
	{
		if(document.employee.keyword.value == '' && document.employee.zone_id.value == '' && document.employee.comp_id.value == '' && document.employee.SSK_OFFICE.value == '')
			{
			alert("<cf_get_lang dictionary_id='54636.En Az Bir Filtre Seçmelisiniz'>!");
			return false;
			}
		return true;
	}
</script>
<cfinclude template="../query/get_ssk_offices.cfm">
<cfquery name="get_our_comp_and_branchs" datasource="#DSN#">
	SELECT
		NICK_NAME,
		COMP_ID
	FROM
		OUR_COMPANY
	ORDER BY
		NICK_NAME
</cfquery>
<cfquery name="ZONES" datasource="#DSN#">
	SELECT ZONE_NAME, ZONE_ID, ZONE_STATUS FROM ZONE ORDER BY ZONE_NAME
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="32110.Personel Durum Çizelgesi"></cfsavecontent>
<div class="col col-12">
    <cf_box title="#message#" print_href="#request.self#?fuseaction=objects.popup_print_files&print_type=176">
        <cfform name="employee" method="post">
                <cf_box_search>
                <div class="form-group medium">
                    <input type="text" name="keyword" id="keyword" maxlength="50" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>">
                </div>
                <div class="form-group small">
                    <input type="text" placeholder="No">
                </div>
                <div class="form-group small">
                    <input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id="57789.Özel Kod">">
                </div>
                <div class="form-group">
                    <select name="SSK_OFFICE" id="SSK_OFFICE">
                        <option value=""><cf_get_lang dictionary_id="30126.Şube Seçiniz"></option>
                        <cfoutput query="GET_SSK_OFFICES">
                            <cfif len(SSK_OFFICE) and len(SSK_NO)>
                                <option value="#SSK_OFFICE#-#SSK_NO#"<cfif isdefined("attributes.SSK_OFFICE") and (attributes.SSK_OFFICE is "#SSK_OFFICE#-#SSK_NO#")> selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
                            </cfif>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <select name="sal_mon" id="sal_mon">
                        <cfif session.ep.period_year lt dateformat(now(),'YYYY')>
                            <cfloop from="1" to="12" index="i">
                                <cfoutput>
                                    <option value="#i#"<cfif isdefined("attributes.sal_mon") and (i eq attributes.sal_mon)> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                </cfoutput>
                            </cfloop>
                        <cfelse>
                            <cfloop from="1" to="12" index="i">
                                <cfoutput>
                                    <option value="#i#"<cfif isdefined("attributes.sal_mon") and (i eq attributes.sal_mon)> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                </cfoutput>
                            </cfloop>
                        </cfif>
                    </select>
                </div>
                <div class="form-group small">
                    <select name="sal_year" id="sal_year">
                        <option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
                        <cfloop from="-5" to="5" index="i">
                            <cfoutput><option value="#session.ep.period_year + i#"<cfif attributes.sal_year eq (session.ep.period_year + i)> selected</cfif>>#session.ep.period_year + i#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
                <cfif isdefined("attributes.ssk_office")>
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module='personel_print' is_ajax='1'>
                </cfif>
            </cf_box_search>
                <cf_box_search_detail search_function="kontrol()">
                            <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                                <select name="zone_id" id="zone_id" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id="53724.Bölge Seçiniz"></option>
                                    <cfoutput query="zones">
                                        <option value="#zone_id#"<cfif isdefined("attributes.zone_id") and (attributes.zone_id eq zone_id)> selected</cfif>>#zone_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                                <select name="comp_id" id="comp_id">
                                    <option value=""><cf_get_lang dictionary_id="54096.Şirket Seçiniz"></option>
                                    <cfoutput query="get_our_comp_and_branchs">
                                        <option value="#comp_id#"<cfif isdefined("attributes.comp_id") and (attributes.comp_id eq comp_id)> selected</cfif>>#NICK_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
            </cf_box_search_detail>
            </div>
        </cfform>
    </cf_box>
    <cfif not isdefined("attributes.ssk_office")>
      <cfexit method="exittemplate">
    </cfif>
    <cfinclude template="../query/get_personel_durum_count.cfm">

    <cf_box title="#message#">
        <div id="personel_print">
            <table style="width:200mm;height:275mm; border: 1px solid #ccc; border-collapse: collapse;" align="center" class="book">
                <tr>
                    <td colspan="13" class="bold">
                        <span class="pull-right">
                            <cf_get_lang dictionary_id="59698.Türkiye İşçi Kurumu"><br/>
                            <cf_get_lang dictionary_id="59699.Aylık İşgücü Çizelgesi">
                        </span>
                    </td>
                </tr>
                <tr>
                    <td colspan="13" class="bold">
                        <span class="pull-right">
                            <cf_get_lang dictionary_id="58724.AY">: <cfoutput>#ListGetAt(ay_list(),attributes.sal_mon)#</cfoutput>
                            - <cf_get_lang dictionary_id="58455.YIL">: <cfoutput>#attributes.sal_year#</cfoutput>
                        </span>
                    </td>
                </tr>
                <tr style="border-top: 1px solid #ccc;">
                    <td colspan="7">
                        <cf_get_lang dictionary_id="59450.İŞYERİNİN ÜNVANI">: <cfoutput>asd#iskur_company_list#</cfoutput><br>
                        <cf_get_lang dictionary_id="52328.FAALİYET ALANI">: <cfoutput>#iskur_real_work#</cfoutput><br>
                        <cf_get_lang dictionary_id="58723.ADRES">: <cfoutput>#iskur_address_list#</cfoutput><br>
                        <cf_get_lang dictionary_id="57499.TELEFON">: <cfoutput>#iskur_tel_code_tel_#</cfoutput><br>
                        <cf_get_lang dictionary_id="36212.E-MAIL ADRESİ">: <cfoutput>#iskur_tel_code_fax_#</cfoutput>
                    </td>
                    <td colspan="6">
                        <cf_get_lang dictionary_id="48358.FAKS">: <cfoutput>#iskur_tel_code_tel_#</cfoutput><br>
                        <cf_get_lang dictionary_id="51251.WEB ADRESİ">: <cfoutput>#iskur_email_#</cfoutput>
                    </td>
                </tr>
                <tr style="border-top: 1px solid #ccc;">
                    <td colspan="13">
                        <span class="bold">
                            <cf_get_lang dictionary_id="39970.İŞKUR NO">: <cfoutput>#iskur_branch_no_#</cfoutput>
                        <br>
                            <cf_get_lang dictionary_id="55663.SGK NO">:
                            <cfoutput>
                                <cfif len(attributes.SSK_OFFICE)>#get_branch.SSK_NO#
                                <cfelseif len(attributes.zone_id)>#valuelist(get_branch.SSK_NO)#
                                <cfelse>
                                <!--- #iskur_ssk_no_# --->
                                <cfloop list="#iskur_ssk_no_#" delimiters="," index="no">
                                    #no#,
                                </cfloop>
                                </cfif>
                            </cfoutput>
                        </span>
                    </td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td width="230">&nbsp;</td>
                    <td colspan="3" style="border: 1px solid #ccc;"><cf_get_lang dictionary_id="59700.GEÇEN AY SONU İTİBARİYLE ÇALIŞANLAR"></td>
                    <td colspan="3" style="border: 1px solid #ccc;"><cf_get_lang dictionary_id="59701.AY İÇİNDE İŞE ALINANLAR"></td>
                    <td colspan="3" style="border: 1px solid #ccc;"><cf_get_lang dictionary_id="59702.AY İÇİNDE İŞTEN AYRILANLAR"></td>
                    <td colspan="3" style="border: 1px solid #ccc;"><cf_get_lang dictionary_id="59703.AY SONU İTİBARİYLE ÇALIŞANLAR"></td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td style="border: 1px solid #ccc;" width="230">&nbsp;</td>
                    <td style="border: 1px solid #ccc;" width="50"><cf_get_lang dictionary_id="58959.ERKEK"></td>
                    <td style="border: 1px solid #ccc;" width="50"><cf_get_lang dictionary_id="58958.KADIN"></td>
                    <td style="border: 1px solid #ccc;" width="50"><cf_get_lang dictionary_id="57492.TOPLAM"></td>
                    <td style="border: 1px solid #ccc;" width="30">E</td>
                    <td style="border: 1px solid #ccc;" width="30">K</td>
                    <td style="border: 1px solid #ccc;" width="30">T</td>
                    <td style="border: 1px solid #ccc;" width="30">E</td>
                    <td style="border: 1px solid #ccc;" width="30">K</td>
                    <td style="border: 1px solid #ccc;" width="30">T</td>
                    <td style="border: 1px solid #ccc;" width="30">E</td>
                    <td style="border: 1px solid #ccc;" width="30">K</td>
                    <td style="border: 1px solid #ccc;" width="30">T</td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td style="border: 1px solid #ccc;" width="230"><cf_get_lang dictionary_id="59704.Belirsiz Süreli iş Sözleşmesine Göre Çalışan Sayısı"></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SURESIZ - STARTED_MEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_SURESIZ - STARTED_WOMEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SURESIZ + ALL_WOMEN_SURESIZ - STARTED_MEN_SURESIZ - STARTED_WOMEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_WOMEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_SURESIZ+STARTED_WOMEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_WOMEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_SURESIZ+FIRED_WOMEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SURESIZ-FIRED_MEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_SURESIZ-FIRED_WOMEN_SURESIZ#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#(ALL_MEN_SURESIZ+ALL_WOMEN_SURESIZ)-(FIRED_MEN_SURESIZ+FIRED_WOMEN_SURESIZ)#</cfoutput></td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td style="border: 1px solid #ccc;" width="230"><cf_get_lang dictionary_id="59705.Belirli Süreli İş Sözleşmesine Göre Çalışan Sayısı"></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SURELI - STARTED_MEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_SURELI - STARTED_WOMEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SURELI + ALL_WOMEN_SURELI - STARTED_MEN_SURELI - STARTED_WOMEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_WOMEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_SURELI+STARTED_WOMEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_WOMEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_SURELI+FIRED_WOMEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SURELI-FIRED_MEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_SURELI-FIRED_WOMEN_SURELI#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#(ALL_MEN_SURELI-FIRED_MEN_SURELI)+(ALL_WOMEN_SURELI-FIRED_WOMEN_SURELI)#</cfoutput></td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td style="border: 1px solid #ccc;" width="230"><cf_get_lang dictionary_id="59706.Kısmi Zamanlı İş Sözleşmesine Göre Çalışan Sayısı"></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_PARTTIME - STARTED_MEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_PARTTIME - STARTED_WOMEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_PARTTIME + ALL_WOMEN_PARTTIME - STARTED_MEN_PARTTIME - STARTED_WOMEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_WOMEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_PARTTIME+STARTED_WOMEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_WOMEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_PARTTIME+FIRED_WOMEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_PARTTIME-FIRED_MEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_PARTTIME-FIRED_WOMEN_PARTTIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#(ALL_MEN_PARTTIME-FIRED_MEN_PARTTIME)+(ALL_WOMEN_PARTTIME-FIRED_WOMEN_PARTTIME)#</cfoutput></td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td style="border: 1px solid #ccc;" width="230"><cf_get_lang dictionary_id="59707.Çalışan Özürlü Sayısı"></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SAKAT - STARTED_MEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_SAKAT - STARTED_WOMEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SAKAT + ALL_WOMEN_SAKAT - STARTED_MEN_SAKAT - STARTED_WOMEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_WOMEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_SAKAT+STARTED_WOMEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_WOMEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_SAKAT+FIRED_WOMEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_SAKAT-FIRED_MEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_SAKAT-FIRED_WOMEN_SAKAT#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#(ALL_MEN_SAKAT-FIRED_MEN_SAKAT)+(ALL_WOMEN_SAKAT-FIRED_WOMEN_SAKAT)#</cfoutput></td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td style="border: 1px solid #ccc;" width="230"><cf_get_lang dictionary_id="59708.Çalışan Eski Hükümlü Sayısı"></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_HUKUMLU - STARTED_MEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_HUKUMLU - STARTED_WOMEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_HUKUMLU + ALL_WOMEN_HUKUMLU - STARTED_MEN_HUKUMLU - STARTED_WOMEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_WOMEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_HUKUMLU+STARTED_WOMEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_WOMEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_HUKUMLU+FIRED_WOMEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_HUKUMLU-FIRED_MEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_HUKUMLU-FIRED_WOMEN_HUKUMLU#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#(ALL_MEN_HUKUMLU-FIRED_MEN_HUKUMLU)+(ALL_WOMEN_HUKUMLU-FIRED_WOMEN_HUKUMLU)#</cfoutput></td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td style="border: 1px solid #ccc;" width="230"><cf_get_lang dictionary_id="59709.Terörle Mücadele kanunu kap. Çalışan Sayısı"></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_TEROR - STARTED_MEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_TEROR - STARTED_WOMEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_TEROR + ALL_WOMEN_TEROR - STARTED_MEN_TEROR - STARTED_WOMEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_WOMEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#STARTED_MEN_TEROR+STARTED_WOMEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_WOMEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#FIRED_MEN_TEROR+FIRED_WOMEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_MEN_TEROR-FIRED_MEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#ALL_WOMEN_TEROR-FIRED_WOMEN_TEROR#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" align="center"><cfoutput>#(ALL_MEN_TEROR-FIRED_MEN_TEROR)+(ALL_WOMEN_TEROR-FIRED_WOMEN_TEROR)#</cfoutput></td>
                </tr>
                <tr style="border-top: 1px solid #ccc;text-align:center;" class="bold">
                    <td colspan="13"><cf_get_lang dictionary_id="59703.AY SONU İTİBARİYLE ÇALIŞANLARDAN"></td>
                </tr>
                <tr style="border-top: 1px solid #ccc;">
                    <td style="border: 1px solid #ccc;" colspan="4"><cf_get_lang dictionary_id="59710.VARSA KISMİ ZAMANLI ÇALIŞANLAR"></td>
                    <td style="border: 1px solid #ccc;" colspan="9"><cf_get_lang dictionary_id="59711.VARSA YER ALTI/SUALTI İŞLERİNDE ÇALIŞANLAR"></td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align:center;">
                    <td style="border: 1px solid #ccc;" colspan="4"><cf_get_lang dictionary_id="59712.KISMİ ZAMANLI İŞ SÖZLEŞMESİNE GÖRE ÇALIŞANLARIN TAMAMININ AYLIK ÇALIŞMA SAATLERİ TOPLAMI"></td>
                    <td style="border: 1px solid #ccc;" colspan="3"><cf_get_lang dictionary_id="58959.ERKEK"></td>
                    <td style="border: 1px solid #ccc;" colspan="3"><cf_get_lang dictionary_id="58958.KADIN"></td>
                    <td style="border: 1px solid #ccc;" colspan="3"><cf_get_lang dictionary_id="57492.TOPLAM"></td>
                </tr>
                <tr style="border-top: 1px solid #ccc; text-align: center;">
                    <td style="border: 1px solid #ccc;" colspan="4"><cfoutput>#TOPLAM_PART_TIME#</cfoutput></td>
                    <td style="border: 1px solid #ccc;" colspan="3"></td>
                    <td style="border: 1px solid #ccc;" colspan="3"></td>
                    <td style="border: 1px solid #ccc;" colspan="3"></td>
                </tr>
                <tr style="border-top: 1px solid #ccc;">
                    <td colspan="13">
                        <cf_get_lang dictionary_id="57467.NOT">:1- <cf_get_lang dictionary_id="59713.Geçen ay sonu itibariyle çalışanlar, ay içinde işe alınanlar, ay içinde işten ayrılanlar ve ay sonu
                        itibariyle çalışanlar sutünlarında Belirsiz, Belirli veya Kısmi Zamanlı İş Sözleşmelerine göre yeraltı ve su altı işlerinde çalışanlarda dahil edilerek gösterilecektir."><br>
                        2-<cf_get_lang dictionary_id="59714.Yeraltı ve su altı işlerinde çalışanlar, Kurumca özürlü kontenjan hesaplanmasına dahil edilmeyecektir. Ayrıca özürlüler yer altı ve
                        su altı işlerinde çalıştırılmayacaktır.">
                    </td>
                </tr>
                <tr style="border-top: 1px solid #ccc;">
                    <td colspan="13">
                        <tr>
                            <td colspan="13">a) <cf_get_lang dictionary_id="59715.Karşılanmasında güçlük çekilen meslekleri (varsa önceliklerine göre) sıralayınız"></td>
                        </tr>
                        <tr colspan="13">
                            <td>1-<br>2-<br>3-<br>4-<br>5-</td>
                        </tr>
                        <tr>
                            <td colspan="13">b) <cf_get_lang dictionary_id="59716.Kurumla ortaklaşa meslek edindirme, geliştirme ve değiştirme kursu düzenlemek ister misiniz">?</td>
                        </tr>
                        <tr>
                            <td><input type="radio" name="meslekedinme" id="meslekedinme"> <cf_get_lang dictionary_id="57495.Evet"><input type="radio" name="meslekedinme" id="meslekedinme" checked> <cf_get_lang dictionary_id="57496.Hayır"></td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="13">c) <cf_get_lang dictionary_id="59717.Kurumun işletmelerde eğitim faaliyetlerinden yararlanmak ister misiniz">?<br><input type="radio" name="egitim" id="egitim"> <cf_get_lang dictionary_id="57495.Evet"> <input type="radio" name="egitim" id="egitim" checked> <cf_get_lang dictionary_id="57496.Hayır"></td>
                        </tr>
                        <tr>
                            <td colspan="13">d) <cf_get_lang dictionary_id="59718.Önümüzdeki ay içersinde işgücü gereksinimlerinizde bir değişim bekliyor musunuz">?</td>
                            </tr>
                        <tr>
                            <td colspan="13">
                                <input type="radio" name="isgucu" id="isgucu"><cf_get_lang dictionary_id="59719.Azalacak">
                                <input type="radio" name="isgucu" id="isgucu" checked> <cf_get_lang dictionary_id="59720.Değişmeyecek">
                                <input type="radio" name="isgucu" id="isgucu" checked> <cf_get_lang dictionary_id="59721.Artacak">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="13">
                                e) <cf_get_lang dictionary_id="59722.Önümüzdeki ay içersinde çırak gereksinimi olacak mı">?
                            </td>
                        </tr>
                        <tr>
                            <td colspan="13">
                                <input type="radio" name="cirak" id="cirak"> <cf_get_lang dictionary_id="57495.Evet">
                                <input type="radio" name="cirak" id="cirak" checked> <cf_get_lang dictionary_id="57496.Hayır">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="13">f) <cf_get_lang dictionary_id="59723.Kurum hizmetlerinden yararlanmak istediğinizde 180 numaralı telefonu arayabilirsiniz"></td>
                            </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="13">
                            (*)<cf_get_lang dictionary_id="59724.Özürlü, eski hükümlü ve terörden etkilenenler olarak çalışanların dışındakileri belirleyiniz">.<br/>
                            (**)<cf_get_lang dictionary_id="59725.Varsa Kısmi Zamanlı İş Sözleşmesine göre çalışanları belirtiniz">.<br/>
                            (***)<cf_get_lang dictionary_id="59726.Terörle Mücadele kanunu kapsamında çalışılan şehit ve çalışamayacak derecede malül olanların yakınları ile çalışabilecek durumdakileri belirtiniz">.<br/>
                            (****)(<cf_get_lang dictionary_id="59727.Değişik:19/07/2002 - 10999 sayılı Makam Onayı">) <cf_get_lang dictionary_id="59728.Kamu Kesimi işyerlerince, ay içinde işe alınanların tümü ekli Form 7 2/1 'de gösterilecek ve bu çizelge ile birlikte Kuruma gönderilecektir">.<br/>
                            (*****)(<cf_get_lang dictionary_id="59727.Değişik:19/07/2002 - 10999 sayılı Makam Onayı">) <cf_get_lang dictionary_id="59729.Kamu Kesimi işyerlerince , ay içinde işe alınanların tümü ekli Form 7 2/2 'de gösterilecek ve bu çizelge ile birlikte Kuruma gönderilecektir">.<br/>
                            (******) <cf_get_lang dictionary_id="59730.Kısmi zamanlı çalışanların olması halinde bunların tamamının ay içindeki çalışma saatleri toplamını belirtiniz">.
                            </td>
                            </tr>
                    </td>
                </tr>
            </table>
        </div>
    </cf_box>
</div>