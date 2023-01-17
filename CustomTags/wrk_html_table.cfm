<!--- index folder musterilerde farkli yerlerde olabileceginden download_folder olarak degistirildi --->
<cfparam name="attributes.id" default="html_table_#round(rand()*10000000)#">
<cfparam name="attributes.table_draw_type" default="0">
<cfparam name="attributes.pagebreak_number" default="50">
<cfparam name="attributes.sheettotal_number" default="50000">
<cfparam name="attributes.is_auto_page_break" default="1"><!--- 0 gelirse o an sayfayi boler --->
<cfparam name="attributes.is_auto_sheet_break" default="1"><!--- 0 gelirse o an yeni calisma kitabi olusturur --->
<cfparam name="attributes.no_output" default="0"><!--- 1 gelirse dosya olusturulur. Ama indirme linki kullaniciya girmez --->
<cfparam name="attributes.is_write_every_row" default="0">
<cfparam name="attributes.table" default="1">
<cfparam name="attributes.filename" default="file_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#">
<cfset caller.active_table_draw_type = attributes.table_draw_type>
<cfset caller.pagebreak_number = attributes.pagebreak_number>
<cfset caller.sheettotal_number = attributes.sheettotal_number>
<cfset caller.is_auto_page_break = attributes.is_auto_page_break>
<cfset caller.is_auto_sheet_break = attributes.is_auto_sheet_break>
<cfparam name="attributes.font_size_1" default="10"><!--- Sayfanin govde kisimlarinin font size'i --->
<cfparam name="attributes.font_size_2" default="12"><!--- Sayfanin baslik kisimlarinin font size'i --->
<cfparam name="attributes.font_style_1" default="Arial"><!--- Sayfanin govde kisimlarinin yazi tipi --->
<cfparam name="attributes.font_style_2" default="Arial"><!--- Sayfanin baslik kisimlarinin yazi tipi --->
<cfset caller.sheet_ = 0>
<cfset caller.fileName = attributes.filename>

<cfif not isdefined("caller.download_folder")>
	<cfset caller.download_folder = caller.caller.download_folder>
    <cfset caller.dir_seperator = caller.caller.dir_seperator>
</cfif>

<cfif thisTag.executionMode eq "start">
	<cfif caller.active_table_draw_type eq 0>
		<cfset caller.rowspan_son = 0>		
		<cfset deger=Structkeylist(attributes)>
		<cfset count=StructCount(attributes)>
		
		<cfset list_=''>
		<cfloop from="1" to="#count#" index="cc">
			<cfset att= listgetat(deger,cc)>
			<cfset listem='#att#="#evaluate('attributes.#att#')#" '>
			<cfset list_=listappend(list_,listem)>
		</cfloop>
		<cfif attributes.table>
		<cfoutput>
			<table <cfloop index="ff" list="#list_#">#ff#</cfloop>  id="#attributes.id#" width="100%" cellspacing="0">
		</cfoutput>
		</cfif>
	<cfelseif caller.active_table_draw_type eq 1>
		<cfset caller.drc_name_ = "#dateformat(now(),'yyyymmdd')#">
		<cfif not directoryexists("#caller.download_folder#documents#caller.dir_seperator#reserve_files#caller.dir_seperator##caller.drc_name_#")>
			<cfdirectory action="create" directory="#caller.download_folder#documents#caller.dir_seperator#reserve_files#caller.dir_seperator##caller.drc_name_#">
		</cfif>
		
		<cfset caller.workBook = createObject("java","org.apache.poi.xssf.usermodel.XSSFWorkbook").init()/>	
		<cfset caller.newSheet = caller.workBook.createSheet()/>	

		<cfset caller.workBook.setSheetName(caller.sheet_, "Yeni Excel Sistemi")/>
		<cfset caller.tr_satir_sayisi = 0>	
		<cfset printSetup = caller.newSheet.getPrintSetup()>				
		
		<cfset caller.newSheet.setMargin(0,0)>
		<cfset caller.newSheet.setMargin(1,0)>
		<cfset caller.newSheet.setMargin(2,0)>
		<cfset caller.newSheet.setMargin(3,0)>		
		
		<cfset deger=Structkeylist(attributes)>
		<cfset count=StructCount(attributes)>	
				
		<cfset caller.rowspan_son = 0>				
		<cfset caller.colspan_son = 0>
		<cfset caller.ortala= 0>
		<cfset caller.bold_ = 400>
		<cfset caller.font_size_ = 10>
		<cfset caller.satir_tut = 0 >
		<cfset caller.nodraw_deger = 0>

		<cfset caller.normal_font_br = caller.workBook.createFont()>
		<cfset caller.normal_style_br = caller.workBook.createCellStyle()>	
		<!---<cfset caller.normal_font_br.setBoldWeight(400)>--->
		<cfset caller.normal_font_br.setFontHeightInPoints(attributes.font_size_1)>
		<cfset caller.normal_font_br.setFontName("#attributes.font_style_1#")>			
		<!---<cfset caller.normal_style_br.setAlignment(0)>--->
		<cfset caller.normal_style_br.setWrapText(true)>
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>	
			<cfset caller.normal_font_br.setCharSet(1)>	
		</cfif>		
		<cfset caller.normal_style_br.setFont(caller.normal_font_br)>


		<!--- normal left style --->
		<cfset caller.normal_left_font = caller.workBook.createFont()>
		<cfset caller.normal_left_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.normal_left_font.setBoldWeight(400)>--->
		<cfset caller.normal_left_font.setFontHeightInPoints(attributes.font_size_1)>
		<cfset caller.normal_left_font.setFontName("#attributes.font_style_1#")>			
		<!---<cfset caller.normal_left_style.setAlignment(0)>--->

		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>	
			<cfset caller.normal_left_font.setCharSet(1)>	
		</cfif>		
		<cfset caller.normal_left_style.setFont(caller.normal_left_font)>
		<!--- normal left style --->
		
		<!--- normal right style --->
		<cfset caller.normal_right_font = caller.workBook.createFont()>
		<cfset caller.normal_right_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.normal_right_font.setBoldWeight(400)>--->
		<cfset caller.normal_right_font.setFontHeightInPoints(attributes.font_size_1)>		
		<cfset caller.normal_right_font.setFontName("#attributes.font_style_1#")>			
		<!---<cfset caller.normal_right_style.setAlignment(3)>--->
		<cfset caller.normal_right_style.setWrapText(true)>
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>
			<cfset caller.normal_right_font.setCharSet(1)>	
		</cfif>			
		<cfset caller.normal_right_style.setFont(caller.normal_right_font)>
		<!--- normal right style --->
		
		<!--- normal center style --->
		<cfset caller.normal_center_font = caller.workBook.createFont()>
		<cfset caller.normal_center_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.normal_center_font.setBoldWeight(400)>--->
		<cfset caller.normal_center_font.setFontHeightInPoints(attributes.font_size_1)>	
		<cfset caller.normal_center_font.setFontName("#attributes.font_style_1#")>				
		<!---<cfset caller.normal_center_style.setAlignment(2)>--->
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>			
			<cfset caller.normal_center_font.setCharSet(1)>			
		</cfif>	
		<cfset caller.normal_center_style.setFont(caller.normal_center_font)>
		<!--- normal center style --->	
		
		<!--- txtbold left style --->
		<cfset caller.txtbold_left_font = caller.workBook.createFont()>
		<cfset caller.txtbold_left_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.txtbold_left_font.setBoldWeight(700)>--->
		<cfset caller.txtbold_left_font.setFontName("#attributes.font_style_1#")>		
		<cfset caller.txtbold_left_font.setFontHeightInPoints(attributes.font_size_1)>		
		<!---<cfset caller.txtbold_left_style.setAlignment(0)>--->
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>				
			<cfset caller.txtbold_left_font.setCharSet(1)>
		</cfif>
		<cfset caller.txtbold_left_style.setFont(caller.txtbold_left_font)>
		<!--- txtbold left style --->	
		
		<!--- txtbold right style --->
		<cfset caller.txtbold_right_font = caller.workBook.createFont()>
		<cfset caller.txtbold_right_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.txtbold_right_font.setBoldWeight(700)>--->
		<cfset caller.txtbold_right_font.setFontHeightInPoints(attributes.font_size_1)>	
		<cfset caller.txtbold_right_font.setFontName("#attributes.font_style_1#")>				
		<!---<cfset caller.txtbold_right_style.setAlignment(3)>--->
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>			
			<cfset caller.txtbold_right_font.setCharSet(1)>	
		</cfif>
		<cfset caller.txtbold_right_style.setFont(caller.txtbold_right_font)>
		<!--- txtbold right style --->	
		
		<!--- txtbold center style --->
		<cfset caller.txtbold_center_font = caller.workBook.createFont()>
		<cfset caller.txtbold_center_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.txtbold_center_font.setBoldWeight(700)>--->
		<cfset caller.txtbold_center_font.setFontHeightInPoints(attributes.font_size_1)>
		<cfset caller.txtbold_center_font.setFontName("#attributes.font_style_1#")>					
		<!---<cfset caller.txtbold_center_style.setAlignment(2)>--->	
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>			
			<cfset caller.txtbold_center_font.setCharSet(1)>		
		</cfif>
		<cfset caller.txtbold_center_style.setFont(caller.txtbold_center_font)>
		<!--- txtbold center style --->	
		
		<!--- headbold left style --->
		<cfset caller.headbold_left_font = caller.workBook.createFont()>
		<cfset caller.headbold_left_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.headbold_left_font.setBoldWeight(700)>--->
		<cfset caller.headbold_left_font.setFontHeightInPoints(attributes.font_size_2)>	
		<cfset caller.headbold_left_font.setFontName("#attributes.font_style_2#")>				
		<!---<cfset caller.headbold_left_style.setAlignment(0)>--->
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>		
			<cfset caller.headbold_left_font.setCharSet(1)>				
		</cfif>	
		<cfset caller.headbold_left_style.setFont(caller.headbold_left_font)>
		<!--- headbold left style --->	
		
		<!--- headbold right style --->
		<cfset caller.headbold_right_font = caller.workBook.createFont()>
		<cfset caller.headbold_right_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.headbold_right_font.setBoldWeight(700)>--->
		<cfset caller.headbold_right_font.setFontHeightInPoints(attributes.font_size_2)>
		<cfset caller.headbold_right_font.setFontName("#attributes.font_style_2#")>						
		<!----<cfset caller.headbold_right_style.setAlignment(3)>--->	
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>		
			<cfset caller.headbold_right_font.setCharSet(1)>	
		</cfif>					
		<cfset caller.headbold_right_style.setFont(caller.headbold_right_font)>
		<!--- headbold right style --->	
		
		<!--- headbold center style --->	
		<cfset caller.headbold_center_font = caller.workBook.createFont()>
		<cfset caller.headbold_center_style = caller.workBook.createCellStyle()>	
		<!---<cfset caller.headbold_center_font.setBoldWeight(700)>--->
		<cfset caller.headbold_center_font.setFontHeightInPoints(attributes.font_size_2)>	
		<cfset caller.headbold_center_font.setFontName("#attributes.font_style_2#")>					
		<!---<cfset caller.headbold_center_style.setAlignment(2)>--->
		<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') gt 8>			
			<cfset caller.headbold_center_font.setCharSet(1)>
		</cfif>					
		<cfset caller.headbold_center_style.setFont(caller.headbold_center_font)>
		<!--- headbold center style --->												
		
		<!--- format_numeric --->
		<cfset caller.numeric_data = caller.workBook.createDataFormat()>
		<cfset caller.numeric_font = caller.workBook.createFont()>
		<cfset caller.numeric_style = caller.workBook.createCellStyle()>
		<cfset caller.numeric_font.setFontHeightInPoints(attributes.font_size_1)>	
		<cfset caller.numeric_font.setFontName("#attributes.font_style_1#")>
		<!---<cfset caller.numeric_style.setAlignment(3)>	--->		
		<cfset caller.numeric_style.setDataFormat(caller.numeric_data.getFormat("##,####0.00"))>
		<cfset caller.numeric_style.setFont(caller.numeric_font)>							
		
		<!--- format_date --->
		<cfset caller.date_data = caller.workBook.createDataFormat()>
		<cfset caller.date_font = caller.workBook.createFont()>
		<cfset caller.date_style = caller.workBook.createCellStyle()>
		<cfset caller.date_font.setFontHeightInPoints(attributes.font_size_1)>	
		<cfset caller.date_font.setFontName("#attributes.font_style_1#")>	
		<!---<cfset caller.date_style.setAlignment(3)>	--->		
		<cfset caller.date_style.setDataFormat(caller.date_data.getFormat("dd/mm/yyyy"))>
		<cfset caller.date_style.setFont(caller.date_font)>	
				
		<cfset caller.font = caller.workBook.createFont()>
		<cfset caller.style = caller.workBook.createCellStyle()>
        
        <cfscript>
			if(attributes.is_write_every_row)
				caller.csv_write_every_row = 1;
			else
				caller.csv_write_every_row = 0;
        </cfscript>			
				
	<cfelseif caller.active_table_draw_type eq 2>
		<cfset caller.drc_name_ = "#dateformat(now(),'yyyymmdd')#">
		<cfif not directoryexists("#caller.download_folder#documents#caller.dir_seperator#reserve_files#caller.dir_seperator##caller.drc_name_#")>
			<cfdirectory action="create" directory="#caller.download_folder#documents#caller.dir_seperator#reserve_files#caller.dir_seperator##caller.drc_name_#">
		</cfif>
		<cfscript>
			caller.csv_CRLF = Chr(13) & Chr(10);
			caller.csv_dosya = ArrayNew(1);
			caller.csv_filename = attributes.filename;
			if(attributes.is_write_every_row)
				caller.csv_write_every_row = 1;
			else
				caller.csv_write_every_row = 0;
		</cfscript>
	</cfif>
<cfelse>
	<cfif caller.active_table_draw_type eq 0>
		<cfif attributes.table>
		</table>
	</cfif>
	<cfelseif caller.active_table_draw_type eq 1>	
		
		<cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#caller.download_folder#documents#caller.dir_seperator#reserve_files#caller.dir_seperator##caller.drc_name_##caller.dir_seperator##attributes.filename#.xlsx")/>
		<cfset caller.workBook.write(fileOutStream)/>
		<cfset fileOutStream.close()/>
		<cfif attributes.no_output eq 0>
			<script type="text/javascript">
				<cfoutput>
					get_wrk_message_div("#caller.getLang('main',1931)#","#caller.getLang('main',1934)#","/documents/reserve_files/#caller.drc_name_#/#attributes.filename#.xlsx")  
				</cfoutput>
		    </script>
		</cfif>
	<cfelseif caller.active_table_draw_type eq 2>
		<cfif caller.csv_write_every_row eq 0>
			<cffile action="write" output="#ArrayToList(caller.csv_dosya,caller.csv_CRLF)#" addnewline="yes" file="#caller.download_folder#documents#caller.dir_seperator#reserve_files#caller.dir_seperator##caller.drc_name_##caller.dir_seperator##attributes.filename#.csv" charset="ISO-8859-9">
		</cfif>
			<script type="text/javascript">
                get_wrk_message_div("<cfoutput>#caller.getLang('main',1931)#</cfoutput>","CSV","<cfoutput>/documents/reserve_files/#caller.drc_name_#/#attributes.filename#.csv</cfoutput>")
            </script>
	</cfif>
</cfif>