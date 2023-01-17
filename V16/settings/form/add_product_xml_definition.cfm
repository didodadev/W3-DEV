<cfsetting showdebugoutput="no">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.price_catid" default="">

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>

<cf_form_box title="Ürün Tanım XML">
<form name="add_product_xml_definition" action="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_add_product_xml_definition" method="post">
    <table border="0" style="float:left">
        <tr>
            <td valign="top">Tanım Adı *</td>
            <td valign="top"><input name="xml_definition_name" id="xml_definition_name" maxlength="50" style="width:200px;"/></td>
        </tr>
        <tr>
            <td valign="top">Kategori *</td>
            <td valign="top"> 
                <select name="product_catid" id="product_catid" multiple="multiple" style="width:200px; height:60px">
                    <cfoutput query="get_product_cat">
                        <cfif listlen(hierarchy,".") lte 3>
                            <option value="#product_catid#" <cfif listfind(attributes.product_catid,product_catid)>selected</cfif>>#hierarchy#-#product_cat#</option>
                        </cfif>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="top">Fiyat Listesi *</td>
            <td valign="top">
                <select name="price_catid" id="price_catid" multiple="multiple" style="width:200px; height:60px">
                     <cfoutput query="get_price_cat">
                        <option value="#price_catid#" <cfif attributes.price_catid eq price_catid> selected</cfif>>#price_cat#</option>
                    </cfoutput>
                </select>
            </td>
       </tr>
       <tr>
       		<td valign="top">Açıklama 1</td>
            <td valign="top">
                <select name="detail1" id="detail1" style="width:200px;">
                    <option value="0" selected>Gönderilmesin</option>
                    <option value="1" selected>Gönderilsin</option>
                 </select>	
            </td>
       </tr>
       <tr>
       		<td valign="top">Açıklama 2</td>
            <td valign="top">
                <select name="detail2" id="detail2" style="width:200px;">
                    <option value="0" selected>Gönderilmesin</option>
                	<option value="1" selected>Gönderilsin</option>
                </select>	
            </td>
       </tr>
       <tr>
            <td colspan="5"></td>
       </tr> 
    </table>
    <table id="row">
        <tr>
            <td>Dosya İsmi *</td>
            <td><input name="file_name" id="file_name" maxlength="50" autocomplete="off" style="width:200px;"  /></td>
            <td><a href="#" name="insert_row" onclick="addRow()"> <img src="/images/plus_list.gif" alt="" border="0"></a></td>
        </tr>
    </table>
   <cf_popup_box_footer><cf_workcube_buttons add_function='kontrol()'></cf_popup_box_footer>
</form>    
<script>
function delRow(id)
{
	var inputId = $(id).closest('tr').attr('id');
		$('#'+inputId).remove();
}
	
function addRow()
{
	 var randomNum = Math.ceil(Math.random()*100000);
	 $('#row').append('	<tr id="'+randomNum +'"><td>Dosya İsmi *</td><td><input name="file_name" id="file_name" autocomplete="off" maxlength="50" multiple="multiple" style="width:200px;"/></td><td><a href="#" name="insert_row"> <img align="absmiddle" id="tes" onclick="delRow(this)" src="/images/delete_list.gif" border="0"></a></td></tr>');
}//addrow

function kontrol()
{		
	var tanim_adi =$('input[name="xml_definition_name"]');
	var kategori  = $('select[name="product_catid"]');
	var liste_fiyati = $('select[name="price_catid"]'); 
	var dosya_ismi = $('input[name="file_name"]');
	
	var dizi = [];
		if ( trim(tanim_adi.val()) == ''){tanim_adi.css('border','2px solid red'); alert('Tanım Adı Giriniz !'); return false; } else  tanim_adi.css('border','2px solid green');
		if ( kategori.val() == null ) {kategori.css('border','2px solid red'); alert('Kategori Seçiniz !');  return false;  } else  kategori.css('border','2px solid green');
		if ( liste_fiyati.val() == null ){ liste_fiyati.css('border','2px solid red'); alert('Fiyat Listesi Seçiniz !');  return false; }else  liste_fiyati.css('border','2px solid green');
		
	 for (var i = 0; i <dosya_ismi.length;i++){
		var value = dosya_ismi.eq(i).val();
		var newValue = value.replace(/ /g, '');
		dosya_ismi.eq(i).val(newValue);		 
		if ( trim(dosya_ismi.eq(i).val()) == '') {
			 dosya_ismi.eq(i).css('border','2px solid red'); 
			 alert('Dosya Adı Giriniz !');  
			 return false;  
		}else if (dizi.indexOf(dosya_ismi.eq(i).val()) > -1){
			dosya_ismi.eq(i).css('border','2px solid red'); 
			alert('Aynı İsimde Dosya Adı Giremezsiniz ! ');  
			return false;
		}else {
			dosya_ismi.eq(i).css('border','2px solid green');
			 dizi.push(dosya_ismi.eq(i).val());
		}//if
	 }//for

	return true;		
}
</script>
