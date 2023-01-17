<br />
<cfquery name="get_search_layouts" datasource="#dsn_dev#">
SELECT
    LAYOUT_ID,
    LAYOUT_NAME
FROM
    SEARCH_TABLES_LAYOUTS_NEW
ORDER BY
   	LAYOUT_NAME
</cfquery>


<cfquery name="get_headers" datasource="#dsn_dev#">
	SELECT  * FROM SEARCH_TABLES_COLOUMS ORDER BY ROW_ID ASC
</cfquery>

<div class="col col-12">
	<cf_box draggable="1" title="#getLang('','Görünüm',32796)#" closable="1">
		<cfform name="add_" action="#request.self#?fuseaction=retail.emptypopup_save_layout_action_new" method="post">
			<input type="hidden" name="sort_list" id="sort_list">
			<cf_box_elements>
				<div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-record_type1">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="radio" name="record_type" value="1" <cfif not len(attributes.layout_id)>checked</cfif> onclick="set_action();"/> <cf_get_lang dictionary_id='45697.Yeni Kayıt'>
                        </label>
					</div>
					<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-record_type2">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <input type="radio" name="record_type" value="2" <cfif len(attributes.layout_id)>checked</cfif> onclick="set_action();"/> <cf_get_lang dictionary_id='57703.Güncelleme'>
                        </label>
                    </div>
				</div>
				<div class="col col-6 col-md-4 col-sm-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-layout_name" style="<cfif len(attributes.layout_id)>display:none;</cfif>">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62071.Yeni Layout İsmi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="layout_name" value="">
                        </div>
                    </div>
					<div class="form-group" id="item-old_layout_id" style="<cfif not len(attributes.layout_id)>display:none;</cfif>">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62072.Eski Layout İsmi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="old_layout_id" id="old_layout_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_search_layouts">
									<option value="#layout_id#" <cfif attributes.layout_id eq layout_id>selected</cfif>>#layout_name#</option>
								</cfoutput>
							</select>
                        </div>
                    </div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<input type="button" value="Kaydet" onclick="save_layout_src();"/>
			</cf_box_footer>
			<div id="hide_col_list_action_div"></div>
		</cfform>
	</cf_box>
</div>
<script>
deger_list = '';
	<cfoutput query="get_headers">
		var index = $('##jqxgrid').jqxGrid('getcolumnindex', '#kolon_ad#');
		var value = $('##jqxgrid').jqxGrid('getcolumnproperty', '#kolon_ad#', 'hidden');
		
		deger_ = '#kolon_ad#*';
		deger_ += index;
		if(value == false)
			deger_ += '*show';
		else
			deger_ += '*hide';
		
		if(deger_list == '')
			deger_list = deger_;
		else
			deger_list += ',' + deger_;
		//document.getElementById('ozel_ekran').innerHTML += 'alan: #kolon_ad#' +  '   sira: ' + index + '  gizleme:'  + '<br>';
	</cfoutput>
	document.getElementById('sort_list').value = deger_list;

function set_action()
{
	if(document.add_.record_type[0].checked == true)
	{
		show('new_record');
		show('new_record2');
		hide('upd_record');	
		hide('upd_record2');	
	}
	else
	{
		hide('new_record');
		hide('new_record2');
		show('upd_record2');
		show('upd_record');	
	}	
}
function save_layout_src()
{
	if(document.getElementById('layout_name').value == '' && document.add_.record_type[0].checked == true)
	{
		alert('<cf_get_lang dictionary_id='62069.Layout Giriniz'>!');
		return false;	
	}
	
	if(document.getElementById('old_layout_id').value == '' && document.add_.record_type[1].checked == true)
	{
		alert('<cf_get_lang dictionary_id='62070.Eski Layout Seçiniz'>!');
		return false;	
	}
	AjaxFormSubmit('add_','hide_col_list_action_div',1,'<cf_get_lang dictionary_id='58889.Kaydediliyor'>','<cf_get_lang dictionary_id='58890.Kaydedildi'>');	
}
</script>