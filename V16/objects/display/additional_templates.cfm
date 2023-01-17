<cfset attributes.type = 1>
<cfinclude template="../../settings/query/get_template_dimension.cfm">
<table align="center" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF" style="width:<cfoutput>#GET_TEMPLATE_DIMENSION.TEMPLATE_WIDTH##GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT#;height:#GET_TEMPLATE_DIMENSION.TEMPLATE_HEIGHT##GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT#;</cfoutput>">
  <cfset attributes.offer_id = attributes.id>
  <cfinclude template="../../sales/query/get_offer_pages.cfm">
  <cfoutput query="GET_OFFER_PAGES">
    <tr>
      <td class="headbold">#page_no# - #page_name#</td>
    </tr>
    <tr>
      <td>#PAGE_CONTENT#</td>
    </tr>
  </cfoutput>
  <cfset url.offer_id = attributes.id>
  <cfinclude template="../../sales/query/get_offer_content.cfm">
  <cfoutput query="get_offer_content">
    <cfset attributes.type = 1>
    <cfinclude template="../../settings/query/get_template_dimension.cfm">
    <tr>
      <td class="headbold" valign="top">#cont_head#</td>
    </tr>
    <tr>
      <td class="txtbold" valign="top">#cont_summary#</td>
    </tr>
    <tr>
      <td valign="top">#cont_body#</td>
    </tr>
  </cfoutput>
</table>
<script type="text/javascript">
    function preview(){
		var errorString = "<cf_get_lang dictionary_id='32750.Bu Sayfayı Görüntülemek İçin Windows95 ve Internet Explorer 5 Veya Üzeri Gerekir !'>"
		var Ok = "IE";
		var name =  navigator.appName;
		var version =  parseFloat(navigator.appVersion);
		var platform = navigator.platform;	
		var document_height = Math.round(document.body.clientHeight / 3);
		
		if (platform == "Win32" && name == "Microsoft Internet Explorer" && version >= 4){
			Ok = "IE";
		} else 	if (name == "Netscape" && version >= 4){
			Ok = "Nets";
			document_height = Math.round(window.innerHeight / 3);
		}else{
			Ok= "false";
		}
	
	   var line_count = Math.round(document_height / <cfoutput>#GET_TEMPLATE_DIMENSION.TEMPLATE_HEIGHT#</cfoutput>);
	   if (Ok == "IE"){
		  for (i=1;i <= line_count ; i++){
				document.write("<div id='lines' style='z-index:1;position:absolute;left:10px;top:" +  (i * <cfoutput>#GET_TEMPLATE_DIMENSION.TEMPLATE_HEIGHT#</cfoutput>) + "mm;width:210mm;'><table width='100%' height='15'><tr><td width='30'><font size='1'>Sayfa</font></td><td><hr noshade></td><td width='30' align='right' ><font size='1'>Kesim</font></td></tr></table></div>");			
		  }	
		  /*alert('document_height : ' + document_height + ' - line_count : ' + line_count + ' - ' + document.all.lines.value);*/
	   }
	}   

</script>

