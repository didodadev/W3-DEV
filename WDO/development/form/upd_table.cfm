<!--- kolon bilgilerinin cekildigi query--->
<cfquery name="get_column_property" datasource="#dsn#">
	SELECT * FROM WRK_COLUMN_INFORMATION WHERE TABLE_ID = #attributes.TABLE_ID#
</cfquery>
<!--- kolon bilgilerinin cekildigi query--->

<!---Tablo bilgisinin cekildigi query---->
<cfquery datasource="#dsn#" name="text_info">
	SELECT TABLE_INFO,OBJECT_NAME,OBJECT_ID,DB_NAME,STATUS,TYPE,VERSION,TABLE_INFO_ENG FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.TABLE_ID#
</cfquery>
<!---Tablo bilgisinin Çekildiği query---->

<cfoutput>
<table class="dph">
	<tr>
		<td class="dpht">Update Table</td>
		<td class="dphb">
            <input type="text" name="txt_table" id="txt_table" onkeyup="if(event.keyCode == 13) {check_table();}" onfocus="if(this.value=='Tablo Arama'){this.value='';this.style.color =''}" style="color:999999;width:215px;" value="<cfif isdefined("attributes.txt_table") and len(attributes.txt_table)><cfoutput>#attributes.txt_table#</cfoutput><cfelse>Tablo Arama</cfif>">&nbsp;&nbsp;&nbsp;
            <img src="http://ep.workcube/images/history.gif" />
            <a href="#request.self#?fuseaction=dev.add_table"><img src="http://ep.workcube/images/plus1.gif" /></a>
            <div id="check_table_layer" style="width:200px;position:absolute;right:180px;"></div>	
		</td>
	</tr>
</cfoutput>	
<form id="create_table_" name="create_table_" action="http://ep.workcube/index.cfm?fuseaction=dev.upd_table" method="post" >	
    <table class="dpm" align="center">
            <tr>
                <td class="dpml">
                    <cf_box style="width:99%">
                        <table>
                            <tr>
                                <td width="100"></td>
                                <td width="300"><input  disabled="disabled" type="checkbox" onclick="return aktif_ayni_tablo(this);" name="type" id="type" <cfif text_info.TYPE EQ 1>checked</cfif> />Active</td>
                            </tr>
                            <tr>
                                <td>Database Name</td>
                                <td>
                                    <cfif text_info.DB_NAME is 'workcube_cf'>
                                        Workcube_Main_Db
                                    <cfelseif text_info.DB_NAME is 'workcube_cf_product'>
                                        Workcube_Product_Db	
                                    <cfelseif text_info.DB_NAME is 'workcube_cf_1'>
                                        Workcube_Company_Db
                                    <cfelseif text_info.DB_NAME is 'workcube_cf_2012_1'>
                                        Workcube_Period_Db		
                                    </cfif>
                                </td>
                                <td>Status</td>
                                <td>
                                    <select name="status" id="status" style="width:123px;"> 
                                        <option value="Deployment" <cfif text_info.STATUS is 'Deployment'>selected</cfif>>Deployment</option>
                                        <option value="Development" <cfif text_info.STATUS is 'Development'>selected</cfif>>Development</option>
                                    </select> 
                                </td>
                            </tr>
                            <tr>
                                <td>Table Name</td>
                                <td><cfoutput>#text_info.OBJECT_NAME#</cfoutput><input type="hidden" name="table_name_text" value="<cfoutput>#text_info.OBJECT_NAME#</cfoutput>" id="table_name_text" /></td>
                                <td>Version</td>
                                <td><input type="text" id="version" value="<cfoutput>#text_info.VERSION#</cfoutput>" name="version" /></td>
                            </tr>
                            <tr>
                                <td valign="top">Description(Tr)*</td>
                                <td>
                                    <textarea cols="47" rows="6" id="table_info_text" name="table_info_text"><cfoutput>#text_info.TABLE_INFO#</cfoutput></textarea>
                                </td>
                                <td valign="top">Description(Eng)*</td>
                                <td>
                                    <textarea cols="47" rows="6" id="table_info_eng" name="table_info_eng"><cfoutput>#text_info.TABLE_INFO_ENG#</cfoutput></textarea>
                                </td>
                            </tr>
                            <!---<tr>
                                <td valign="top">Detail</td>
                                <td colspan="3">
                                    <textarea cols="47" rows="6" id="table_note" name="table_note"><cfoutput>#text_info.NOTE#</cfoutput></textarea>
                                </td>
                            </tr>--->
                        </table>
                    </cf_box>
                    <table class="big_list" id="link_table">
                        <thead>
                            <tr>
                                    <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_column_property.recordcount#</cfoutput>" />
                                    <input type="hidden"  name="object_id" id="object_id"value="<cfoutput>#text_info.OBJECT_ID#</cfoutput>">
                                    <input type="hidden" name="database_name" id="database_name" value="<cfoutput>#text_info.DB_NAME#</cfoutput>">
                                    <input type="hidden" name="tablo_adi" id="tablo_adi" value="<cfoutput>#text_info.OBJECT_NAME#</cfoutput>">
                                    <input type="hidden" name="table_type_control" id="table_type_control" value="<cfoutput>#text_info.TYPE#</cfoutput>">
                                
                                <th>Column Name*</th>
                                <th>Data Type</th>
                                <th>Length</th>
                                <th>Is Null?</th>
                                <th >Auto Increment</th>
                                <th>Default Value</th>
                                <th>Description(Tr)*</th>
                                <th>Description(Eng)</th>
                                <th>Alter</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_column_property">
                                <tr id="my_row_#currentrow#">
                                    <td>
                                        #COLUMN_NAME#
                                        <input type="hidden" name="column_id#currentrow#" id="column_id#currentrow#" value="#COLUMN_ID#" />
                                        <input type="hidden"  value="#currentrow#" id="row_kontrol_#currentrow#"  name="row_kontrol_#currentrow#">
                                        <input type="hidden" value="# get_column_property.DATA_TYPE#" name="data_type_#currentrow#" id="data_type_#currentrow#"/>
                                        <input type="hidden" value="1" name="control_#currentrow#" id="control_#currentrow#" />
                                    </td>
                                    <td> #DATA_TYPE#</td>
                                    <td><cfif MAXIMUM_LENGTH EQ -1 >MAX<cfelse>#MAXIMUM_LENGTH#</cfif></td>
                                    <td><input  disabled="disabled" type="checkbox" style="width:50px;" name="is_null#currentrow#" <cfif #IS_NULL# EQ'YES'>checked="checked"</cfif>  id="is_null#currentrow#"/></td>
                                    <td nowrap="nowrap">Start #SEED_VALUE#,Increment #INCREMENT_VALUE# </td>
                                    <td nowrap="nowrap"> #COLUMN_DEFAULT#</td>
                                    <td><input type="text"  name="column_info#currentrow#" id="column_info#currentrow#" value="#COLUMN_INFO#" /></td>
                                    <td><input type="text"  name="column_info_eng#currentrow#" id="column_info_eng#currentrow#" value="#COLUMN_INFO_ENG#" /></td>
                                    <td><input type="checkbox" readonly="readonly" onclick="alter_command(#currentrow#);" id="alter_control#currentrow#" name="alter_control" /></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="9">
                                    <cf_workcube_buttons 
                                    is_upd="1"
                                    is_delete='1' 
                                    delete_page_url="#request.self#?fuseaction=dev.emptypopup_del_table&TABLE_ID=#attributes.TABLE_ID#">
                                </td>
                            </tr>
                        </tfoot>		
                    </table>
                    
                    <!---<div id="delete_col"></div>--->
                    <cf_box title="ALTER TABLE" id="alter" style="width:99%" unload_body="1" box_page="#request.self#?fuseaction=dev.upd_table_ajax&type=5&table_id=#attributes.TABLE_ID#">
                    </cf_box>
                    <cf_box title="CREATE TABLE" id="create_" style="width:99%" unload_body="1" box_page="#request.self#?fuseaction=dev.upd_table_ajax&type=6&table_id=#attributes.TABLE_ID#">
                    </cf_box>
                    
                    <cf_box title="İlişkili Tablolar" 
                        id="relationed_table" 
                        closable="0"
                        style="width:99%"
                        body_style="overflow-y:hidden;"
                        add_href="#request.self#?fuseaction=dev.popup_add_relationship&table_id=#attributes.TABLE_ID#"
                        unload_body="1" box_page="#request.self#?fuseaction=dev.upd_table_ajax&type=7&table_id=#attributes.TABLE_ID#">
                    </cf_box>
                </td>
                <td class="dpmr">
                    
                    <cf_box title="İndexler" id="tbl_index" unload_body="1" box_page="#request.self#?fuseaction=dev.upd_table_ajax&type=1&table_id=#attributes.TABLE_ID#">
                    </cf_box>
                    
                    <cf_box title="Constraints" body_style="overflow-y:hidden;" id="Const" unload_body="1" box_page="#request.self#?fuseaction=dev.upd_table_ajax&type=2&table_id=#attributes.TABLE_ID#">
                    </cf_box>
                    
                    <cf_box title="History" body_style="overflow-y:hidden;" id="History" unload_body="1" box_page="#request.self#?fuseaction=dev.upd_table_ajax&type=3&table_id=#attributes.TABLE_ID#">
                    </cf_box>
                    
                    <cf_box title="Column Relation" body_style="overflow-y:hidden;" id="Relation"  unload_body="1" box_page="#request.self#?fuseaction=dev.upd_table_ajax&type=4&table_id=#attributes.TABLE_ID#">
                    </cf_box>		
                </td>	
            </tr>
    </table>
</form>

<script type="text/javascript">


function check_table()
{
	if(document.getElementById('txt_table').value.length > 2)
	{
		
		this_table_name = document.getElementById('txt_table').value;
		//get_table_ = wrk_safe_query('obj_get_table','dsn',0,this_table_name);
		_show_(this_table_name);
	}
	return false;
}


function _show_(this_table_name)
{
	if(document.getElementById('check_table_layer') != undefined)
	{
		
		goster(check_table_layer);
		//alert('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.emptypopup_get_table&table_name=' + this_table_name);
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.emptypopup_get_table&table_name=' + this_table_name,'check_table_layer',true);
	}
	else
		setTimeout('_show_("'+this_table_name+'")',20);
} 

</script>
