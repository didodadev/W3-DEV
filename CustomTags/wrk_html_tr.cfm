﻿<cfif thisTag.executionMode eq "start">
	<cfif caller.active_table_draw_type eq 0>
		<cfset deger=Structkeylist(attributes)>
		<cfset count=StructCount(attributes)>
		<cfset caller.rowspan_buyuk = 0>			
		
		<cfset list_=''>
		<cfloop from="1" to="#count#" index="cc">
			<cfset att= listgetat(deger,cc)>
			<cfset listem='#att#="#evaluate('attributes.#att#')#" '>
			<cfset list_=listappend(list_,listem)>
		</cfloop>
		<cfoutput>
			<tr <cfloop index="ff" list="#list_#">#ff#</cfloop>>
		</cfoutput>
	<cfelseif caller.active_table_draw_type eq 2>	
		<cfset caller.tr_nodraw_deger = 0>
		<cfset deger=Structkeylist(attributes)>
		<cfset count=StructCount(attributes)>		
		
		<cfset list_=''>
		<cfloop from="1" to="#count#" index="cc">
			<cfset att= listgetat(deger,cc)>
			<cfset listem='#att#="#evaluate('attributes.#att#')#" '>
			<cfset list_=listappend(list_,listem)>		
			
			<cfif att is 'nodraw' or att is 'NODRAW'>
            	<cfif evaluate('attributes.nodraw') eq 1>
					<cfset caller.tr_nodraw_deger = 1>	
                </cfif>			
			</cfif>								
		</cfloop>	
		<cfif caller.tr_nodraw_deger neq 1>
			<cfset caller.csv_satir = ''>
			<cfset caller.sutun_sayisi = 0>		
		</cfif>		
	<cfelseif caller.active_table_draw_type eq 1>	
		<cfset caller.tr_nodraw_deger = 0>
		<cfset deger=Structkeylist(attributes)>
		<cfset count=StructCount(attributes)>	
		<cfset caller.rowspan_buyuk = 0>		
		
		<cfset list_=''>
		<cfloop from="1" to="#count#" index="cc">
			<cfset att= listgetat(deger,cc)>
			<cfset listem='#att#="#evaluate('attributes.#att#')#" '>
			<cfset list_=listappend(list_,listem)>		
			
			<cfif att is 'nodraw' or att is 'NODRAW'>
	            <cfif evaluate('attributes.nodraw') eq 1>
					<cfset caller.tr_nodraw_deger = 1>
					<cfset caller.butun_satir_sil = 1>
                </cfif>		
			</cfif>								
		</cfloop>	
		<cfif caller.tr_nodraw_deger eq 0>
			<cfset caller.excel_table_row = caller.newSheet.createRow(caller.tr_satir_sayisi)/>
			<cfset gercek_sira_ = caller.tr_satir_sayisi + 1>
			<cfset caller.sutun_sayisi = 0>
			<cfset caller.tr_satir_sayisi = caller.tr_satir_sayisi +1>
			<cfif caller.is_auto_page_break eq 1>
				<cfif gercek_sira_ neq 1 and gercek_sira_ mod caller.pagebreak_number eq 0>
					<cfset caller.newSheet.setRowBreak(caller.tr_satir_sayisi-1)>					
				</cfif>
			<cfelse>
			</cfif>
			<cfif caller.is_auto_sheet_break eq 1>
				 <cfif caller.tr_satir_sayisi gte caller.sheettotal_number>
					<cfset caller.sheet_ = caller.sheet_ + 1>				 
					<cfset caller.newSheet = caller.workBook.createSheet()/>						
					<cfset caller.workBook.setSheetName(caller.sheet_, "Yeni Excel Sistemi #caller.sheet_#")/>	
					<cfset printSetup = caller.newSheet.getPrintSetup()>
					<cfset caller.newSheet.setMargin(0,0)>
					<cfset caller.newSheet.setMargin(1,0)>
					<cfset caller.newSheet.setMargin(2,0)>
					<cfset caller.newSheet.setMargin(3,0)>					
					<cfset caller.sutun_sayisi = 0>		
					<cfset caller.tr_satir_sayisi = 0>			
				</cfif> 
			<cfelse>
			</cfif>
    	</cfif>
    <cfelse>
        <cfset caller.sutun_sayisi = 0>	
        <cfset caller.tr_satir_sayisi = caller.tr_satir_sayisi +1>
    </cfif>
<cfelse>
	<cfif caller.active_table_draw_type eq 0>	
		</tr>		
	<cfelseif caller.active_table_draw_type eq 2>
		<cfif caller.csv_write_every_row eq 0>
			<cfscript>
				if (caller.tr_nodraw_deger neq 1)
				{
					ArrayAppend(caller.csv_dosya,caller.csv_satir);
				}
			</cfscript>
		<cfelse>
			<cfif caller.tr_nodraw_deger neq 1>
				<cfif arraylen(caller.csv_dosya) gte 500>
					<cffile action="append" output="#ArrayToList(caller.csv_dosya,caller.csv_CRLF)#" file="#caller.upload_folder#reserve_files#caller.dir_seperator##caller.drc_name_##caller.dir_seperator##caller.csv_filename#.csv" charset="ISO-8859-9">
					<cfscript>
						caller.csv_dosya = ArrayNew(1);
					</cfscript>
				<cfelse>
					<cfscript>
						ArrayAppend(caller.csv_dosya,caller.csv_satir);
					</cfscript>
				</cfif>
			</cfif>	
		</cfif>
    <cfelseif caller.active_table_draw_type eq 3>
    	<cfif caller.tr_satir_sayisi eq 1>
			<cfset caller.kolon_listesi_ = ''>
            <cfset sql_tip_listesi_ = ''>
            <cfloop index="aaa" from="1" to="#arraylen(caller.my2darray[arraylen(caller.my2darray)])#">
            	<cfif caller.my2darray[1][aaa] contains ' '>
                	<cfset caller.my2darray[1][aaa] = Replace(Trim(caller.my2darray[1][aaa]),' ','_','all')>
                </cfif>
            	<cfif caller.my2darray[1][aaa] contains '-'>
                	<cfset caller.my2darray[1][aaa] = Replace(Trim(caller.my2darray[1][aaa]),'-','_','all')>
                </cfif>
            	<cfif caller.my2darray[1][aaa] contains '/'>
                	<cfset caller.my2darray[1][aaa] = Replace(Trim(caller.my2darray[1][aaa]),'/','_','all')>
                </cfif>
            	<cfset caller.kolon_listesi_ = listAppend(caller.kolon_listesi_,caller.my2darray[1][aaa],',')>
                <cfset sql_tip_listesi_ = listAppend(sql_tip_listesi_,'VarChar',',')>
            </cfloop>
	        <cfset caller.get_excel_from_query = queryNew(caller.kolon_listesi_,sql_tip_listesi_)>
        </cfif>
	<cfelse>
		<cfif caller.tr_nodraw_deger eq 0>
	        <cfset caller.tr_satir_sayisi = caller.tr_satir_sayisi>
			<!---<cfset caller.tr_satir_sayisi = caller.tr_satir_sayisi + caller.rowspan_buyuk>  Rowspan kullanılan sayfalarda kayıtlarda hata yapıyordu diye kapattim. kontrol edilecek silmeyiniz.. EY 20130307--->
		<cfelse>
			<cfset caller.tr_nodraw_deger = 0>
		</cfif>

	</cfif>
</cfif>