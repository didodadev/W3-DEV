<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!--- 
Description : fileların farkli serverlardan cekilmesini saglar.

Parameters :
	output_file :		--- > dosya adi --- required
	output_server :		--- > dosya serveri --- required
	output_type : 0,1,2,3,4,5,6,7,8 --- > imaj,dosya_adi,kucuk imaj,read,full path,linkli full path,other link --- required
	image_width : 		--- > imaj genisligi
	image_height : 		--- > imaj yuksekligi
	image_link : 0,1,2	--- > linksiz,popup,normal
	small_image : 		--- > kucuk imaj dosyasi
	read_name : 		--- > okunan dosya adi
	title :				--- > ürün açıklaması
	alt:				--- > imaj alt paramteresi
Syntax :
	<cf_get_server_file output_file="dosya_adi.gif" output_server="1" output_type="0">
created :
	YO20061027
	BK20120313 other link parametresi eklendi.
--->
<!--- <cfoutput>--#attributes.output_server#--</cfoutput> --->
<cfparam name="attributes.read_name" default="dosya">
<cfparam name="attributes.image_width" default="">
<cfparam name="attributes.image_height" default="">
<cfparam name="attributes.output_type" default="0">
<cfparam name="attributes.image_link" default="0">
<cfparam name="attributes.small_image" default="/images/file.gif">
<cfparam name="attributes.image_class" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.alt" default="">
<cfparam name="attributes.icon" default="">
<cfparam name="attributes.dam" default="0">
<cfset attributes.output_file = replace(attributes.output_file,'\','/','all')>
<!--- Urun detayında resimler link olarak verildigi icin attributes.output_server bos gelebilir. BK 20120319 --->
<cfif not isdefined("fusebox.server_machine_list")>
	<cfif isDefined("caller.fusebox.server_machine_list")>
		<cfset caller.fusebox.server_machine_list = caller.fusebox.server_machine_list>
	<cfelseif isdefined("caller.caller.fusebox.server_machine_list")>
		<cfset caller.fusebox.server_machine_list = caller.caller.fusebox.server_machine_list>
	<cfelseif isdefined("application.systemParam.systemParam.fusebox.server_machine_list")>
		<cfset caller.fusebox.server_machine_list = application.systemParam.systemParam().fusebox.server_machine_list>
	<cfelse>
		<cfset caller.fusebox.server_machine_list = application.systemParam.systemParam().server_machine_list>
	</cfif>	
</cfif>

<cfif not isdefined("fusebox.server_machine")>
	<cfif isdefined("caller.fusebox.server_machine")>
		<cfset caller.fusebox.server_machine = caller.fusebox.server_machine>
	<cfelseif isdefined("caller.caller.fusebox.server_machine")>
		<cfset caller.fusebox.server_machine = caller.caller.fusebox.server_machine>
	</cfif>
</cfif>
<cfif not isdefined("fusebox.file_web_path")>
	<cfif isDefined("caller.fusebox.file_web_path")>
		<cfset caller.file_web_path = caller.fusebox.file_web_path>
	<cfelseif isdefined("caller.caller.fusebox.file_web_path")>
		<cfset caller.file_web_path = caller.caller.fusebox.file_web_path>            
	</cfif>
</cfif>
<cfif not isdefined("caller.file_web_path")>
 	<cfset caller.file_web_path = application.systemParam.systemParam().file_web_path>
</cfif>
<cfif isdefined('attributes.output_server') and len(attributes.output_server)>
	<cftry>
		<cfset my_server_name = listgetat(caller.fusebox.server_machine_list,attributes.output_server,';')>
        <!--- Gerçek sistemde kayıtlı olan sistem sayısı, test sisteminde kayıtlı olan sistem sayısı ile birbirini tutmadığı zaman DB eşitlemelerinde gerçek sistemin fazla olan serverından yüklenen fotograflar hata veriyordu. id=89488 MA 20150528 --->
    <cfcatch>
    	<cfset my_server_name = listfirst(caller.fusebox.server_machine_list,';')>
    </cfcatch>
    </cftry>
<cfelse>
	<cfset my_server_name = listfirst(caller.fusebox.server_machine_list,';')>
</cfif>
<cftry>
<cfoutput>
<cfif attributes.output_server eq caller.fusebox.server_machine>
	<cfif attributes.output_type eq 0>
		<cfif attributes.image_link eq 1>
			<a href="javascript://" onclick="windowopen('#caller.file_web_path##attributes.output_file#','medium');"><img src="#caller.file_web_path##attributes.output_file#"  border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>></a>
		<cfelseif attributes.image_link eq 2>
			<a href="#caller.file_web_path##attributes.output_file#"><img src="#caller.file_web_path##attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>></a>
		<cfelse>
			<img src="#caller.file_web_path##attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>>
		</cfif>
	<cfelseif attributes.output_type eq 2>
		<cfif attributes.image_link eq 1>
			<a href="javascript://" onclick="windowopen('#caller.file_web_path##attributes.output_file#','medium');"><img src="#attributes.small_image#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>></a>
		<cfelseif attributes.image_link eq 2>
			<a href="#caller.file_web_path##attributes.output_file#"><img src="#attributes.small_image#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> alt="#attributes.alt#" <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>></a>
		<cfelse>
			<img src="#attributes.small_image#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif>>
		</cfif>
	<cfelseif attributes.output_type eq 1>
		<cfif attributes.image_link eq 1>
			<a href="javascript://" onclick="windowopen('#caller.file_web_path##attributes.output_file#','medium');">#attributes.output_file#</a>
		<cfelse>
			<a href="#caller.file_web_path##attributes.output_file#">#attributes.output_file#</a>
		</cfif>
	<cfelseif attributes.output_type eq 3>
		<!--- fbs 20120321 musteride documents klasorunun farkli yerde olmasi durumundaki problem nedeniyler degistirildi paramdan alindi
		<cffile action="read" file="#caller.index_folder#documents#caller.dir_seperator##attributes.output_file#" variable="c_dosya"> --->
		<cffile action="read" file="#caller.upload_folder##caller.dir_seperator##attributes.output_file#" variable="c_dosya">
		<cfset 'caller.#attributes.read_name#' = c_dosya>
	<cfelseif attributes.output_type eq 4>
		#caller.file_web_path##attributes.output_file#
	<cfelseif attributes.output_type eq 5>
		<img src="#my_server_name##caller.file_web_path##attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>>
	<cfelseif attributes.output_type eq 6>
		<a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#attributes.output_file#" class="tableyazi"><i class="fa fa-download"></i></a>
	<cfelseif attributes.output_type eq 7>
		<cfif attributes.dam eq 1>
			<a href="javascript://" onclick="windowopen('#caller.file_web_path##attributes.output_file#','medium');"><cf_get_lang dictionary_id = "38734.Görüntüle"></a>
		<cfelse>
			<a href="javascript://" onclick="windowopen('#caller.file_web_path##attributes.output_file#','medium');">#my_server_name#/documents/#attributes.output_file#</a>
		</cfif>
    <cfelseif attributes.output_type eq 8>
		<a href="javascript://" onclick="windowopen('#attributes.output_file#','medium');"><img src="#attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>></a>
	<cfelseif attributes.output_type eq 9>
		<cfset video = "#REPLACE("#attributes.output_file#","watch?v=","embed/","ALL")#">
        <iframe src="#video#"></iframe>
	</cfif>
<cfelse>
	<cfif attributes.output_type eq 0>
		<cfif attributes.image_link eq 1>
			<a href="javascript://" onclick="windowopen('#my_server_name#/documents/#attributes.output_file#','medium');"><img src="#my_server_name#/documents/#attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>></a>
		<cfelseif attributes.image_link eq 2>
			<a href="#my_server_name#/documents/#attributes.output_file#"><img src="#my_server_name#/documents/#attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> alt="#attributes.alt#" <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif> <cfif len(attributes.title)>title="#attributes.title#"</cfif>></a>
		<cfelse>
			<img src="#my_server_name#/documents/#attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif>  alt="#attributes.alt#" <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif> <cfif len(attributes.title)>title="#attributes.title#"</cfif>>
		</cfif>
	<cfelseif attributes.output_type eq 2>
		<cfif attributes.image_link eq 1>
			<a href="javascript://" onclick="windowopen('#my_server_name#/documents/#attributes.output_file#','medium');"><img src="#attributes.small_image#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> alt="#attributes.alt#"<cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif> <cfif len(attributes.title)>title="#attributes.title#"</cfif>></a>
		<cfelseif attributes.image_link eq 2>
			<a href="#my_server_name#/documents/#attributes.output_file#"><img src="#attributes.small_image#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif>  alt="#attributes.alt#" <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif> <cfif len(attributes.title)>title="#attributes.title#"</cfif>></a>
		<cfelseif attributes.image_link eq 3>
			<a href="javascript://" onclick="windowopen('#my_server_name##attributes.output_file#','medium');"><cfif len(attributes.icon)><i class="#attributes.icon#"></i><cfelse><img src="#attributes.small_image#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> alt="#attributes.alt#"<cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif> <cfif len(attributes.title)>title="#attributes.title#"</cfif>></cfif></a>
		<cfelse>
			<img src="#attributes.small_image#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif>>
		</cfif>
	<cfelseif attributes.output_type eq 1>
		<cfif attributes.image_link eq 1>
			<a href="javascript://" onclick="windowopen('#my_server_name#/documents/#attributes.output_file#','medium');">#attributes.output_file#</a>
		<cfelse>
			<a href="#my_server_name#/documents/#attributes.output_file#">#attributes.output_file#</a>
		</cfif>
	<cfelseif attributes.output_type eq 3>
		<cfhttp url="#my_server_name#/documents/#attributes.output_file#"></cfhttp>
		<cfset 'caller.#attributes.read_name#' = cfhttp.fileContent>
	<cfelseif attributes.output_type eq 4>
		#my_server_name#/documents/#attributes.output_file#
	<cfelseif attributes.output_type eq 5>
		<img src="#my_server_name##caller.file_web_path##attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> alt="#attributes.alt#" <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif> <cfif len(attributes.title)>title="#attributes.title#"</cfif>>
	<cfelseif attributes.output_type eq 6>
		<a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#my_server_name##caller.file_web_path##attributes.output_file#" class="tableyazi"><img src="#attributes.small_image#" border="0" alt="#attributes.alt#" <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>></a>
    <cfelseif attributes.output_type eq 8>
		<a href="javascript://" onclick="windowopen('#attributes.output_file#','medium');"><img src="#attributes.output_file#" border="0" <cfif len(attributes.image_width)>width="#attributes.image_width#"</cfif> alt="#attributes.alt#" <cfif len(attributes.title)>title="#attributes.title#"</cfif> <cfif len(attributes.image_height)>height="#attributes.image_height#"</cfif> <cfif len(attributes.image_class)>class="#attributes.image_class#"</cfif>></a>
	<cfelseif attributes.output_type eq 9>
		<cfset video = "#REPLACE("#attributes.output_file#","watch?v=","embed/","ALL")#">
        <iframe src="#video#"></iframe>
	</cfif>
</cfif>
</cfoutput>
<cfcatch type="any"><cfoutput>#caller.getLang('main',557)#!</cfoutput><!---- Dosya Görüntüleme Hatası ----></cfcatch>
</cftry>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
