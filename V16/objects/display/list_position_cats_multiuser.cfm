<!--- 
	Bu Sayfa Kullanilirken Opener sayfasinda yapilmasi gerekenler nelerdir:
	öncelikle bir satir silme fonksiyonu yazilmalidir.bu fonksiyonun ismi tabiki parametre olarak url den gonderilmelidir.
	örneğin:Bu sayfayi cagiran opener daki url asagidaki gibi olsun:
		table_row_name :  Insert isleminin yapildigi her bir yeni satir tablosunun sutun ismi 
		field_form_name : inputlarin buludugu form sayfasinin adi 
		field_poscat_id : position_cat_id lerin gonderilecegi inputun adi
		table_name= tum pos cat listesinin listelenecegi tablonun id si
		row_count= Kacta satir varsa o satirin max numarasi opener dokumani icinde bir hidden inputta durur.Bu inputun ismi
		function_row_name : openerdaki belirtilen position cat i silmek icin kullanilacak openerdaki sil fonksiyonunun adi
		Kaydet butonuna basildiginda oncelikle tum kayitlardan hangileri secilmis onlar belirlenip ardindan openera bilgileri gondermek
		için kullanilan "ekle_str" fonksiyonu cagirilir.
--->
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_position_cats.cfm">
<cfparam name="attributes.keyword" default = "" >
<cfparam name="attributes.position_hierarchy" default = "" >
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_position_cats.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	url_string = '';
	if (isdefined("attributes.field_td")) url_string = "#url_string#&field_td=#attributes.field_td#";
	if (isdefined("attributes.field_poscat_id")) url_string = "#url_string#&field_poscat_id=#attributes.field_poscat_id#";
	if (isdefined("attributes.field_form_name")) url_string = "#url_string#&field_form_name=#attributes.field_form_name#";
	if (isdefined("attributes.table_name")) url_string = "#url_string#&table_name=#attributes.table_name#";
	if (isdefined("attributes.table_row_name")) url_string = "#url_string#&table_row_name=#attributes.table_row_name#";
	if (isdefined("attributes.row_count")) url_string = "#url_string#&row_count=#attributes.row_count#";	
	if (isdefined("attributes.function_row_name")) url_string="#url_string#&function_row_name=#attributes.function_row_name#";	
</cfscript>
<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Pozisyon Tipi','59004')#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_box_search>
            <cfform action="#request.self#?fuseaction=objects.popup_list_position_cats_multiuser#url_string#" method="post" name="search">       
                <cf_box_elements>
                    <div class="form-group" id="keyword">
                        <cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#">
                    </div>   
                    <div class="form-group" id="position_hierarchy">
                        <cfinput type="text" name="position_hierarchy" placeholder="#getLang('','Hiyerarşi','57761')#" value="#attributes.position_hierarchy#">
                    </div> 
                    <div class="form-group small">
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3">
                    </div> 
                    <div class="form-group">
                        <cf_wrk_search_button is_upd='0' type_format="1" button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
                    </div>  
                </cf_box_elements>                   
            </cfform>
            <cfif len(attributes.keyword)>
                <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
            </cfif> 
            <cfif len(attributes.position_hierarchy)>
                <cfset url_string = '#url_string#&position_hierarchy=#attributes.position_hierarchy#'>
            </cfif> 
        </cf_box_search> 
        <form action="" method="post" name="form_name">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                        <th width="15"><input type="Checkbox" name="all_" id="all_" value="1" onclick="javascript: hepsi();"><!--- Herkes ---></th>
                    </tr>
                </thead>
                    <cfset sorgu_sayac=0>
                    <cfoutput query="get_position_cats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfset sorgu_sayac = sorgu_sayac + 1 >
                        <tbody>
                            <tr>
                                <td>#position_cat#</td>
                                <td>
                                    <input type="checkbox" name="POS_CAT_IDS#sorgu_sayac#" id="POS_CAT_IDS#sorgu_sayac#" value="#POSITION_CAT_ID#">
                                    <input type="hidden" name="POSITION_CAT#sorgu_sayac#" id="POSITION_CAT#sorgu_sayac#" value="#POSITION_CAT#">
                                    <input type="hidden" name="POSITION_CAT_ID#sorgu_sayac#" id="POSITION_CAT_ID#sorgu_sayac#" value="#POSITION_CAT_ID#">							
                                </td>
                            </tr>
                        </tbody>
                    </cfoutput>
                    <input type="hidden" name="record_type" id="record_type" value="employee">
                    <input type="hidden" name="url_string" id="url_string" value="<cfoutput>#url_string#</cfoutput>">
            </cf_grid_list> 
            <cfif attributes.totalrecords gt attributes.maxrows>
                <table width="99%" align="center"  height="35">
                    <tr>
                        <td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects.popup_list_position_cats_multiuser#url_string#"></td>
                        <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
                    </tr>
                </table>
            </cfif>  
            <cf_box_footer>
                <input type="button" value="<cf_get_lang dictionary_id ='57461.Kaydet'>" onClick="add_checked();">
            </cf_box_footer>
        </form>
    </cf_box>
</div>
<!-- sil -->
<script type="text/javascript">

    rowCount = parseInt(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.<cfoutput>#attributes.row_count#</cfoutput>.value);

 	<cfif isdefined("attributes.table_name") and isdefined("attributes.function_row_name")>
		function ekle_str(str_ekle,int_id,int_id2)
		{
			var newRow;
			var newCell;
			rowCount = rowCount + 1;
            <cfoutput>
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_form_name#.#attributes.row_count#</cfoutput>.value = rowCount;
                newRow = <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.all.#attributes.table_name#.insertRow();
                newRow.setAttribute("name","<cfoutput>#attributes.table_row_name#</cfoutput>" + rowCount);
                newRow.setAttribute("id","<cfoutput>#attributes.table_row_name#</cfoutput>" + rowCount);		
                newRow.setAttribute("style","display:''");	
                newCell = newRow.insertCell(newRow.cells.length);
                str_html = '';
                <cfif isdefined("attributes.field_poscat_id")>
                    str_html = str_html + '<input type="hidden" name="<cfoutput>#attributes.field_poscat_id#</cfoutput>" value="' + int_id + '">';
                </cfif>
        
                str_del = '<a href="javascript://" onClick="<cfoutput>#attributes.function_row_name#</cfoutput>(' + rowCount +');"><i class="fa fa-minus"></i></a>&nbsp;';	
                newCell.innerHTML = str_del ;
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = str_html + str_ekle;
                return 1;
            </cfoutput>
            return 1;
		 }
	</cfif>

	max_sayac = <cfoutput>#sorgu_sayac#</cfoutput>;
	function hepsi()
	{
		if (document.getElementById('all_').checked)
			{
				for(int_k=1 ; int_k <= max_sayac ; int_k++ )
				{
					var my_elem = eval("form_name.POS_CAT_IDS"+int_k);
					my_elem.checked = true;					
				}
			}
		else
			{
				for(int_k=1 ; int_k <= max_sayac ; int_k++ )
				{
					var my_elem = eval("form_name.POS_CAT_IDS"+int_k);
					my_elem.checked = false;
				}			
            }
	}

 	function add_checked()
	{
		for(int_k=1 ; int_k <= max_sayac ; int_k++ )
		{
			var my_elem = eval("form_name.POS_CAT_IDS"+int_k);
			if(my_elem.checked)
			{
				ekle_str(eval("form_name.POSITION_CAT" + int_k+".value") , eval("form_name.POSITION_CAT_ID" + int_k+".value"));
			}
		}
/* 		window.close();
 */	} 


















</script>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>