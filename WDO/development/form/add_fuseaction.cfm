<cfparam name="attributes.modul" default="">
<cfparam name="attributes.dictionary_id" default="">
<cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
<cfset GET_MODULES = list_wbo.getWbo('#dsn#')>
<cfset GET_USER_NAME = list_wbo.getUserName('#dsn#','#session.ep.userid#')>
<cfset WBO_TYPES = list_wbo.getWboList()>
<table class="dpm" align="center">
    <tr>
        <td class="dpml">
            <cfform name="add_faction" method="post" action="#request.self#?fuseaction=dev.emptypopup_add_fuseaction">
                <cf_form_box>
                	<table>
                    	<tr>
                        	<td colspan="3">
                                <input type="checkbox" name="is_active" id="is_active" value="1" checked="checked">Active&nbsp;&nbsp;
                                <input type="checkbox" name="is_special" id="is_special">Sisteme �zel &nbsp;&nbsp;
                                <input type="checkbox" name="is_menu" id="is_menu" value="1"> Men�de G�ster
                            </td>
						</tr>
                        <tr>                            
                            <td width="90">Base *</td>
                            <td width="220">
                                <select name="modul" id="modul" style="width:200px;">
                                    <option value="">
                                        <cf_get_lang_main no="322.Se�iniz">
                                    </option>
                                    <cfoutput query="GET_MODULES" group="SOLUTION">
                                        <optgroup label="#SOLUTION#">
                                            <cfoutput group="FAMILY">
                                                <optgroup label="&nbsp;&nbsp;#FAMILY#">
                                                    <cfoutput>
                                                        <option value="#MODUL_NO#">&nbsp;&nbsp;#MODULE#</option>
                                                    </cfoutput>
                                                </optgroup>
                                            </cfoutput>
                                        </optgroup>
                                    </cfoutput>
                                </select>
                            </td>
                            <td align="left" rowspan="2">Type *</td>
                            <td rowspan="2">
                            	<select name="wbo_type" id="wbo_type" multiple="multiple" style="width:200px; height:45px;">
                                	<cfoutput query="WBO_TYPES">
                                    	<option value="#TYPE_ID#">#TYPE_NAME#</option>
                                    </cfoutput>
                                </select>
                                <!---
                                <cf_multiselect_check 
                                    query_name="WBO_TYPES"  
                                    name="wbo_type"
                                    width="200" 
                                    option_value="TYPE_ID"
                                    option_name="TYPE_NAME">
                                    --->
                            </td>
                        </tr>
                        <tr>
                            <td>Head *</td>
                            <td><input type="text" name="head"  id="head" value="" style="width:100px;" readonly="readonly">
                                <input type="text" name="dictionary_id"  id="dictionary_id" value="" style="width:80px;">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_settings&module_name=dev&is_use_send&lang_dictionary_id=add_faction.dictionary_id&lang_item_name=add_faction.head','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
							</td>
                        </tr>
                        <tr>
                        	<td>Fuseaction *</td>
							<td><input type="text" name="fuseaction_name" id="fuseaction_name" value="" maxlength="100" style="width:200px;"></td>
                            <td>Security *</td>
                            <td>
                            	<select name="security"  id="security" style="width:200px;">
                                    <option value="">Please Select</option>
                                    <option value="HTTP" selected="selected">HTTP</option>
                                    <option value="HTTPS">HTTPS</option>
                                    <option value="FTP">FTP</option>
                                    <option value="FTPS">FTPS</option>
                                </select>
							</td>
                        </tr>
                        <tr>
						    <td>Full Path *</td>
                            <td><input type="text" name="file_path" id="file_path" style="width:200px;" placeholder="dev\form\add_fuseaction.cfm"></td>   
                            <td align="left">Window *</td>
                            <td>
                            	<select name="window_name" id="window_name" style="width:200px;" onchange="showPopupInfo();">
                                    <option value="">Please Select</option>
                                    <option value="normal">Normal</option>
                                    <option value="popup">Popup</option>
                                    <option value="emptypopup">Empty Popup</option>
                                </select>
							</td>                 
                        </tr>
                        <tr>
                        	<td>File Name</td>
            				<td><input type="file" name="file_name" style="width:180px;"></td>
                            <td class="popupInfo" style="display:none;"></td>
                            <td class="popupInfo" style="display:none;">
                            	<cfset popupTypeList = 'page*750*500;print_page*750*500;list*700*555;medium*600*470;small*570*350;date*275*190;project*800*620;large*615*550;horizontal*1600*300;list_horizontal*1100*400;wide*980*600;wide2*1100*600;longpage*1200*500;page_horizontal*800*500;video*480*420;online_contact*600*500;wwide*1600*860;long_menu*200*500;adminTv*1040*870;userTv*565*487;video_conference*750*610;white_board*100*730;wwide1*1200*700;norm_horizontal*950*300;page_display*1100*600;work*950*620'><!--- else 400,400--->
                            	<select name="popupInfoType"  id="popupInfoType" style="width:200px;">
                                    <option value=""><cf_get_lang_main no="322.Se�iniz"></option>
                                    <cfoutput>
                                        <cfloop index="index" from="1" to="#listlen(popupTypeList,';')#">
                                            <cfset item = listgetat(popupTypeList,index,';')>
                                            <option value="#listFirst(item,'*')#">#listFirst(item,'*')# (#listgetat(item,2,'*')#*#listgetat(item,3,'*')#)</option>
                                        </cfloop>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <div style="width:550px;margin-left:6px;" id="clickme">Detail</div>
                    <div style="idth:550px;margin-left:6px;" id="div_id">
                        <cfmodule
                            template="../../fckeditor/fckeditor.cfm"
                            toolbarSet="Basic"
                            basePath="/fckeditor/"
                            instanceName="work_detail"
                            valign="top"
                            value=""
                            width="550"
                            height="180">
                    </div>
                    <cf_form_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function='OnFormSubmit()'>
                    </cf_form_box_footer>
                </cf_form_box>
            </cfform>
        </td>
    </tr>
</table>
<script language="JavaScript">
$( "#clickme" ).click(function() {
  $( "#div_id" ).toggle( "slow", function() {
  });
});

function OnFormSubmit()
{
	var wbo_type_status = 0;
	var wbo_type_status = 0;
	for(i=0;i<document.getElementById('wbo_type').options.length;++i)
	{
		if(document.getElementById('wbo_type').options[i].selected==true)
		{
			wbo_type_status = 1;
			break;
		}
	}
	if(wbo_type_status == 0)
	{
		alert('Tip Se�melisiniz !');
		return false;
	}
	//Form Tipler i�in kontrol
	if((document.getElementById('wbo_type').options[0].selected== true || document.getElementById('wbo_type').options[1].selected== true) 
	&&(document.getElementById('wbo_type').options[2].selected== true || document.getElementById('wbo_type').options[3].selected== true || document.getElementById('wbo_type').options[4].selected== true || document.getElementById('wbo_type').options[5].selected== true || document.getElementById('wbo_type').options[6].selected== true || document.getElementById('wbo_type').options[7].selected== true))
	{
		alert(' Form Tiplerini Sadece Kendi Arasinda Se�ebilirsiniz !');
		return false;
	}
	//Query Tipler i�in kontrol		
	if((document.getElementById('wbo_type').options[2].selected== true || document.getElementById('wbo_type').options[3].selected== true) 
	&& (document.getElementById('wbo_type').options[0].selected== true || document.getElementById('wbo_type').options[1].selected== true || document.getElementById('wbo_type').options[4].selected== true || document.getElementById('wbo_type').options[5].selected== true || document.getElementById('wbo_type').options[6].selected== true || document.getElementById('wbo_type').options[7].selected== true))
	{
		alert('Query Tiplerini Sadece Kendi Arasinda Se�ebilirsiniz !');
		return false;
	}
	if(document.getElementById('base').value == "")
	{
		alert("Base se�melisiniz !");
		document.getElementById('base').focus();
		return false;
	}
	if(document.getElementById('modul').value == "")
	{
		alert("Modul se�melisiniz !");
		document.getElementById('modul').focus();
		return false;
	}
	
	if(document.getElementById('file_path').value == "query")
	{
		var metin = document.add_faction.fuseaction_name.value;
		if (metin.indexOf('emptypopup') == -1 && metin.indexOf('popupflush') == -1 )
		{ 
			alert("Query klas�r�ndeki WBO tanimlarinda Fuseaction ifadesi emptypopup yada popupflush ile baslamalidir.") ;
			return false;
		}
		else if(metin.indexOf('emptypopup') > 0)
		{ 
			alert("Emptypopup ifadesini basa aliniz.") ;
			return false;
		}
		else if(metin.indexOf('popupflush') > 0)
		{ 
			alert("Popupflush ifadesini basa aliniz.") ;
			return false;
		}
	}
	
	if(document.getElementById('fuseaction_name').value == "")
	{
		alert("Fuseaction se�melisiniz !");
		document.getElementById('fuseaction_name').focus();
		return false;
	}
	if(document.getElementById('head').value == "")
	{
		alert("Head se�melisiniz !");
		document.getElementById('head').focus();
		return false;
	}
	if(document.getElementById('file_path').value == "")
	{
		alert("Full Path girmelisiniz !");
		document.getElementById('file_path').focus();
		return false;
	}
	if(document.getElementById('window_name').value == "")
	{
		alert("Window Tipi se�melisiniz !");
		document.getElementById('window_name').focus();
		return false;
	}
	if(document.getElementById('security').value == "")
	{
		alert("Security Tipi se�melisiniz !");
		document.getElementById('security').focus();
		return false;
	}
}

function showPopupInfo()
{
	if($("#window_name").val() == 'popup')
	{
		$(".popupInfo").show();
	}
	else
	{
		$(".popupInfo").hide();
		$("#popupInfoType").val('');
	}
}
</script>
