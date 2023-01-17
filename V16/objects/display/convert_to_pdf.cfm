<!---
	Description :
	   convert html pages to pdf format
	Parameters :
		module       ==> Module directory path name for page
		file         ==> file name of the page
	
	syntax1 : #request.self#?fuseaction=objects.popup_convertpdf&module=<module name>&file=<file name>#page_code#
	sample1 : #request.self#?fuseaction=objects.popup_convertpdf&module=finance/ch&file=list_emps_extre#page_code#
	
	Note1 : For sub modules , we should  arrange 'module' that syntax : <parent file structure>/<child file structure>
	Note2 : Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
	Note3 : '#page_code#' statement is important at the end
--->
<cfsavecontent variable="css">
<style type="text/css">
	body
	{
		margin-left : 0px;
		margin-top : 0px;
		margin-bottom : 0px;
		margin-right : 0px;
	}	
	table{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : #333333;}
	.txtbold {  font-weight: bold; font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 10px; color: #000000}
	.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
	.txtboldblue { font-weight: bold; font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 10px; color: #6699CC; padding-right: 1px; padding-left: 1px}
	.formbold {	font-family:  Geneva, Verdana, Arial, sans-serif; font-size : 11px; font-weight: bold;color: #000000;}
	.color-list	{background-color: #E6E6FF;}
	.color-header{background-color: #a7caed;}
	.color-border	{background-color:#6699cc;}
	.color-row{	background-color: #f1f0ff;}
	.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : #333333;padding-left: 4px;}
	.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 1px;color : #0033CC;	}          
	a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 1px;color : #0033CC;} 
	a.tableyazi:active {text-decoration: none;}
	a.tableyazi:hover {text-decoration: underline; color:#339900;}  
	a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 1px;color : #0033CC;}
	.form-title	{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:white;font-weight : bold; clip:   rect(   );}			
	a.form-title:visited 	{font-size:11px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;	color:white;font-weight : bold;}	
	a.form-title:active {text-decoration: none;}
	a.form-title:hover {text-decoration: underline; color:#ffffff;}  
	a.form-title:link{font-size:11px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;color:white;font-weight : bold;}	
</style>
</cfsavecontent>
<cfsavecontent variable="cont"><cfmodule template="../../index.cfm" fuseaction="#attributes.module#.#attributes.faction#" popup_for_files='1'></cfsavecontent>
<cfset cont = "<!-- sil -->" & cont & "<!-- sil -->">
<cfset start = find('<!-- sil -->',cont,1)>
<cfset middle = find('<!-- sil -->',cont,start + 12)>
<cfloop condition="(start gt 0) and (middle gt 0)">
	<cfset cont = removechars(cont,start,middle-start+12)>
	<cfset start = find('<!-- sil -->',cont,1)>
	<cfset middle = find('<!-- sil -->',cont,start + 12)>
</cfloop>
<cfset start = find('<!-- siil -->',cont,1)>
<cfset middle = find('<!-- siil -->',cont,start + 13)>
<cfloop condition="(start gt 0) and (middle gt 0)">
	<cfset cont = removechars(cont,start,middle-start+13)>
	<cfset start = find('<!-- siil -->',cont,1)>
	<cfset middle = find('<!-- siil -->',cont,start + 13)>
</cfloop>
<cfif isdefined("name")>
	<cfif Attributes.Name eq ''>
		<cfset filename = "#createuuid()#.pdf">
	<cfelse>
		<cfset filename = "#Attributes.Name#.pdf">
	</cfif>
	<cfif form.fonts eq 'verdana'>
		<cfset form.fonts = 'c:\winnt\fonts\verdana.ttf'>
	<cfelseif form.fonts eq 'comic'>
		<cfset form.fonts = 'c:\winnt\fonts\comic.ttf'>
	<cfelseif form.fonts eq 'arial'>
		<cfset form.fonts = 'c:\winnt\fonts\arial.ttf'>
	</cfif>
	<cfif form.margin_left eq ''>
		<cfset form.margin_left = 50>
	</cfif>
	<cfif form.margin_right eq ''>
		<cfset form.margin_right = 50>
	</cfif>
	<cfif form.margin_top eq ''>
		<cfset form.margin_top = 50>
	</cfif>
	<cfif form.margin_bottom eq ''>
		<cfset form.margin_bottom = 50>
	</cfif>
	<cfif find("/",attributes.module,1) neq 0>
		<cfset attributes.module = ListGetAt(attributes.module,1,"/")>
	</cfif>
	<cfset cont = ReplaceList(cont,'javascript://','')>
	
	<cftry>
		<cfx_Html2pdf 
			html_String="#cont#"
			outputfile="#upload_folder#finance#dir_seperator##filename#"
			imagesdir="#ExpandPath('/images')#" 
			header="#attributes.pdf_header# <br/> #DateFormat(now(),dateformat_style)# #TimeFormat(now(),timeformat_style)# (GMT+0)"
			footer="Bu döküman workcube PDF engine tarafindan üretilmistir <br/> www.workcube.com"
			table_header="true"
			font_family="#form.fonts#"
			font_encoding="IDENTITY_H"
			default_font_size="#attributes.default_font_size#"
			layout="#form.layout#"
			margin_top="#form.margin_top#"
			margin_right="#form.margin_right#"				
			margin_left="#form.margin_left#"				
			margin_bottom="#form.margin_bottom#"				
			pagesize="#form.pagesize#">
		</cfx_Html2pdf>
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.pdf" file="#upload_folder#finance#dir_seperator##filename#" deletefile="yes">
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top">
				<table height="100%" width="100%" cellspacing="1" cellpadding="2">
					<tr class="color-list">
						<td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id='32457.Workcube PDF Engine'></td>
					</tr>
					<tr class="color-row">
						<td align="center" class="headbold"><cf_get_lang dictionary_id='32458.PDF Basariyla Üretildi'>.</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			function waitfor(){
				<cfif isDefined("attributes.is_pop") and (attributes.is_pop EQ 1)>
					window.opener.close();
				</cfif>
				window.close();
			}
			setTimeout("waitfor()",3000);  
		</script>
		<cfcatch type="any">
			<cfoutput>--- #cont# --- <br/></cfoutput>
			<table width="98%" align="center">
				<tr>
					<td valign="bottom" class="headbold" align="center"><cf_get_lang dictionary_id='32459.Maalesef Bu Modülde Pdf Olusturamiyoruz'>!!</td>
				</tr>
				<tr>
					<td align="center" colspan="5">
						<form><input type="Button" value="<cf_get_lang dictionary_id='57553.Kapat'>" style="cursor:pointer" onclick="window.close();"></form>
					</td>
				</tr>
			</table>
		  <cfabort>
		</cfcatch>
	</cftry>
<cfelse>
	<cfform action="#request.self#?fuseaction=objects.popup_convertpdf#page_code#" name="pdf" method="post">
	<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
		<tr class="color-border">
			<td valign="middle" height="200">
			<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
				<tr class="color-list" valign="middle">
					<td height="35">
					<table width="98%" align="center">
						<tr>
							<td valign="bottom" class="headbold"><cf_get_lang dictionary_id='32457.Workcube PDF Engine'></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr class="color-row" valign="top">
					<td>
					<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td valign="top"><br/>
							<table>
								<tr>
									<td colspan="4" class="formbold"><cf_get_lang dictionary_id='32461.PDF Parametreleri'></td>
								</tr>
								<tr>
									<td width="100"><cf_get_lang dictionary_id='32462.Döküman Adi'></td>
									<td width="175"><input type="text" name="name" id="name" style="width:150px;"></td>
									<td width="100"><cf_get_lang dictionary_id='58071.Üst Marjin'></td>
									<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='32754.Lütfen Üst Marjini Sayi Giriniz !'></cfsavecontent>
										<cfinput type="text" name="margin_top" style="width:150px;" validate="integer" message="#message#">
									</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='57685.Font'></td>
									<td><select name="Fonts" id="Fonts" style="width:150px;">
											<option value="comic"><cf_get_lang dictionary_id='32781.Comic Sans MS'></option>
											<option value="verdana"><cf_get_lang dictionary_id='32785.Verdana'></option>
											<option value="arial" selected><cf_get_lang dictionary_id='32807.Arial'></option>
											<option value="COURIER"><cf_get_lang dictionary_id='32808.Courier'></option>
											<option value="HELVETICA"><cf_get_lang dictionary_id='32816.Helvetica'></option>
											<option value="Times_roman"><cf_get_lang dictionary_id='32827.Times New Roman'></option>
											<option value="ZAPFDINGBATS"><cf_get_lang dictionary_id='32863.Zapfdingbats'></option>
										</select>
									</td>
									<td><cf_get_lang dictionary_id='58072.Sag Marjin'></td>
									<td><cfsavecontent variable="message2"><cf_get_lang dictionary_id='32865.Lütfen Sag Marjini Sayi Giriniz !'></cfsavecontent>
										<cfinput type="text" name="margin_right" style="width:150px;" validate="integer" message="#message2#">
									</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='32466.Sayfa Formati'></td>
									<td><select name="pagesize" id="pagesize" style="width:150px;">
											<option value="A4"><cf_get_lang dictionary_id='32885.A4'></option>
											<option value="LEGAL"><cf_get_lang dictionary_id='32886.LEGAL'></option>
											<option value="LETTER"><cf_get_lang dictionary_id='32935.LETTER'></option>
											<option value="FLSA"><cf_get_lang dictionary_id='32973.FLSA'></option>
											<option value="FLSE"><cf_get_lang dictionary_id='32621.FLSE'></option>
											<option value="HALFLETTER"><cf_get_lang dictionary_id='32620.HALFLETTER'></option>
											<option value="NOTE"><cf_get_lang dictionary_id='32616.NOTE'></option>
										</select>
									</td>
									<td><cf_get_lang dictionary_id='58073.Sol Marjin'></td>
									<td><cfsavecontent variable="message3"><cf_get_lang dictionary_id='32984.Lütfen Sol Marjini Sayi Giriniz !'></cfsavecontent>
										<cfinput type="text" name="margin_left" style="width:150px;" validate="integer" message="#message3#">
									</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58070.Layout'></td>
									<td><select name="Layout" id="Layout" style="width:150px;">
											<option value="PORTRAIT"><cf_get_lang dictionary_id='32976.PORTRAIT'></option>
											<option value="LANDSCAPE"><cf_get_lang dictionary_id='32944.LANDSCAPE'></option>
										</select>
									</td>
									<td><cf_get_lang dictionary_id='58074.Alt Marjin'></td>
									<td><cfsavecontent variable="message4"><cf_get_lang dictionary_id='58074.Lütfen Alt Marjini Sayi Giriniz !'></cfsavecontent>
										<cfinput type="text" name="margin_bottom" style="width:150px;" validate="integer" message="#message4#">
									</td>
								</tr>
								<tr>
									<td width="100"><cf_get_lang dictionary_id='32406.Varsayilan Font Ölçüsü'></td>
									<td><select name="default_font_size" id="default_font_size" style="width:150px;">
											<option value="4">4</option>
											<option value="5">5</option>
											<option value="6">6</option>
											<option value="7">7</option>							  							  
										</select>
									</td>						
									<td width="100"><cf_get_lang dictionary_id='57480.Baslik'></td>
									<td width="175"><input type="text" name="pdf_header" id="pdf_header" style="width:150px;"></td>
								</tr>						
								<tr>
									<td colspan="4" style="text-align:right;"><cfsavecontent variable="message"><cf_get_lang dictionary_id='57478.PDF Yap'></cfsavecontent><cf_workcube_buttons is_upd='0' insert_info='#message#' insert_alert=''></td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td><cfoutput>#cont#</cfoutput></td>
		</tr>
	</table>
	</cfform>
</cfif>
