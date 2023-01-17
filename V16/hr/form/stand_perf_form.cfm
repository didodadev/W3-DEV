<cfparam name="attributes.meet_form_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfset position_list=valuelist(get_emp_pos.POSITION_CODE,',')>
<cfquery name="GET_FORM" datasource="#dsn#">
	SELECT FIRST_BOSS_ID,FIRST_BOSS_CODE,FIRST_BOSS_VALID,START_DATE,FINISH_DATE FROM PERF_MEET_FORM WHERE FORM_ID = #attributes.meet_form_id#
</cfquery>
<cf_form_box title="#getLang('hr',581)#">
	<cfform name="add_perf_emp_info" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_stand_perf_form" enctype="multipart/form-data">
    	<cf_seperator id="performans" title="Performans Değerlendirme Kriterleri">
    	<table id="performans">
            <tr>
                <td class="txtbold" colspan="2"><cf_get_lang dictionary_id="46196.Değerlendirilen"></td>
            </tr>
            <tr>
                <td width="100"><cf_get_lang dictionary_id="30368.Çalışan"> *</td>
                <td>
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="43281.Çalışan Seçmelisiniz"> !</cfsavecontent>
                    <cfinput type="text" name="emp_name" readonly="yes" value="#get_emp_info(attributes.employee_id,0,0)#" required="yes" message="#message#" style="width:180px;">
                </td>
            </tr>
            <tr>
                <td class="txtbold" colspan="2"><cf_get_lang dictionary_id="31937.Değerlendiren"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id="46198.İlk Amir"> *</td>
                <td>
                    <input type="hidden" name="amir_id" id="amir_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="56573.Amir Seçmelisiniz"> !</cfsavecontent>
                    <cfif GET_FORM.FIRST_BOSS_VALID eq 1>
                        <cfinput type="text" name="amir_name" readonly="yes" value="#get_emp_info(GET_FORM.FIRST_BOSS_ID,0,0)#" required="yes" message="#message#" style="width:180px;">
                    <cfelse>
                        <cfinput type="text" name="amir_name" readonly="yes" value="#get_emp_info(GET_FORM.FIRST_BOSS_CODE,1,0)#" required="yes" message="#message#" style="width:180px;">
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58472.Dönem'> *</td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                    <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="#dateformat(get_form.start_date,dateformat_style)#" style="width:80px;">
                    <cf_wrk_date_image date_field="start_date">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                    <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="#dateformat(get_form.finish_date,dateformat_style)#" style="width:77px;">
                    <cf_wrk_date_image date_field="finish_date">
                </td>
            </tr>
		</table>
        <cf_seperator id="basari" title="Başarı Puanı (1-5) Açıklaması">
        <table id="basari">
            <tr>
                <td colspan="2" width="450">
                    <strong>1</strong>:<cf_get_lang dictionary_id="41078.Yetersiz">, <strong>2</strong>:<cf_get_lang dictionary_id="41075.Yeterlinin Altında">, <strong>3</strong>:<cf_get_lang dictionary_id="41073.Yeterli">, <strong>4</strong>:<cf_get_lang dictionary_id="46443.İyi">, <strong>5</strong>:<cf_get_lang dictionary_id="46444.Çok İyi">,<br/>
                    <strong>UO</strong>:<cf_get_lang dictionary_id="41072.Uygulaması Olmayan">
                </td>
                <td class="txtbold" width="25">UO</td>
                <td class="txtbold" width="50"><cf_get_lang dictionary_id="41070.Başarı Puanı"> (1-5)</td>
                <td class="txtbold" width="250" style="text-align:center;"><cf_get_lang dictionary_id="59067.Açıklama"></td>
            </tr>
        </table>
        <cf_seperator id="bilgi" title="Bilgi (KNOW_HOW)">
        <table id="bilgi">
            <tr>
                <td class="txtbold" width="150" valign="top"><cf_get_lang dictionary_id="41069.Bilgi Düzeyi">/<cf_get_lang dictionary_id="41068.Bakış Açısı"></td>
                <td valign="top" width="300"><cf_get_lang dictionary_id="41067.Göreve ilişkin teknik, mesleki bilginin yeterliliği, varsa bu konudaki sorunları, bu sorunların diğer faaliyet alanları
                ile olan ilişkilerini geniş perspektifle ve detaylı olarak görebilme"></td>
                <td valign="top" width="25"><input type="checkbox" name="bilgi_1_uo" id="bilgi_1_uo" value="1" onClick="uo_count(this,'bilgi')"></td>
                <td valign="top" width="50"><select name="bilgi_1" id="bilgi_1" onChange="bölüm_hesapla('bilgi');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                    <textarea name="bilgi_1_detail" id="bilgi_1_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                </td>
            </tr>
            <tr>
                <td class="txtbold" width="150" valign="top"><cf_get_lang dictionary_id="41066.Uygulama Becerisi"> / <cf_get_lang dictionary_id="41065.Çözüm Bulabilme"></td>
                <td valign="top"><cf_get_lang dictionary_id="41063.Görevle ilgili uygulama bilgi ve becerisinin yeterliliği ile sorunlara tarafsız ve duygusallıktan arınmış, kabul görebilir, 
                uygulanabilir çözümler bularak yaklaşabilme ve bunları hayata geçirebilme, gerçekleştirebilme"></td>
                <td valign="top" width="25"><input type="checkbox" name="bilgi_2_uo" id="bilgi_2_uo" value="1" onClick="uo_count(this,'bilgi')"></td>
                <td valign="top" width="50"><select name="bilgi_2" id="bilgi_2" onChange="bölüm_hesapla('bilgi');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="bilgi_2_detail" id="bilgi_2_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="41062.Uzmanlık"></td>
                <td valign="top"><cf_get_lang dictionary_id="41061.Göreve ilişkin uzmanlık/ihtisaslaşma düzeyi, konulara hakimiyet derecesi, ortaya çıkan soruların özünü belirleyebilme"></td>
                <td valign="top"><input type="checkbox" name="bilgi_3_uo" id="bilgi_3_uo" value="1" onClick="uo_count(this,'bilgi')"></td>
                <td valign="top"><select name="bilgi_3" id="bilgi_3" onChange="bölüm_hesapla('bilgi');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="bilgi_3_detail" id="bilgi_3_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="35162.Yabancı Diller"></td>
                <td valign="top"><cf_get_lang dictionary_id="41060.Görevin gerektirdiği yabancı dillerin, sözlü ve yazılı, akıcı iletişim kurabilecek düzeyde olup olmadığı, değil ise ulaşılması hedeflenen duruma göre bulunduğu seviye"></td>
                <td valign="top"><input type="checkbox" name="bilgi_4_uo" id="bilgi_4_uo" value="1" onClick="uo_count(this,'bilgi')"></td>
                <td valign="top"><select name="bilgi_4" id="bilgi_4" onChange="bölüm_hesapla('bilgi');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="bilgi_4_detail" id="bilgi_4_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td colspan="3" align="center" class="txtbold"><cf_get_lang dictionary_id="41059.BİLGİ (KNOW-HOW) TOPLAMI"></td>
                <td colspan="2"><cfinput type="text" name="toplam_bilgi" value="" style="width:20px" maxlength="1" readonly="yes"></td>
            </tr>							
        </table>
        <cf_seperator id="organizasyon" title="İŞ ORGANİZASYONU / YÖNETİM">
        <table id="organizasyon">
            <tr>
                <td class="txtbold" width="150" valign="top"><cf_get_lang dictionary_id="58123.Planlama"></td>
                <td valign="top"><cf_get_lang dictionary_id="41038.İşlerin istenen kalitatif ve kantitatif özelliklerde ve belirlenen terminlerde tamamlanmalarını sağlayacak	öncelikleri saptayarak uygun eylem akışlarını tesis etme"></td>
                <td valign="top" width="25"><input type="checkbox" name="org_1_uo" id="org_1_uo" value="1" onClick="uo_count(this,'org')"></td>
                <td valign="top" width="50"><select name="org_1" id="org_1" onChange="bölüm_hesapla('org');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="org_1_detail" id="org_1_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="55364.Karar Verme"></td>
                <td valign="top"><cf_get_lang dictionary_id="41037.Göreve ilişkin konularda karar verme ve öncelikleri saptama mantığı, eylem sonuçlarına bakıldığında varılan kararların doğruluğu, tutarlılığı"></td>
                <td valign="top"><input type="checkbox" name="org_2_uo" id="org_2_uo" value="1" onClick="uo_count(this,'org')"></td>
                <td valign="top"><select name="org_2" id="org_2" onChange="bölüm_hesapla('org');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="org_2_detail" id="org_2_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="51495.Uygulama"></td>
                <td valign="top"><cf_get_lang dictionary_id="41252.Kullanımda bulunan tüm kaynaklardan verimli şekilde yararlanarak etkin olarak amaçları gerçekleştirme yönünde	görev kapsamındaki işlerin organize edilmesi, yürütülmesi, koordinasyonu, astlara yetki ve sorumluluk devri"></td>
                <td valign="top"><input type="checkbox" name="org_3_uo" id="org_3_uo" value="1" onClick="uo_count(this,'org')"></td>
                <td valign="top"><select name="org_3" id="org_3" onChange="bölüm_hesapla('org');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="org_3_detail" id="org_3_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="30185.Kontrol"></td>
                <td valign="top"><cf_get_lang dictionary_id="41251.Görevin sorumluluğu içindeki işleri ve astları çalışma amaçları doğrultusunda izleme, denetleme, düzeltme, yönlendirme ve/veya değişiklikler konusunda uyarma"></td>
                <td valign="top"><input type="checkbox" name="org_4_uo" id="org_4_uo" value="1" onClick="uo_count(this,'org')"></td>
                <td valign="top"><select name="org_4" id="org_4" onChange="bölüm_hesapla('org');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="org_4_detail" id="org_4_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td colspan="3" align="center" class="txtbold"><cf_get_lang dictionary_id="56577.İŞ ORGANİZASYONU">/<cf_get_lang dictionary_id="41250.YÖNETİM TOPLAMI"></td>
                <td colspan="2"><cfinput type="text" name="toplam_org" value="" style="width:20px" maxlength="1" readonly="yes"></td>
            </tr>							
        </table>
        <cf_seperator id="problem_cozme" title="PROBLEM ÇÖZME">
        <table id="problem_cozme">
            <tr>
                <td class="txtbold" width="150" valign="top"><cf_get_lang dictionary_id="41249.Sorumluluk Alma"></td>
                <td valign="top"><cf_get_lang dictionary_id="Delege edilen ve kendiliğinden üstlenilen işlerin yürütülmesi sırasında sorumluluk alma ve kullanmadaki cesaret ve isteklilik, gerektiğinde tek başına karar verebilme, olaylara yön verme, etkileme
                amacıyla çaba gösterme"></td>
                <td valign="top" width="25"><input type="checkbox" name="prob_1_uo" id="prob_1_uo" value="1" onClick="uo_count(this,'prob')"></td>
                <td valign="top" width="50"><select name="prob_1" id="prob_1" onChange="bölüm_hesapla('prob');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="prob_1_detail" id="prob_1_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="41247.Analiz ve Sentez"></td>
                <td valign="top"><cf_get_lang dictionary_id="41225.Potansiyel konu ve problemleri belirleme, inceleme, ilgili verileri toplama ve analiz etme, eldeki 
                verilere göre sorunların muhtemel nedenlerini ortaya koyma; özel dikkat gerektiren konuları ve karmaşık problemleri kavrama ve
                muhakeme etme, diziler halinde parçalara ayırabilme, neden-sonuç ilişkilerini kurarak parçaları yeniden birleştirme ve 
                alternatif önerilere yönlendirme; farklı fikir, kavram ve tasarıları bütünleştirme"></td>
                <td valign="top"><input type="checkbox" name="prob_2_uo" id="prob_2_uo" value="1" onClick="uo_count(this,'prob')"></td>
                <td valign="top"><select name="prob_2" id="prob_2" onChange="bölüm_hesapla('prob');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="prob_2_detail" id="prob_2_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="41208.Yaratıcılık"></td>
                <td valign="top"><cf_get_lang dictionary_id="41197.Görev yürütümünde organizasyonun yararlanabileceği yeni tasarıları, yöntemleri, yararlılıkları, kolaylıkları bulma"></td>
                <td valign="top"><input type="checkbox" name="prob_3_uo" id="prob_3_uo" value="1" onClick="uo_count(this,'prob')"></td>
                <td valign="top"><select name="prob_3" id="prob_3" onChange="bölüm_hesapla('prob');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="prob_3_detail" id="prob_3_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="32219.Zaman Yönetimi"></td>
                <td valign="top"><cf_get_lang dictionary_id="41192.Görevin yürütülmesi ve sorunların çözülmesinde gereği kadar süre ayırarak zamanı etkin kulanma, doğru zamanlama
                yapma ve iş teslim terminlerine uymada hassasiyet gösterme"></td>
                <td valign="top"><input type="checkbox" name="prob_4_uo" id="prob_4_uo" value="1" onClick="uo_count(this,'prob')"></td>
                <td valign="top"><select name="prob_4" id="prob_4" onChange="bölüm_hesapla('prob');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="prob_4_detail" id="prob_4_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td colspan="3" align="center" class="txtbold"><cf_get_lang dictionary_id="41191.PROBLEM ÇÖZME TOPLAMI"></td>
                <td colspan="2"><cfinput type="text" name="toplam_prob" value="" style="width:20px" maxlength="1" readonly="yes"></td>
            </tr>							
        </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="56579.İnsan İlişkileri">
        <cf_seperator id="insan_iliskileri" title="#message#">
        <table id="insan_iliskileri">
            <tr>
                <td class="txtbold" width="150" valign="top"><cf_get_lang dictionary_id="55368.Motivasyon"></td>
                <td valign="top"><cf_get_lang dictionary_id="41190.Belirlenen amaçlara ulaşabilmek amacıyla kişinin kendisini ve/veya bir grubu etkileyerek
                moralleri yüksek ve hedeflere ulaşmadaki istekliliği kuvvetli tutabilme"></td>
                <td valign="top" width="25"><input type="checkbox" name="relation_1_uo" id="relation_1_uo" value="1" onClick="uo_count(this,'relation')"></td>
                <td valign="top" width="50"><select name="relation_1" id="relation_1" onChange="bölüm_hesapla('relation');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="relation_1_detail" id="relation_1_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="41183.Ekip Çalışması"></td>
                <td valign="top"><cf_get_lang dictionary_id="41182.Ortak bir hedefe ulaşma yönünde aynı seviyedekilerle ve/veya astlarla ve/veya üstlerle ekiplerde
                çalışmaya yatknlık, ekip içindeki çalışmalarındaki irade, enerji, etkinlik ve katkı"></td>
                <td valign="top"><input type="checkbox" name="relation_2_uo" id="relation_2_uo" value="1" onClick="uo_count(this,'relation')"></td>
                <td valign="top"><select name="relation_2" id="relation_2" onChange="bölüm_hesapla('relation');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="relation_2_detail" id="relation_2_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="55345.İletişim Kurma"></td>
                <td valign="top"><cf_get_lang dictionary_id="41181.Etkin dinleme; bilgi ve görüşleri etkili, anlaşılır ve net olarak hiyerarşik iletişim kurallarına
                özen göstererek aktarma; üçüncü kişilerle şirket yararına iyi ilişkiler kurma"></td>
                <td valign="top"><input type="checkbox" name="relation_3_uo" id="relation_3_uo" value="1" onClick="uo_count(this,'relation')"></td>
                <td valign="top"><select name="relation_3" id="relation_3" onChange="bölüm_hesapla('relation');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="relation_3_detail" id="relation_3_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="41179.Başkalarını Geliştirme"></td>
                <td valign="top"><cf_get_lang dictionary_id="41178.Astları ve/veya çalışma arkadaşlarını ve/veya iç ve dış müşterileri bilgilendirme, yönlendirme,
                eğitme, düzeltme ve imkanlar çerçevesinde yardım etme"></td>
                <td valign="top"><input type="checkbox" name="relation_4_uo" id="relation_4_uo" value="1" onClick="uo_count(this,'relation')"></td>
                <td valign="top"><select name="relation_4" id="relation_4" onChange="bölüm_hesapla('relation');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="relation_4_detail" id="relation_4_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td colspan="3" align="center" class="txtbold"><cf_get_lang dictionary_id="41177.İnsan İlişkileri Toplamı"></td>
                <td colspan="2"><cfinput type="text" name="toplam_relation" value="" style="width:20px" maxlength="1" readonly="yes"></td>
            </tr>							
        </table>
        <cf_seperator id="basari_" title="BAŞARI">
        <table id="basari_">
            <tr>
                <td class="txtbold" width="150" valign="top"><cf_get_lang dictionary_id="41183.İş Kalitesi"></td>
                <td valign="top"><cf_get_lang dictionary_id="41176.Elde edilen iş sonuçlarında kesinlik, doğruluk, güvenilirlik ve müşteri tatmininin sağlanması"></td>
                <td valign="top" width="25"><input type="checkbox" name="success_1_uo" id="success_1_uo" value="1" onClick="uo_count(this,'success')"></td>
                <td valign="top" width="50"><select name="success_1" id="success_1" onChange="bölüm_hesapla('success');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="success_1_detail" id="success_1_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="41162.Kurallara Uyum"></td>
                <td valign="top"><cf_get_lang dictionary_id="41161.İşyerinde mevcut kural, prosedür ve yönetmeliklere ve maliyet-yarar bilincine uygun davranma"></td>
                <td valign="top"><input type="checkbox" name="success_2_uo" id="success_2_uo" value="1" onClick="uo_count(this,'success')"></td>
                <td valign="top"><select name="success_2" id="success_2" onChange="bölüm_hesapla('success');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="success_2_detail" id="success_2_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="41160.Bağımsız Çalışma"></td>
                <td valign="top"><cf_get_lang dictionary_id="41157.İşe ilişkin yerleşik kuralların veya nezaretin olmadığı hallerde görevi yürütmede istekli ve etkin
                olabilme; danışmaya veya yönlendirmeye gerek duymadan kendi kendine yetebilme ve bağımsız hareket edebilme"></td>
                <td valign="top"><input type="checkbox" name="success_3_uo" id="success_3_uo" value="1" onClick="uo_count(this,'success')"></td>
                <td valign="top"><select name="success_3" id="success_3" onChange="bölüm_hesapla('success');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="success_3_detail" id="success_3_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td class="txtbold" valign="top"><cf_get_lang dictionary_id="41156.Esneklik"></td>
                <td valign="top"><cf_get_lang dictionary_id="41154.Belirli bir amaca ulaşabilmek için gelişmelere, değişimlere ve yeniliklere açık olma ve stil ve davranışları
                yeni duruma hızla uyarlama"></td>
                <td valign="top"><input type="checkbox" name="success_4_uo" id="success_4_uo" value="1" onClick="uo_count(this,'success')"></td>
                <td valign="top"><select name="success_4" id="success_4" onChange="bölüm_hesapla('success');"><cfoutput><cfloop from="1" to="5" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select></td>
                <td valign="top"><textarea name="success_4_detail" id="success_4_detail" style="width:250px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td colspan="3" align="center" class="txtbold"><cf_get_lang dictionary_id="41149.BAŞARI TOPLAMI"></td>
                <td colspan="2"><cfinput type="text" name="toplam_success" value="" style="width:20px" maxlength="1" readonly="yes"></td>
            </tr>							
        </table>
        <table>
            <tr>
                <td colspan="3" align="center" width="450" class="txtbold"><cf_get_lang dictionary_id="57680.GENEL TOPLAM"></td>
                <td colspan="2"><cfinput type="text" name="genel_toplam" value="" style="width:50px" maxlength="1" readonly="yes"></td>
            </tr>
        </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="56574.Değerlendirmelere İlişkin Yorumlar"></cfsavecontent>
        <cf_seperator id="deg_ilsk_yorumlar" title="#message#">
        <table id="deg_ilsk_yorumlar">
            <tr>
                <td class="txtbold" colspan="2"><cf_get_lang dictionary_id="56574.Değerlendirmelere İlişkin Yorumlar"></td>
            </tr>
            <tr>
                <td class="txtbold" colspan="2"><cf_get_lang dictionary_id="41147.Personelin Güçlü Yönleri/Başarıları"></td>
            </tr>
            <tr>
                <td colspan="2">(<cf_get_lang dictionary_id="41146.Personelin en belirgin güçlü yönleri, yıl içinde gerçekleştirdiği başarılar">)</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><textarea name="strong_way" id="strong_way" style="width:370px;height:60px" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td colspan="2" class="txtbold"><cf_get_lang dictionary_id="30992.Geliştirmesi Gereken Yönleri"></td>
            </tr>
            <tr>
                <td colspan="2">(<cf_get_lang dictionary_id="41360.Personelin geliştirmesi gereken davranış ve özellikleri, daha fazla deneyim kazanması gereken alanlar">)</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><textarea name="weak_way" id="weak_way" style="width:370px;height:60px" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
            </tr>
            <tr>
                <td colspan="2" class="txtbold"><cf_get_lang dictionary_id="41340.Eğitim ve Geliştirme Planı"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <table>
                        <tr>
                            <td><cf_get_lang dictionary_id="41339.Gelişme Sahası"></td>
                            <td><cf_get_lang dictionary_id="41338.Gerçekleştirilecek Etkinlik">/<br/><cf_get_lang dictionary_id="41337.Alınacak Eğitim"></td>
                            <td><cf_get_lang dictionary_id="33596.Dönemi"></td>
                            <td><cf_get_lang dictionary_id="29805.Yorum"></td>
                        </tr>
                        <tr>
                            <td><input type="text" name="grow_area_1" id="grow_area_1" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_edu_1" id="grow_edu_1" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_date_1" id="grow_date_1" maxlength="50" value=""></td>
                            <td><input type="text" name="comment_1" id="comment_1" maxlength="100" value=""></td>
                        </tr>
                        <tr>
                            <td><input type="text" name="grow_area_2" id="grow_area_2" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_edu_2" id="grow_edu_2" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_date_2" id="grow_date_2" maxlength="50" value=""></td>
                            <td><input type="text" name="comment_2" id="comment_2" maxlength="100" value=""></td>
                        </tr>
                        <tr>
                            <td><input type="text" name="grow_area_3" id="grow_area_3" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_edu_3" id="grow_edu_3" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_date_3" id="grow_date_3" maxlength="50" value=""></td>
                            <td><input type="text" name="comment_3" id="comment_3" maxlength="100" value=""></td>
                        </tr>
                        <tr>
                            <td><input type="text" name="grow_area_4" id="grow_area_4" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_edu_4" id="grow_edu_4" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_date_4" id="grow_date_4" maxlength="50" value=""></td>
                            <td><input type="text" name="comment_4" id="comment_4" maxlength="100" value=""></td>
                        </tr>
                        <tr>
                            <td><input type="text" name="grow_area_5" id="grow_area_5" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_edu_5" id="grow_edu_5" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_date_5" id="grow_date_5" maxlength="50" value=""></td>
                            <td><input type="text" name="comment_5" id="comment_5" maxlength="100" value=""></td>
                        </tr>
                        <tr>
                            <td><input type="text" name="grow_area_6" id="grow_area_6" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_edu_6" id="grow_edu_6" maxlength="100" value=""></td>
                            <td><input type="text" name="grow_date_6" id="grow_date_6" maxlength="50" value=""></td>
                            <td><input type="text" name="comment_6" id="comment_6" maxlength="100" value=""></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="text-align:right;" height="35" colspan="2"><cfif GET_FORM.FIRST_BOSS_VALID neq 1 and listfind(position_list,GET_FORM.FIRST_BOSS_CODE,',')><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cfif></td>
            </tr>
        </table>
    	<cf_form_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_form_box_footer>
    </cfform>
</cf_form_box>
<script type="text/javascript">
var uo_say=0
function uo_count(nesne,bolum)
{
/*uo lar değiştiğinde çalışıyor ve bölümü birdaha hesaplıyor*/
	if(nesne.checked)
	{
		if(uo_say+1>3)
		{
			nesne.checked=false;
			alert("<cf_get_lang dictionary_id='41336.Uygulaması olamyan 3 taneden fazla seçemezsiniz'>!");
			return false;
		}
		uo_say++;
	}else
	{
		uo_say--;
	}
	bölüm_hesapla(bolum);
}

function bölüm_hesapla(bolum)
{
/*her bölüm için çağrılır ancak bölüm değeri bölümdeki nesnelerin ismi olmalı bilgi gibi*/
 toplam=0;
 	for(var i=1;i<5;i++)
	{
		uo=eval("document.add_perf_emp_info."+bolum+"_"+i+"_uo");
		if(uo.checked==false)
		{
			nesne=eval("document.add_perf_emp_info."+bolum+"_"+i);
			toplam=toplam+parseInt(nesne.value);
		}
	}
	toplam_nesne=eval("document.add_perf_emp_info.toplam_"+bolum);
	toplam_nesne.value=toplam;
	toplam_hesapla();
}

function toplam_hesapla()
{
/*bölüm hesaplandıktan sonra genel toplam için çalışıyor*/
	genel_toplam=0;
	if(document.add_perf_emp_info.toplam_bilgi.value!="") genel_toplam=genel_toplam+parseInt(document.add_perf_emp_info.toplam_bilgi.value);
	if(document.add_perf_emp_info.toplam_org.value!="") genel_toplam=genel_toplam+parseInt(document.add_perf_emp_info.toplam_org.value);
	if(document.add_perf_emp_info.toplam_prob.value!="") genel_toplam=genel_toplam+parseInt(document.add_perf_emp_info.toplam_prob.value);
	if(document.add_perf_emp_info.toplam_relation.value!="") genel_toplam=genel_toplam+parseInt(document.add_perf_emp_info.toplam_relation.value);
	if(document.add_perf_emp_info.toplam_success.value!="") genel_toplam=genel_toplam+parseInt(document.add_perf_emp_info.toplam_success.value);	
	if(uo_say>0)
	{
		/*uygulaması olmayan soru toplam soru sayısından çıkarılıp yeni ağırlık hesaplanıp genel toplamla çarpılıyor*/
		agirlik=20/(20-uo_say);
		genel_toplam=genel_toplam*agirlik;
	}	
	
	document.add_perf_emp_info.genel_toplam.value=commaSplit(genel_toplam);
}

function kontrol()
{
	if(detail_control('bilgi')==false) return false;
	if(detail_control('org')==false) return false;
	if(detail_control('prob')==false) return false;
	if(detail_control('relation')==false) return false;
	if(detail_control('success')==false) return false;

	bölüm_hesapla('bilgi');
	bölüm_hesapla('org');
	bölüm_hesapla('prob');
	bölüm_hesapla('relation');
	bölüm_hesapla('success');
	document.add_perf_emp_info.genel_toplam.value=filterNum(document.add_perf_emp_info.genel_toplam.value);
	return true;
}

function detail_control(bolum)
{
	for(var i=1;i<5;i++)
	{
		detail=eval("document.add_perf_emp_info."+bolum+"_"+i+"_detail");
		if(detail.value.length < 3)
		{
			alert(<cf_get_lang dictionary_id="33337.Açıklama Girmelisiniz">);
			detail.focus();
			return false;
		}
	}
	return true;
}
</script>
