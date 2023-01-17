<!--- formun bagli oldugu form hic onay almadi ise kaydet butonlari ilk amire gorunuyor--->
<cfparam name="attributes.meet_form_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id ='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id ='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id ='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id ='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id ='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id ='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id ='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id ='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id ='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id ='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id ='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id ='57603.Aralık'></cfsavecontent>
<cfscript>
</cfscript>
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfset position_list=valuelist(get_emp_pos.POSITION_CODE,',')>
<cfquery name="GET_FORM" datasource="#dsn#">
	SELECT FIRST_BOSS_ID,FIRST_BOSS_VALID,FIRST_BOSS_CODE FROM PERF_MEET_FORM WHERE FORM_ID = #attributes.meet_form_id#
</cfquery>

<cf_form_box title="#getLang('hr',1651)#">
    <cfform name="add_per_form" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_career_form" enctype="multipart/form-data">
    	<input type="hidden" name="meet_form_id" id="meet_form_id" value="<cfoutput>#attributes.meet_form_id#</cfoutput>">
        <table>
            <tr>
                <td align="center" class="formbold" colspan="2"><cf_get_lang dictionary_id ='56737.Gizli'></td>
            </tr>
            <tr class="color-list">
                <td colspan="2" class="txtbold"><cf_get_lang dictionary_id ='56575.Personelin'></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='57897.Adı'>-<cf_get_lang dictionary_id ='58550.Soyadı'>:</td>
                <td colspan="2"><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56649.Çalışan Seçmelisiniz'> !</cfsavecontent>
                    <cfinput type="text" readonly="yes" name="emp_name" value="#get_emp_info(attributes.employee_id,0,0)#" required="yes" message="#message#" style="width:180px;">
                </td>
            </tr>
            <tr class="color-list">
                <td colspan="2" class="txtbold"><cf_get_lang dictionary_id ='56738.E POTANSİYEL DEĞERLENDİRMESİ'> /<cf_get_lang dictionary_id ='56739.KARİYER PLANLAMASI'> </td>
            </tr>
            <tr>
                <td colspan="2">(<cf_get_lang dictionary_id ='56740.Personelin görevi ve gelecekte sorumluluk alabileceği görevler açısından potansiyel değerlendirme ve kariyer ile ilgili geliştirme planları'>)</td>
            </tr>
            </table>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="56741.Görevine uygunluğu / yatkınlığı"></cfsavecontent>
            <cf_seperator id="gorev" title="#message#">
            <table id="gorev">
                <tr>
                    <td colspan="2">(<cf_get_lang dictionary_id ='56742.Personel görevi ile ilgili beklentilere ne kadar uyumlu olduğu ile bilgi ve yeteneklerinin yeterliliğini değerlendiriniz'>)</td>
                </tr>
                <tr><cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
	                <td colspan="2"><textarea name="position_fit" id="position_fit" style="width:550px;height:100px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
                </tr>
            </table>
            <cfsavecontent variable="right_image">
                <a href="##" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_perf_pot_table</cfoutput>','list')"><img src="/images/extre.gif" border="0" title="<cf_get_lang no ='1659.Performans / Potansiyel Değerlendirme Formu'>" align="absmiddle"></a></td>
            </cfsavecontent>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="56743.Farklı / üst göreve atanma potansiyeli"></cfsavecontent>
			<cf_seperator id="farkli_ust" title="#message# #right_image#">
            <table id="farkli_ust">
            <tr>
                <td colspan="2">(<cf_get_lang dictionary_id ='56745.Personel farklı / üst göreve atanması için  yeterli bilgi ve yeteneklere, liderlik ve esneklik gibi özelliklere sahip olup olmasığını
                yukarıdaki butona tıklayarak açılan Performans/Potansiyel Değerlendirme Tablosunda uygun alternatifi seçerek değerlendiriniz'>.)</td>
            </tr>
            <tr>
                <td colspan="2">
                    <select name="appointment_potential" id="appointment_potential" style="width:100px">
                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        <option value="1">A1</option>
                        <option value="2">A2</option>
                        <option value="3">A3</option>
                        <option value="4">B1</option>
                        <option value="5">B2</option>
                        <option value="6">B3</option>
                        <option value="7">C1</option>
                        <option value="8">C2</option>
                        <option value="9">C3</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <textarea name="appointment_potential_detail" id="appointment_potential_detail" style="width:550px;height:100px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                </td>
            </tr>
            </table>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="56746.Geliştirme/Yerleştirme planları"></cfsavecontent>
            <cf_seperator id="gelistirme" title="#message#">
			<table id="gelistirme">
            <tr>
                <td colspan="2">(<cf_get_lang dictionary_id ='56747.Gelecek üç yıllık dönem içinde personelin geliştirme ya da farklı/üst göreve atanmasıyla ilgili planlar'>)</td>
            </tr>
            <tr>
                <td colspan="2">
                    <table>
                        <tr class="txtbold">
                            <td><cf_get_lang dictionary_id ='56748.Geliştirme Planları'></td>
                            <td><cf_get_lang dictionary_id ='56749.Önerilen Tarih'></td>
                            <td><cf_get_lang dictionary_id="37657.Program">/<cf_get_lang dictionary_id ='57480.Konu'>/<cf_get_lang dictionary_id ='56750.İş İçeriği'></td>
                            <td><cf_get_lang dictionary_id ='1666.Karşılaşılabilecek Sorunlar'></td>
                        </tr>
                        <tr>
                            <td>a.<cf_get_lang dictionary_id ='56752.İş zenginleştirme olasılığı'> </td>
                            <td><select name="offer_month1" id="offer_month1">
                                    <cfloop from="1" to="12" index="j">
                                        <cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
                                    </cfloop>
                                </select>
                                <select name="offer_year1" id="offer_year1">
                                    <cfloop from="#dateFormat(now(),'yyyy')#" to="#year(now())+3#" index="j">
                                        <cfoutput><option value="#j#">#j#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </td>
                            <td><input type="text" name="work_content1" id="work_content1" value="" style="width:150px;"></td>
                            <td><input type="text" name="problem1" id="problem1" value="" style="width:150px;"></td>
                        </tr>
                        <tr>
                            <td>b.<cf_get_lang dictionary_id='56753.Transfer olasılığı'> </td>
                            <td><select name="offer_month2" id="offer_month2">
                                    <cfloop from="1" to="12" index="j">
                                        <cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
                                    </cfloop>
                                </select>
                                <select name="offer_year2" id="offer_year2">
                                    <cfloop from="#dateFormat(now(),'yyyy')#" to="#year(now())+3#" index="j">
                                        <cfoutput><option value="#j#">#j#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </td>
                            <td><input type="text" name="work_content2" id="work_content2" value="" style="width:150px;"></td>
                            <td><input type="text" name="problem2" id="problem2" value="" style="width:150px;"></td>
                        </tr>
                        <tr>
                            <td>c.<cf_get_lang dictionary_id ='56754.Terfi olasılığı'> </td>
                            <td><select name="offer_month3" id="offer_month3">
                                    <cfloop from="1" to="12" index="j">
                                        <cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
                                    </cfloop>
                                </select>
                                <select name="offer_year3" id="offer_year3">
                                    <cfloop from="#dateFormat(now(),'yyyy')#" to="#year(now())+3#" index="j">
                                        <cfoutput><option value="#j#">#j#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </td>
                            <td><input type="text" name="work_content3" id="work_content3" value="" style="width:150px;"></td>
                            <td><input type="text" name="problem3" id="problem3" value="" style="width:150px;"></td>
                        </tr>
                    </table>
                </td>
            </tr>
          </table>
		<cf_form_box_footer><cfif GET_FORM.FIRST_BOSS_VALID neq 1 and listfind(position_list,GET_FORM.FIRST_BOSS_CODE,',')><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cfif></cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
function kontrol()
{	
	if(document.add_per_form.appointment_potential.value.length==0)
	{
		alert("<cf_get_lang dictionary_id ='56755.Potansiyel Seçmelisiniz'> !");
		return false;
	}
}	
</script>
