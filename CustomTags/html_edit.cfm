<!--- 
Örnek Kullanım :

parametreler :
	form_name ==> html_edit i içine koyduğunuz form adı (zorunlu)
	field_name ==> içeriğin kopyalanacağı form alanı (sayfanızda tanımlamayın html_edit tanımlayacak)
	width ==> genişlik (default 350)(min 350)
	height ==> yükseklik (default 550)
	var_name ==> verilen değişken içeriği default olarak içerilir
		*** eğer bir içerik gönderecekseniz ve içeriğiniz html kod içeriyorsa
		htmleditformat yada html codeformat fonksiyonlarýndan geçirdikten sonra 
		gönderiniz 

	image_upload ==> 1 verilirse image upload edilebilir (default olarak kapalı) (eğer aktif yapılırsa folder da verilmeli)
	folder ==> image upload yapılacaksa hangi klasöre ("#file_web_path#sales/" gibi)
	
	add_table ==> 1 verilirse tablo ekleme ikonu görünür default açık
	add_flash ==> 1 verilirse flash ekleme ikonu görünür default kapalı (eğer aktif yapılırsa folder da verilmeli)
	add_file ==> 1 verilirse dosya ekleme ikonu görünür default kapalı (eğer aktif yapılırsa folder da verilmeli)
	add_code ==> 1 verilirse html kodu göster ikonu görünür default açık

Kullanım :
	1) öncelikle içinde html_edit kullandığınız forma  { onsubmit="return OnFormSubmit();" } parametresini ekleyin
	
	2) formunuzun içinde istediğiniz yerde 
	
	<cf_html_edit form_name="add_reply" field_name="reply" add_flash="0">
	
	şeklinde kullanılabilir isteğe bağlı parametreler de eklenebilir
	
Önemli Not:
	update sayfanızda ise

	  <cfset tr_topic = htmleditformat(TOPIC.TOPIC)>
      <cf_html_edit field_name="topic" form_name="upd_topic" var_name="tr_topic">
	şeklinde kullanın
 --->
<cfif not isdefined("attributes.add_table")>
	<cfset attributes.add_table = 1>
</cfif>
<cfif not isdefined("attributes.add_flash")>
	<cfset attributes.add_flash = 0>
</cfif>
<cfif not isdefined("attributes.add_file")>
	<cfset attributes.add_file = 0>
</cfif>
<cfif not isdefined("attributes.add_code")>
	<cfset attributes.add_code = 1>
</cfif>
<cfif (listlen(cgi.http_user_agent,';') eq 2) or (listgetat(cgi.http_user_agent,3,';') contains 'Mac')>
	<script type="text/javascript">
		function OnFormSubmit()
		{
			return true;
		}
	</script>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="<cfif isdefined("attributes.height")><cfoutput>#attributes.height#</cfoutput><cfelse>350</cfif>">
		<tr> 
			<td valign="top"> 
			<div id=editbar> 
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="left" height="<cfif isdefined("attributes.height")><cfoutput>#attributes.height#</cfoutput><cfelse>350</cfif>">
				<tr> 
					<td valign="top" width="<cfif not isdefined("attributes.width")>510<cfelse><cfoutput>#attributes.width#</cfoutput></cfif>"> 
					<table width="500" border="0" cellspacing="0" cellpadding="0" height="100%">
						<tr valign="top"> 
							<td><textarea name="<cfoutput>#attributes.field_name#</cfoutput>" id="<cfoutput>#attributes.field_name#</cfoutput>" style="<cfoutput>width:<cfif isdefined("attributes.width")>#attributes.width#<cfelse>100%</cfif>; height:<cfif isdefined("attributes.height")>#attributes.height#<cfelse>%100</cfif>;</cfoutput>"><cfif isdefined("attributes.var_name")><cfoutput>#evaluate('caller.#attributes.var_name#')#</cfoutput></cfif></textarea></td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			</div>
			</td>
		</tr>
	</table>
<cfelse>
	<style type="text/css">.clsCursor {cursor:pointer}</style>
	<textarea name="<cfoutput>#attributes.field_name#</cfoutput>" id="<cfoutput>#attributes.field_name#</cfoutput>" style="display: none;"><cfif isdefined("attributes.var_name")><cfoutput>#evaluate('caller.#attributes.var_name#')#</cfoutput></cfif></textarea>
	<input type="hidden" name="pd_edit_table" id="pd_edit_table" value="0">
	<input type="hidden" name="pd_edit_file" id="pd_edit_file" value="0">
	<input type="hidden" name="pd_edit_flash" id="pd_edit_flash" value="0">

	<script type="text/javascript">
		var errorString = '<cf_get_lang dictionary_id="32750.Bu sayfayı görüntülemek için Windows95 ve Internet Explorer 5 veya üzeri gerekir.">';
		var Ok = "false";
		var name =  navigator.appName;
		var version =  parseFloat(navigator.appVersion);
		var platform = navigator.platform;
		if (platform == "Win32" && name ==  "Microsoft Internet Explorer" && version >= 4) Ok = "true";
		else Ok= "false";
		
		if(Ok == "false") alert(errorString);
		
		function ColorPalette_OnClick(colorString)
		{	
			cpick.bgColor=colorString;
			document.all.colourp.value=colorString;
			doFormat('ForeColor',colorString);
		}
		
		function initToolBar(ed)
		{
			var eb = document.all.editbar;
			if (ed!=null) eb._editor = window.frames['html_edit'];
		}
		
		function doFormat(what)
		{
			var eb = document.all.editbar;
			if(what == "FontName")
			{
				if(arguments[1] != 1)
				{
					eb._editor.execCommand(what, arguments[1]);
					document.all.font.selectedIndex = 0;
				}
			}
			else if(what == "FontSize")
			{
				eb._editor.execCommand(what, arguments[1]);
				document.all.size.selectedIndex = 0;
			}
			else
			   eb._editor.execCommand(what, arguments[1]);
		}
		
		function swapMode()
		{
			var eb = document.all.editbar._editor;
			eb.swapModes();
		}
		
		function create()
		{
			var eb = document.all.editbar;
			eb._editor.newDocument();
		}
		
		function newFile()
		{
			create();
		}
		
		function makeUrl()
		{
			if (document.all.what.selectedIndex == 10 )
			{
				sUrl = document.all.what.value + document.all.url.value + '\',\'page\');';
			}
			else if (document.all.what.selectedIndex > 6)
			{
				sUrl = document.all.what.value + document.all.url.value + '\',\'page\');';
			}
			else
			{
				sUrl = document.all.what.value + document.all.url.value;
			}
			doFormat('CreateLink',sUrl);
			/*alert(document.frames("html_edit").document.frames("textEdit").document.body.innerHTML);*/
		}
		
		function copyValue() 
		{
			var theHtml = "" + document.frames("html_edit").document.frames("textEdit").document.body.innerHTML + "";
			<cfif url.fuseaction contains 'help.'>
				theHtml = eraseExcess(theHtml);
			</cfif>
			document.<cfoutput>#attributes.form_name#.#attributes.field_name#</cfoutput>.value = theHtml;
			return true;
		}
		
		function eraseExcess(txt)
		{
			var ind = 0;
			var content = txt;
			var ind1 = 0;
			var ind2 = 0;
			var temp;
			while((content.indexOf("<img",ind) != -1) || (content.indexOf("<IMG",ind) != -1))
			{
				if(content.indexOf("<img",ind) != -1)
					ind = content.indexOf("<img",ind) + 1;
				if(txt.indexOf("<IMG",ind) != -1)
					ind = content.indexOf("<IMG",ind) + 1;
				ind1 = content.indexOf(">",ind - 3);
				ind2 = content.lastIndexOf("<",ind - 3);
				temp = content.substring(ind2, ind1 + 1);		
				if(temp.indexOf("href=\"") != -1){
					content = content.slice(0, ind2) + content.slice(ind1 + 1, content.length);	
					ind -= temp.length;
					ind1 = content.indexOf("<",ind + 3);
					ind2 = content.indexOf(">",ind1 + 1);
					temp = content.substring(ind1, ind2 + 1);		
					content = content.slice(0, ind1) + content.slice(ind2 + 1, content.length);	
					ind -= temp.length;
					/*alert(ind1 + '-' + ind2 + '-' + temp + '-' + temp.length);*/
			}
						
		}
			ind = content.indexOf("href=\"");
			while(content.indexOf("href=\"",ind) != -1)
			{
				ind = content.indexOf("href=\"",ind) + 1;
				ind1 = content.indexOf("\"",ind + 8) + 1;
				if((content.indexOf("#",ind) < ind1) && (content.indexOf("#",ind) != -1))
					{content = content.slice(0, ind + 5) + content.slice(content.indexOf("#",ind), content.length);}
				else continue;
			}
			return content;
		}
		
		function SwapView_OnClick()
		{
			if(document.all.btnSwapView.value == '<cf_get_lang dictionary_id="51898.Html kodu göster">')
			{
				var sMes = '<cf_get_lang dictionary_id="51911.Wysiwyg moda dön">';
				var sStatusBarMes = '<cf_get_lang dictionary_id="51909.Html kodu gösteriliyor">';
			}
			else
			{
				var sMes = '<cf_get_lang dictionary_id="51898.Html kodu göster">';
				var sStatusBarMes = '<cf_get_lang dictionary_id="51914.Workcube İçerik Aracı">';
			}
			document.all.btnSwapView.value = sMes;
			window.status  = sStatusBarMes;
			swapMode();
		}
		
		function OnFormSubmit()
		{
			copyValue();
			return true;
		}
	</script>
 	<table width="100%" align="center">
    	<tr> 
      		<td valign="top"> 
			<table>
				<tr> 
					<td valign="top"> 
					<table border="0" cellpadding="0" cellspacing="0" width="100%" height="<cfif isdefined("attributes.height")><cfoutput>#attributes.height#</cfoutput><cfelse>350</cfif>">
						<tr> 
							<td valign="top"> 
							<div id=editbar> 
							<table width="100%" border="0" cellpadding="0" cellspacing="0" align="left" height="<cfif isdefined("attributes.height")><cfoutput>#attributes.height#</cfoutput><cfelse>350</cfif>">
								<tr> 
									<td height="20"> 
									<cfoutput> 
									<table border="0">
										<tr> 
											<td nowrap valign="baseline"> 
												<div align="left"> 
												<select name="font" id="font" onChange=" doFormat('FontName',document.all.font.value);" style="width:60px; font: 8pt verdana;">
													<option value="1" selected>#caller.getLang('main',273)#</option> <!--- Font --->
													<option value="arial">Arial</option>
													<option value="times">Times</option>
													<option value="courier">Courier</option>
													<option value="georgia">Georgia</option>
													<option value="verdana">Verdana</option>
													<option value="helvetica">Helvetica</option>
												</select>
												<select name="size" id="size" onChange="doFormat('FontSize',document.all.size.value);" style="width:52px;font: 8pt verdana;">
													<option value="None">#caller.getLang('main',274)#</option> <!--- Olcu --->
													<option value="1">1</option>
													<option value="2">2</option>
													<option value="3">3</option>
													<option value="4">4</option>
													<option value="5">5</option>
													<option value="6">6</option>
													<option value="7">7</option>
													<option value="+1">+1</option>
													<option value="+2">+2</option>
													<option value="+3">+3</option>
													<option value="+4">+4</option>
													<option value="+5">+5</option>
													<option value="+6">+6</option>
													<option value="+7">+7</option>
												</select>
												<img class='clsCursor' src="images/editor_images/Bold.gif" width="16" height="16" border="0" align="absmiddle" alt="#caller.getLang('main',91)#" onClick="doFormat('Bold')">&nbsp 
												<img class='clsCursor' src="images/editor_images/Italics.gif" width="16" height="16" border="0" align="absmiddle" alt="#caller.getLang('main',92)#" onClick="doFormat('Italic')">&nbsp 
												<img class='clsCursor' src="images/editor_images/underline.gif" width="16" height="16" border="0" align="absmiddle" alt="#caller.getLang('main',93)#" onClick="doFormat('Underline')" >&nbsp 
												<img class='clsCursor' src="images/editor_images/left.gif" width="16" height="16" border="0" alt="#caller.getLang('main',94)#" align="absmiddle" onClick="doFormat('JustifyLeft')"> 
												<img class='clsCursor' src="images/editor_images/centre.gif" width="16" height="16" border="0" alt="#caller.getLang('main',96)#" align="absmiddle" onClick="doFormat('JustifyCenter')">&nbsp 
												<img class='clsCursor' src="images/editor_images/right.gif" width="16" height="16" border="0" alt="#caller.getLang('main',95)#" align="absmiddle" onClick="doFormat('JustifyRight')">
												<img class='clsCursor' src="images/editor_images/justify.gif" width="16" height="16" border="0" alt="#caller.getLang('main',357)#" align="absmiddle" onClick="doFormat('JustifyFull')"></div>
											</td>
											<td valign="baseline" nowrap> 
												<img class='clsCursor' src="images/editor_images/para_bul.gif" width="16" align="absmiddle" height="16" border="0" alt="#caller.getLang('main',97)#" onClick="doFormat('InsertUnorderedList');" >&nbsp 
												<img class='clsCursor' src="images/editor_images/para_num.gif" width="16" align="absmiddle" height="16" border="0" alt="#caller.getLang('main',98)#" onClick="doFormat('InsertOrderedList');" >&nbsp 
												<img class='clsCursor' src="images/editor_images/indent.gif" width="20" align="absmiddle" height="16" alt="#caller.getLang('main',276)#" onClick="doFormat('Indent')">&nbsp 
												<img class='clsCursor' src="images/editor_images/outdent.gif" width="20" align="absmiddle" height="16" alt="#caller.getLang('main',275)#" onClick="doFormat('Outdent')">&nbsp 
												<img class='clsCursor' src="images/editor_images/hr.gif" align="absmiddle" width="16" height="18" alt="#caller.getLang('main',255)#" onClick="doFormat('InsertHorizontalRule')">&nbsp 
												<cfif isdefined("attributes.image_upload")>
													<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_image_upload<cfif isdefined("attributes.module")>&module=#attributes.module#</cfif>&folder=#attributes.folder#','small');"><img src="/images/image.gif" border="0"  alt="#caller.getLang('main',102)#"></a>
												</cfif>
												<cfif attributes.add_file eq 1>
													<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_file_toeditor<cfif isdefined("attributes.module")>&module=#attributes.module#</cfif>&folder=#attributes.folder#&field=#attributes.field_name#','small');"><img class='clsCursor' src="/images/asset.gif" align="absmiddle" border="0" alt="#caller.getLang('main',103)#"></a> 
												</cfif>
												<cfif attributes.add_table eq 1>
													<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_table_toeditor<cfif isdefined("attributes.module")>&module=#attributes.module#</cfif>&field=#attributes.field_name#','small');"><img class='clsCursor' src="/images/table.gif" border="0" alt="#caller.getLang('main',104)#" align="absmiddle"></a> 
												</cfif>
												<cfif attributes.add_flash eq 1>
													<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_flash_toeditor<cfif isdefined("attributes.module")>&module=#attributes.module#</cfif>&folder=#attributes.folder#&field=#attributes.field_name#','small');"><img class='clsCursor' src="/images/Flash.gif" border="0" alt="#caller.getLang('main',105)#"></a>								  
												</cfif>
												<cfif attributes.add_code eq 1>
													<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_edit_code','list');"><img class='clsCursor' src="/images/sourcecode.gif" align="absmiddle" border="0" alt="Source Code"></a>
												</cfif>
											</td>
										</tr>
									</table>
									</cfoutput>
									</td>
								</tr>
								<tr> 
									<td height="24"> 
									<table border="0" width="500">
										<tr valign="baseline"> 
											<td width="72" nowrap> 
												<select name="what" id="what" style="width:83px; font: 8pt verdana;">
													<option value="http://" selected>http://</option>
													<option value="mailto:">mailto:</option>
													<option value="ftp://">ftp://</option>
													<option value="https://">https://</option>
													<option value="<cfoutput>http://#CGI.SERVER_NAME#/#request.self#?fuseaction=</cfoutput>">Workcube</option>
													<option value="<cfoutput>javascript:windowopen('http://#CGI.SERVER_NAME#/#request.self#?fuseaction=</cfoutput>">Workcube Popup</option>
													<option value="javascript:windowopen('http://">Popup http://</option>
												</select>
											</td>
											<td width="150"><input type="text" name="url" id="url" size="28" style="width:150px; font: 8pt verdana;"></td>
											<td width="39"><input type="button" name="button2" id="button2" value="<cfoutput>#caller.getLang('main',170)#</cfoutput>" onClick="makeUrl();" style="font: 8pt verdana;"></td>
											<td width="35"> 
											<table bgcolor="#000000" width="25" id="cpick" border="1" cellspacing="0" cellpadding="0" align="center">
												<tr>
													<td>&nbsp;</td>
												</tr>
											</table>
											</td>
											<td width="182"> 
											<table border=1 bgcolor="#CCCCCC" cellpadding="0" cellspacing="0" width="74">
											<input type="hidden" name="colourp" id="colourp" size="8" value="#000000" style="width:74px; font: 8pt verdana" readonly>
												<tr> 
													<td bgcolor="#FF0000" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#FF0000')"></td>
													<td bgcolor="#ff00cc" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#ff00cc')"></td>
													<td bgcolor="#ff99ff" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#ff99ff')"></td>
													<td bgcolor="#ffff00" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#ffff00')"></td>
													<td bgcolor="#cc6600" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#cc6600')"></td>
													<td bgcolor="#cccc66" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#cccc66')"></td>
													<td bgcolor="#006600" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#006600')"></td>
													<td bgcolor="#339900" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#339900')"></td>
													<td bgcolor="#33cc69" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#33cc69')"></td>
													<td bgcolor="#000099" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#000099')"></td>
													<td bgcolor="#0099ff" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#0099ff')"></td>
													<td bgcolor="#6699cc" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#6699cc')"></td>
													<td bgcolor="#999999" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#999999')"></td>
													<td bgcolor="#996666" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#996666')"></td>
													<td bgcolor="#000000" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#000000')"></td>
												</tr>
												<tr> 
													<td bgcolor="#990000" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#990000')"></td>
													<td bgcolor="#ff6666" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#ff6666')"></td>
													<td bgcolor="#990099" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#990099')"></td>
													<td bgcolor="#ffcc00" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#ffcc00')"></td>
													<td bgcolor="#663300" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#663300')"></td>
													<td bgcolor="#ff9966" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#ff9966')"></td>
													<td bgcolor="#006666" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#006666')"></td>
													<td bgcolor="#666600" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#666600')"></td>
													<td bgcolor="#99cc00" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#99cc00')"></td>
													<td bgcolor="#333366" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#333366')"></td>
													<td bgcolor="#6633cc" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#6633cc')"></td>
													<td bgcolor="#9999ff" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#9999ff')"></td>
													<td bgcolor="#999966" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#999966')"></td>
													<td bgcolor="#666666" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#666666')"></td>
													<td bgcolor="#ffffff" width="12"><img class="clsCursor" src="/images/blank.gif" height=8 width=10 border=0 onClick="ColorPalette_OnClick('#ffffff')"></td>
												</tr>
											</table>
											</td>
										</tr>
									</table>
									</td>
								</tr>
								<tr> 
									<td valign="top" width="<cfif not isdefined("attributes.width")>510<cfelse><cfoutput>#attributes.width#</cfoutput></cfif>"> 
									<table width="500" border="0" cellspacing="0" cellpadding="0" height="100%">
										<tr valign="top"> 
											<td><iframe id="html_edit" scrolling="no" src="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_pd_edit<cfoutput>&field_name=#attributes.field_name#&form_name=#attributes.form_name#<cfif isdefined("attributes.image_upload")>&folder=#attributes.folder#</cfif></cfoutput>" onFocus="initToolBar(this)" width=<cfif not isdefined("attributes.width")>500<cfelse><cfoutput>#attributes.width#</cfoutput></cfif> height=100%></iframe></td>
										</tr>
									</table>
									</td>
								</tr>
							</table>
							</div>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
<script type="text/javascript">
	initToolBar("foo");
	window.status = '<cf_get_lang dictionary_id="51914.Workcube İçerik Aracı">';
</script>
</cfif>
