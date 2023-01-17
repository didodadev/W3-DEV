<cf_xml_page_edit fuseact="objects.popup_form_import_sales_cards">
<cfif xml_process_date eq 1>
	<cfset attributes.processdate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
<cfelse>
	<cfset attributes.processdate = ''>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32888.Satış Raporu Belgesi Ekle'></cfsavecontent>
<cf_box title="#message#" closable="0">
    <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=objects.emptypopup_upload_sales_cards">
    <cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group" id="item-startdate">
                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='58594.Format'></label>
                <div class="col col-8 col-xs-12">
                    <select name="target_pos" id="target_pos" onchange="get_details();">
                        <option value="-1"><cf_get_lang dictionary_id='45932.Genius'></option>
                        <option value="-2"><cf_get_lang dictionary_id='50158.Inter'></option>
                        <option value="-3">N C R</option>
                        <option value="-4"><cf_get_lang dictionary_id='58783.Workcube'></option>
                        <option value="-6">ESPOS</option>
                        <option value="-8">Wincor Nixdorf</option>
						<option value="-82">Wincor Nixdorf E-İşlem</option>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-startdate">
                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                <div class="col col-8 col-xs-12">
                    <select name="file_format" id="file_format">
                        <option value="ISO-8859-9"><cf_get_lang dictionary_id='32979.ISO-8859-9 (Türkçe)'></option>
                        <option value="UTF-8">UTF-8</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-uploaded_file">
                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='57468.Belge'></label>
                <div class="col col-8 col-xs-12">
                    <input type="file" name="uploaded_file" id="uploaded_file">
                </div>
            </div>
			<div class="form-group" id="item-uploaded_file2" style="display:none;">
                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='57468.Belge'> 2</label>
                <div class="col col-8 col-xs-12">
                    <input type="file" name="uploaded_file2" id="uploaded_file2">
                </div>
            </div>
            <div class="form-group" id="item-startdate">
                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='57453.Şube'> *</label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="department_id" id="department_id" value="">
                        <input type="text" name="department" id="department" value="" readonly>
                        <span class="input-group-addon icon-ellipsis"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=formexport&field_name=department&field_id=department_id&is_authority_branch=1</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group" id="item-startdate">
                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                    <cfinput type="text" name="processdate" value="#dateformat(attributes.processdate, dateformat_style)#" required="Yes" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="processdate"></span>
                    <cfinput type="hidden" name="date_now" value="#dateformat(date_add('h',session.ep.time_zone,now()),dateformat_style)#">	
                </div>
                </div>
            </div>
            <div class="form-group" id="item-startdate">
                <label class="col col-4 col-xs-4"><cf_get_lang dictionary_id ='34043.Kasa Numarası'></label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="import_detail" value="" maxlength="10" style="width:200px;">
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons is_upd='0' add_function='form_chk()'>
    </cf_box_footer>
</cfform> 

</cf_box>
</div>

<script type="text/javascript">
function get_details()
{
	eleman_ = document.getElementById('target_pos').value;
	if(eleman_ == '-82' || eleman_ == -82)
	{
		show('item-uploaded_file2');
	}
	else
	{
		hide('item-uploaded_file2');
	}
}

function form_chk()
{	
	if(!chk_period(formexport.processdate,"İşlem")) return false;
	if(document.getElementById('department_id').value == '')
	{
		alert("<cf_get_lang dictionary_id ='58579.Şube Seçiniz'> !");
		return false;
	}
	
	if(!date_check(document.formexport.processdate,document.formexport.date_now,"<cf_get_lang dictionary_id ='34040.Seçtiğiniz Tarih Bugünden Büyük Olmamalıdır'>!"))
	{
		return false;
	}	
	
	eleman_ = document.getElementById('target_pos').value;
	if(eleman_ == '-6' || eleman_ == -6 || eleman_ == '-2' || eleman_ == -2)
	{
		if (document.formexport.import_detail.value == "")
		{
			alert ("<cf_get_lang dictionary_id ='34177.INTER ve ESPOS Belgeler İçin Kasa No Açıklama Alanına Girilmelidir'> !");
			return false;
		}
	}
	
	eleman_ = document.getElementById('target_pos').value;
	if(eleman_ == '-82' || eleman_ == -82)
	{
		if(document.getElementById('uploaded_file').value == '' || document.getElementById('uploaded_file2').value == '')
		{
			alert('Dosya Seçmelisiniz!');
			return false;
		}
	}
	
	if (!chk_period(formexport.processdate,"İşlem")) return false;
	return true;		
}
</script>
