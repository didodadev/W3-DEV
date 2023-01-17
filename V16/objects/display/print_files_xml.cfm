<cfset xml_forder_name = "#upload_folder#settings#dir_seperator##get_form.template_file#">
<cfset TLFormatList = "SubTotal,SaDiscount,DiscountTotal,TaxTotal,OtvTotal,NetTotal,OtherMoneyValue,RowDevredenToplam">
<cfif FileExists("#xml_forder_name#")>
	 <cffile action="read" file="#xml_forder_name#" variable="xmldosyam" charset="UTF-8">
		<cfscript>
             dosyam = XmlParse(xmldosyam);
             xml_dizi =dosyam.DesignPaper.XmlChildren;
             d_boyut = ArrayLen(xml_dizi);
			 	PRINTDESIGNTYPE = ListFirst(dosyam.DesignPaper[1].XmlAttributes.PRINTDESIGNTYPE,'-'); //sablon tipi
				COLUMNHEIGHT = dosyam.DesignPaper[1].XmlAttributes.COLUMNHEIGHT;
				COLUMNWIDTH = dosyam.DesignPaper[1].XmlAttributes.COLUMNWIDTH;
				PAGEHEIGHT = dosyam.DesignPaper[1].XmlAttributes.PAGEHEIGHT;
				PAGEWIDTH = dosyam.DesignPaper[1].XmlAttributes.PAGEWIDTH;
				ROWCOUNT = dosyam.DesignPaper[1].XmlAttributes.ROWCOUNT;
				PRINTDESIGNNAME = dosyam.DesignPaper[1].XmlAttributes.PRINTDESIGNNAME;
				SIZEUNIT = 'mm';
        </cfscript>
		<!--- Queryler Cekiliyor, yukaridaki scriptten deger cekmem gerektiginden buraya yazdim yerini degistirmeyiniz FBS --->
        <!--- FS değiştirmeyin dediyse değiştirmeyin M.ER :) --->
		<cfinclude template="../query/get_print_files_xml_query.cfm">
        <cfparam name="main_div_top" default="0"><!--- Sayfalama yapılacak yerlerde ana divimizin top değerine ihtiyacımız var.. --->
		<cfset AraToplam = 0>
<!---		<cfif len(ROWCOUNT)>
			<cfset max_row = ROWCOUNT><!--- Şimdilik el ile set edildi daha sonra düzeltilecek... --->
		<cfelse>--->
			<cfset max_row = GetRowInfo.recordcount>
<!---		</cfif>--->
		<cfif val(ROWCOUNT) neq 0>
			<cfset son_satir = val(ROWCOUNT)>
		</cfif>	
		<cfset sayfa_sayisi = ceiling(GetRowInfo.recordcount/max_row)>
		<cfif sayfa_sayisi eq 0>
			<cfset sayfa_sayisi = 1>
		</cfif>
		<cfloop from="1" to="#sayfa_sayisi#" index="j">
			<cfset 'sayfa_toplam_#j#' = 0>
        	<cfset start_row=((j-1)*max_row)+1>
			<cfset is_write_row = 0>
            <cfset row_left_list = ''>
			<cfset min_left_ = 800>
			<cfset deneme_left_ = 0>	
			<cfset totalwith = 0>
			<cfset totalwitheng = 0>		
			<cfoutput>
            <div id="main_div" style="margin-top:#main_div_top+j#mm;width:#PAGEWIDTH##SIZEUNIT#;height:#PAGEHEIGHT##SIZEUNIT#; border:0px solid black;position:absolute;">
                <cfloop from="1" to="#d_boyut#" index="xind">
                    <cfset field_chapter = dosyam.DesignPaper[1].XmlChildren[xind].XmlName>
                    <cfset field_length = ArrayLen(dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren)>					
						<cfif field_chapter is 'Middle'>
							<cfloop from="1" to="#field_length#" index="fli">						
								<cfset deneme = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.LeftMargin>								
									<cfif deneme lt min_left_>
										<cfset min_left_ = deneme>
										<cfset deneme_left_ = fli>
									</cfif>	 						   
							</cfloop>							
						</cfif>																			
                        <cfloop from="1" to="#field_length#" index="fli">
	                        <cfset query_field_turkish = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlText>
                            <cfset query_field = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlName>							
                            <cfset query_field_height = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.Height>
                            <cfset query_field_left_margin = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.LeftMargin>
							<!---xind orta kısımdaki elemanların tek sıra ile yazılması için kontrol edilmiştir--->
							<cfif field_chapter is 'Middle'>							                        
								<cfset query_field_top_margin = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[deneme_left_].XmlAttributes.TopMargin>
							<cfelse>							   
	                            <cfset query_field_top_margin = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.TopMargin>							
							</cfif>
                            <cfset query_field_widht = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.Width>
							<cfset query_field_font_size = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.FontSize>
							<cfset query_field_font_family = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.FontType>
							<cfset query_field_bold = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.Bold>	
							<cfset query_field_italic = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.Italic>								
							<cfset query_field_justify_center = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.JustifyCenter>	
							<cfset query_field_justify_left = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.JustifyLeft>	
							<cfset query_field_justify_right = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.JustifyRight>		
							<cfset query_field_underline = dosyam.DesignPaper[1].XmlChildren[xind].XmlChildren[fli].XmlAttributes.Underline>
							<cfset font_size_ = 10>
							<cfset font_family_ = "Arial, Helvetica, sans-serif">
							<cfset font_weight_ = 100>
							<cfset text_align_ = "left">
							<cfset font_style_ = "normal">
							<cfset text_decoration_ = "none">
							   <cfif isdefined("query_field_font_size") and len(query_field_font_size)><cfset font_size_ = val(query_field_font_size)></cfif>
							   <cfif isdefined("query_field_font_family") and len(query_field_font_family)><cfset font_family_ = query_field_font_family></cfif>
							   <cfif isdefined("query_field_bold") and query_field_bold eq 1><cfset font_weight_ = "bold"></cfif>
							   <cfif isdefined("query_field_justify_left") and query_field_justify_left is 1><cfset text_align_ = "left"></cfif>
							   <cfif isdefined("query_field_justify_center") and query_field_justify_center is 1><cfset text_align_ = "center"></cfif>
							   <cfif isdefined("query_field_justify_right") and query_field_justify_right is 1><cfset text_align_ = "right"></cfif>	
							   <cfif isdefined("query_field_italic") and query_field_italic eq 1><cfset font_style_ = "italic"></cfif>							   						   							   
							   <cfif isdefined("query_field_underline") and query_field_underline eq 1><cfset text_decoration_ = "underline"></cfif>					
							<cfif field_chapter is 'Middle'>
								<div id="#query_field#_div" style="top:#query_field_top_margin#; left:#query_field_left_margin#; width:#query_field_widht#;text-align:#text_align_#; border:0px solid black; position:absolute; overflow:hidden;">							  	
									<cfset satir_sayisi = #GetRowInfo.recordcount#>
									<cfloop from="1" to="#satir_sayisi#" index="mmk">
										<span style="font-size:#font_size_#px; font-family:#font_family_#; font-weight:#font_weight_#; font-style:#font_style_#; text-decoration:#text_decoration_#;">
											<cfset row_value_ = GetRowInfo["#query_field#"][mmk]>									
											<cfif len(row_value_)>
												<cfif listfindnocase(TLFormatList,query_field)>
													#tlformat(row_value_)#
												<cfelse>
													#row_value_#
												</cfif>
											<cfelse>&nbsp;
											</cfif>
											<cfif mmk neq GetRowInfo.recordcount><br /></cfif>
										</span>
									</cfloop>
								</div>
							<cfelse>
								<div id="#query_field#_div" style="top:#query_field_top_margin#; left:#query_field_left_margin#; width:#query_field_widht#; height:#query_field_height#; text-align:#text_align_#; border:0px solid black; position:absolute; overflow:hidden;">
								   <span style="font-size:#font_size_#px; font-family:#font_family_#; font-weight:#font_weight_#; font-style:#font_style_#; text-decoration:#text_decoration_#">				
										<cfif query_field is 'NETTOTAL'>
								   			<cfset row_value_ = evaluate(query_field)>											
											<cfset totalwith = row_value_>
											<cfset totalwitheng = row_value_>											
										</cfif>
										<cfif query_field is 'TOTALWITHWRITE'>
											<cf_get_lang_set_main lang_name="TR">
											<cf_n2txt number="totalwith">
											<cfoutput>#totalwith#</cfoutput>
										<cfelseif query_field is 'TOTALWITHWRITEENG'>
											<cf_get_lang_set_main lang_name="ENG">
											<cf_n2txt number="totalwitheng">
											<cfoutput>#totalwitheng#</cfoutput>
										<cfelseif query_field contains 'PFILEADDINFO'>
								   			 <cfset row_value_ = "#query_field_turkish#">
										<cfelse>
											<cfset row_value_ = evaluate(query_field)>
										</cfif>
										
										<cfif listfindnocase(TLFormatList,query_field)>
											#tlformat(row_value_)#
										<cfelseif query_field is 'TOTALWITHWRITE'>
										<cfelseif query_field is 'TOTALWITHWRITEENG'>
										<cfelse>
											#row_value_#
										</cfif>
								   </span>
								</div>
							</cfif>
                        </cfloop>
                </cfloop>
            </div>           
			</cfoutput>
		</cfloop>
<cfelse>
    <cf_get_lang dictionary_id='60172.XML DOSYA BULUNAMADI'>!
</cfif>
