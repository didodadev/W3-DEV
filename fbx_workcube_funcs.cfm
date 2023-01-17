<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="yes">
<!--- 
Workcube CF FonksiyonlarÄ± include
----------------------------------
* Sistem Ã‡apÄ±nda kullanÄ±lan fonksiyonlarÄ± buraya ekleyiniz
* EklediÄŸiniz Fonksiyonlar iÃ§in yardÄ±mÄ± aÅŸaÄŸÄ±daki formatta ekleyiniz
--->
<cfscript>
	/*  
		Sayfalama yaparken kullandÄ±ÄŸÄ±mÄ±z url_string ifadelerini attributes Struct'Ä±nÄ± dÃ¶ndÃ¼rerek kendisi oluÅŸturur.ilk parametre her zaman url ifadelerini tutan deÄŸiÅŸkenimizin ismi olmalÄ±dÄ±r,
		diÄŸer parametreler ise sayfa iÃ§inde kullanÄ±lan deÄŸiÅŸken isimlerini ifade eder ve n tane olabilir.
		Ã–rnek : wrkUrlStrings('url_str','is_submitted','keyword','station_id','location_id'); ÅŸeklinde kullanÄ±lÄ±r,bu durumda sayfanÄ±n iÃ§indeki tÃ¼m attributes deÄŸiÅŸkenlerinden uzunluklarÄ± olanlar "url_str" ismiyle set edilirler.
		M.ER 20 03 20009
	*/
	function wrkUrlStrings(){
		var arg_count = ArrayLen(Arguments);
		'#Arguments[1]#' = "";
		for(url_str_indx = 2;url_str_indx lte arg_count; url_str_indx=url_str_indx+1){
			if(isdefined("attributes.#Arguments[url_str_indx]#"))// and len(Evaluate("attributes.#Arguments[url_str_indx]#"))
				if(isdate(Evaluate("attributes.#Arguments[url_str_indx]#")) and ListLen(Evaluate("attributes.#Arguments[url_str_indx]#"),",") eq 1)//1,2,3 gibi bir deÄŸer geldiÄŸinde onuda tarih gibi algÄ±lÄ±yordu dolayÄ±sÄ± ile listlen kontrolÃ¼ eklendi...
					'#Arguments[1]#' = '#Evaluate("#Arguments[1]#")#&#Arguments[url_str_indx]#=#URLEncodedFormat(DateFormat(Evaluate("attributes.#Arguments[url_str_indx]#"),'DD/MM/YYYY'))#';
				else
					'#Arguments[1]#' = '#Evaluate("#Arguments[1]#")#&#Arguments[url_str_indx]#=#URLEncodedFormat(Evaluate("attributes.#Arguments[url_str_indx]#"))#';
		/*if(isdefined("attributes.#Arguments[url_str_indx]#"))			
			writeoutput('#Arguments[url_str_indx]#---#URLEncodedFormat(Evaluate("attributes.#Arguments[url_str_indx]#"))#---#isdate(Evaluate("attributes.#Arguments[url_str_indx]#"))#__#ListLen(Evaluate("attributes.#Arguments[url_str_indx]#"),",")# <br/>');	*/
		}
	}
</cfscript>

<cffunction name="getReport" access="public" returntype="any">
	<!--- 
	creator: Cemil Durgan, Durgan20150825
	notes :
		verilen queryden dosya Ã¼retir ya da queryyi ekrana basar.
	parameters :
		type [string] :
			xls - Eski yapÄ±ya uygun excel dosyasÄ± oluÅŸturur. Her sheet 65k satÄ±rÄ± geÃ§memeli.
			xlsx - Yeni yapÄ±ya uygun excel dosyasÄ± oluÅŸturur. Her sheet 1m satÄ±rÄ± geÃ§memeli.
			pdf - Pdf dosyasÄ± oluÅŸturur. Sadece pdf olarak gÃ¶nderildiÄŸinde pagetype: a4, yÃ¼kseklik 29, geniÅŸlik 21 default deÄŸerlerini alÄ±r. 'pdf_a4:29:21' ÅŸeklinde Ã¶zelleÅŸtirilebilir.
			display - jQuery ile display yapar.
		sheetStruct [struct] :
			Her bir sheeti oluÅŸturmak iÃ§in bu ÅŸekilde bir yapÄ± oluÅŸturulup gÃ¶nderilmeli. sheetStruct altÄ±nda birden fazla sheet tanÄ±mlanabilir.
				sheetStruct.theSheet.sourcesql [query] - theSheet sheet'inin kaynak sorgusu.
				sheetStruct.theSheet.colremove [string] - formatlama amaÃ§lÄ± Ã§ektiÄŸimiz kolonlar olabilir, silmek iÃ§in liste olarak gÃ¶nderirsek iÅŸini bitirince bu kolonlarÄ± uÃ§urur.
				sheetStruct.theSheet.pagebreak [numeric] - Sayfa baÅŸÄ±na kaÃ§ satÄ±r geleceÄŸi. Åimdilik PDF iÃ§in.
				sheetStruct.theSheet.formatOrder [string] - GÃ¶ndereceÄŸimiz formatlarÄ±n uygulanma sÄ±rasÄ±. Liste olarak format isimleri gÃ¶nderilir.
				sheetStruct.theSheet.format [struct] - FormatlarÄ±mÄ±zÄ± tutan struct. Birden fazla format tutabilir.
					# sheetStruct.theSheet.format.boldFormat.bold [boolean] ve 
					# sheetStruct.theSheet.format.boldFormat.font [string] ÅŸeklinde spreadsheetformatcell'de kullanÄ±lan Ã¶zellikler kullanÄ±labilir
					Bunlara ek olarak;
					# sheetStruct.theSheet.format.boldFormat.rowvalue [string] ile formatÄ±n etkilemesi gereken satÄ±r numaralarÄ± liste olarak gÃ¶nderilebilir,
					# sheetStruct.theSheet.format.boldFormat.colvalue [string] ile formatÄ±n etkilemesi gereken kolonlarÄ±n isimleri gÃ¶nderilebilir.
						Ä°kisi beraber gÃ¶nderilirse, bunlarÄ±n kesiÅŸtiÄŸi hÃ¼creler formatlanÄ±r.
		filename [string] :
			oluÅŸacak dosyanÄ±n adÄ±. EÄŸer birden fazla dosya oluÅŸursa filename_sheetname ÅŸeklinde oluÅŸur.
		logfile [numeric], default 0:
			ÅŸimdilik 0 ve 1 olarak gÃ¶nderilebilir. EÄŸer 1 olarak seÃ§ilirse, iÅŸlemin detaylarÄ±nÄ± loglar, zip dosyasÄ±nÄ±n iÃ§inde bÄ±rakÄ±r, ayrÄ±ca yeni sekmede gÃ¶sterir.
		singleSheet [numeric], default 1:
			0 ve 1 gÃ¶nderilebilir. 1 gÃ¶nderildiÄŸinde oluÅŸan dosyalarÄ± tek parÃ§ada toplar. PDF ise merge eder, excel ise sheetler halinde verir. 0 iken parÃ§alÄ± halde verir.
	usage :
		report/standart/rapor_yevmiye.cfm 'de Ã¶rneÄŸi var.
 --->
	<cfargument name="type" type="string" required="yes" default="" />
    <cfargument name="sheetStruct" type="struct" required="yes" default="" />
    <cfargument name="filename" type="string" required="yes" default="" />
    <cfargument name="logfile" type="numeric" required="no" default="0" />
    <cfargument name="singleSheet" type="numeric" required="no" default="0" />
    
    <cfif ListLen(arguments.type,'_') gt 1>
    	<cfset arguments.pagetype = ListGetAt(arguments.type,2,'_')>
        <cfset arguments.type = ListGetAt(arguments.type,1,'_')>
    <cfelse>
    	<cfset arguments.pagetype = 'a4;29;21'>
    </cfif>
    
    <!--- addLog : log dosyasÄ±na kayÄ±t atar. BÃ¶ylece dosya oluÅŸurken hangi aÅŸamada olduÄŸunu gÃ¶rebilirim. --->
    <cffunction name="addLog" access="private" returntype="any">
    	<cfargument name="msg" type="string" required="yes" default="" />
		<cfif not FileExists("#upload_folder#reserve_files/#session.ep.userid#/log.txt")>
            <cffile action="write" file="#upload_folder#reserve_files/#session.ep.userid#/log.txt" output="[#timeFormat(Now(),'hh:mm:ss')#] getReport : Log dosyasi olusturuldu.">
        </cfif>
        
        <cffile action="append" file="#upload_folder#reserve_files/#session.ep.userid#/log.txt" output="[#timeFormat(Now(),'hh:mm:ss')#] getReport : #arguments.msg#">
    </cffunction>
    <!--- //addLog --->
    
    <cfset report_filename = ListGetAt(arguments.filename,1)>
    
    <!--- prepareDirectory : reserve_files altÄ±ndaki #userid# klasÃ¶rÃ¼nÃ¼ uÃ§urup baÅŸtan oluÅŸturur. Araya sleep attÄ±m, bazen daha silemeden tekrar oluÅŸturmaya Ã§alÄ±ÅŸÄ±yor Ã§Ã¼nkÃ¼. --->
    <cffunction name="prepareDirectory" access="private" returntype="any">
    	<cftry>
			<cfif DirectoryExists("#upload_folder#reserve_files/#session.ep.userid#")>
                <cfdirectory action="delete" directory="#upload_folder#reserve_files/#session.ep.userid#" recurse="yes">
            </cfif>
            <cfif FileExists("#upload_folder#/reserve_files/#report_filename#.zip")>
                <cffile action="delete" file="#upload_folder#/reserve_files/#report_filename#.zip">
            </cfif>
            <cfset Sleep(3000)>
            <cfdirectory action="create" directory="#upload_folder#reserve_files/#session.ep.userid#">
            <cfset log = addLog('Klasorler olusturuldu.')>
            
            <cfcatch>
            	<cfset log = addLog('Klasorlerin silinmesi/olusturulmasi sirasinda bir hata olustu. Dosyalar ya da klasorler kullanimda olabilir.')>
                <script type="text/javascript">
					alert('Klasorlerin silinmesi/olusturulmasi sirasinda bir hata olustu. Dosyalar ya da klasorler kullanimda olabilir.');
					window.reload();
				</script>
                <cfabort>
            </cfcatch>
        </cftry>
    </cffunction>
    <!--- //prepareDirectory --->
    
    <!--- spreadsheetNewFromQuery : gelen query objesini olduÄŸu gibi excele gÃ¶mer, oradan okur. spreadsheetaddrows'tan Ã§ok daha performanslÄ±. 65k satÄ±rÄ± geÃ§memesine dikkat etmek gerek, Ã§Ã¼nkÃ¼ xls. --->
    <cffunction name="spreadsheetNewFromQuery" output="no">
        <cfargument name="data" type="query" required="yes">
        <cfargument name="sheetName" type="string" required="yes">
        
        <cfset tempPath = GetTempDirectory() & CreateUuid & ".xls">
        
        <cfspreadsheet action = "write" filename = "#tempPath#" query = "data" sheetname = #sheetName# overwrite="true">
        <cfscript>
            var spreadSheetObject = SpreadsheetRead(tempPath);
            FileDelete(tempPath);
            SpreadsheetDeleteRow(spreadSheetObject,1);
			SpreadsheetShiftRows(spreadSheetObject,2,data.recordcount+1,-1);
            return spreadSheetObject;
        </cfscript>
    </cffunction>
    <!--- //spreadsheetNewFromQuery --->
    
    <!--- sheetler arasÄ±na garbage collect yapacaÄŸÄ±m o yÃ¼zden bu java objelerine ihtiyacÄ±m var. --->
	<cfset runtime = createObject("java","java.lang.Runtime").getRuntime()>
    <cfset objSys = createObject("java","java.lang.System")/>
    
    <cfset start_time = GetTickCount()>
    
    <cfset pd = prepareDirectory()>

    <cfset row_count = 0>
    
	<cfif arguments.type eq 'xlsx' or arguments.type eq 'xls'>
    	<cfset structList = ListSort(StructKeyList(arguments.sheetStruct),'numeric')>
        <cfset log = addLog('#arguments.type# secildi.')>
        <cfset log = addLog('Olusturulacak sayfa sayisi : #ListLen(structList)#')>
        <cfset old_tick_count = GetTickCount()>
        <cfloop list="#structList#" index="currentSheet">
        	<cfset sheetstruct[currentsheet] = arguments.sheetStruct[currentSheet]>
            <cfset tempquery = sheetstruct[currentsheet].sourcesql>
        	<cfset row_count = row_count + tempquery.recordcount>
            
            <cfset theSheet = spreadsheetNewFromQuery( data : tempquery, sheetName = sheetstruct[currentsheet].sheetname )>
            
            <cfset cfcolors = 'aqua,black,blue,blue_grey,bright_green,brown,coral,cornflower_blue,dark_blue,dark_green,dark_red,dark_teal,dark_yellow,gold,green,grey_25_percent,grey_40_percent,grey_50_percent,grey_80_percent,indigo,lavender,lemon_chiffon,light_blue,light_cornflower_blue,light_green,light_orange,light_turquoise,light_yellow,lime,maroon,olive_green,orange,orchid,pale_blue,pink,plum,red,rose,royal_blue,sea_green,sky_blue,tan,teal,turquoise,violet,white,yellow'>
            <cfset cfcolorindexes = '49,8,12,54,11,60,29,24,18,58,16,56,19,51,17,22,55,23,63,62,46,26,48,31,42,52,41,43,50,25,59,53,28,44,14,61,10,45,30,57,40,47,21,15,20,9,13'>
            
            <!--- gelen rgb deÄŸerine gÃ¶re cfcolors listesinden bir renk deÄŸerinin rgb deÄŸerlerini manipÃ¼le edip, formatlarÄ± uygularken formattaki color yerine onu koyacaÄŸÄ±m ve kullanacaÄŸÄ±m. BÃ¶ylece 40-50 renk ile kÄ±sÄ±tlanmayacaÄŸÄ±m. --->
            <cfset rgblist = ''>
            <cfset colorlist = ''>
            <cfloop list="#sheetstruct[currentsheet].formatOrder#" index="currentformat">
            	<cfscript>
					if(structKeyExists(sheetstruct[currentsheet].format[currentformat],'color') and ListFind(colorlist,sheetstruct[currentsheet].format[currentformat].color) eq 0) {
						newcolorcode = ListGetAt(cfcolors,ListLen(colorlist)+1);
						theSheet.getworkbook().getcustompalette().setcoloratindex(ListGetAt(cfcolorindexes,ListFind(cfcolors,newcolorcode)),javacast("int",inputBaseN(Mid(sheetstruct[currentsheet].format[currentformat].color,1,2), 16)).bytevalue(),javacast("int",inputBaseN(Mid(sheetstruct[currentsheet].format[currentformat].color,3,2), 16)).bytevalue(),javacast("int",inputBaseN(Mid(sheetstruct[currentsheet].format[currentformat].color,5,2), 16)).bytevalue());
						sheetstruct[currentsheet].format[currentformat].color = newcolorcode;
						
						rgblist = ListAppend(rgblist,sheetstruct[currentsheet].format[currentformat].color);
						colorlist = ListAppend(colorlist,newcolorcode);
					}
				</cfscript>
            </cfloop>
            
            <!--- zaten yukarÄ±da theSheet objesini spreadsheetNewFromQuery ile hÄ±zlÄ±ca oluÅŸturmuÅŸtum, ÅŸimdi sadece gelen formatlarÄ± uygulayacaÄŸÄ±m. --->
            <cfloop list="#sheetstruct[currentsheet].formatOrder#" index="currentformat">
            	<cfscript>
					if(structKeyExists(sheetstruct[currentsheet].format[currentformat],'color')) {
						sheetstruct[currentsheet].format[currentformat].color = ListGetAt(colorlist,ListFind(rgblist,sheetstruct[currentsheet].format[currentformat].color));
					}
				
					if(not structKeyExists(sheetstruct[currentsheet].format[currentformat],'rowvalue') and structKeyExists(sheetstruct[currentsheet].format[currentformat],'colvalue')) {
						for(col_num = 1; col_num lte ListLen(arrayToList(tempquery.getColumnList())); col_num = col_num + 1) {
							if(ListFindNoCase(sheetstruct[currentsheet].format[currentformat].colvalue,ListGetAt(arrayToList(tempquery.getColumnList()),col_num)))
								SpreadSheetFormatColumn(theSheet,sheetstruct[currentsheet].format[currentformat],col_num);
						}
					}
					if(structKeyExists(sheetstruct[currentsheet].format[currentformat],'rowvalue') and not structKeyExists(sheetstruct[currentsheet].format[currentformat],'colvalue') and len(sheetstruct[currentsheet].format[currentformat].rowvalue)) {
						SpreadSheetFormatRows(theSheet,sheetstruct[currentsheet].format[currentformat],sheetstruct[currentsheet].format[currentformat].rowvalue);
					}
					if(structKeyExists(sheetstruct[currentsheet].format[currentformat],'rowvalue') and structKeyExists(sheetstruct[currentsheet].format[currentformat],'colvalue') and len(sheetstruct[currentsheet].format[currentformat].rowvalue)) {
						for(col_num = 1; col_num < ListLen(arrayToList(tempquery.getColumnList())); col_num = col_num + 1) {
							if(ListFindNoCase(sheetstruct[currentsheet].format[currentformat].colvalue,ListGetAt(arrayToList(tempquery.getColumnList()),col_num))) {
								for(row_num in sheetstruct[currentsheet].format[currentformat].rowvalue) {
									SpreadSheetFormatCell(theSheet,sheetstruct[currentsheet].format[currentformat],row_num,col_num);
								}
							}
						}
					}
				</cfscript>
            </cfloop>
            
            <!--- merge edeceÄŸim hÃ¼creler var ise, SpreadSheetMergeCells uyguluyorum. --->
            <cfif structKeyExists(sheetstruct[currentsheet],'merge')>
                <cfloop collection="#sheetstruct[currentsheet].merge#" item="mergeitem">
                    <cfloop list="#sheetstruct[currentsheet].merge[mergeitem].rowvalue#" index="mergerow">
                        <cfloop list="#sheetstruct[currentsheet].merge[mergeitem].colvalue#" index="mergecol">
                            <cfset colspan_value = sheetstruct[currentsheet].merge[mergeitem].col2merge>
                            <cfset rowspan_value = sheetstruct[currentsheet].merge[mergeitem].row2merge>
                            <cfif colspan_value eq 0 or colspan_value gt ListLen(arrayToList(tempquery.getColumnList())) - ListLen(sheetstruct[currentsheet].colremove) - ListFindNoCase(arrayToList(tempquery.getColumnList()),mergecol) + 1>
                                <cfset colspan_value = ListLen(arrayToList(tempquery.getColumnList())) - ListLen(sheetstruct[currentsheet].colremove) - ListFindNoCase(arrayToList(tempquery.getColumnList()),mergecol) + 1>
                            </cfif>
                            <cfscript>
                                SpreadSheetMergeCells(theSheet,mergerow,mergerow+rowspan_value-1,ListFindNoCase(arrayToList(tempquery.getColumnList()),mergecol),ListFindNoCase(arrayToList(tempquery.getColumnList()),mergecol)+colspan_value-1);
                            </cfscript>
                        </cfloop>
                    </cfloop>
                </cfloop>
            </cfif>
            
            <!--- pageBreak deÄŸeri gelmiÅŸ ise, sadece cf11 iÃ§in pagebreakler atacaÄŸÄ±m. Print ederken oralardan yeni sayfaya geÃ§ecek. cf10 ve Ã¶ncesi iÃ§in maalesef bÃ¶yle bir ÅŸansÄ±m yok. --->
            <cfif listFirst(server.ColdFusion.ProductVersion) gte 11 and structKeyExists(sheetstruct[currentsheet],'pageBreak')>
                <cfset SpreadSheetAddPagebreaks(theSheet,sheetstruct[currentsheet].pageBreak,"")>
            </cfif>
            <cfset log = addLog('Formatlama islemi tamamlandi.')>
            
            <!--- queryden dÃ¶nmesi ancak ekrana basÄ±lmamasÄ± gereken kolonlar oluyor. colremove iÃ§inde tanÄ±mlanmÄ±ÅŸsa, o kolonlarÄ± yok ediyorum. --->
            <cfscript>
				if(len(sheetstruct[currentsheet].colremove)) {
					for(col_num = 1; col_num lte ListLen(arrayToList(tempquery.getColumnList())); col_num = col_num + 1) {
						if(ListFindNoCase(sheetstruct[currentsheet].colremove,ListGetAt(arrayToList(tempquery.getColumnList()),col_num)))
							SpreadSheetDeleteColumn(theSheet,col_num);
					}
				}
            </cfscript>
            
            <!--- rapor sonucu tek dosyada toplanacak ise, sheetler halinde tutulur. Aksi halde ayrÄ± dosyalar olarak bÄ±rakÄ±lÄ±r. --->
            <cfif arguments.singleSheet eq 1>
				<cfif FileExists("#upload_folder#reserve_files/#session.ep.userid#/#report_filename#.#arguments.type#")>
                    <cfspreadsheet action="update" filename="#upload_folder#reserve_files/#session.ep.userid#/#report_filename#.#arguments.type#" name="theSheet" sheetname="#sheetstruct[currentsheet].sheetname#">
                <cfelse>
                    <cfspreadsheet action="write" filename="#upload_folder#reserve_files/#session.ep.userid#/#report_filename#.#arguments.type#" name="theSheet" sheetname="#sheetstruct[currentsheet].sheetname#" overwrite=true>
                </cfif>
            <cfelse>
            	<cfspreadsheet action="write" filename="#upload_folder#reserve_files/#session.ep.userid#/#report_filename#_#currentSheet#.#arguments.type#" name="theSheet" sheetname="#sheetstruct[currentsheet].sheetname#" overwrite=true>
            </cfif>
            
            <!--- sayfayÄ± oluÅŸturduk, gc yapÄ±p loopta kaldÄ±ÄŸÄ±mÄ±z yerden devam edeceÄŸiz. --->
        <cfset log = addLog('#sheetstruct[currentsheet].sheetname# sayfasi olusturuldu. Sayfa : #ListFind(structList,currentsheet)#/#ListLen(structList)#')>
            <cfset objSys.gc() />
            <cfset log = addLog('Garbage Collect yapildi, tahmini kalan sure : #wrk_round(((ListLen(structList)-ListFind(structList,currentsheet))*(GetTickCount()-old_tick_count))/60000,1)# dakika.')>
            <cfset old_tick_count = GetTickCount()>
        </cfloop>
        <cfset objSys.runFinalization()/>
		<cfset end_time = GetTickCount()>
        <cfset log = addLog('#row_count# satir #wrk_round((end_time-start_time)/60000,1)# dakikada islendi. Islem tamamlandi.')>
    <cfelseif arguments.type eq 'display'>
        
        <!--- display modu ÅŸimdilik sadece 1 sayfayÄ± destekliyor, bu yÃ¼zden ne yollanÄ±rsa yollansÄ±n sadece ilk sayfayÄ± display edecektir. --->
    	<cfset structList = ListGetAt(ListSort(StructKeyList(arguments.sheetStruct),'numeric'),1)>
    	<cfloop list="#structList#" index="currentSheet">
        
        	<!--- isimlendirmeler formatlarla aynÄ± olacak ÅŸekilde css style'lar oluÅŸturuluyor. --->
			<style type="text/css">
				<cfoutput>
					<cfloop list="#sheetstruct[currentsheet].formatOrder#" index="currentformat">
						<cfset cf_str = sheetstruct[currentsheet].format[currentformat]>
						<cfset cf_alignment = ''>
						<cfset cf_bold = ''>
						<cfset cf_font = ''>
						<cfset cf_fontsize = ''>
						<cfset cf_bottomborder = ''>
						<cfset cf_bottombordercolor = ''>
						<cfset cf_color = ''>
						<cfset cf_indent = ''>
						<cfset cf_italic = ''>
						<cfset cf_leftborder = ''>
						<cfset cf_leftbordercolor = ''>
						<cfset cf_rightborder = ''>
						<cfset cf_rightbordercolor = ''>
						<cfset cf_topborder = ''>
						<cfset cf_topbordercolor = ''>
						<cfset cf_verticalalignment = ''>
						<cfif isDefined("cf_str.bold") and cf_str.bold eq 'true'>
							<cfset cf_bold = 'bold'>
						</cfif>
						<cfif isDefined("cf_str.alignment")>
							<cfset cf_alignment = cf_str.alignment>
						</cfif>
						<cfif isDefined("cf_str.font")>
							<cfset cf_font = cf_str.font>
						</cfif>
						<cfif isDefined("cf_str.fontsize")>
							<cfset cf_fontsize = cf_str.fontsize>
						</cfif>
						<cfif isDefined("cf_str.bottomborder")>
							<cfset cf_bottomborder = cf_str.bottomborder>
						</cfif>
						<cfif isDefined("cf_str.bottombordercolor")>
							<cfset cf_bottombordercolor = cf_str.bottombordercolor>
						</cfif>
						<cfif isDefined("cf_str.color")>
							<cfset cf_color = cf_str.color>
						</cfif>
						<cfif isDefined("cf_str.indent")>
							<cfset cf_indent = cf_str.indent>
						</cfif>
						<cfif isDefined("cf_str.italic")>
							<cfset cf_italic = 'italic'>
						</cfif>
						<cfif isDefined("cf_str.leftborder")>
							<cfset cf_leftborder = cf_str.leftborder>
						</cfif>
						<cfif isDefined("cf_str.leftbordercolor")>
							<cfset cf_leftbordercolor = cf_str.leftbordercolor>
						</cfif>
						<cfif isDefined("cf_str.rightborder")>
							<cfset cf_rightborder = cf_str.rightborder>
						</cfif>
						<cfif isDefined("cf_str.rightbordercolor")>
							<cfset cf_rightbordercolor = cf_str.rightbordercolor>
						</cfif>
						<cfif isDefined("cf_str.topborder")>
							<cfset cf_topborder = cf_str.topborder>
						</cfif>
						<cfif isDefined("cf_str.topbordercolor")>
							<cfset cf_topbordercolor = cf_str.topbordercolor>
						</cfif>
						<cfif isDefined("cf_str.verticalalignment")>
							<cfset cf_verticalalignment = cf_str.verticalalignment>
						</cfif>
						.#currentformat#{
								font-weight:#cf_bold# !important;
								text-align:#cf_alignment# !important;
								font-family:#cf_font# !important;
								font-size:#cf_fontsize#px !important;
								border-bottom:#cf_bottomborder# !important;
								border-bottom-color:###cf_bottombordercolor# !important;
								color:###cf_color# !important;
								text-indent:#cf_indent# !important;
								font-style:#cf_italic# !important;
								border-left:#cf_leftborder# !important;
								border-left-color:###cf_leftbordercolor# !important;
								border-right:#cf_rightborder# !important;
								border-right-color:#cf_rightbordercolor# !important;
								border-top:#cf_topborder# !important;
								border-top-color:###cf_topbordercolor# !important;
								vertical-align:#cf_verticalalignment# !important;
							}
					</cfloop>
				</cfoutput>
			</style>
            
        	<cfset tempquery = sheetstruct[currentsheet].sourcesql>
            <cfset row_count = row_count + tempquery.recordcount>
			
            <!--- datayÄ±, format-link-merge objelerini komple jsona atÄ±yorum. --->
			<cfset jsonData = SerializeJSON(tempquery)>
            <cfset jsonFormat = SerializeJSON(sheetstruct[currentsheet].format)>
            <cfset jsonLink = SerializeJSON(sheetstruct[currentsheet].link)>
            <cfset jsonMerge = SerializeJSON(sheetstruct[currentsheet].merge)>
            <cfif left(jsonData, 2) is "//"><cfset jsonData = mid(jsonData, 3, len(jsonData) - 2)></cfif>
            <cfif left(jsonFormat, 2) is "//"><cfset jsonFormat = mid(jsonFormat, 3, len(jsonFormat) - 2)></cfif>
            <cfif left(jsonLink, 2) is "//"><cfset jsonLink = mid(jsonLink, 3, len(jsonLink) - 2)></cfif>
            <cfif left(jsonMerge, 2) is "//"><cfset jsonMerge = mid(jsonMerge, 3, len(jsonMerge) - 2)></cfif>
			<cfset jsonData = URLEncodedFormat(jsonData, "utf-8")>
            <cfset jsonFormat = URLEncodedFormat(jsonFormat, "utf-8")>
            <cfset jsonMerge = URLEncodedFormat(jsonMerge, "utf-8")>
            <cfset jsonLink = URLEncodedFormat(jsonLink, "utf-8")>
			<script type="text/javascript">
				var jsonData = $.evalJSON(decodeURIComponent("<cfoutput>#jsonData#</cfoutput>"));
				var jsonFormat = $.evalJSON(decodeURIComponent("<cfoutput>#jsonFormat#</cfoutput>"));
				var jsonLink = $.evalJSON(decodeURIComponent("<cfoutput>#jsonLink#</cfoutput>"));
				var jsonMerge = $.evalJSON(decodeURIComponent("<cfoutput>#jsonMerge#</cfoutput>"));
				var jsonFormatOrder = '<cfoutput>#sheetstruct[currentsheet].formatorder#</cfoutput>'.split(',');
				
				var pageBreakList = "0,<cfoutput>#sheetstruct[currentsheet].pageBreak#</cfoutput>";
				var tempPageBreakArray = pageBreakList.split(',');
				
				if(tempPageBreakArray.indexOf(jsonData.DATA.length) == -1)
					tempPageBreakArray.push(jsonData.DATA.length);
				
				var pageBreakArray = [];
				
				for(pagenum = 0; pagenum < tempPageBreakArray.length; pagenum++) {
					if(tempPageBreakArray[pagenum] <= jsonData.DATA.length && pageBreakArray.indexOf(tempPageBreakArray[pagenum]) == -1 && tempPageBreakArray[pagenum] != "")
						pageBreakArray.push(tempPageBreakArray[pagenum]);
				}
				
				gotoPage(1);
				
				function gotoPage(pageNum)
				{
					if(isNaN(pageNum) || pageNum > parseInt(pageBreakArray.length - 1) || pageNum < 1) { <!--- saÃ§ma sapan deÄŸerler page no olarak gelirse, ona gÃ¶re uygun bir sayfaya yolluyorum. --->
						if(pageNum <1)
							gotoPage(1);
						if(pageNum > parseInt(pageBreakArray.length - 1))
							gotoPage(parseInt(pageBreakArray.length - 1));
					} else {
						$("#page").remove();
						
						var divNew = document.createElement('div');
						divNew.id = 'page';
						$(divNew).css({							
							'padding':'12px',							
							});
						var tableNew = document.createElement('table');
							$(tableNew).css({
							'margin':'auto',
							'width':'98%'							
							});
						
						$(tableNew).addClass("basket_list"); <!--- galiba koca fonksiyonda workcube'e Ã¶zel tek yapÄ± bu. --->
						
						var startRow = pageBreakArray[pageNum-1];
						var maxRows = pageBreakArray[pageNum];
						
						if(maxRows > jsonData.DATA.length)
							maxRows = jsonData.DATA.length;
						
						var divNav = document.createElement('div'); <!--- divNav, navigasyon butonlarÄ±mÄ± tutuyor. ileri-geri vs. --->
						divNav.id = 'navigation';
						$(divNav).css({
							'margin':'auto',
							'width':'130px'							
							});
						
						var buttonNew = document.createElement('div');
						buttonNew.className = "pages_button";
						buttonNew.innerHTML = '<a href="javascript://" onclick="gotoPage(1)">&laquo;</a>';
						$(divNav).append(buttonNew);					
						if(pageNum == 1)
							buttonNew.innerHTML = '&laquo;';
						
						var buttonNew = document.createElement('div');
						buttonNew.className = "pages_button";
						buttonNew.innerHTML = '<a href="javascript://" onclick="gotoPage('+parseInt(pageNum-1)+')">&lsaquo;</a>';
						$(divNav).append(buttonNew);
						if(pageNum == 1)
							buttonNew.innerHTML = '&lsaquo;';
						
						var buttonNew = document.createElement('div');
						buttonNew.className = "pages_button";
						$(buttonNew).css({
							'margin' : '5px'
														
						});				
						buttonNew.innerHTML = '<input type="text" style="width:50px; text-align:center;" min="1" max="'+parseInt(pageBreakArray.length - 1) +'" name="pagesearch" id = "pagesearch" value="'+parseInt(pageNum)+'" onkeyup="isNumber(this);" onkeydown="javascript: if (event.keyCode == 13) gotoPage( $(this).val())" onblur="gotoPage( $(this).val())">';
						$(divNav).append(buttonNew);
						
						var buttonNew = document.createElement('div');
						buttonNew.className = "pages_button";
						buttonNew.innerHTML = '<a href="javascript://" onclick="gotoPage('+parseInt(pageNum+1)+')">&rsaquo;</a>';
						$(divNav).append(buttonNew);
						if(pageNum == pageBreakArray.length - 1)
							buttonNew.innerHTML = '&rsaquo;';
	
						var buttonNew = document.createElement('div');
						buttonNew.className = "pages_button";
						buttonNew.innerHTML = '<a href="javascript://" onclick="gotoPage('+parseInt(pageBreakArray.length - 1) +')">&raquo;</a>';
						$(divNav).append(buttonNew);
						if(pageNum == pageBreakArray.length - 1)
							buttonNew.innerHTML = '&raquo;';
						
						$(divNav).clone().appendTo(divNew); <!--- divNav'Ä±n aynÄ±sÄ±ndan en alta da atÄ±yorum, lazÄ±m olur. --->
						
						$("#report").append(divNew);
						
						<!--- blacklist yapÄ±sÄ±, merge objesine gÃ¶re hangi hÃ¼creleri ekrana BASMAYACAÄIMI tespit etmeme yarÄ±yor. BÃ¶ylece istediÄŸim gibi merge deÄŸeri yollarÄ±m, kayma olmaz.
							  Ã¶rneÄŸin bir hÃ¼crede 2 kolon, 3 satÄ±r merge efekti var ise, bunun altÄ±ndan 4, saÄŸÄ±ndan 1 hÃ¼cre ekrana basÄ±lmaz. Yani ezilir. --->
						var blacklist = [];
						blacklist.push([-1,-1,-1,-1]); <!--- boÅŸ durmasÄ±n, dummy bir kayÄ±t atmÄ±ÅŸ olalÄ±m. --->
						
						for(i=parseInt(startRow);i<parseInt(maxRows);i++) <!--- SATIRLARI DÃ–NDÃœRÃœYORUM --->
						{
							var trNew = document.createElement('tr');
							trNew.id = 'rowNum'+parseInt(parseInt(i)+1);
							
							for(j=0;j<jsonData.COLUMNS.length;j++) <!--- KOLONLARI DÃ–NDÃœRÃœYORUM --->
							{
								<!--- her bir td iÃ§in aÅŸaÄŸÄ±daki if kadar iÅŸlem yapÄ±lÄ±yor. colremove ise hiÃ§ basÄ±lmÄ±yor. --->
								if("<cfoutput>#sheetstruct[currentsheet].colremove#</cfoutput>".split(',').indexOf(jsonData.COLUMNS[j]) == -1) {
									var tdNew = document.createElement('td');
									for(cformat in jsonFormatOrder) {
										<!--- bir td, birden fazla formattan etkilenebilir. addClass ile hepsi uygulanÄ±r. --->
										if( ( (!('COLVALUE' in jsonFormat[jsonFormatOrder[cformat].toUpperCase()])) && ('ROWVALUE' in jsonFormat[jsonFormatOrder[cformat].toUpperCase()]) && (jsonFormat[jsonFormatOrder[cformat].toUpperCase()].ROWVALUE.split(',').indexOf((i+1).toString()) != -1) ) || (('COLVALUE' in jsonFormat[jsonFormatOrder[cformat].toUpperCase()]) && !('ROWVALUE' in jsonFormat[jsonFormatOrder[cformat].toUpperCase()]) && jsonFormat[jsonFormatOrder[cformat].toUpperCase()].COLVALUE.split(',').indexOf(jsonData.COLUMNS[j]) != -1) || (('ROWVALUE' in jsonFormat[jsonFormatOrder[cformat].toUpperCase()]) && ('COLVALUE' in jsonFormat[jsonFormatOrder[cformat].toUpperCase()]) && (jsonFormat[jsonFormatOrder[cformat].toUpperCase()].ROWVALUE.split(',').indexOf((i+1).toString()) != -1) && (jsonFormat[jsonFormatOrder[cformat].toUpperCase()].COLVALUE.split(',').indexOf(jsonData.COLUMNS[j]) != -1) ) )
											$(tdNew).addClass(jsonFormatOrder[cformat]);
									}
									
									<!--- td'nin iÃ§eriÄŸini yazÄ±yorum. eÄŸer linklendirilecek ise, if'in iÃ§inde en sonda innerHTML deÄŸerini linkli yapÄ±yorum. --->
									tdNew.innerHTML = jsonData.DATA[i][j];
									for(clink in jsonLink) {
										if( (jsonLink[clink].ROWVALUE.split(',').indexOf((i+1).toString()) != -1) && (jsonLink[clink].COLVALUE.split(',').indexOf(jsonData.COLUMNS[j]) != -1) ) {
											parameterstring = jsonLink[clink].LINKSTRING;
											for(param = 0; param < jsonLink[clink].PARAMETERS.split(',').length; param = param + 1)
												parameterstring = parameterstring + '&' + jsonLink[clink].PARAMETERS.split(',')[param] + '=' + jsonData.DATA[i][jsonData.COLUMNS.indexOf(jsonLink[clink].VALUES.split(',')[param])];
											tdNew.innerHTML = '<a href = \'javascript://\' onClick=\'MyWindow=window.open(\"' + parameterstring + '\",\"MyWindow\",width=600,height=300); return false;\'> ' + jsonData.DATA[i][j] + '</a>';
										}
									}
									
									<!--- default olarak her tdnin colspan=1 ve rowspan=1 'dir. cmerge'den birÅŸey dÃ¶nerse, bu deÄŸerler tekrar atanÄ±r. --->
									var colspan_value = 1;
									var rowspan_value = 1;
									for(cmerge in jsonMerge) {
										if( (jsonMerge[cmerge].ROWVALUE.split(',').indexOf((i+1).toString()) != -1) && (jsonMerge[cmerge].COLVALUE.split(',').indexOf(jsonData.COLUMNS[j]) != -1) ) {
											colspan_value = jsonMerge[cmerge].COL2MERGE;
											rowspan_value = jsonMerge[cmerge].ROW2MERGE;
											
											<!--- colspan ve rowspan value'lar, eÄŸer tabloyu kaydÄ±racaksa azaltÄ±lÄ±yor. SÄ±fÄ±r gÃ¶nderilmiÅŸ ise sÄ±nÄ±rsÄ±z demek oluyor. --->
											if(colspan_value == 0 || colspan_value > jsonData.COLUMNS.length - "<cfoutput>#sheetstruct[currentsheet].colremove#</cfoutput>".split(',').length - j - 1)
												colspan_value = jsonData.COLUMNS.length - "<cfoutput>#sheetstruct[currentsheet].colremove#</cfoutput>".split(',').length - j;
											if(rowspan_value == 0 || rowspan_value > (maxRows-startRow) - 1)
												rowspan_value = (maxRows-startRow) - 1;
											
											<!--- merge uygulandÄ± ise, ilgili dÃ¶rtgen blackliste atÄ±lÄ±yor. merge efektinin ezdiÄŸi hÃ¼creler trye append yapÄ±lmÄ±yor. --->
											blacklist.push([i,i+rowspan_value - 1,j,j+colspan_value - 1]);
										}
									}
									$(tdNew).attr('colspan',colspan_value);
									$(tdNew).attr('rowspan',rowspan_value);
									
									hide_value = 0;
									for(hideitem in blacklist) {
										if(i >= blacklist[hideitem][0] && i <= blacklist[hideitem][1] && j >= blacklist[hideitem][2] && j <= blacklist[hideitem][3] && !(i == blacklist[hideitem][0] && j == blacklist[hideitem][2]))
											hide_value = 1;
									}
									if(hide_value == 0)
										$(trNew).append(tdNew);
								}
							}
							$(tableNew).append(trNew);
						}

						$(divNew).append(tableNew);
						$(divNav).clone().appendTo(divNew);
					}
				}
			</script>
        </cfloop>
    <cfelseif arguments.type eq 'pdf'>
    	<cfset structList = ListSort(StructKeyList(arguments.sheetStruct),'numeric')>
        <cfset log = addLog('#arguments.type# secildi.')>
        <cfset log = addLog('Olusturulacak sayfa sayisi : #ListLen(structList)#')>
        <cfset old_tick_count = GetTickCount()>
        
    	<cfloop list="#structList#" index="currentSheet">
        	<cfset tempquery = sheetstruct[currentsheet].sourcesql>
            <cfset row_count = row_count + tempquery.recordcount>
            
            <!--- pagetype olaylarÄ±nÄ±, filename'i falan argÃ¼manlardan alÄ±yor. --->
            <cfdocument format="pdf" filename="#upload_folder#reserve_files/#session.ep.userid#/#report_filename#_#currentSheet#.#arguments.type#" orientation="portrait" backgroundvisible="false" pagetype="#ListFirst(arguments.pagetype,';')#" unit="cm" pageheight="#ListGetAt(arguments.pagetype,2,';')#" pagewidth="#ListGetAt(arguments.pagetype,3,';')#" marginleft="0" marginright="0" margintop="0" marginbottom="0">
				<style type="text/css">
						<cfoutput>
							<!--- displaydeki gibi css style deÄŸerleri oluÅŸturuluyor. Burada yaptÄ±ÄŸÄ±mÄ±z iÅŸin html sayfa oluÅŸturmaktan hiÃ§ farkÄ± yok. --->
							<cfloop list="#sheetstruct[currentsheet].formatOrder#" index="currentformat">
								<cfset cf_str = sheetstruct[currentsheet].format[currentformat]>
								<cfset cf_alignment = ''>
								<cfset cf_bold = ''>
								<cfset cf_font = ''>
								<cfset cf_fontsize = ''>
								<cfset cf_bottomborder = ''>
								<cfset cf_bottombordercolor = ''>
								<cfset cf_color = ''>
								<cfset cf_indent = ''>
								<cfset cf_italic = ''>
								<cfset cf_leftborder = ''>
								<cfset cf_leftbordercolor = ''>
								<cfset cf_rightborder = ''>
								<cfset cf_rightbordercolor = ''>
								<cfset cf_topborder = ''>
								<cfset cf_topbordercolor = ''>
								<cfset cf_verticalalignment = ''>
								<cfif isDefined("cf_str.bold") and cf_str.bold eq 'true'>
									<cfset cf_bold = 'bold'>
								</cfif>
								<cfif isDefined("cf_str.alignment")>
									<cfset cf_alignment = cf_str.alignment>
								</cfif>
								<cfif isDefined("cf_str.font")>
									<cfset cf_font = cf_str.font>
								</cfif>
								<cfif isDefined("cf_str.fontsize")>
									<cfset cf_fontsize = cf_str.fontsize>
								</cfif>
								<cfif isDefined("cf_str.bottomborder")>
									<cfset cf_bottomborder = cf_str.bottomborder>
								</cfif>
								<cfif isDefined("cf_str.bottombordercolor")>
									<cfset cf_bottombordercolor = cf_str.bottombordercolor>
								</cfif>
								<cfif isDefined("cf_str.color")>
									<cfset cf_color = cf_str.color>
								</cfif>
								<cfif isDefined("cf_str.indent")>
									<cfset cf_indent = cf_str.indent>
								</cfif>
								<cfif isDefined("cf_str.italic")>
									<cfset cf_italic = 'italic'>
								</cfif>
								<cfif isDefined("cf_str.leftborder")>
									<cfset cf_leftborder = cf_str.leftborder>
								</cfif>
								<cfif isDefined("cf_str.leftbordercolor")>
									<cfset cf_leftbordercolor = cf_str.leftbordercolor>
								</cfif>
								<cfif isDefined("cf_str.rightborder")>
									<cfset cf_rightborder = cf_str.rightborder>
								</cfif>
								<cfif isDefined("cf_str.rightbordercolor")>
									<cfset cf_rightbordercolor = cf_str.rightbordercolor>
								</cfif>
								<cfif isDefined("cf_str.topborder")>
									<cfset cf_topborder = cf_str.topborder>
								</cfif>
								<cfif isDefined("cf_str.topbordercolor")>
									<cfset cf_topbordercolor = cf_str.topbordercolor>
								</cfif>
								<cfif isDefined("cf_str.verticalalignment")>
									<cfset cf_verticalalignment = cf_str.verticalalignment>
								</cfif>
								.#currentformat#{
										font-weight:#cf_bold# !important;
										text-align:#cf_alignment# !important;
										font-family:#cf_font# !important;
										font-size:#cf_fontsize#px !important;
										border-bottom:#cf_bottomborder# !important;
										border-bottom-color:###cf_bottombordercolor# !important;
										color:###cf_color# !important;
										text-indent:#cf_indent# !important;
										font-style:#cf_italic# !important;
										border-left:#cf_leftborder# !important;
										border-left-color:###cf_leftbordercolor# !important;
										border-right:#cf_rightborder# !important;
										border-right-color:###cf_rightbordercolor# !important;
										border-top:#cf_topborder# !important;
										border-top-color:###cf_topbordercolor# !important;
										vertical-align:#cf_verticalalignment# !important;
									}
							</cfloop>
						</cfoutput>
					</style>
                <table cellpadding="2" cellspacing="1" border="0" style="width:210mm">
                	<!--- yine blacklist mantÄ±ÄŸÄ± ile ilerliyoruz. --->
                	<cfset blacklist = ArrayNew(2)>
                    <cfset append = ArrayAppend(blacklist,[-1,-1,-1,-1])>
                    <cfoutput query="tempquery">
                    
                    	<!--- alttaki loop mantÄ±ÄŸÄ± ile bir td birden fazla style alabiliyor. --->
                    	<cfset cf_tr_list = ''>
                        <cfloop list="#sheetstruct[currentsheet].formatOrder#" index="currentformat">
                        	<cfif structKeyExists(sheetstruct[currentsheet].format[currentformat],'rowvalue') and not structKeyExists(sheetstruct[currentsheet].format[currentformat],'colvalue') and len(sheetstruct[currentsheet].format[currentformat].rowvalue) and listFind(sheetstruct[currentsheet].format[currentformat].rowvalue,currentrow)>
                            	<cfset cf_tr_list = cf_tr_list & ' ' & currentformat>
                            </cfif>
                        </cfloop>
                        <tr class="#cf_tr_list#">
                            <cfloop list="#arrayToList(tempquery.getColumnList())#" index="columnname">
                            	<cfset colspan_value = 1>
                                <cfset rowspan_value = 1>
                            	<cfif not (structKeyExists(sheetstruct[currentsheet],'colremove') and ListFindNoCase(sheetstruct[currentsheet].colremove,columnname))>
                                	<cfset cf_td_list = ''>
                                    <cfloop list="#sheetstruct[currentsheet].formatOrder#" index="currentformat">
                                        <cfif (structKeyExists(sheetstruct[currentsheet].format[currentformat],'rowvalue') and structKeyExists(sheetstruct[currentsheet].format[currentformat],'colvalue') and listFind(sheetstruct[currentsheet].format[currentformat].rowvalue,currentrow) and listFind(sheetstruct[currentsheet].format[currentformat].colvalue,columnname)) or
										(not structKeyExists(sheetstruct[currentsheet].format[currentformat],'rowvalue') and structKeyExists(sheetstruct[currentsheet].format[currentformat],'colvalue') and listFind(sheetstruct[currentsheet].format[currentformat].colvalue,columnname))>
                                            <cfset cf_td_list = cf_td_list & ' ' & currentformat>
                                        </cfif>
                                    </cfloop>
                                    <cfif structKeyExists(sheetstruct[currentsheet],'merge')>
                                        <cfloop collection="#sheetstruct[currentsheet].merge#" item="mergeitem">
                                            <cfif ListFindNoCase(sheetstruct[currentsheet].merge[mergeitem].ROWVALUE,currentrow) and ListFindNoCase(sheetstruct[currentsheet].merge[mergeitem].COLVALUE,columnname)>
                                                <cfset colspan_value = sheetstruct[currentsheet].merge[mergeitem].COL2MERGE>
                                                <cfset rowspan_value = sheetstruct[currentsheet].merge[mergeitem].ROW2MERGE>
                                                
                                                <cfif colspan_value eq 0 or colspan_value gt ListLen(arrayToList(tempquery.getColumnList())) - ListLen(sheetstruct[currentsheet].colremove) - ListFindNoCase(arrayToList(tempquery.getColumnList()),columnname) + 1>
                                                    <cfset colspan_value = ListLen(arrayToList(tempquery.getColumnList())) - ListLen(sheetstruct[currentsheet].colremove) - ListFindNoCase(arrayToList(tempquery.getColumnList()),columnname) + 1>
                                                </cfif>
                                                
                                                <cfset append = ArrayAppend(blacklist,[currentrow,currentrow+rowspan_value-1,ListFindNoCase(arrayToList(tempquery.getColumnList()),columnname),ListFindNoCase(arrayToList(tempquery.getColumnList()),columnname) + colspan_value - 1])>
                                            </cfif>
                                        </cfloop>
                                    </cfif>
                                    
                                    <!--- blackliste dÃ¼ÅŸen td iÃ§in hide_value = 1 atanÄ±yor ve gÃ¶sterilmiyor. --->
                                    <cfset hide_value = 0>
                                    <cfloop from="1" to="#arrayLen(blacklist)#" index="hideitem">
                                    	<cfif currentrow gte blacklist[hideitem][1] and currentrow lte blacklist[hideitem][2] and ListFindNoCase(arrayToList(tempquery.getColumnList()),columnname) gte blacklist[hideitem][3] and ListFindNoCase(arrayToList(tempquery.getColumnList()),columnname) lte blacklist[hideitem][4] and not (currentrow eq blacklist[hideitem][1] and ListFindNoCase(arrayToList(tempquery.getColumnList()),columnname) eq blacklist[hideitem][3])>
                                        	<cfset hide_value = 1>
                                        </cfif>
                                    </cfloop>
                                    <cfif hide_value eq 0>
	                                    <td class="#cf_td_list#" <cfif colspan_value neq 1>colspan = #colspan_value#</cfif> <cfif rowspan_value neq 1>rowspan = #rowspan_value#</cfif>>#evaluate("tempquery.#columnname#")#</td>
                                    </cfif>
                                </cfif>
                            </cfloop>
                        </tr>
                        
                        <!--- pagebreak'lere denk geldiysek, uyguluyoruz. --->
                        <cfif structKeyExists(sheetstruct[currentsheet],'pagebreak') and ListLen(sheetstruct[currentsheet].pageBreak) and ListFind(sheetstruct[currentsheet].pageBreak,currentrow)>
                        	</table>
                            <cfdocumentitem type="pagebreak" />
                            <table cellpadding="2" cellspacing="1" border="0" style="width:210mm">
                        </cfif>
                    </cfoutput>
                </table>
            </cfdocument>
            
            <!--- gc yapÄ±p yeni sheet'e geÃ§iyoruz. --->
            <cfset log = addLog('#sheetstruct[currentsheet].sheetname# sayfasi olusturuldu. Sayfa : #ListFind(structList,currentsheet)#/#ListLen(structList)#')>
            <cfset objSys.gc() />
            <cfset log = addLog('Garbage Collect yapildi, tahmini kalan sure : #wrk_round(((ListLen(structList)-ListFind(structList,currentsheet))*(GetTickCount()-old_tick_count))/60000,1)# dakika.')>
            <cfset old_tick_count = GetTickCount()>
        </cfloop>
        
        <!--- cfpdf action="merge" singlesheet istiyorsak uyguluyoruz. Ã§ok kÃ¼Ã§Ã¼k parÃ§alar halinde oluÅŸturmak dosya boyutunu gereksiz bÃ¼yÃ¼tÃ¼yor. Ã§ok bÃ¼yÃ¼k parÃ§alar ise ram'i aÄŸlatÄ±yor. 5-10 k idealdir. --->
        <cfif arguments.singleSheet eq 1>
        	<cfpdf action = "merge" directory = "#upload_folder#reserve_files/#session.ep.userid#" order = "time" ascending = "yes" destination = "#upload_folder#reserve_files/#session.ep.userid#/#report_filename#.#arguments.type#">
            <cfloop list="#structList#" index="currentSheet">
            	<cffile action = "delete" file = "#upload_folder#reserve_files/#session.ep.userid#/#report_filename#_#currentSheet#.#arguments.type#">
            </cfloop>
        </cfif>
        <cfset objSys.runFinalization()/>
		<cfset end_time = GetTickCount()>
        <cfset log = addLog('#row_count# satir #wrk_round((end_time-start_time)/60000,1)# dakikada islendi. Islem tamamlandi.')>
    </cfif>
    
    <!--- iÅŸimiz bittiÄŸinde logfile yeni sekmede aÃ§Ä±lÄ±yor. Ã§ok cool. --->
    <cfif arguments.logfile neq 0>
		<script type="text/javascript">
            var logpopup = window.open("http://wrk/documents/reserve_files/<cfoutput>#session.ep.userid#</cfoutput>/log.txt");
        </script>
    </cfif>
    
    <!--- logfile istemiyorsak siliyoruz. --->
    <cfif arguments.logfile eq 0>
    	<cffile action="delete" file="#upload_folder#reserve_files/#session.ep.userid#/log.txt">
    </cfif>
    
    <!--- display deÄŸil ise reserve_files/#userid#/ altÄ±nda ne varsa paketleyip veriyor. --->
    <cfif arguments.type neq 'display'>
    	<cfzip file="#upload_folder#/reserve_files/#report_filename#.zip" source="#upload_folder#/reserve_files/#session.ep.userid#">
		<script type="text/javascript">
            <cfoutput>
                get_wrk_message_div("Zip","Zip","/documents/reserve_files/#report_filename#.zip") ;
            </cfoutput>
        </script>
    </cfif>
</cffunction>

<cffunction name="getValueList" access="public" returntype="string">
    <cfargument name="source" type="query" required="yes">
    <cfargument name="case" type="string" required="yes">
    <cfargument name="column" type="string" required="yes">
    <cfquery name="get" dbtype="query">
        SELECT #column# AS RESULT FROM source WHERE #case#
    </cfquery>
    <cfif get.recordcount>
        <cfreturn ValueList(get.result)>
    <cfelse>
        <cfreturn ''>
    </cfif>
</cffunction>

<cffunction name="listGrid" access="private">
    <cfargument name="struct" type="struct" required="yes">
    <cfinclude template="/JS/jqwidgets/specialLocalization.cfm">
    <cfif WOStruct[attributes.fuseaction].systemObject.extendedForm is true>
    	<cfquery name="getExtendedFields" datasource="#dsn#">
            SELECT
                UPPER(FIELD_ID) FIELD_ID,
                FIELD_TYPE,
                LABEL
            FROM
                catalyst_cf.EXTENDED_FIELDS
            WHERE
                TABLE_NAME = '#WOStruct[attributes.fuseaction].systemObject.pageTableName#'
                AND DATASOURCE_NAME = '#WOStruct[attributes.fuseaction].systemObject.dataSourceName#'
        </cfquery>
        
        <cfscript>
			for(i=1;i<=getExtendedFields.recordcount;i++) {
				struct.columns[getExtendedFields['FIELD_ID'][i]] = structNew();
				
				text = getExtendedFields['LABEL'][i];
				switch (getExtendedFields['FIELD_TYPE'][i]) {
					case 'text':
					case 'paragraph':
					fieldtype = 'string';
					break;
					
					case 'date':
					fieldtype = 'date';
					break;
					
					case 'dropdown':
					fieldtype = 'dropdown';
					break;
					
					case 'checkboxes':
					fieldtype = 'checkboxes';
					break;
				}
				
				struct.columns[getExtendedFields['FIELD_ID'][i]].text = text;
				struct.columns[getExtendedFields['FIELD_ID'][i]].hidden = false;
				struct.columns[getExtendedFields['FIELD_ID'][i]].width = 100;
				struct.columns[getExtendedFields['FIELD_ID'][i]].fieldtype = fieldtype;
			}
		</cfscript>
    </cfif>
    <cfloop list = "#StructKeyList(struct.columns)#" index = "col">
        <cfif not StructKeyExists(struct.columns[col],'fieldtype')>
            <cfset struct.columns[col].fieldtype = 'string'>
        </cfif>
        <cfif not StructKeyExists(struct.columns[col],'hidden')>
            <cfset struct.columns[col].hidden = false>
        </cfif>
        <cfif struct.columns[col].text eq 'No'>
            <cfset struct.columns[col].text = 'No '>
        </cfif>
        <cfif struct.columns[col].fieldtype eq 'date'>
            <cfset struct.columns[col].cellsformat = 'dd.MM.yyyy'>
        <cfelseif struct.columns[col].fieldtype eq 'money'>
            <cfset struct.columns[col].cellsformat = 'c2'>
            <cfset struct.columns[col].align = 'right'>
            <cfset struct.columns[col].cellsalign = 'right'>
        </cfif>
    </cfloop>
    <cfif not structKeyExists(struct,'columnresize')>
    	<cfset struct.columnresize = false>
    </cfif>
    <cfif not structKeyExists(struct,'enabletooltips')>
    	<cfset struct.enabletooltips = false>
    </cfif>
    <cfif not structKeyExists(struct,'pagermode')>
    	<cfset struct.pagermode = 'simple'>
    </cfif>
    <cfif not structKeyExists(struct,'columnresize')>
    	<cfset struct.columnresize = false>
    </cfif>
    <cfif not structKeyExists(struct,'filterable')>
    	<cfset struct.filterable = false>
    </cfif>
    <cfif not structKeyExists(struct,'pageable')>
    	<cfset struct.pageable = true>
    </cfif>
    <cfif not structKeyExists(struct,'sortable')>
    	<cfset struct.sortable = false>
    </cfif>
    <cfif not structKeyExists(struct,'addLink')>
    	<cfset struct.addLink = false>
    </cfif>
    <cfif not structKeyExists(struct,'updLink')>
    	<cfset struct.updLink = false>
    </cfif>
    <cfif not structKeyExists(struct,'delLink')>
    	<cfset struct.delLink = false>
    </cfif>
    
    <script type="text/javascript">
		var filtered = 0;
        $(document).ready(function () {
			//initGrid();
		});
        
		function initGrid(args) {
			if(args != undefined) {
				var formValues = args;
			} else {
				var formValues = {};
			}
			$('#filterForm :input').each(function() {
				if(($(this)[0].type != 'checkbox' && $(this).val() != undefined && $(this).val().length) || $(this)[0].checked == 1)
				{
					formValues[this.name] = $(this).val();
				}
			});
			
			var gridData = jQuery.parseJSON(JSON.stringify(<cfoutput>#replace(SerializeJSON(struct),"//","")#</cfoutput>));
			var dataFields = [];
			$.each(gridData.COLUMNS,function( index, value ) {
				dataFields.push({ name : index, type : value.FIELDTYPE });
			});
			
			$.ajax({ url : gridData.URL, data : formValues, async:false,success : function(res){ if ( res ) { result = res; } } });
			
			
			if(jQuery.parseJSON(result)[0] != undefined) {
				$.each(jQuery.parseJSON(result)[0],function( index, value ) {
					if(gridData.COLUMNS[index] != undefined)
						dataFields.push({ name : index, type : gridData.COLUMNS[index].FIELDTYPE });
					else
						dataFields.push({ name : index, type : '' });
				});
				var source =
				{
					datatype: "json",
					localdata: result,
					datafields: dataFields,
					root: 'Rows',
					beforeprocessing: function (data) {
						if(jQuery.parseJSON(data)[0] == undefined)
							source.totalrecords = 0;
						else
							source.totalrecords = jQuery.parseJSON(data)[0].TOTALROWS;
					}
				};
				var dataAdapter = new $.jqx.dataAdapter(source,
					{
						formatData: function (data) {
							$.extend(data, {
								featureClass: "P",
								style: "full",
								maxRows: 50
							});
							return data;
						}
					}
				);
				// load virtual data.
				var rendergridrows = function (params) {
					params.startindex = 0;
					params.endindex = parseFloat($("#filterForm #maxrows").val());
					return params.data;
				}
				
				var columns = [
					  {
						  text: '#', sortable: false, filterable: false, editable: false,
						  groupable: false, draggable: false, resizable: false,
						  datafield: '', columntype: 'number', width : 25,
						  cellsrenderer: function (row, column, value) {
							  return "<div style='margin:4px;'>" + (value + 1) + "</div>";
						  }
					  }
				  ];
				$.each(gridData.COLUMNS,function( index, value ) {
					var newColumn = {};
					
					newColumn['datafield'] = index;
					$.each(gridData.COLUMNS[index],function( index2, value2 ) {
						newColumn[index2.toLowerCase()] = value2;
					});
					columns.push(newColumn);
				});
				if(gridData.UPDLINK == true) {
					var newColumn = {};
					newColumn['datafield'] = '+';
					newColumn['width'] = 25;
					
					columns.push(newColumn);
				}
				if(gridData.DELLINK == true) {
					var newColumn = {};
					newColumn['datafield'] = '-';
					newColumn['width'] = 25;
					
					columns.push(newColumn);
				}
				$("#jqxgrid").jqxGrid(
				{
					theme: 'office',
					width: '100%',
					height: '99%',
					source: dataAdapter,
					columnsresize: gridData.COLUMNRESIZE,
					enabletooltips: gridData.ENABLETOOLTIPS,
					pagermode: gridData.PAGERMODE,
					filterable: gridData.FILTERABLE,
					virtualmode: true,
					columns: columns,
					pageable : gridData.PAGEABLE,
					pagesize : parseFloat($("#filterForm #maxrows").val()),
					sortable : gridData.SORTABLE,
					rendergridrows: rendergridrows
				});
				var listSource = [];
				$.each(gridData.COLUMNS,function( index, value ) {
					if(value.TEXT != '')
						listSource.push({ label: value.TEXT, value: index, checked: !(value.HIDDEN)});
				});
				$("#jqxlistbox").jqxListBox({ source: listSource, width: 120, height: 400,  checkboxes: true });
				$("#jqxlistbox").on('checkChange', function (event) {
					$("#jqxgrid").jqxGrid('beginupdate');
					if (event.args.checked) {
						$("#jqxgrid").jqxGrid('showcolumn', event.args.value);
					}
					else {
						$("#jqxgrid").jqxGrid('hidecolumn', event.args.value);
					}
					$("#jqxgrid").jqxGrid('endupdate');
				});
			} else {
				$("#after_filter").empty();
				var divNew = document.createElement('div');
				divNew.className = "col col-12";
				divNew.id = "jqxgrid";
				divNew.innerHTML = '<div class="after_filter_text">Kayıt Yok !</div>';
				$(after_filter).append(divNew);	
			}
			
			if(filtered == 0) {
				$('#jqxlistbox').hide();
				$("#jqxgrid").bind('cellclick', function (event) {
					rowData = $("#jqxgrid").jqxGrid('getrowdata', event.args.rowindex);
					rowData.COLUMN = event.args.datafield;
					<cfif struct.updLink eq true>
						if(gridData.UPDLINK == true) {
							if(event.args.datafield == '+') {
								window.open("<cfoutput>#request.self#?fuseaction=#WOStruct[attributes.fuseaction].add.nextEvent#</cfoutput>" + rowData['<cfoutput>#WOStruct[attributes.fuseaction].systemObject.pageIdentityColumn#</cfoutput>']);
							}
						}
					</cfif>
					<cfif structKeyExists(struct,'clickAction')>
						<cfoutput>#struct.clickAction#</cfoutput>
					</cfif>
				});
				
				$("#jqxgrid").on("pagechanged", function (event) 
				{
					var args = {};
					args.pagenum = parseInt(event.args.pagenum);
					args.pagesize = parseInt(event.args.pagesize);
					initGrid(args);
				}); 
				$("#jqxgrid").on("sort", function (event) 
				{
					var args = {};
					args.sortField = event.args.sortinformation.sortcolumn;
					if(event.args.sortinformation.sortdirection.ascending == true)
						args.sortType = 'ASC';
					if(event.args.sortinformation.sortdirection.descending == true)
						args.sortType = 'DESC';
					initGrid(args);
				}); 
				$("#jqxgrid").jqxGrid('localizestrings', localizationobj);
				filtered = 1;
			}
		}
		$(document).keypress(function(e) {
			if(e.which == 13) {
				$("#filterGrid").click();
			}
		});
		
		$("#filterForm").submit(function(e){
			return false;
		});
    </script>
    <script type="text/javascript">
    $(function() {	
		var h =$( window ).height()-200+"px"
		$(".gridContent").css("height",h)
	});
	
	$( window ).resize(function() {
		var h =$( window ).height()-200+"px"
		$(".gridContent").css("height",h)
	});
    </script>
    <div id="after_filter" class="row gridContent">
    	<cfif struct.addLink is true>
	    	<a target="_new" href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&event=add</cfoutput>">[ ekle ]</a>
        </cfif>
        <div class="col col-12" id="jqxgrid">
        	<div class="after_filter">
                <div class="after_filter_text">Filtre Ediniz !</div>
            </div>
        </div>
    </div>
	<div class="list_settings" align="right">
        <a href="javascript://" onclick="$('#jqxlistbox').slideToggle();" id="opener">&nbsp;</a>
        <div id="jqxlistbox"></div>
    </div>
</cffunction>

<cffunction name="isClosed" returntype="any">
	<cfargument name="action_table" default="" type="string" required="yes">
    <cfargument name="action_id" default="" type="numeric" required="yes">
	<cfquery name="closedControl" datasource="#DSN2#">
		SELECT 
			CCR.ACTION_ID
		FROM 
			CARI_ROWS CR 
				LEFT JOIN CARI_CLOSED_ROW CCR ON CR.CARI_ACTION_ID = CCR.CARI_ACTION_ID
		WHERE 
			CR.ACTION_TABLE = '#action_table#'
			AND CR.ACTION_ID = #action_id#
	</cfquery>
	<cfreturn closedControl.ACTION_ID/>
</cffunction>
<!--- Sayfadaki variables, query, function atamaları takip etmeye yarar created by MEY  --->
<cffunction name="showAllVariables" output="yes" returntype="string">
	<cfset ignoreList = 'UPD_NEWER_COST,WRK_CONTENT_CLEAR,WRK_CONTENT_SUB_CLEAR,WRK_FORM_SMS_TEMPLATE,WRK_SMS_BODY_REPLACE,PHYSICAL_ACTION,DUEDATE_ACTION,FIND_GT_ELEMENT,F_KUR_EKLE,F_KUR_EKLE_ACTION,GET_ALL_IMS_IDS,GET_ALL_RELATED_COMPANIES,GET_ALL_SZ_IDS,GET_CHEQUE_NO,GET_PRODUCT_STOCK_COST,GET_COST_RATE,GET_PERMITED_IMS,GET_MODULE_ID,WORKNET_URL,DATABASE_LOG_FOLDER,K,GET_WRK_SECURE_BANNED_IP,ISCLOSED,WORKNET_DOMAIN,OKU,LCASETR,THIS,PDA_DOMAIN,STANDART_PROCESS_MONEY,GET_POSITION_ID,CLOSE_TD,AMOUNTFORMAT,DATABASE_TYPE,SAFEIP,USE_PASSWORD_REMINDER,ACTIVE_DIRECTORY_SERVER,INCLUDE,LANGUAGE,UCASETR,TLFORMAT,INTERNETTV_FOLDER_PATH,EMPLOYEE_DOMAIN,FILE_WEB_PATH,IS_AJAX_REQUEST,GET_PRODUCT_NAME,USE_HTTPS,APATH,ONAPPLICATIONSTART,ADD_COMPANY_RELATED_ACTION,PDA_COMPANIES,WRK_GET_TODAY,WRK_ROUND,MOBILE_DOMAIN,GET_MODULE_POWER_USER,FREE_ACTIONS,DATABASE_USERNAME,SES_VALUE,FUSEACTION_LIST,GET_MONEY_TYPE,FILTERSPECIALCHARS,GET_EMP_INFO_2,SESSION_TREE_CONT,ONREQUEST,PAGE_LIST,EMP_MAIL_PATH,GET_EMP_INFO,FUSEBOX,DSN_ALIAS,TR2ASC,INTERNETTV_PATH,FMS_SERVER_ADDRESS,SESSION_BASE,EMPLOYEE_URL,SPECER,FLASHCOMSERVERAPPLICATIONSPATH,PARTNER_COMPANIES,STANDART_PROCESS_OTHER_MONEY,UPLOAD_FOLDER,DATE_ADD,GETRANDSTRING,MOBILE_URL,RESERVED_WORDS,GET_PROCESS_NAME,ISVALIDREQUEST,LANG_LIST,SETWORK,MUHASEBE_SIL,SQL_UNICODE,CON_MAIL_PATH,CAMPAIGN_MAIL_ADDRESS_LIST,CAREER_URL,CFSTOREDPROC,IS_WRK_VISIT_REPORT,GET_CONSUMER_PERIOD,SESSION_BASKET_KUR_EKLE,OPEN_TD,AJAX_REDIRECT,TR2ENG,GET_WORKCUBE_APP_USER,SHOWALLVARIABLES,ONAPPLICATIONEND,FUSEBOXVERSION,GET_COMPANY_PERIOD,MODULE_KONTROL,SATURDAY_ON,DATABASE_FOLDER,GET_DATE_PART,YERLES_SAGA,IS_PERFORMANCE_COUNTER,ATTACK_RETURN,APP_USER_ID_,NBSP,VALUE,USE_ACTIVE_DIRECTORY,GET_PAR_INFO_2,COLORLIST,VISIT_OFF_LIST,FB_,ARRAYTOQUERY,SERVER_URL,ACTIVE_DIRECTORY_START,DSN2_ALIAS,INDEX_FOLDER,VISIT_PARAMETERS_,BASKET_KUR_EKLE,GET_PAR_INFO,GET_BASKET_NAME,GET_COST_INFO,ONSESSIONEND,NETBOOK_FOLDER,DSN3,ABORT,DSN_REPORT,USER_DOMAIN,SERVER_DETAIL,SES_LASTKEY,PARTNER_DOMAIN,CLOSE_TR,FUSEBOXOSNAME,WORKCUBE_VERSION,SES_PATHINFO,GET_PRODUCT_ACCOUNT,STRUCTTOLIST,COLORBORDER,DSN2,FUSEACT_CONTROL,HTTPS_DOMAIN,TVCHANNELNAME,CARICI,DATABASE_PASSWORD,GET_CONTRACT_ACTION_DETAIL,SERVER_COMPANIES,DIRECT_LIST_ACTION,LISTDELETEDUPLICATES,IS_PDF_HEADER,GET_WORK_NAME,WORKNET_COMPANIES,MODULE_NAME,GETUSERPERIODDATE,DIRECTACCESSFILES,UPD_WORKCUBE_APP_ACTION,GET_LANG_MAIN_CACHED_TIME,USE_SCRIPT_ON_PROCESS,xml_unload_body_big_list_search_invoice_list_bill,COLORROW,GET_PROJECT_NAME,IS_ONLY_SHOW_PAGE,PAR_MAIL_PATH,YERLES,COST_ACTION,VISIT_PAGE_,STANDALONE_TYPE,IZINLI_PAGES,ONREQUESTEND,PDA_URL,ACIRCUITNAME,IS_FULLTEXT_SEARCH,ATTACK,ACTIVE_DIRECTORY_ATRR,URL_FRIENDLY_REQUEST,BUTCECI,GET_LOCATION_INFO,MUHASEBECI,NEW_DSN3,FMS_AUTH_ID,GET_DENIED_PAGE_CACHED_TIME,ONLY_REPORT_SYSTEM,OPEN_TABLE,BUTCE_SIL,WRK_XML,CF_ADMIN_PASSWORD,CFQUERY,GET_EMPLOYEE_PERIOD,WRKURLSTRINGS,DSN_REPORT_ALIAS,WORKCUBE_APP,CLOSE_TABLE,DSN1,IS_GOV_PAYROLL,COLORHEADER,REPORT_URL,PUBLIC_DOMAIN,DIR_SEPERATOR,SES_I,REPORTMAN_URL,PAGE_CODE,DENIED_PAGES,I,WRK_EVAL,CARI_SIL,SESSION_TREE,LANG_ARRAY,ATTRIBUTES,COMPANY_ASSET_RELATION,ACTIVE_DIRECTORY_SERVER_ADD,DSN,ALERT,UPD_WORKCUBE_SESSION,LISTDELETEDUPLICATESNOCASE,UF_PAGE_ADDRESS,VISIT_FUSEACT_,MX_COM_SERVER,CAREER_COMPANIES,WRK_XML_READ,FILTERNUM,GET_LANG_CACHED_TIME,ONSESSIONSTART,DEFAULT_COMPANY_ID_,DSN1_ALIAS,PARTNER_URL,USE_STANDALONE,DATABASE_HOST,NOTE,DOWNLOAD_FOLDER,DEL_COST,CONTENTENCRYPTINGANDDECODINGAES,GET_FUSEACTIONS,DIRECT_LIST,USE_BOOMBOSS_REPORT,GET_CONS_INFO,APPNAME,PARTNER_BROWSER_TYPES,BROWSERDETECT,DENIED_LIST,WRK_COOKIE_ID,LANG_ARRAY_MAIN,DSN3_ALIAS,OPEN_TR'>
    
		<cfset returnStructList = StructKeyList(variables)>
        <cfloop from="1" to="#listlen(ignoreList,',')#" index="delim">
	        <cftry>
				<cfset returnStructList = listDeleteAt(returnStructList,listFindNoCase(returnStructList,listGetAt(ignoreList,delim,',')))>
			<cfcatch></cfcatch>
			</cftry>
		</cfloop>
        <cfset returnStructList = listSort(listDeleteAt(returnStructList,listFindNoCase(returnStructList,'IGNORELIST')),'text')>
        <cfoutput>
        	<cfloop index="delim" from="1" to="#listlen(returnStructList,',')#">
            	#listGetAt(returnStructList,delim,',')#=<cfdump var='#variables["#listGetAt(returnStructList,delim,',')#"]#'><br />
			</cfloop>
		</cfoutput>
</cffunction>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">