﻿<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode eq "start">
	<cfif caller.active_table_draw_type eq 0>		
		<cfset deger=Structkeylist(attributes)>
		<cfset count=StructCount(attributes)>
		
		<cfset list_=''>
		<cfloop from="1" to="#count#" index="cc">
			<cfset caller.att= listgetat(deger,cc)>
			<cfset listem='#caller.att#="#evaluate('attributes.#caller.att#')#" '>
			<cfif listem contains 'ALIGN' or listem contains 'align'>
                <cfset listem='style="text-align:#evaluate('attributes.#caller.att#')#" '>
            </cfif>
			<cfset list_=listappend(list_,listem)>

			<cfif caller.att eq 'colspan'>
				<cfset colspan_deger =evaluate('attributes.#caller.att#')>
			</cfif>

		</cfloop>
		<cfoutput>
			<th <cfif listlen(list_) gt 0><cfloop index="ff" list="#list_#">#ff#</cfloop></cfif>>
		</cfoutput>
	<cfelseif caller.active_table_draw_type eq 1>
	</cfif>
<cfelse>
	<cfif caller.active_table_draw_type eq 0>
		<cfoutput>#degerim_#</cfoutput></th>
	<cfelseif caller.active_table_draw_type eq 2>
		<cfset deger=Structkeylist(attributes)>
		<cfset count=StructCount(attributes)>		
		<cfset caller.colspan_son = 0>
		<cfset caller.nodraw_deger = 0>		
		<cfset list_=''>
		<cfloop from="1" to="#count#" index="cc">
			<cfset att= listgetat(deger,cc)>
			<cfset listem='#att#="#evaluate('attributes.#att#')#" '>
			<cfset list_=listappend(list_,listem)>
			<cfif att is 'colspan'>
				<cfset caller.colspan_son = evaluate('attributes.#att#') - 1>
			</cfif>		
			<cfif att is 'nodraw' or att is 'NODRAW'>
				<cfset caller.nodraw_deger = 1>					
			</cfif>											
		</cfloop>
		<cfset csv_add_ = ''>
		<cfloop index="LoopCount" from="1" to="#caller.colspan_son#">
			<cfset csv_add_ = csv_add_ & ';'>
		</cfloop>
		<cfif caller.nodraw_deger neq 1 and caller.tr_nodraw_deger neq 1>		
			<cfset caller.csv_satir = '#caller.csv_satir##csv_add_##degerim_#;'>
		</cfif>		
	<cfelseif caller.active_table_draw_type eq 1>			
		<cfset caller.rowspan_son = 0>		
		<cfset caller.colspan_son = 0>	
		<cfset caller.ortala = 0>			
		<cfset caller.width_ = 1>
		<cfset caller.bold_ = 400>	
		<cfset deger=Structkeylist(attributes)>
		<cfset count=StructCount(attributes)>
		<cfset cell = caller.excel_table_row.createCell(caller.sutun_sayisi)>
		
		
		<cfset list_=''>
		<cfset this_td_class="normal">
		<cfset this_td_align="left">
		<cfset this_td_format = "text">
		<cfset this_class_type2 = "text2">
		<cfloop from="1" to="#count#" index="cc">
			<cfset att= listgetat(deger,cc)>
			<cfset listem='#att#="#evaluate('attributes.#att#')#" '>
			<cfset list_=listappend(list_,listem)>

			<cfif att is 'colspan'>
				<cfset caller.colspan_son = evaluate('attributes.#att#') -1>
			</cfif>
			
			<cfif att is 'rowspan'>
				<cfset caller.rowspan_son = evaluate('attributes.#att#') -1>
                <cfset 'caller.rowspan_#caller.tr_satir_sayisi#' = 1>	
				<cfif caller.rowspan_son gte caller.rowspan_buyuk>
					<cfset caller.rowspan_buyuk = caller.rowspan_son>
				</cfif>			
			</cfif>		
			
			<cfif att is 'width' and evaluate('attributes.#att#') does not contain "%">
				<cfset caller.width_ = evaluate('attributes.#att#')>
				<cfset caller.newSheet.setColumnWidth(caller.sutun_sayisi,caller.width_*25)>
				<cfset caller.style.setFont(caller.font)>						
			</cfif>	
			
			<cfif att is 'nodraw' or att is 'NODRAW'>
				<cfset caller.nodraw_deger = 1>
			</cfif>					
			
			<cfset this_td_class="txtbold">
			
			<cfif att is 'format'>
				<cfif evaluate('attributes.#att#') is 'numeric'>
					<cfset this_td_format = "numeric">	
					<cfset this_class_type2 = "#this_td_format#_style">
				<cfelseif evaluate('attributes.#att#') is 'date'>
					<cfset this_td_format = "date">
					<cfset this_class_type2 = "#this_td_format#_style">
				</cfif>				
			</cfif>
				
			<cfif att is 'align'>
				<cfset this_td_align = evaluate('attributes.#att#')>
			</cfif>				
		</cfloop>
        
		<cfif (this_class_type2 eq "#this_td_format#_style")>
			<cfset this_class_type = this_class_type2>
		<cfelse>
			<cfset this_class_type = "#this_td_class#_#this_td_align#_style">		
		</cfif>

		<cfif caller.nodraw_deger eq 0 and caller.tr_nodraw_deger eq 0>				
			<cfif caller.colspan_son gt 0 and caller.tr_satir_sayisi neq 0>
				<cfset region = createObject("java","org.apache.poi.ss.util.CellRangeAddress").init(caller.tr_satir_sayisi-1,caller.tr_satir_sayisi-1,caller.sutun_sayisi,caller.sutun_sayisi+caller.colspan_son)/>
				<cfset caller.newSheet.addMergedRegion(region)>
			</cfif>			
		
			<cfset caller.satir_tut = caller.tr_satir_sayisi>	
            <cfif caller.rowspan_son gt 0 and caller.tr_satir_sayisi neq 0>
				<cfset region = createObject("java","org.apache.poi.ss.util.CellRangeAddress").init(caller.satir_tut-1,caller.satir_tut+caller.rowspan_son-1,caller.sutun_sayisi,caller.sutun_sayisi)/>
				<cfset caller.newSheet.addMergedRegion(region)>	
                <cfset caller.rowspan_deger = caller.rowspan_son>
				<cfset caller.rowspan_satir = caller.satir_tut>	
				<cfset caller.rowspan_count = caller.sutun_sayisi>			
			</cfif>
            
			<cfif caller.rowspan_son eq 0 and not isdefined("caller.temp_satir_sayisi_#caller.tr_satir_sayisi#") and isdefined("caller.rowspan_satir") and ( caller.rowspan_satir lt caller.tr_satir_sayisi and caller.tr_satir_sayisi lte caller.rowspan_satir + caller.rowspan_deger + 1 )>
				<cfif isdefined("caller.rowspan_#caller.tr_satir_sayisi#") and evaluate("caller.rowspan_#caller.tr_satir_sayisi#") eq 1>
				<cfelse>
				<cfset caller.sutun_sayisi = caller.sutun_sayisi + caller.rowspan_count + 1>
				<cfset 'caller.temp_satir_sayisi_#caller.tr_satir_sayisi#' = 1>
				</cfif>
			</cfif>		

			<cfset caller.sutun_sayisi = caller.sutun_sayisi + 1 + caller.colspan_son>	
			<cfif degerim_ contains "&nbsp;">
				<cfset degerim_ = "#Replace(degerim_,"&nbsp;"," ","All")#">					
			</cfif>	
			<cfif degerim_ contains "<br />">
				<cfset degerim_ = "#Replace(degerim_,"<br />"," ","All")#">
			</cfif>	
			<cfif degerim_ contains "<br>">
				<cfset degerim_ = "#Replace(degerim_,"<br>"," ","All")#">
			</cfif>	
            
			<cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') lte 8>	
				<cfset cell.setEncoding(caller.workBook.ENCODING_UTF_16)>
			</cfif>	
            
			<cfif this_td_format is 'numeric'>
				<cfif degerim_ contains "." and degerim_ contains ",">
					<cfset degerim_ = "#Replace(degerim_,".","","All")#">			
					<cfset degerim_ = "#Replace(degerim_,",",".","All")#">												
				<cfelseif degerim_ contains ",">
					<cfset degerim_ = "#Replace(degerim_,",",".","All")#">				
				</cfif>
				<cfset cell.setCellValue(val(degerim_))>	
			<cfelseif this_td_format is 'date'>
				<cfset correct_date_1 = listgetat(degerim_,1,"/")>
				<cfset correct_date_2 = listgetat(degerim_,2,"/")>
				<cfset correct_date_3 = listgetat(degerim_,3,"/")>
				<cfif correct_date_1 lte 12>
					<cfset control_date = correct_date_2>				
					<cfset correct_date_2 = correct_date_1>
					<cfset correct_date_1 = control_date>
					<cfset degerim_ = correct_date_1 & '/' & correct_date_2 & '/' & correct_date_3>
				</cfif>
				<cfset cell.setCellValue(val(degerim_+0))>
			<cfelse>
				<cfset degerim_ = Rtrim(degerim_)>
				<cfset degerim_ = Ltrim(degerim_)>
				<cfset cell.setCellValue("#degerim_#")>
			</cfif>
            
			<cfset cell.setCellStyle("#evaluate('caller.#this_class_type#')#")>
		
		<cfelse>
			<cfset caller.nodraw_deger = 0>		
		</cfif>				
	</cfif>	
</cfif>