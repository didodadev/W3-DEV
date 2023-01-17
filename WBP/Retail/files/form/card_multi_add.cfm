

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form_basket" action="#request.self#?fuseaction=retail.card_multi_add" method="post" enctype="multipart/form-data">
            <input type="hidden" value="1" name="first_submit"/>
            <cf_box_elements>
                <div class="form-group" id="item-excel_file">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61842.Dosya Yüklemelisiniz'>!</cfsavecontent>
                    <cfinput type="file" name="excel_file" required="yes"  message=#message#>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='35776.Dosya Gönder'></cfsavecontent>
                <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' insert_info='#message#'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<table align="left" cellpadding="0" cellspacing="0" style="margin-left:10px;">
<tr>
<td>

<cfif isdefined("attributes.first_submit")>
	<cfif len(attributes.excel_file)>
		<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
        <cftry>
            <cffile action = "upload" 
                    fileField = "excel_file" 
                    destination = "#upload_folder#"
                    nameConflict = "MakeUnique"  
                    mode="777">
            <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
            
            <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
            
            <cfspreadsheet  
                action="read" 
                src = "#upload_folder##file_name#" 
                query = "get_excel"/> 
            <cffile action="delete" file="#upload_folder##file_name#">
            
            <cfset file_size = cffile.filesize>
            <cfcatch type="Any">
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
        
        <cfif get_excel.recordcount>
            <cfquery name="get_card_members" datasource="#dsn#">
                SELECT
                    C.CONSUMER_NAME,
                    C.CONSUMER_SURNAME,
                    CC.CARD_NO
                FROM
                    CUSTOMER_CARDS CC,
                    CONSUMER C
                WHERE
                    CC.ACTION_TYPE_ID = 'CONSUMER_ID' AND
                    CC.ACTION_ID = C.CONSUMER_ID AND
                    CC.CARD_NO IN ('#REPLACE(valuelist(get_excel.col_1),",","','","all")#')
            </cfquery>
        </cfif>
        <cfform name="form_basket1" action="#request.self#?fuseaction=retail.emptypopup_card_multi_add2" method="post">
        <cfinput type="hidden" value="#get_excel.recordcount#" name="rowscount"/>
        <cfsavecontent  variable="title"><cf_get_lang dictionary_id='61843.Genius Puan Ekleme'></cfsavecontent>
        <cf_form_box title="#title#">
        	<table>
                <tr>
                    <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
                    <td>
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='56986.Lütfen Açıklama Girin'></cfsavecontent>
                        <cfinput type="text" name="detail" required="yes" message="#message#" maxlength="60">
                    </td>
                    <td>
                    	<input type="checkbox" name="is_clear" value="1"/><cf_get_lang dictionary_id='61844.Sıfırlama İşlemi Yap'>
                    </td>
                    <td><cf_workcube_buttons is_upd='0'></td>
                </tr>  
            </table>
        </cf_form_box>
        <table class="medium_list">
        <thead>
        	<tr>
            	<th><cf_get_lang dictionary_id='30233.Kart No'></th>
                <th width="200"><cf_get_lang dictionary_id='58192.Müşteri Adı'></th>
                <th width="50"><cf_get_lang dictionary_id='58984.Puan'></th>
                <th width="75"><cfinput name="puan_ekle" type="text" value="0" class="moneybox" style="width:50px;" onBlur="puanekle();" onkeyup="formatcurrency(this,event,2);"> (+)</th>
                <th width="75"><cfinput name="puan_cikar" type="text" value="0" class="moneybox" style="width:50px;" onBlur="puancikar();" onkeyup="formatcurrency(this,event,2);"> (-)</th>
            </tr>
        </thead>
        <cfoutput query="get_excel" startrow="2" maxrows="#get_excel.recordcount#">
            <cfquery name="get_member" dbtype="query">
            	SELECT * FROM get_card_members WHERE CARD_NO = '#col_1#'
            </cfquery>
            <cfquery name="get_card_info" datasource="#dsn_gen#">
            	SELECT * FROM CARD WHERE CODE = '#col_1#'
            </cfquery>
            <cfquery name="get_cons_info" datasource="#dsn_gen#">
            	SELECT * FROM CUSTOMER WHERE ID = #get_card_info.FK_CUSTOMER#
            </cfquery>
            <tr>
                <td><input type="text" name="card_no_#currentrow#" value="#col_1#" readonly="readonly"></td>
                <td>#get_member.CONSUMER_NAME# #get_member.CONSUMER_SURNAME#</td>
                <td>#tlformat(get_cons_info.bonus,2)#</td>
                <td><cfinput name="puan_ekle_#currentrow#" type="text" value="0" class="moneybox" onkeyup="formatcurrency(this,event,2);" style="width:50px;"></td>
                <td><cfinput name="puan_cikar_#currentrow#" type="text" value="0" class="moneybox" onkeyup="formatcurrency(this,event,2);" style="width:50px;"></td>
            </tr>
        </cfoutput>
        </table>
        </cfform>
    <cfelse>
    	<cf_get_lang dictionary_id='61842.Dosya Yüklemelisiniz'>.
    </cfif>
<script>
function puanekle()
{
	ana_deger1 = document.getElementById('puan_ekle').value;
	for (var i=2; i <= <cfoutput>#get_excel.recordcount#</cfoutput>; i++) //ul içindeki lileri döndürüyoruz
	{
		document.getElementById('puan_ekle_' + i).value	= ana_deger1;
	}
	return false;
}
function puancikar()
{
	ana_deger1 = document.getElementById('puan_cikar').value;
	for (var i=2; i <= <cfoutput>#get_excel.recordcount#</cfoutput>; i++) //ul içindeki lileri döndürüyoruz
	{
		document.getElementById('puan_cikar_' + i).value = ana_deger1;
	}
	return false;
}
</script>
</cfif>

</td>
</tr>
</table>