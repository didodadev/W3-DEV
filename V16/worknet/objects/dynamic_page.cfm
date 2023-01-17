<cfsetting showdebugoutput="no">
<cfloop index="xx" from="1" to="#ArrayLen(MyDocument.XmlChildren)#">
	<cfset 'fuseaction_definition_#xx#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[1].XmlText')>
    <cfset 'fuseaction_keyword_#xx#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[2].XmlText')>
    <cfset 'fuseaction_title_#xx#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[3].XmlText')>
    <cfset 'fuseaction_name_#xx#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[4].XmlText')>
    <cfset 'fuseaction_userfriendly_#xx#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[5].XmlText')>
    <cfloop index="ss" from="6" to="#ArrayLen(MyDocument.XmlChildren[xx].XmlChildren)#">
		<cfset 'objects_#xx#_#ss-5#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[ss].XmlText')>
        <cfset 'id_#xx#_#ss-5#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[1].XmlText')>
        <cfset 'class_name_#xx#_#ss-5#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[2].XmlText')>
        <cfset 'include_#xx#_#ss-5#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[3].XmlText')>
        <cfset 'path_#xx#_#ss-5#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[4].XmlText')>
        <cfset 'width_#xx#_#ss-5#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[5].XmlText')>
        <cfset 'top_#xx#_#ss-5#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[6].XmlText')>
        <cfset 'left_#xx#_#ss-5#' = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[7].XmlText')>
        <cfif ArrayLen(MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren) gt 7>
            <cfset 'control_parameter_#xx#_#ss-5#' = ArrayLen(MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren)><!--- Special Parameter daki eleman Sayısı --->
            <cfloop index="aa" from="1" to="#Evaluate('control_parameter_#xx#_#ss-5#')#">
                <cfset text = MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[aa].XmlChildren[1].XmlText><!--- Special Parametredeki parameter_name--->
                <cfset 'parameter_name_#xx#_#ss-5#_#aa#' = text>
                <cfset text = MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[aa].XmlChildren[2].XmlText><!--- Special Parametredeki parameter_detail--->
                <cfset 'parameter_detail_#xx#_#ss-5#_#aa#' = text>
                <cfset text = MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[aa].XmlChildren[3].XmlText><!--- Special Parametredeki parameter_type--->
                <cfset 'parameter_type_#xx#_#ss-5#_#aa#' = text>
                <cfset text = MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[aa].XmlChildren[4].XmlText><!--- Special Parametredeki parameter_values--->
                <cfset 'parameter_values_#xx#_#ss-5#_#aa#' = text>
                <cfset text = MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[aa].XmlChildren[5].XmlText><!--- Special Parametredeki parameter_value_names--->
                <cfset 'parameter_value_names_#xx#_#ss-5#_#aa#' = text>
                <cfset text = MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[aa].XmlChildren[6].XmlText><!--- Special Parametredeki parameter_default--->
                <cfset 'parameter_default_#xx#_#ss-5#_#aa#' = text>
        	  </cfloop>
 		 </cfif>
	</cfloop>
</cfloop>

<div id="main_div" style="width:auto; height:auto; z-index:9999; display:block">
	<cfform name="form_submit_1" id="form_submit_1" action="#request.self#?fuseaction=test.bombos5" method="post">
		<input type="hidden" value="" name="obje_id_" id="obje_id_" />
        <input type="hidden" value="" name="parametre_degerler" id="parametre_degerler" />
    </cfform>
    <cfloop index="xx" from="1" to="#ArrayLen(MyDocument.XmlChildren)#">
        <cfloop index="ss" from="6" to="#ArrayLen(MyDocument.XmlChildren[xx].XmlChildren)#">
            <cfif attributes.fuseaction is '#Evaluate("fuseaction_name_#xx#")#'>
                <cfif len(Evaluate('path_#xx#_#ss-5#'))>
                    <cfset path_ = Replace(Evaluate('path_#xx#_#ss-5#'),'request.self','','all')>
                    <cfset path_ = Replace(path_,'##','','all')>
                    <cfset path_ = 'index.cfm' & path_>
                <cfelse>
                    <cfset path_ = ''>
                </cfif>
                <cfif ArrayLen(MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren) gt 7>
					<cfloop index="cc" from="1" to="#Evaluate('control_parameter_#xx#_#ss-5#')#">
						<cfif len(Evaluate('parameter_default_#xx#_#ss-5#_#cc#'))><!--- Parametre selectbox ise value değeri yerine default değerini seçiyoruz. --->
							<cfset path_ = path_ & '&' & Evaluate('parameter_name_#xx#_#ss-5#_#cc#') & '=' & Evaluate('parameter_default_#xx#_#ss-5#_#cc#')>
						<cfelse>
							<cfif len(Evaluate('parameter_values_#xx#_#ss-5#_#cc#'))><!--- Parametre tanımlı olup içi boş gelebilir bu yüzden kontrol ediyoruz. --->
								<cfset path_ = path_ & '&' & Evaluate('parameter_name_#xx#_#ss-5#_#cc#') & '=' & Evaluate('parameter_values_#xx#_#ss-5#_#cc#')>
							</cfif>
						</cfif>
					</cfloop>
                </cfif>
                <cfset top_ = Evaluate('top_#xx#_#ss-5#')>
                <cfset left_ = Evaluate('left_#xx#_#ss-5#')>
                <cfset width_ = Evaluate('width_#xx#_#ss-5#')>
                <cfset div_id = Evaluate('id_#xx#_#ss-5#')>
                <cfset class_name = Evaluate('class_name_#xx#_#ss-5#')>
                <cfset position_ = ''>
                <cfif len(Evaluate('include_#xx#_#ss-5#'))>
                    <cf_box id="#div_id#" design_type="1" class="#class_name#" style="position:#position_#; margin-top:#top_#; margin-left:#left_#; width:#width_#; height:auto;" body_style="width:100%">
                    <cfif isdefined("session.ep")>
                        <div id="baslik_<cfoutput>#div_id#</cfoutput>" style="float:left; height:15px; width:25px" onMouseDown="bul(<cfoutput>#div_id#</cfoutput>);"><img src="../../images/drag.gif"></div>
                        <div id="duzenle" style="float:right; padding-top:1px"><a href="javascript://" onclick="gizle_goster(degisiklik_<cfoutput>#div_id#</cfoutput>);"><cf_get_lang_main no='1306.Düzenle'></a></div>
                        <div id="degisiklik_<cfoutput>#div_id#</cfoutput>" style="display:none; height:auto; width:auto; text-align:center;">
                            <cfif ArrayLen(MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren) gt 7>
                                <cfset parametre_isimleri = ''><!--- parametre isimlerini bir listeye atıyoruz. --->
                                <table>
                                    <cfloop index="aa" from="1" to="#Evaluate('control_parameter_#xx#_#ss-5#')#">
                                        <tr>
                                            <td>
                                                <cfoutput>#Evaluate('parameter_detail_#xx#_#ss-5#_#aa#')#</cfoutput>
                                            </td>
                                            <td>
                                                <cfif Evaluate('parameter_type_#xx#_#ss-5#_#aa#') is 'input'>
                                                    <input type="text" name="<cfoutput>#Evaluate('parameter_name_#xx#_#ss-5#_#aa#')#</cfoutput>" id="<cfoutput>#Evaluate('parameter_name_#xx#_#ss-5#_#aa#')#</cfoutput>" value="<cfoutput>#Evaluate('parameter_values_#xx#_#ss-5#_#aa#')#</cfoutput>">
                                                <cfelse>
                                                    <select name="<cfoutput>#Evaluate('parameter_name_#xx#_#ss-5#_#aa#')#</cfoutput>" id="<cfoutput>#Evaluate('parameter_name_#xx#_#ss-5#_#aa#')#</cfoutput>">
                                                    <cfset option_number = listlen(Evaluate('parameter_value_names_#xx#_#ss-5#_#aa#'),',')>
                                                    <cfloop index="bb" from="1" to="#option_number#">
                                                        <option value="<cfoutput>#listgetat(Evaluate('parameter_values_#xx#_#ss-5#_#aa#'),bb)#</cfoutput>" <cfif listgetat(Evaluate('parameter_values_#xx#_#ss-5#_#aa#'),bb) eq Evaluate('parameter_default_#xx#_#ss-5#_#aa#')>selected</cfif>><cfoutput>#listgetat(Evaluate('parameter_value_names_#xx#_#ss-5#_#aa#'),bb)#</cfoutput></option>
                                                    </cfloop>
                                                </cfif>
                                                <cfif len(parametre_isimleri)>
                                                    <cfset parametre_isimleri = parametre_isimleri & '+' & Evaluate('parameter_name_#xx#_#ss-5#_#aa#')>
                                                <cfelse>
                                                    <cfset parametre_isimleri = Evaluate('parameter_name_#xx#_#ss-5#_#aa#')>
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfloop>
                                    <tr>
                                        <td colspan="2" align="right"><input type="submit" value="Kaydet" id="submit_button" onclick="save_properties('<cfoutput>#div_id#</cfoutput>','<cfoutput>#parametre_isimleri#</cfoutput>');"/><div id="mesaj_div"></div></td>
                                    </tr>
                                </table>
                            </cfif>
                        </div>
                    </cfif>
                    <cfif ArrayLen(MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren) gt 7>
                        <cfloop index="cc" from="1" to="#ArrayLen(MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren)#">
                            <cfif len(Evaluate('parameter_default_#xx#_#ss-5#_#cc#'))>
                                <cfset 'attributes.#MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[cc].XmlChildren[1].XmlText#' = '#MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[cc].XmlChildren[6].XmlText#'>                
                            <cfelse>
                                <cfset 'attributes.#MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[cc].XmlChildren[1].XmlText#' = '#MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren[8].XmlChildren[cc].XmlChildren[4].XmlText#'>
                            </cfif>
                        </cfloop>
                    </cfif>
                    <cfinclude template="#Evaluate('include_#xx#_#ss-5#')#">
                    </cf_box>
                <cfelse>
                    <cf_box id="#div_id#" design_type="1" class="#class_name#" style="position:#position_#; margin-top:#top_#; margin-left:#left_#; width:#width_#; height:auto; z-index:1" body_style="width:100%">
                        <cfif isdefined("session.ep")>
                            <div id="baslik_<cfoutput>#div_id#</cfoutput>" style=" height:15px; width:25px;" onMouseDown="bul(<cfoutput>#div_id#</cfoutput>);"><img src="../../images/drag.gif"></div>
                            <div id="duzenle" style="float:right;"><a href="javascript://" onclick="gizle_goster(degisiklik_<cfoutput>#div_id#</cfoutput>);"><cf_get_lang_main no='1306.Düzenle'></a></div>
                            <div id="degisiklik_<cfoutput>#div_id#</cfoutput>" style="display:none; height:auto; width:auto; text-align:center;">
                                <cfif ArrayLen(MyDocument.XmlChildren[xx].XmlChildren[ss].XmlChildren) gt 7>
                                    <cfset parametre_isimleri = ''><!--- parametre isimlerini bir listeye atıyoruz. --->
                                    <table>
                                    <cfloop index="aa" from="1" to="#Evaluate('control_parameter_#xx#_#ss-5#')#">
                                        <tr>
                                            <td>
                                                <cfoutput>#Evaluate('parameter_detail_#xx#_#ss-5#_#aa#')#</cfoutput>
                                            </td>
                                            <td>
                                                <cfif Evaluate('parameter_type_#xx#_#ss-5#_#aa#') is 'input'>
                                                    <input type="text" name="<cfoutput>#Evaluate('parameter_name_#xx#_#ss-5#_#aa#')#</cfoutput>" id="<cfoutput>#Evaluate('parameter_name_#xx#_#ss-5#_#aa#')#</cfoutput>" value="<cfoutput>#Evaluate('parameter_values_#xx#_#ss-5#_#aa#')#</cfoutput>">
                                                <cfelse>
                                                    <select name="<cfoutput>#Evaluate('parameter_name_#xx#_#ss-5#_#aa#')#</cfoutput>">
                                                    <cfset option_number = listlen(Evaluate('parameter_value_names_#xx#_#ss-5#_#aa#'),',')>
                                                    <cfloop index="bb" from="1" to="#option_number#">
                                                        <option value="<cfoutput>#listgetat(Evaluate('parameter_values_#xx#_#ss-5#_#aa#'),bb)#</cfoutput>" <cfif listgetat(Evaluate('parameter_values_#xx#_#ss-5#_#aa#'),bb) eq Evaluate('parameter_default_#xx#_#ss-5#_#aa#')>selected</cfif>><cfoutput>#listgetat(Evaluate('parameter_value_names_#xx#_#ss-5#_#aa#'),bb)#</cfoutput></option>
                                                    </cfloop>
                                                </cfif>
                                                <cfif len(parametre_isimleri)>
                                                    <cfset parametre_isimleri = parametre_isimleri & '+' & Evaluate('parameter_name_#xx#_#ss-5#_#aa#')>
                                                <cfelse>
                                                    <cfset parametre_isimleri = Evaluate('parameter_name_#xx#_#ss-5#_#aa#')>
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfloop>
                                    <tr>
                                        <td colspan="2" align="right"><input type="submit" value="Kaydet" id="submit_button" onclick="save_properties('<cfoutput>#div_id#</cfoutput>','<cfoutput>#parametre_isimleri#</cfoutput>');"/><div id="mesaj_div"></div></td>
                                    </tr>
                                    </table>
                                </cfif>
                            </div>
                        </cfif>
                        <div id="<cfoutput>#div_id#</cfoutput>_"></div>
                    </cf_box>
                    <script type="text/javascript">
                        AjaxPageLoad("<cfoutput>#path_#</cfoutput>","<cfoutput>#div_id#_</cfoutput>");
                    </script>
                </cfif>
            </cfif>
       </cfloop>
    </cfloop>
</div>

<!---

<script type="text/javascript" src="../../JS/domdrag.js"></script>
<script type="text/javascript">
<cfoutput>
 <cfloop index="xx" from="1" to="#ArrayLen(MyDocument.XmlChildren)#">
    <cfif attributes.fuseaction is '#Evaluate("fuseaction_name_#xx#_#ss#")#'>
		Drag.init(document.getElementById("baslik_#Evaluate('id_#xx#')#"),document.getElementById("#Evaluate('id_#xx#')#"));
	</cfif>
</cfloop>
</cfoutput>
function bul(id)
{
	alert(id);
}
function deneme(id)
{
	id.style.display = '';
}
function save_properties(obj,metin)
{
	document.form_submit_1.obje_id_.value = obj;
	add_p_ = '';
	if(metin != '')
		{
			var uzunluk_ = list_len(metin,'+');
			for(i=1;i<=uzunluk_;i++)
				{
					deger_name_ = list_getat(metin,i,'+');
					deger_id_ = list_getat(metin,i,'+');
					if(add_p_=='')
						{
						add_p_ = deger_name_ + '=' + document.getElementById(deger_id_).value;
						}
					else
						{
						add_p_ = add_p_ + '+' + deger_name_ + '=' + document.getElementById(deger_id_).value;
						}
				}
		}
	document.form_submit_1.parametre_degerler.value = add_p_;
	form_submit_1.submit();
}
</script>--->
