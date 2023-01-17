<!--- DBS Limit Import 20121211 --->
<cfparam name="attributes.bank_id" default="">
<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','DBS Aktarım','42840')#" closable="0">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_dbs_limit_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="bank_id" id="bank_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_bank_names">
                                    <option value="#bank_id#" <cfif attributes.bank_id eq bank_id>selected</cfif>>#bank_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-bank">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">                        
                        </div>
                    </div>
                    <div class="form-group" id="item-product_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/DBS_Limit_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                
                    </div>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='63130.LİMİT DESENİ'>                
                    </div>
                    <div class="form-group" id="item-exp2">
                        <cf_grid_list>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id='30817.Müşteri No'></th>
                                    <th><cf_get_lang dictionary_id='57571.Ünvan'></th>
                                    <th><cf_get_lang dictionary_id='59005.Şube Kodu'></th>
                                    <th><cf_get_lang dictionary_id='54820.Limit'></th>
                                    <th><cf_get_lang dictionary_id='57878.Kullanılabilir Limit'></th>
                                    <th><cf_get_lang dictionary_id='63131.Krediden Kullanılan Tutar'></th>
                                    <th><cf_get_lang dictionary_id='57489.Para Birimi'>(<cf_get_lang dictionary_id='37345.TL'>,<cf_get_lang dictionary_id='37344.USD'>,<cf_get_lang dictionary_id='63132.EUR'>,<cf_get_lang dictionary_id='63133.vs'>.)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-center">A(20)</td>
                                    <td class="text-center">A(40)</td>
                                    <td class="text-center">A(10)</td>
                                    <td class="text-center">N(15)</td>
                                    <td class="text-center">N(15)</td>
                                    <td class="text-center">N(15)</td>
                                    <td class="text-center">A(3)</td>
                                </tr>
                            </tbody>
                        </cf_grid_list>
                    </div>  
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='63134.ÖRNEK VERİ'>
                    </div>   
                    <div class="form-group" id="item-exp4">
                        M1051200161 &nbsp;
                        WORKCUBE E-BUSINESS SOLUTIONS &nbsp; 
                        0000012345000001150094.23000020000000.00000000010000.00USD &nbsp;
                    </div>
                    <div class="form-group" id="item-exp5">
                        M1051200312 &nbsp;      
                        WORKCUBE E-BUSINESS SOLUTIONS &nbsp;  
                        0000089012000001127094.93000015000000.00000000000000.00TRY &nbsp;
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
    	        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById("bank_id").value == '')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57521.Banka'>");
		return false;
	}
	if(document.getElementById("uploaded_file").value == '')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57468.Belge'>");
		return false;
	}
	return true;
}
</script>
