<!---Parametreler--->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">

<!---Sayfa Başlığı--->
<div class="row">
	<div class="col-md-3">
		<label class="dpht">Kod Arama</label>
	</div>
</div>

<!---Arama Formu--->
<cfform name="frmCodeSearch" method="post" action="#request.self#?fuseaction=dev.code_search"><input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<div class="row">
		<div class="ltCodeSearchFilter">
			<cfinput type="text" name="keyword" id="keyword" message="Aranacak Kelimeyi Giriniz" placeholder="Aranacak Kelime" style="max-width:500px; width:50%; border-radius:5px;" value="#attributes.keyword#"  required="Yes" maxlength="50">
			<cf_wrk_search_button> 
		</div>
	</div>
<script type="text/javascript">
	document.frmCodeSearch.keyword.focus();
</script>
</cfform>
<!---Post Sonrası Sonuç--->
<cfif isdefined("form_submitted")>
	<cfset dosya_sayisi = 0>
	<cfset sonuc=[] >
	<cfobject name="getCodeSearch" component="WDO.development.cfc.CodeSearch" >
	<cfset aranacakDizinler=["V16","WBO","WDO","WMO","WRO","NoCode","Utility"] >
	<cfloop array="#aranacakDizinler#" index="d">
		<cfset arrMatchingPaths = getCodeSearch.SearchFiles(
		Path = ExpandPath( "./#d#" ),
		Criteria = "#attributes.keyword#"
		) />
		<cfloop array="#arrMatchingPaths#" index="mp">
			<cfset ArrayAppend(sonuc, #mp#)>
		</cfloop>
	</cfloop>
	
	
	<cf_box title="Arama Sonuçları" uidrop="1"> 
	<cf_ajax_list>
		<thead>
			<tr>
				<th>Aranan Kelime</th>
				<th>ilgili Dosya</th>
				<th>Workcube Object</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#sonuc#" index="i">
				<cfoutput>
					<tr>
						<td>#attributes.keyword#</td>
						<td><a href="file://#i#"  class="tableyazi">#i#</a></td>
						<td>
							<cfquery name="find_file" datasource="#dsn#">
								SELECT FULL_FUSEACTION,HEAD FROM WRK_OBJECTS WHERE FILE_NAME = '#listlast(i,'\')#'
							</cfquery>
							<cfif find_file.recordcount>
									<a href="#request.self#?fuseaction=#find_file.FULL_FUSEACTION#" class="tableyazi" target="blank">#find_file.HEAD#</a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
				<cfset dosya_sayisi = dosya_sayisi + 1>
			</cfloop>
			<tr>
				<td></td>
				<td colspan="2">
					Dosya Sayısı: <cfoutput>#dosya_sayisi#</cfoutput>
				</td>
			</tr>
		</tbody>
	</cf_ajax_list>
	</cf_box>
</cfif>


<!--- Eski Kod --->
<!---
<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.file_filter_type" default="">
<cfparam name="attributes.file_filter" default="">
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
		MODULE_SHORT_NAME,
		MODULE_NAME_TR,
		MODULE_NAME,
        FOLDER
	FROM 
		MODULES
	ORDER BY
		MODULE_NAME_TR
</cfquery>
<cfform name="code_search_form" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=dev.code_search">
<input type="hidden" value="1" name="is_submitted" id="is_submitted" />
	<table border="0" cellspacing="1" cellpadding="2" width="98%" align="center">
		<tr style="height:50px;">
        	<td class="dpht">Kod Arama</td>
        </tr>
        <tr valign="bottom">
			<td width="108px">Aranacak Kelime</td>
			<td><cfinput type="text" name="keyword" id="keyword" size="60" value="#attributes.keyword#" required="Yes" message="Aranacak Kelime Girmelisiniz" style="width:150px;">&nbsp;&nbsp;<!--- <img src="http://www.picgifs.com/graphics/s/snoopy/graphics-snoopy-660907.gif" style="width:150px;height:90px" /> --->  + karakteri ile birden fazla anahtar kelimeyi aynı anda içeren dosyalar bulunabilir.</td>
		</tr>
        <tr>
            <td width="108px">Dosya Adı</td>
            <td><cfinput type="text" name="file_filter" id="file_filter" size="60" value="#attributes.file_filter#" style="width:150px;">
                <select name="file_filter_type" id="file_filter_type">
                    <option value="">Bana Tıkla</option>
                    <option value="1" <cfif attributes.file_filter_type eq 1>selected="selected"</cfif>>İçeren</option>
                    <option value="2" <cfif attributes.file_filter_type eq 2>selected="selected"</cfif>>ile Başlayan</option>
                    <option value="3" <cfif attributes.file_filter_type eq 3>selected="selected"</cfif>>ile Biten</option>
                </select>
            </td>
        </tr>
        <tr>
        	<td>Excel e Getir <input type="checkbox" name="is_excel" id="is_excel" /></td>
            <td style="text-align:left"><cf_workcube_buttons is_upd='0' add_function="kontrol()" insert_info='Getir' is_cancel='0' insert_alert=''></td> 
        </tr>
		<tr>
			<td colspan="2">
				<table>
					<tr>
						<td><b>Ana Moduller</b></td>
					</tr>				
				<cfset x = 1>
				<cfloop from="1" to="#ceiling(get_modules.recordcount/5)#" index="i">
					<tr>
					<cfoutput query="get_modules" startrow="#x#" maxrows="5">
						<td width="200">#module_name_tr# (#module_name#)</td>
						<td width="60"><input type="checkbox"<cfif isdefined("attributes.#module_short_name#_") or not isdefined("attributes.is_submitted")>checked="checked"</cfif>  name="#module_short_name#_" id="#module_short_name#_" value="1"></td>
					</cfoutput>
					<cfset x = x+5>
					<cfif ceiling(get_modules.recordcount/5) neq i></tr></cfif>
				</cfloop>
						<td width="140">My Home</td>
						<td><input type="checkbox" name="myhome" id="myhome"<cfif isdefined("attributes.myhome") or not isdefined("is_submitted")>checked="checked"</cfif> value="1" /></td>
						<td width="140">Objects 2</td>
						<td><input type="checkbox" name="objects2" id="objects2" <cfif isdefined("attributes.objects2") or not isdefined("is_submitted")>checked="checked"</cfif>  value="1" /></td>
						<td width="140">Schedules</td>
						<td><input type="checkbox" name="schedules" id="schedules" <cfif isdefined("attributes.schedules") or not isdefined("is_submitted")>checked="checked"</cfif>  value="1" /></td>
					</tr>
					<tr>
						<td>PDA</td>
						<td><input type="checkbox" name="pda" id="pda" <cfif isdefined("attributes.pda") or not isdefined("is_submitted")>checked="checked"</cfif>  value="1" /></td>
						<td>Test</td>
						<td><input type="checkbox" name="test" id="test" <cfif isdefined("attributes.test")>checked="checked"</cfif>  value="1" /></td>
						<td>Add Options</td>
						<td><input type="checkbox" name="add_options" id="add_options" <cfif isdefined("attributes.add_options")>checked="checked"</cfif>  value="1" /></td>	
						<td>Documents</td>
						<td><input type="checkbox" name="documents" id="documents" <cfif isdefined("attributes.documents")>checked="checked"</cfif>  value="1" /></td>
						<td>FCK Editor</td>
						<td><input type="checkbox" name="fck_editor" id="fck_editor" <cfif isdefined("attributes.fck_editor")>checked="checked"</cfif>  value="1" /></td>
					</tr>
					<tr>
						<td>JS</td>
						<td><input type="checkbox" name="js" id="js" <cfif isdefined("attributes.js")>checked="checked"</cfif>  value="1" /></td>
						<td width="108">Design</td>
						<td><input type="checkbox" name="design" id="design" <cfif isdefined("attributes.design") or not isdefined("is_submitted")>checked="checked"</cfif> value="1"></td>
                        <td width="108">CSS</td>
						<td><input type="checkbox" name="css" id="css" <cfif isdefined("attributes.css") or not isdefined("is_submitted")>checked="checked"</cfif> value="1"></td>
                        <td width="108">Workdata</td>
						<td><input type="checkbox" name="workdata" id="workdata" <cfif isdefined("attributes.workdata") or not isdefined("is_submitted")>checked="checked"</cfif> value="1"></td>
					</tr>
					<tr>
						<td width="108"><b>Custom Tag</b></td>
						<td><input type="checkbox" name="custom_tags" id="custom_tags" <cfif isdefined("attributes.custom_tags") or not isdefined("is_submitted")>checked="checked"</cfif> value="1"></td>
					</tr>
					<tr>
						<td width="108"><b>Hepsi</b></td>
						<td><input type="checkbox" name="all_check" id="all_check" value="1" onclick="hepsi();"></td>
					</tr>                    
				</table>
			</td>
		</tr>
	</table>
</cfform>

<cfif isdefined("is_submitted")>
	<cfset like_list = ''>
    <!--- Secili Modullere gore Klasor Listesi Olusturuluyor --->
	<cfoutput query="get_modules">
		<cfif isdefined("attributes.#module_short_name#_")>
            <cfset folder_ = replace(folder,'/','\')>
			<cfset like_list = listappend(like_list,folder_,',')>   
		</cfif>
	</cfoutput>
		<cfif isdefined("attributes.myhome")>
			<cfset like_list = listappend(like_list,'myhome',',')>
		</cfif>
		<cfif isdefined("attributes.objects2")>
			<cfset like_list = listappend(like_list,'objects2',',')>
		</cfif>
		<cfif isdefined("attributes.schedules")>
			<cfset like_list = listappend(like_list,'schedules',',')>
		</cfif>
		<cfif isdefined("attributes.pda")>
			<cfset like_list = listappend(like_list,'workcube_pda',',')>
		</cfif>
		<cfif isdefined("attributes.objects2")>
			<cfset like_list = listappend(like_list,'objects2',',')>
		</cfif>
		<cfif isdefined("attributes.test")>
			<cfset like_list = listappend(like_list,'test',',')>
		</cfif>
		<cfif isdefined("attributes.add_options")>
			<cfset like_list = listappend(like_list,'add_options',',')>
		</cfif>
		<cfif isdefined("attributes.js")>
			<cfset like_list = listappend(like_list,'JS',',')>
		</cfif>
		<cfif isdefined("attributes.extra")>
			<cfset like_list = listappend(like_list,'extra',',')>
		</cfif>
		<cfif isdefined("attributes.design")>
			<cfset like_list = listappend(like_list,'design',',')>
		</cfif>
        <cfif isdefined("attributes.custom_tags")>
			<cfset like_list = listappend(like_list,'CustomTags',',')>
		</cfif>
		<cfif isdefined("attributes.css")>
			<cfset like_list = listappend(like_list,'css',',')>
        </cfif>
        <cfif isdefined("attributes.workdata")>
			<cfset like_list = listappend(like_list,'workdata',',')>
        </cfif>
    <!--- //Secili Modullere gore Klasor Listesi Olusturuluyor --->
    
	<cfset directory_list = "#index_folder#"><!--- Workcube kurulu oldugu klasor--->
    
	<cfset search_directory ="#index_folder#">	

	<cfset sayi_ = 0>
	
	<cfset folder_list = "">
    <cfset search_count = 0>
    <cfdirectory directory="#search_directory#" name="get_folders" listinfo="all" action="list"><!--- Workcube kurulumu icindeki klasorler alınıyor --->
		<cfoutput query="get_folders">
		    <cfset folder_list =   listappend(folder_list,get_folders.name,',')>
            
            <cfif name eq 'hr' and listfind(like_list,'hr\ehesap')>
	            <cfset folder_list = listappend(folder_list,'hr\ehesap',',')> 
            </cfif>
		</cfoutput>
        
        <cfloop list="#folder_list#" index="up_name_">
			<cfoutput>
				<cfset sayi_ = sayi_ + 1>
                
                <cfif listfind(like_list,up_name_)><!--- Secili olan klasorler kontrol ediliyor --->
                <cfset directory_list = listappend(directory_list,'#search_directory##up_name_#\')>

                <cfset sayi_ = sayi_ + 1>
                <cfdirectory directory="#search_directory##up_name_#" name="get_folders_#sayi_#" action="list"><!--- Ilgili Modulun altındaki dosyalara bakılıyor --->
                   <cfloop query="get_folders_#sayi_#">
                        <cfif evaluate("get_folders_#sayi_#.type") is 'dir'>
                            <cfset directory_list = listappend(directory_list,'#search_directory##up_name_#\#evaluate("get_folders_#sayi_#.name")#\')>
                            <cfdirectory directory='#search_directory##up_name_#\#evaluate("get_folders_#sayi_#.name")#\' name='get_folders_#sayi_#_a' action='list'>
                            <cfloop query="get_folders_#sayi_#_a">
                                <cfif evaluate("get_folders_#sayi_#_a.type") is 'dir'>
                                    <cfset directory_list = listappend(directory_list,'#search_directory##up_name_#\#evaluate("get_folders_#sayi_#.name")#\#evaluate("get_folders_#sayi_#_a.name")#\')>
                                </cfif>
                            </cfloop>
                        </cfif>
                    </cfloop>
                </cfif>
                
            </cfoutput>
        </cfloop>
        
	<cfset list_yasak = "selected,checked,bgcolor,background,if,margin,px,class,NULL,Selected,height,colspan,style,disabled,readonly,value,Checked,null,StructDelete,member_login_results,group,none,consumer,document,No,control_value,dsp_mail,form,parseFloat,process,title,parseInt,history,Array,1,2,3,4,5,6,7,8,9,0,">
	<cfset list_izin = "">
	<cfloop from="1" to="#listlen(list_yasak)#" index="xxx">
		<cfset list_izin = listappend(list_izin,'*')>
	</cfloop>

	<cfset dosya_sayisi = 0>
	<cfif isdefined("attributes.is_excel")>
		<cfset filename = "#dateformat(now(),'ddmmyyyy')#_#attributes.keyword#">
        <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader charset="utf-8" name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
    </cfif>
    <table style="width:100%">
	<cfloop list="#directory_list#" index="d_name">
		<cfif attributes.file_filter_type eq 1>
            <cfdirectory directory="#d_name#" name="get_sub_folders" action="list" filter="*#attributes.file_filter#*">
        <cfelseif attributes.file_filter_type eq 2>
            <cfdirectory directory="#d_name#" name="get_sub_folders" action="list" filter="*#attributes.file_filter#">
        <cfelseif attributes.file_filter_type eq 3>
            <cfdirectory directory="#d_name#" name="get_sub_folders" action="list" filter="#attributes.file_filter#*">
        <cfelse>
            <cfdirectory directory="#d_name#" name="get_sub_folders" action="list" filter="*.cfm|*.css|*.cfc|*.js">
        </cfif>
		
		<cfoutput query="get_sub_folders">
		
            <cftry>
                <cffile action="read" variable = "icerik_" file="#d_name##name#">
                <cfcatch>
                <tr>
                    <td>Okunamayan Dosya : #d_name##name# (Dosya Kullanılıyor ya da zarar görmüş olabilir ! )</td>
                </tr>    
                </cfcatch>
            </cftry>
			<cfset icerik_son_ =  ''>
            <cfset search_count = 0>
            <cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="kkk">
                <cfset eleman = "#listgetat(attributes.keyword,kkk,'+')#">
				
					<cfif findnocase(eleman,icerik_) and left(name,1) neq '_'>
						<cfset ++search_count>
						<cfif kkk eq listlen(attributes.keyword,'+') and search_count eq listlen(attributes.keyword,'+')>
							<cfset dosya_sayisi = dosya_sayisi + 1>
							<tr>
								<td style="width:25%">Aranan İfade : #eleman# &nbsp;&nbsp;&nbsp; </td> 
								<td style="width:75%">İlgili Dosya : <a href="file://#index_folder##replace('#d_name#','#search_directory#','')##name#" class="tableyazi">#d_name##name#</a></td>
                            </tr>
							<cfbreak>
						</cfif>
					</cfif>		
					
            </cfloop>
        </cfoutput>
	</cfloop>
        <tr>
            <td colspan="2" style="text-align:right">Dosya Sayısı : <cfoutput>#dosya_sayisi#</cfoutput></td>
        </tr>
    </table>
</cfif>
<!-- sil -->
<script type="text/javascript">
document.getElementById('keyword').focus();
function hepsi()
{
	if (document.getElementById('all_check').checked)
	{
	<cfoutput query="get_modules">
		document.getElementById('#module_short_name#_').checked = true;
	</cfoutput>
		document.getElementById('myhome').checked = true;
		document.getElementById('objects2').checked = true;
		document.getElementById('schedules').checked = true;
		document.getElementById('pda').checked = true;
		document.getElementById('test').checked = true;
		document.getElementById('add_options').checked = true;
		document.getElementById('documents').checked = true;
		document.getElementById('fck_editor').checked = true;
		document.getElementById('js').checked = true;
		document.getElementById('design').checked = true;
		document.getElementById('custom_tags').checked = true;
		document.getElementById('css').checked = true;
		document.getElementById('workdata').checked = true;
	}
	else
	{
	<cfoutput query="get_modules">
		document.getElementById('#module_short_name#_').checked = false;
	</cfoutput>	
		document.getElementById('myhome').checked = false;
		document.getElementById('objects2').checked = false;
		document.getElementById('schedules').checked = false;
		document.getElementById('pda').checked = false;
		document.getElementById('test').checked = false;
		document.getElementById('add_options').checked = false;
		document.getElementById('documents').checked = false;
		document.getElementById('fck_editor').checked = false;
		document.getElementById('js').checked = false;
		document.getElementById('design').checked = false;
		document.getElementById('custom_tags').checked = false;
		document.getElementById('css').checked = false;
		document.getElementById('workdata').checked = false;		
	}
}
function kontrol()
{
	if(document.getElementById('file_filter').value != '' && document.getElementById('file_filter_type').value =='')
	{
		alert('Dosya Adını Nasıl Arasın İsterdiniz ');
		document.getElementById('file_filter_type').focus();
		return false;
	}
	if(document.getElementById('is_excel').checked==true)
	{
		document.getElementById('code_search_form').action = '<cfoutput>#request.self#</cfoutput>?fuseaction=dev.emptypopup_code_search';
	}
}
</script>
--->