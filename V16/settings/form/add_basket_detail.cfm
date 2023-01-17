<!--- 
	Bu sayfada basket ayarlamaları  goruntu duzenlemeleri icin  secme ekranıdır.
	setup_basket tablosundaki B_TYPE alani 1 olan kayıtlar eklenir.
	B_TYPE =1 demek isleme sayfasi demektir.B_TYPE=0 olsa idi goruntu sayfası olurdu.
 --->
<cfif isdefined('attributes.basket_id') and len(attributes.basket_id)>
    <cfquery name="GET_MODULE_DSP" datasource="#DSN3#">
        SELECT * FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #attributes.basket_id# AND B_TYPE=1
    </cfquery>
    <cfquery name="get_basket_this" datasource="#DSN3#">
        SELECT
            *
        FROM
            SETUP_BASKET
        WHERE
            B_TYPE = 1 AND 
            BASKET_ID = #attributes.basket_id#
        ORDER BY
            BASKET_ID
    </cfquery>
    <cfquery name="get_selected" dbtype="query">
    	SELECT * FROM GET_MODULE_DSP WHERE IS_SELECTED = 1
   	</cfquery>
    <cfset selected_list = valueList(get_selected.TITLE)>
</cfif>

<cfif isdefined('attributes.basket_id') and len(attributes.basket_id)>
 <input type="hidden" name="basket_id2" id="basket_id2" value="<cfoutput>#basket_id#</cfoutput>" />
</cfif>

<cfset attributes.B_TYPE = 1>
<cfset attributes.sec_id = ''>
<cfquery name="get_basket_ids" datasource="#DSN3#">
	SELECT BASKET_ID FROM SETUP_BASKET WHERE B_TYPE = 1
</cfquery>
<cfset liste_basket_ids = ValueList(get_basket_ids.BASKET_ID)>
<cf_form_box title="#getLang('settings',392)#">
    <cf_area width="100">
        <cfinclude template="../display/list_basket_modules.cfm">
    </cf_area>
    <cf_area>
        <table width="100%">
            <tr>
                <td><b><cf_get_lang_main no='1160.Kullanım'></b>
                    <select name="basket_id" id="basket_id" style="width:200px;" onChange="showBasket(this.value);">
                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfif not listfind(liste_basket_ids,1,",")><option<cfif attributes.sec_id eq 1> selected</cfif> value="1"><cf_get_lang no='84.Alis Faturası'></option></cfif>
                        <cfif not listfind(liste_basket_ids,2,",")><option<cfif attributes.sec_id eq 2> selected</cfif> value="2"><cf_get_lang no='85.Satış Faturası'></option></cfif>
                        <cfif not listfind(liste_basket_ids,3,",")><option<cfif attributes.sec_id eq 3> selected</cfif> value="3"><cf_get_lang no='86.Satış Teklifi'> </option></cfif>
                        <cfif not listfind(liste_basket_ids,4,",")><option<cfif attributes.sec_id eq 4> selected</cfif> value="4"><cf_get_lang no='87.Satış Siparişi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,5,",")><option<cfif attributes.sec_id eq 5> selected</cfif> value="5"><cf_get_lang no='88.Satınalma Teklifi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,6,",")><option<cfif attributes.sec_id eq 6> selected</cfif> value="6"><cf_get_lang no='71.Satınalma Siparişi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,7,",")><option<cfif attributes.sec_id eq 7> selected</cfif> value="7"><cf_get_lang no='89.Satınalma İç Talepleri'></option></cfif>
                        <cfif not listfind(liste_basket_ids,8,",")><option<cfif attributes.sec_id eq 8> selected</cfif> value="8"><cf_get_lang no='90.Yazışmalar İç Talepler'></option></cfif>
                        <cfif not listfind(liste_basket_ids,10,",")><option<cfif attributes.sec_id eq 10> selected</cfif> value="10"><cf_get_lang no='92.Stok Satış İrsaliyesi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,31,",")><option<cfif attributes.sec_id eq 31> selected</cfif> value="31"><cf_get_lang no='747.Stok Sevk İrsaliyesi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,11,",")><option<cfif attributes.sec_id eq 11> selected</cfif> value="11"><cf_get_lang no='93.Stok Alım İrsaliyesi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,12,",")><option<cfif attributes.sec_id eq 12> selected</cfif> value="12"><cf_get_lang no='528.Stok Fişi Ekle'></option></cfif>
                        <cfif not listfind(liste_basket_ids,13,",")><option<cfif attributes.sec_id eq 13> selected</cfif> value="13"><cf_get_lang no='95.Stok Açılış Fişi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,14,",")><option<cfif attributes.sec_id eq 14> selected</cfif> value="14"><cf_get_lang no='96.Stok Satış Siparişi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,15,",")><option<cfif attributes.sec_id eq 15> selected</cfif> value="15"><cf_get_lang no='98.Stok Alım Siparişi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,17,",")><option<cfif attributes.sec_id eq 17> selected</cfif> value="17"><cf_get_lang no='99.Şube Alım İrsaliyesi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,18,",")><option<cfif attributes.sec_id eq 18> selected</cfif> value="18"><cf_get_lang no='100.Şube Satış Faturası'></option></cfif>
                        <cfif not listfind(liste_basket_ids,19,",")><option<cfif attributes.sec_id eq 19> selected</cfif> value="19"><cf_get_lang no='101.Şube Stok Fişi'> </option></cfif>
                        <cfif not listfind(liste_basket_ids,20,",")><option<cfif attributes.sec_id eq 20> selected</cfif> value="20"><cf_get_lang no='102.Şube Alış Faturası'></option></cfif>
                        <cfif not listfind(liste_basket_ids,21,",")><option<cfif attributes.sec_id eq 21> selected</cfif> value="21"><cf_get_lang no='103.Şube Satış İrsaliyesi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,32,",")><option<cfif attributes.sec_id eq 32> selected</cfif> value="32"><cf_get_lang no='748.Şube Sevk İrsaliyesi'></option></cfif>					  
                        <cfif not listfind(liste_basket_ids,24,",")><option<cfif attributes.sec_id eq 24> selected</cfif> value="24"><cf_get_lang no='822.Partner Portal Teklifler Satış'></option></cfif>
                        <cfif not listfind(liste_basket_ids,25,",")><option<cfif attributes.sec_id eq 25> selected</cfif> value="25"><cf_get_lang no='823.Partner Portal Siparişler Satış'></option></cfif>
                        <cfif not listfind(liste_basket_ids,26,",")><option<cfif attributes.sec_id eq 26> selected</cfif> value="26"><cf_get_lang no='107.Partner Portal Ürün Katalogları'></option></cfif>
                        <cfif not listfind(liste_basket_ids,28,",")><option<cfif attributes.sec_id eq 28> selected</cfif> value="28"><cf_get_lang no='109.Public Portal Basket'></option></cfif>
                        <cfif not listfind(liste_basket_ids,29,",")><option<cfif attributes.sec_id eq 29> selected</cfif> value="29"><cf_get_lang no='110.Kataloglar'></option></cfif>
                        <cfif not listfind(liste_basket_ids,33,",")><option<cfif attributes.sec_id eq 33> selected</cfif> value="33"><cf_get_lang_main no='411.Müstahsil Makbuzu'></option></cfif>
                        <cfif not listfind(liste_basket_ids,34,",")><option<cfif attributes.sec_id eq 34> selected</cfif> value="34"><cf_get_lang no='760.Bütçe Satış Kotaları'></option></cfif>
                        <cfif not listfind(liste_basket_ids,35,",")><option<cfif attributes.sec_id eq 35> selected</cfif> value="35"><cf_get_lang no='820.Partner Portal(Alım) Siparişleri'></option></cfif>
                        <cfif not listfind(liste_basket_ids,36,",")><option<cfif attributes.sec_id eq 36> selected</cfif> value="36"><cf_get_lang no='821.Partner Portal(Alım) Teklifleri'></option></cfif>
                        <cfif not listfind(liste_basket_ids,38,",")><option<cfif attributes.sec_id eq 38> selected</cfif> value="38"><cf_get_lang no='758.Sube Satış Siparişi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,37,",")><option<cfif attributes.sec_id eq 37> selected</cfif> value="37"><cf_get_lang no='832.Sube Alım Siparişi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,39,",")><option<cfif attributes.sec_id eq 39> selected</cfif> value="39"><cf_get_lang no='314.Şube İç Talepler'></option></cfif>
                        <cfif not listfind(liste_basket_ids,40,",")><option<cfif attributes.sec_id eq 40> selected</cfif> value="40"><cf_get_lang no='348.Stok Hal İrsaliyesi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,41,",")><option<cfif attributes.sec_id eq 41> selected</cfif> value="41"><cf_get_lang no='356.Şube Hal İrsaliyesi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,42,",")><option<cfif attributes.sec_id eq 42> selected</cfif> value="42"><cf_get_lang_main no='407.Hal Faturası'></option></cfif>
                        <cfif not listfind(liste_basket_ids,43,",")><option<cfif attributes.sec_id eq 43> selected</cfif> value="43"><cf_get_lang no='422.Şube Hal Faturası'></option></cfif>
                        <cfif not listfind(liste_basket_ids,44,",")><option<cfif attributes.sec_id eq 44> selected</cfif> value="44"><cf_get_lang no='475.Sevk İç Talep'></option></cfif>
                        <cfif not listfind(liste_basket_ids,45,",")><option<cfif attributes.sec_id eq 45> selected</cfif> value="45"><cf_get_lang no='498.Şube Sevk İç Talep'></option></cfif>
                        <cfif not listfind(liste_basket_ids,46,",")><option<cfif attributes.sec_id eq 46> selected</cfif> value="46"><cf_get_lang_main no='1420.Abone'></option></cfif>
                        <cfif not listfind(liste_basket_ids,47,",")><option<cfif attributes.sec_id eq 47> selected</cfif> value="47"><cf_get_lang no='1055.Servis Giriş'></option></cfif>
                        <cfif not listfind(liste_basket_ids,48,",")><option<cfif attributes.sec_id eq 48> selected</cfif> value="48"><cf_get_lang no='1056.Servis Çıkış'></option></cfif>
                        <cfif not listfind(liste_basket_ids,49,",")><option<cfif attributes.sec_id eq 49> selected</cfif> value="49"><cf_get_lang_main no='1791.İthal Mal Girişi'></option></cfif>
                        <cfif not listfind(liste_basket_ids,50,",")><option<cfif attributes.sec_id eq 50> selected</cfif> value="50"><cf_get_lang no='1465.Proje Malzeme Planı'></option></cfif>
                        <cfif not listfind(liste_basket_ids,51,",")><option<cfif attributes.sec_id eq 51> selected</cfif> value="51"><cf_get_lang no='1588.Taksitli Satış'></option></cfif>
                        <cfif not listfind(liste_basket_ids,52,",")><option<cfif attributes.sec_id eq 52> selected</cfif> value="52"><cf_get_lang_main no='1026.Z Raporu'></option></cfif>
                    </select>
                </td>
            </tr>
            <tr>
            	<td style="width:100%"><div id="BASKET_DETAIL"></div></td>
            </tr>
         </table>
   </cf_area>
    <cf_form_box_footer>
    <table align="right">
    	<tr>
    	<td><input type="button" value="Kaydet" onclick="kontrol()"/></td>
        </tr>
        </table>
<!---    	<cf_workcube_buttons>--->
    </cf_form_box_footer>
<!---   </cfform>--->
</cf_form_box>
<script type="text/javascript">
function sec()
{	
	//for (i=0; i < add_basket_details.module_content.length ; i=i+1)
	/*for (i=0; i < $("input[name='module_content']").length ; i=i+1)
		add_basket_details.module_content[i].checked = true;*/
	if(document.getElementById('select_all').checked){
		$("input[name='module_content']").each(function() {
		  $(this).attr("checked",true);
		})
		$("input[name='use_project_discount_']").each(function() {
		  $(this).attr("checked",true);
		})
	}else{
		$("input[name='module_content']").each(function() {
		  $(this).attr("checked",false);
		})
		$("input[name='use_project_discount_']").each(function() {
		  $(this).attr("checked",false);
		})
	}
}

function kontrol()
{
	AjaxFormSubmit('add_basket_details','emin',1,'Güncelleniyor','Güncellendi','','',1);
}

function showBasket(basket_id_)	
{ 
	var basket_id_ = document.getElementById("basket_id").value;
	<cfif isdefined('attributes.basket_id') and len(attributes.basket_id)>
		var add_basket_id = document.getElementById("basket_id2").value;
	</cfif>
	if (basket_id_ != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_ajax_add_basket_detail_info&basket_id_="+basket_id_+'&sec_id='+basket_id_+'&b_type=1'<cfif isdefined('attributes.basket_id') and len(attributes.basket_id)>+'&add_basket_id='+add_basket_id</cfif>;
		AjaxPageLoad(send_address,'BASKET_DETAIL',1);
	}
}

</script>

<cfif isdefined("attributes.basket_id")>
	<script type="text/javascript">
		$("#basket_id").val('<cfoutput>#attributes.basket_id#</cfoutput>');
		showBasket('<cfoutput>#attributes.basket_id#</cfoutput>');
    </script>
</cfif>
