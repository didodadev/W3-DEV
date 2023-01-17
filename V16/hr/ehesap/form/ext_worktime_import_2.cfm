<cfquery name="GET_OFFTIME_CATS" datasource="#dsn#">
	SELECT 
		*
    FROM 
    	SETUP_OFFTIME
</cfquery><!--- ehesap.form_add_offtime_popup --->
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
<cfparam name="attributes.sal_mon" default="">
		<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
			<tr height="35" class="color-list">
				<td class="headbold">&nbsp;<cf_get_lang dictionary_id='53692.Mesai İmport'></td>
				<td class="headbold" width="60%"><cf_get_lang dictionary_id='58594.Format'></td>
			</tr>
			<tr class="color-row">
				<td valign="top">
                    <table>
                        <cfform name="form_import" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_ext_worktime_import_2">
                        <input type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html">
                            <tr>
                                <td></td>
                                <td colspan="2"><input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off"><cf_get_lang dictionary_id ='53662.Puantajda Görüntülenmesin'></td>
                            </tr>
                            <tr>
                                <td width="140"><cf_get_lang dictionary_id='53723.Belge Formatı'></td>
                                <td><select name="file_format" id="file_format" style="width:200px;">
                                        <option value="UTF-8"><cf_get_lang dictionary_id='54245.UTF-8'></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='57468.Belge'>*</td>
                                <td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;" value=""></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id ='53849.Ay/Yıl'></td>
                                <td>
                                    <select name="sal_mon" id="sal_mon">
                                        <cfloop from="1" to="12" index="i">
                                            <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                    <select name="sal_year" id="sal_year">
                                        <cfloop from="#session.ep.period_year#" to="#session.ep.period_year+4#" index="i">
                                            <cfoutput><option value="#i#">#i#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td height="35"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                            </tr>
                        </cfform>
                    </table>
				</td>
				<td valign="top">
					<cf_get_lang dictionary_id ='53850.Bu belgede olması gereken alan sayısı'>:5 <br/>
					<cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>; <br/>
					1_<cf_get_lang dictionary_id ='53109.Sıra No'><br/>
					2_<cf_get_lang dictionary_id ='54211.Tc Kimlik No'> <br />
					3_<cf_get_lang dictionary_id ='57570.Ad Soyad'><br/>
					4_<cf_get_lang dictionary_id ='53718.Fazla Mesai'>(<cf_get_lang dictionary_id='58827.dk'>) (<cf_get_lang dictionary_id='29801.Zorunlu'>)<br/>
					5_<cf_get_lang dictionary_id='58543.Mesai Tipi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>)
					(0 - <cf_get_lang dictionary_id='53014.Normal Gün'>, 1 - <cf_get_lang dictionary_id='53015.Hafta Sonu'>, 2 - <cf_get_lang dictionary_id='53016.Resmi Tatil'>)<br/>
					(<cf_get_lang dictionary_id='53105.Farklı bir değer girerseniz, importunuz geçersiz olur ve hesaba giremez.'>)<br/><br/>
                    <cf_get_lang dictionary_id ='33719.NOT: Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır.
                     Format UTF-8 Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'><br/>
				</td>
			</tr>
		</table>
<script type="text/javascript">
function kontrol()
{
	if(document.form_import.uploaded_file.value.length == 0)
	{
		alert("<cf_get_lang dictionary_id ='54246.Belge Seçmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
