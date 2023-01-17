<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfset file_name_ = "stock_analyse"&"_"&TimeFormat(now(),"hhmmss")>
<cfif not directoryexists("#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_#">
</cfif>

<cfif  fileexists("#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_##dir_seperator##file_name_#.xls")>
	<cffile action="delete" file="#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_##dir_seperator##file_name_#.xls">
</cfif>


<cfset workBook = createObject("java","org.apache.poi.hssf.usermodel.HSSFWorkbook").init()/>
<cfset newSheet = workBook.createSheet()/>
<cfset a = newSheet.createRow(0)>

<cfset new_colspan = 0 >
<cfset report_type_colspan_ = 0 >
<cfset report_type_colspan_1 = 0 >
<cfset report_type_colspan_2 = 0 >
<cfif isdefined("attributes.display_cost")> 
	<cfset report_type_colspan_3 = 1 >
<cfelse>a
	<cfset report_type_colspan_3 = 0 >
</cfif>
<cfset report_type_colspan_4 = 0 >
<cfset report_type_colspan_5 = 0 >
<cfset report_type_colspan_6 = 0 >
<cfset report_type_colspan_7 = 0 >
<cfset report_type_colspan_8 = 0 >
<cfset report_type_colspan_9 = 0 >
<cfset report_type_colspan_10 = 0 >
<cfset report_type_colspan_11 = 0 >
<cfset report_type_colspan_12 = 0 >
<cfset report_type_colspan_13 = 0 >
<cfset report_type_colspan_14 = 0 >
<cfset report_type_colspan_15 = 0 >
<cfset report_type_colspan_16 = 0 >
<cfset report_type_colspan_17 = 0 >
<cfset report_type_colspan_18 = 0 >
<cfset report_type_colspan_19 = 0 >
<cfset report_type_colspan_20 = 0 >
<cfset report_type_colspan_21 = 0 >
<cfset report_type_colspan_22 = 0 >
<cfset report_type_colspan_23 = 0 >
<cfset report_type_colspan_24 = 0 >

<cfif listfind('1,8',attributes.report_type,',')>
	<cfset report_type_colspan_ = 0>
	<cfif attributes.report_type eq 1>
    	<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1> 
			<cfset report_type_colspan_ = report_type_colspan_ + 1>
    	</cfif>
    </cfif>
</cfif>
<cfif listfind('1,2,3,4,5,6,8,9,10',attributes.report_type,',')>
	<cfset report_type_colspan_ = report_type_colspan_ + 1>
</cfif>  
<cfif listfind('1,2,8',attributes.report_type)>
	<cfset report_type_colspan_ = report_type_colspan_ + 1>
</cfif>
<cfif attributes.report_type eq 8>
	<cfset report_type_colspan_ = report_type_colspan_ + 1>	
</cfif> 

<cfif listfind('1,2,8',attributes.report_type)>
	<cfset report_type_colspan_ = report_type_colspan_ + 3 >
	<cfset report_type_colspan_1 = 1>
	<cfif isdefined('attributes.display_cost')>
    	<cfset report_type_colspan_1 = report_type_colspan_1 + 1 >
    	<cfif isdefined('attributes.is_system_money_2')>
        	<cfset report_type_colspan_1 = report_type_colspan_1 + 1 >	
        </cfif>
    </cfif>	
    <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
    	<cfset report_type_colspan_2 =  report_type_colspan_2 + 3 >
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_2 =  report_type_colspan_2 + 3 >	
			<cfif isdefined('attributes.is_system_money_2')>
             	<cfset report_type_colspan_2 =  report_type_colspan_2 + 3 >   
            </cfif>
        </cfif>    
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
    	<cfset report_type_colspan_3 = report_type_colspan_3 + 1>
    	<cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_3 = report_type_colspan_3 + 1>
        </cfif>
        <cfset report_type_colspan_3 = report_type_colspan_3 + 1>
    	<cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
        </cfif>
        <cfset report_type_colspan_3 = report_type_colspan_3 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
        </cfif>
    	<cfif isdefined('attributes.from_invoice_actions')>
        	<cfset report_type_colspan_3 = report_type_colspan_3 + 2>
        	<cfif isdefined('attributes.is_system_money_2')>
            	<cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
            </cfif>
        	<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
            	 <cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
            	 <cfif isdefined('attributes.is_system_money_2')>
                 	<cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
                 </cfif>
            	 <cfset report_type_colspan_3 = report_type_colspan_3 + 2>
           		 <cfif isdefined('attributes.is_system_money_2')>
                 	<cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
                 </cfif>
                 <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
                 	 <cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
					 <cfif isdefined('attributes.is_system_money_2')>
                        <cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
                     </cfif>	
                 </cfif>
            </cfif>
            <cfif isdefined('attributes.display_cost')>
            	<cfset report_type_colspan_3 = report_type_colspan_3 + 1>	
            	<cfif isdefined('attributes.is_system_money_2')>
                	<cfset report_type_colspan_3 = report_type_colspan_3 + 3>	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
    	<cfset report_type_colspan_4 = report_type_colspan_4 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_4 = report_type_colspan_4 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_4 = report_type_colspan_4 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
    	<cfset report_type_colspan_5 = report_type_colspan_5 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_5 = report_type_colspan_5 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_5 = report_type_colspan_5 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
    	<cfset report_type_colspan_6 = report_type_colspan_6 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_6 = report_type_colspan_6 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_6 = report_type_colspan_6 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
    	<cfset report_type_colspan_7 = report_type_colspan_7 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_7 = report_type_colspan_7 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_7 = report_type_colspan_7 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
    	<cfset report_type_colspan_8 = report_type_colspan_8 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_8 = report_type_colspan_8 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_8 = report_type_colspan_8 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
    	<cfset report_type_colspan_9 = report_type_colspan_9 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_9 = report_type_colspan_9 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_9 = report_type_colspan_9 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
    	<cfset report_type_colspan_10 = report_type_colspan_10 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_10 = report_type_colspan_10 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_10 = report_type_colspan_10 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
    	<cfset report_type_colspan_11 = report_type_colspan_11 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_11 = report_type_colspan_11 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_11 = report_type_colspan_11 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
    	<cfset report_type_colspan_12 = report_type_colspan_12 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_12 = report_type_colspan_12 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_12 = report_type_colspan_12 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
    	<cfset report_type_colspan_13 = report_type_colspan_13 + 3>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_13 = report_type_colspan_13 + 3>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_13 = report_type_colspan_13 + 3>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
    	<cfset report_type_colspan_14 = report_type_colspan_14 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_14 = report_type_colspan_14 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_14 = report_type_colspan_14 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
    	<cfset report_type_colspan_15 = report_type_colspan_15 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_15 = report_type_colspan_15 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_15 = report_type_colspan_15 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
    	<cfset report_type_colspan_16 = report_type_colspan_16 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_16 = report_type_colspan_16 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_16 = report_type_colspan_16 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
    	<cfset report_type_colspan_17 = report_type_colspan_17 + 1>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_17 = report_type_colspan_17 + 1>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_17 = report_type_colspan_17 + 1>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,16)>
    	<cfset report_type_colspan_18 = report_type_colspan_18 + 2>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_18 = report_type_colspan_18 + 2>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_18 = report_type_colspan_18 + 2>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,17)>
    	<cfset report_type_colspan_19 = report_type_colspan_19 + 2>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_19 = report_type_colspan_19 + 2>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_19 = report_type_colspan_19 + 2>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,18)>
    	<cfset report_type_colspan_20 = report_type_colspan_20 + 2>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_20 = report_type_colspan_20 + 2>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_20 = report_type_colspan_20 + 2>	
            </cfif>	
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
    	<cfset report_type_colspan_21 = report_type_colspan_21 + 2>
        <cfif isdefined('attributes.display_cost')>
        	<cfset report_type_colspan_21 = report_type_colspan_21 + 2>
            <cfif isdefined('attributes.is_system_money_2') >
            	<cfset report_type_colspan_21 = report_type_colspan_21 + 2>	
            </cfif>	
        </cfif>
    </cfif>
</cfif>

	<cfset report_type_colspan_22 = report_type_colspan_22 + 1 >
 	<cfif isdefined('attributes.display_cost')>
    	<cfset report_type_colspan_22 = report_type_colspan_22 + 1 >	
    	<cfif isdefined('attributes.is_system_money_2')>
        	<cfset report_type_colspan_22 = report_type_colspan_22 + 1 >
        </cfif>
        <cfif isdefined('attributes.display_ds_prod_cost')>
        	<cfset report_type_colspan_22 = report_type_colspan_22 + 1 >	
        	<cfif isdefined('attributes.is_system_money_2')>
        		<cfset report_type_colspan_22 = report_type_colspan_22 + 1 >
        	</cfif>
        </cfif>
    </cfif>
    
    <cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)>
    	<cfset report_type_colspan_23 = report_type_colspan_23 + 1 >
    </cfif>
    <cfif isdefined('attributes.stock_age')>
    	<cfset report_type_colspan_24 = report_type_colspan_24 + 1 >
    </cfif>

<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,0,0,report_type_colspan_)/>
<cfset newSheet.addMergedRegion(region)>
<cfset aa= a.createCell(0)>
<cfset aa.setCellValue("Rapor Tipi")>
<cfset new_colspan = new_colspan + report_type_colspan_ >

<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_1)/>
<cfset newSheet.addMergedRegion(region)>
<cfset aa= a.createCell(new_colspan+1)>
<cfset aa.setCellValue("Dönem Başı")>
<cfset new_colspan = new_colspan + report_type_colspan_1 >

<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_2)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Alış")>
    <cfset new_colspan = new_colspan + report_type_colspan_2 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_3)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Satış")>
    <cfset new_colspan = new_colspan + report_type_colspan_3 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_4)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem içi Giden Konsinye")>
    <cfset new_colspan = new_colspan + report_type_colspan_4 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_5)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi İade Gelen Konsinye")>
    <cfset new_colspan = new_colspan + report_type_colspan_5 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_6)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Konsinye Giriş")>
    <cfset new_colspan = new_colspan + report_type_colspan_6 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_7)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Konsinye Giriş İade")>
    <cfset new_colspan = new_colspan + report_type_colspan_7 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_8)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Teknik Servisten Giren")>
    <cfset new_colspan = new_colspan + report_type_colspan_8 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_9)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Teknik Servisten Çıkan")>
    <cfset new_colspan = new_colspan + report_type_colspan_9 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_10)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("RMA Giriş")>
    <cfset new_colspan = new_colspan + report_type_colspan_10 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_11)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("RMA Çıkış")>
    <cfset new_colspan = new_colspan + report_type_colspan_11 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_12)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Üretim")>
    <cfset new_colspan = new_colspan + report_type_colspan_12 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_13)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Sarf ve Fire")>
    <cfset new_colspan = new_colspan + report_type_colspan_13 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_14)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Sayım")>
    <cfset new_colspan = new_colspan + report_type_colspan_14 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_15)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Demontajdan Giriş")>
    <cfset new_colspan = new_colspan + report_type_colspan_15 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_16)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Demontaja Giden")>
    <cfset new_colspan = new_colspan + report_type_colspan_16 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_17)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Dönem İçi Masraf Fişleri")>
    <cfset new_colspan = new_colspan + report_type_colspan_17 >
</cfif>
<!---<cfif len(attributes.process_type) and listfind(attributes.process_type,16)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_18)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Konsinye  Gelen xxx")>
    <cfset new_colspan = new_colspan + report_type_colspan_18 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,17)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_19)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Konsinye  Gelen xxx")>
    <cfset new_colspan = new_colspan + report_type_colspan_19 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,18)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_20)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Konsinye  Gelen xxx")>
    <cfset new_colspan = new_colspan + report_type_colspan_20 >
</cfif>
<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_21)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Konsinye  Gelen xxx")>
    <cfset new_colspan = new_colspan + report_type_colspan_21 >
</cfif>--->
<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_22)/>
<cfset newSheet.addMergedRegion(region)>
<cfset aa= a.createCell(new_colspan+1)>
<cfset aa.setCellValue("Dönem Sonu Stok")>
<cfset new_colspan = new_colspan + report_type_colspan_22 >

<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_23)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Konsinye  Gelen xxx")>
    <cfset new_colspan = new_colspan + report_type_colspan_23>
</cfif>

<cfif isdefined('attributes.stock_age')>
	<cfset region = createObject("java","org.apache.poi.hssf.util.Region").init(0,new_colspan+1,0,new_colspan + report_type_colspan_24)/>
    <cfset newSheet.addMergedRegion(region)>
    <cfset aa= a.createCell(new_colspan+1)>
    <cfset aa.setCellValue("Konsinye  Gelen xxx")>
    <cfset new_colspan = new_colspan + report_type_colspan_24 >	
</cfif>

<cfset i = 0 >
<cfset a = newSheet.createRow(1)>
<cfif listfind('1,8',attributes.report_type,',')>
    <cfset aa= a.createCell(i)>
    <cfset aa.setCellValue("Stok Kodu")>
    <cfset i = i + 1 >
</cfif>
<cfif attributes.report_type eq 1>
	<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
         <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Özel Kod")>
         <cfset i = i + 1 >
	</cfif>
</cfif>
<cfif attributes.report_type eq 1>
		 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Stok")>
         <cfset i = i + 1 >
	<cfelseif attributes.report_type eq 2>
    	 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Ürün")>
         <cfset i = i + 1 >
	<cfelseif attributes.report_type eq 3>
    	 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Kategori")>
         <cfset i = i + 1 >
	<cfelseif attributes.report_type eq 4>
		 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Sorumlu")>
         <cfset i = i + 1 >
	<cfelseif attributes.report_type eq 5>
    	 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Marka")>
         <cfset i = i + 1 >
	<cfelseif attributes.report_type eq 6>
    	 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Tedarik")>
         <cfset i = i + 1 >
	<cfelseif attributes.report_type eq 8>
    	 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Stok")>
         <cfset i = i + 1 >
	<cfelseif attributes.report_type eq 9>
    	 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Depo")>
         <cfset i = i + 1 >
	<cfelseif attributes.report_type eq 10>Lokasyon
    	 <cfset aa= a.createCell(i)>
		 <cfset aa.setCellValue("Lokasyon")>
         <cfset i = i + 1 >
	</cfif>
<cfif listfind('1,2,8',attributes.report_type)>
	 <cfset aa= a.createCell(i)>
     <cfset aa.setCellValue("Barkod")>
     <cfset i = i + 1 >
</cfif>
<cfif attributes.report_type eq 8>
	<cfset aa= a.createCell(i)>
    <cfset aa.setCellValue("Main Spec")>
    <cfset i = i + 1 >
</cfif>

<cfif listfind('1,2,8',attributes.report_type)>
    <cfset aa= a.createCell(i)>
    <cfset aa.setCellValue("Ürün Kodu")>
    <cfset i = i + 1 >
    <cfset aa= a.createCell(i)>
    <cfset aa.setCellValue("Üretici Kodu")>
    <cfset i = i + 1 >
    <cfset aa= a.createCell(i)>
    <cfset aa.setCellValue("Birim")>
    <cfset i = i + 1 >
    <cfset aa= a.createCell(i)>
    <cfset aa.setCellValue("Stok Miktarı")>
    <cfset i = i + 1 >
    <cfif isdefined('attributes.display_cost')>
        <cfset aa= a.createCell(i)>
    	<cfset aa.setCellValue("Stok Maliyeti")>
    	<cfset i = i + 1 >
        <cfif isdefined('attributes.is_system_money_2')>
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Maliyet")>
            <cfset i = i + 1 >
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
		<cfset aa= a.createCell(i)>
        <cfset aa.setCellValue("Alım Miktarı")>
        <cfset i = i + 1 >

        <cfset aa= a.createCell(i)>
        <cfset aa.setCellValue("Alım İade Miktarı")>
        <cfset i = i + 1 >
        
        <cfset aa= a.createCell(i)>
        <cfset aa.setCellValue("Net Alım Miktarı")>
        <cfset i = i + 1 >
       
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
        	<cfset aa.setCellValue("Alım Tutar")>
        	<cfset i = i + 1 >
            
			<cfset aa= a.createCell(i)>
        	<cfset aa.setCellValue("Alım İade Tutarı")>
        	<cfset i = i + 1 >
            
            <cfset aa= a.createCell(i)>
        	<cfset aa.setCellValue("Net Alım Tutarı")>
        	<cfset i = i + 1 >
            
            <cfif isdefined('attributes.is_system_money_2')>
				<cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Alım Tutar")>
                <cfset i = i + 1 >
                
				<cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Alım İade Tutarı")>
                <cfset i = i + 1 >
                
                <cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Net Alım Tutarı")>
                <cfset i = i + 1 >  
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
		<cfset aa= a.createCell(i)>
        <cfset aa.setCellValue("Satış Miktar")>
        <cfset i = i + 1 > 
        
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Satış Maliyeti")>
            <cfset i = i + 1 > 
        </cfif>
        	<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Satış İade Miktar")>
            <cfset i = i + 1 > 
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Satış İade Maliyeti")>
            <cfset i = i + 1 >
        </cfif>
        	<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Net Satış Miktar")>
            <cfset i = i + 1 >
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Net Satış Maliyeti")>
            <cfset i = i + 1 >
        </cfif>
        <cfif isdefined('attributes.from_invoice_actions')><!--- faturadan hesapla secilmisse --->
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Fatura Satış Miktar")>
            <cfset i = i + 1 >

			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Fatura Satış Tutar")>
            <cfset i = i + 1 >
           
            <cfif isdefined('attributes.is_system_money_2')>
               <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Fatura Satış Tutar")>
                <cfset i = i + 1 >
            </cfif>
            
            <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
					<cfset aa= a.createCell(i)>
                    <cfset aa.setCellValue("Fatura Satış Maliyet")>
                    <cfset i = i + 1 >
                <cfif isdefined('attributes.is_system_money_2')>
					<cfset aa= a.createCell(i)>
                    <cfset aa.setCellValue("Fatura Satış Maliyet")>
                    <cfset i = i + 1 >
                </cfif>
            </cfif>

            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Fatura Satış İade Miktar")>
            <cfset i = i + 1 >
            
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Fatura Satış İade Miktar")>
            <cfset i = i + 1 >
            
            
            <cfif isdefined('attributes.is_system_money_2')>
				<cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Fatura Satış İade Tutar")>
                <cfset i = i + 1 >
            </cfif>
            <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
                <cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Fatura Satış İade Maliyet")>
                <cfset i = i + 1 >
                
				<cfif isdefined('attributes.is_system_money_2')>
					<cfset aa= a.createCell(i)>
                    <cfset aa.setCellValue("Fatura Satış İade Maliyet")>
                    <cfset i = i + 1 >
                </cfif>
            </cfif>
        </cfif>
        <cfif isdefined('attributes.display_cost')>
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Net FaturaSatış Maliyeti")>
            <cfset i = i + 1 >
            
            <cfif isdefined('attributes.is_system_money_2')>
                 <cfset aa= a.createCell(i)>
				 <cfset aa.setCellValue("Satış Maliyeti")>
                 <cfset i = i + 1 >

                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Satış İade Maliyeti")>
                <cfset i = i + 1 >

                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Net Satış Maliyeti")>
                <cfset i = i + 1 > 
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Konsinye Çıkış Miktar")>
            <cfset i = i + 1 > 
        <cfif isdefined('attributes.display_cost')>
           <cfset aa= a.createCell(i)>
           <cfset aa.setCellValue("Konsinye Çıkış Maliyet")>
           <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                <cfset aa= a.createCell(i)>
           		<cfset aa.setCellValue("Konsinye Çıkış Maliyet")>
          		<cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- iade gelen konsinye --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
		<cfset aa= a.createCell(i)>
        <cfset aa.setCellValue("Konsinye İade Miktar")>
        <cfset i = i + 1 >
        <cfif isdefined('attributes.display_cost')>
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Konsinye İade Maliyet")>
            <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                  <cfset aa= a.createCell(i)>
            	  <cfset aa.setCellValue("Konsinye İade Maliyet")>
            	  <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- konsinye giriş iade--->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
		  <cfset aa= a.createCell(i)>
          <cfset aa.setCellValue("Konsinye Giriş Miktar")>
          <cfset i = i + 1 >
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Konsinye Giriş Maliyet")>
            <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                 <cfset aa= a.createCell(i)>
				 <cfset aa.setCellValue("Konsinye Giriş Maliyet")>
                 <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- konsinye giriş iade--->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
    		<cfset aa= a.createCell(i)>
		 	<cfset aa.setCellValue(" Konsinye Giriş İade Miktar")>
        	<cfset i = i + 1 >
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
		 	<cfset aa.setCellValue("Konsinye Giriş İade Maliyet")>
        	<cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                 <cfset aa= a.createCell(i)>
		 		 <cfset aa.setCellValue("Konsinye Giriş İade Maliyet")>
        		 <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>				
		<cfset aa= a.createCell(i)>
        <cfset aa.setCellValue("Miktar")>
        <cfset i = i + 1 >
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Maliyet")>
            <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                 <cfset aa= a.createCell(i)>
				 <cfset aa.setCellValue("Maliyet")>
            	 <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
        <cfset aa= a.createCell(i)>
	 	<cfset aa.setCellValue("Miktar")>
     	<cfset i = i + 1 >
        <cfif isdefined('attributes.display_cost')>
        <cfset aa= a.createCell(i)>
	 	<cfset aa.setCellValue("Maliyet")>
     	<cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                 <cfset aa= a.createCell(i)>
				 <cfset aa.setCellValue("Maliyet")>
                 <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
			 <cfset aa= a.createCell(i)>
             <cfset aa.setCellValue("Miktar")>
             <cfset i = i + 1 >
        <cfif isdefined('attributes.display_cost')>
			 <cfset aa= a.createCell(i)>
             <cfset aa.setCellValue("Maliyet")>
             <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                <cfset aa= a.createCell(i)>
			    <cfset aa.setCellValue("Maliyet")>
         	    <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
        <cfset aa= a.createCell(i)>
        <cfset aa.setCellValue("Miktar")>
        <cfset i = i + 1 >
        <cfif isdefined('attributes.display_cost')>
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Maliyet")>
            <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Maliyet")>
                <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!---donemici uretim fişleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Üretim Miktar")>
        <cfset i = i + 1 >
        
        <cfif isdefined('attributes.display_cost')>
           <cfset aa= a.createCell(i)>
		   <cfset aa.setCellValue("Üretim Maliyet")>
           <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                <cfset aa= a.createCell(i)>
			    <cfset aa.setCellValue("Üretim Maliyet")>
                <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Sarf Miktar")>
        <cfset i = i + 1 >
        
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Üretim Sarf Miktar")>
        <cfset i = i + 1 >
       
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Fire Miktar")>
        <cfset i = i + 1>
        
        <cfif isdefined('attributes.display_cost')>

            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Sarf Maliyet")>
            <cfset i = i + 1>
            
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Üretim Sarf Maliyet")>
            <cfset i = i + 1>
            
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Fire Maliyet")>
            <cfset i = i + 1>
            
            <cfif isdefined('attributes.is_system_money_2')>
                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Sarf Maliyet")>
                <cfset i = i + 1>
                
				<cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Üretim Sarf Maliyet")>
                <cfset i = i + 1>
                
                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Fire Maliyet")>
                <cfset i = i + 1>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Miktar")>
        <cfset i = i + 1 >
        
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Maliyet")>
            <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
				<cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Sayım Maliyet")>
                <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- demontajdan giris --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Miktar")>
        <cfset i = i + 1 >
       
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Maliyet")>
            <cfset i = i + 1 >
            
            <cfif isdefined('attributes.is_system_money_2')>
            	<cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Demontajdan Giriş Maliyet")>
                <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- demontaja giden --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Miktar")>
        <cfset i = i + 1 >
        
		<cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Maliyet")>
        	<cfset i = i + 1 >
            
            <cfif isdefined('attributes.is_system_money_2')>
				<cfset aa= a.createCell(i)>
                <cfset aa.setCellValue(" Demontaja Giden Maliyet")>
                <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- masraf fişleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Miktar")>
        <cfset i = i + 1 >
        
		<cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Maliyet")>
            <cfset i = i + 1 >
            
            <cfif isdefined('attributes.is_system_money_2')>
				<cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Masraf Fişleri Maliyet")>
            	<cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- depo sevk--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Stok Giriş Miktar")>
        <cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Stok Çıkış Miktar")>
            <cfset i = i + 1 >
            
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Stok Giriş Maliyeti")>
            <cfset i = i + 1 >
            
				<cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Stok Çıkış Maliyeti")>
                <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
               
                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Stok Giriş Maliyeti")>
                <cfset i = i + 1 >

               <cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Stok Çıkış Maliyeti")>
                <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- ithal mal girişi--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Stok Giriş Miktar")>
        <cfset i = i + 1 >
        
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Stok Çıkış Miktar")>
        <cfset i = i + 1 >
        
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Stok Giriş Maliyeti")>
            <cfset i = i + 1 >
            
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Stok Çıkış Maliyeti")>
            <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
                
				<cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Stok Giriş Maliyeti")>
                <cfset i = i + 1 >
                
				<cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Stok Çıkış Maliyeti")>
                <cfset i = i + 1 >
                
            </cfif>
        </cfif>
    </cfif>
    <!--- ambar fişi --->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Stok Giriş Miktar")>
        <cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Stok Çıkış Miktar")>
            <cfset i = i + 1 >
            
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Stok Giriş Maliyeti")>
            <cfset i = i + 1 >
            
				<cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Stok Çıkış Maliyeti")>
                <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
               
                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Stok Giriş Maliyeti")>
                <cfset i = i + 1 >

               <cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Stok Çıkış Maliyeti")>
                <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
    <!--- stok virman --->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Stok Giriş Miktar")>
        <cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue("Stok Çıkış Miktar")>
            <cfset i = i + 1 >
            
        <cfif isdefined('attributes.display_cost')>
            <cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Stok Giriş Maliyeti")>
            <cfset i = i + 1 >
            
				<cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Stok Çıkış Maliyeti")>
                <cfset i = i + 1 >
            <cfif isdefined('attributes.is_system_money_2')>
               
                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Stok Giriş Maliyeti")>
                <cfset i = i + 1 >

               <cfset aa= a.createCell(i)>
                <cfset aa.setCellValue("Stok Çıkış Maliyeti")>
                <cfset i = i + 1 >
            </cfif>
        </cfif>
    </cfif>
 </cfif>
 
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Stok Miktar")>
        <cfset i = i + 1 >
        
            <cfif isdefined('attributes.display_cost')>
                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Stok Maliyet")>
                <cfset i = i + 1 >
                
				<cfif isdefined('attributes.is_system_money_2')>
                    <cfset aa= a.createCell(i)>
					<cfset aa.setCellValue("Maliyet")>
                	<cfset i = i + 1 >
				</cfif>
                
				<cfif isdefined('attributes.display_ds_prod_cost')><!--- donem sonu stokta urun birim maliyetinin gosterilmesi secilmiş ise --->
                    <cfset aa= a.createCell(i)>
					<cfset aa.setCellValue("Birim Maliyet")>
                	<cfset i = i + 1 >
                    
					<cfif isdefined('attributes.is_system_money_2')>
                        <cfset aa= a.createCell(i)>
						<cfset aa.setCellValue("Birim Maliyet")>
                        <cfset i = i + 1 >
					</cfif>
				</cfif>
			</cfif>
            
			<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)>
                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Birim Hacim")>
                <cfset i = i + 1 >

                <cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Toplam Hacim")>
                <cfset i = i + 1 >
			
            </cfif>
			<cfif isdefined('attributes.stock_age')>
            	<cfset aa= a.createCell(i)>
				<cfset aa.setCellValue("Stok Yaşı")>
                <cfset i = i + 1 >
			</cfif>

	


    <cfoutput query="get_all_stock">   
	<cfset m = 0 >
	
	<cfset a = newSheet.createRow(currentrow + 1)>
    
	<cfif listfind('1,8',attributes.report_type,',')>
        <cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(replace(GET_ALL_STOCK.STOCK_CODE,";","","all"))>
        <cfset m = m + 1 > 
    </cfif>
    
	<cfif attributes.report_type eq 1>
		<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
            <cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(stock_code_2)>
            <cfset m = m + 1 >  
        </cfif>
    </cfif> 
    
    <cfif listfind('1,8',attributes.report_type,',') and not listfind('1,2',attributes.is_excel)>
        <cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(GET_ALL_STOCK.ACIKLAMA)>
        <cfset m = m + 1 >  
    <cfelseif attributes.report_type eq 2 and not listfind('1,2',attributes.is_excel)>
        <cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(GET_ALL_STOCK.ACIKLAMA)>
        <cfset m = m + 1 >
     <cfelse>
     	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(replace(GET_ALL_STOCK.ACIKLAMA,";","","all"))>
        <cfset m = m + 1 >
    </cfif>
    
    <cfif listfind('1,2,8',attributes.report_type)>					
        <cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(replace(GET_ALL_STOCK.BARCOD,";","","all"))>
        <cfset m = m + 1 >  
    </cfif>
    
    <cfif attributes.report_type eq 8>
		<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(GET_ALL_STOCK.SPECT_VAR_ID)>
                <cfset m = m + 1 >  
        <cfelse>
                <cfset aa= a.createCell(m)>
			    <cfset aa.setCellValue(GET_ALL_STOCK.SPECT_VAR_ID)>
                <cfset m = m + 1 >
        </cfif>
    </cfif>
    
    <cfif listfind('1,2,8',attributes.report_type)>					
         <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(replace(GET_ALL_STOCK.PRODUCT_CODE,";","","all"))>
         <cfset m = m + 1 > 
    </cfif>
    
         <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(replace(GET_ALL_STOCK.MANUFACT_CODE,";","","all"))>
         <cfset m = m + 1 >  
        
         <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(replace(GET_ALL_STOCK.MAIN_UNIT,";","","all"))>
         <cfset m = m + 1 >
        
	<cfif isdefined("GET_ALL_STOCK.DB_STOK_MIKTAR")>
         <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DB_STOK_MIKTAR,4))>
         <cfset m = m + 1 >
    </cfif>
    
    <cfif isdefined('attributes.display_cost')>
		 <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DB_STOK_MIKTAR*GET_ALL_STOCK.ALL_START_COST/1))>
         <cfset m = m + 1 >
         
        <cfif isdefined("attributes.display_cost_money")>
            <cfset aa= a.createCell(m)>
		 	<cfset aa.setCellValue(all_start_money)>
         	<cfset m = m + 1 >
        </cfif>
        
        <cfif isdefined('attributes.is_system_money_2')>
            <cfset aa= a.createCell(m)>
		 	<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DB_STOK_MIKTAR*GET_ALL_STOCK.ALL_START_COST_2/1))>
         	<cfset m = m + 1 >
        </cfif>
    </cfif>
    <!--- alıs ve alıs iadeler bolumu --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS,4))>
                <cfset m = m + 1 >
            </cfif>
            
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_IADE,4))>
                <cfset m = m + 1 >
            </cfif>
            
			<cfset aa= a.createCell(m)>
            <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS-GET_ALL_STOCK.TOPLAM_ALIS_IADE,4))>
            <cfset m = m + 1 >
        
		<cfif isdefined('attributes.display_cost')>
			<cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_MALIYET1")>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET1))>
                <cfset m = m + 1 > 
            <cfelse>
            	<cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(0,4))>
                <cfset m = m + 1 >
            </cfif>
            
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET))>
                <cfset m = m + 1 > 
            </cfif>
            
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET1 - GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET ))>
                <cfset m = m + 1 > 
                 
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2")>
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2))>
                    <cfset m = m + 1 >
                </cfif>
                
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2")>
                        <cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2))>
                        <cfset m = m + 1 >
                    </cfif>
                    	
						<cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2- GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2 ))>
                        <cfset m = m + 1 > 
            </cfif>
        </cfif>
    </cfif>
    <!--- satıs ve satıs iade bolumu --->
	<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
                <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS")>
					<cfset aa= a.createCell(m)>
                    <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_SATIS,4))>
                    <cfset m = m + 1 > 
                </cfif>
                
            <cfif isdefined('attributes.display_cost')>
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS_MALIYET") >
                        <cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET))>
                        <cfset m = m + 1 >
                    </cfif>
            </cfif>
            
                <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS_IADE") >
                    	<cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_IADE,4))>
                        <cfset m = m + 1 >
                </cfif>
                
            <cfif isdefined('attributes.display_cost')>
                    <cfif isdefined("GET_ALL_STOCK.TOP_SAT_IADE_MALIYET") >
                        <cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOP_SAT_IADE_MALIYET))>
                        <cfset m = m + 1 > 
                    </cfif>
            </cfif>
                		<cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat((GET_ALL_STOCK.TOPLAM_SATIS - GET_ALL_STOCK.TOPLAM_SATIS_IADE),4))>
                        <cfset m = m + 1 >
             <cfif isdefined('attributes.display_cost')>
                    	<cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET - GET_ALL_STOCK.TOP_SAT_IADE_MALIYET))>
                        <cfset m = m + 1 >
            </cfif>
            
            
            <cfif isdefined('attributes.from_invoice_actions')><!--- satıs fatura tutarı --->
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MIKTAR") >
                       	<cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_MIKTAR))>
                        <cfset m = m + 1 >
                    </cfif>	
                    
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_TUTAR") >
                        <cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_TUTAR))>
                        <cfset m = m + 1 >
                    </cfif>	
                
				<cfif isdefined('attributes.is_system_money_2')>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_TUTAR_2")>
							<cfset aa= a.createCell(m)>
                            <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_TUTAR_2))>
                            <cfset m = m + 1 > 
                        </cfif>	
                </cfif>
                <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MALIYET") >
                            <cfset aa= a.createCell(m)>
							<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_MALIYET))>
                            <cfset m = m + 1 > 
                        </cfif>
                    <cfif isdefined('attributes.is_system_money_2')>
                            <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MALIYET_2") >
                                <cfset aa= a.createCell(m)>
								<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_MALIYET_2))>
                            	<cfset m = m + 1 > 
                            </cfif>	
                    </cfif>
                </cfif>
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_MIKTAR") >
						<cfset aa= a.createCell(m)>
                        <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_MIKTAR,4))>
                        <cfset m = m + 1 >
                    </cfif>	
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR")>
                        <cfset aa= a.createCell(m)>
                        <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR))>
                        <cfset m = m + 1 > 
                    </cfif>
                <cfif isdefined('attributes.is_system_money_2')>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR_2") >
                            <cfset aa= a.createCell(m)>
                        	<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR_2))>
                        	<cfset m = m + 1 > 
                        </cfif>
                </cfif>
                <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET") >
                            <cfset aa= a.createCell(m)>
                        	<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET))>
                        	<cfset m = m + 1 > 
                        </cfif>
                    <cfif isdefined('attributes.is_system_money_2')>
                            <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET_2") >
                                <cfset aa= a.createCell(m)>
                        		<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET_2))>
                        		<cfset m = m + 1 > 
                            </cfif>	
                    </cfif>
                </cfif>
            </cfif>
            <cfif isdefined('attributes.display_cost')>
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MIKTAR")>
						<cfset aa= a.createCell(m)>
                        <cfset aa.setCellValue(TLFormat(((GET_ALL_STOCK.FATURA_SATIS_MIKTAR - GET_ALL_STOCK.FATURA_SATIS_IADE_MIKTAR)*GET_ALL_STOCK.ALL_FINISH_COST)/1))>
                        <cfset m = m + 1 >
                    <cfelse>
						<cfset aa= a.createCell(m)>
                        <cfset aa.setCellValue("0")>
                        <cfset m = m + 1 >
                    </cfif>
                <cfif isdefined('attributes.is_system_money_2')>	 				
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2")>
                        <cfset aa= a.createCell(m)>
                        <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2))>
                        <cfset m = m + 1 > 
                    </cfif>
                    <cfif isdefined("GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2") >
                        <cfset aa= a.createCell(m)>
                        <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2))>
                        <cfset m = m + 1 >
                    </cfif>
                        <cfset aa= a.createCell(m)>
                        <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2-GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2))>
                        <cfset m = m + 1 > 
                </cfif>
            </cfif>
    </cfif>
    <!--- Konsinye cikis irs. --->
   	<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
            <cfif isdefined("GET_ALL_STOCK.KONS_CIKIS_MIKTAR") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_CIKIS_MIKTAR,4))>
                <cfset m = m + 1 > 
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.KONS_CIKIS_MALIYET")>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_CIKIS_MALIYET))>
                <cfset m = m + 1 > 	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.KONS_CIKIS_MALIYET_2") >								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_CIKIS_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- konsinye iade gelen --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
            <cfif isdefined("GET_ALL_STOCK.KONS_IADE_MIKTAR")>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_IADE_MIKTAR,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.KONS_IADE_MALIYET")>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_IADE_MALIYET))>
                <cfset m = m + 1 > 	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                    <cfif isdefined("GET_ALL_STOCK.KONS_IADE_MALIYET_2")>								
                        <cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_IADE_MALIYET_2))>
                        <cfset m = m + 1 > 
                    </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- Konsinye Giriş İrs. --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
            <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_MIKTAR")>
				<cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_GIRIS_MIKTAR,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_MALIYET") >								
                <cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_GIRIS_MALIYET))>
                <cfset m = m + 1 > 	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_MALIYET_2") >								
                    <cfset aa= a.createCell(m)>
                	<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_GIRIS_MALIYET_2))>
                	<cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- Konsinye Giriş İade İrs. --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
            <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_IADE_MIKTAR") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_GIRIS_IADE_MIKTAR,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET") >								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET))>
                <cfset m = m + 1 > 	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET_2")>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET_2))>
                    <cfset m = m + 1 >  	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- Teknik Servis Giriş --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
            <cfif isdefined("GET_ALL_STOCK.SERVIS_GIRIS_MIKTAR") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SERVIS_GIRIS_MIKTAR,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SERVIS_GIRIS_MALIYET")>
					<cfset aa= a.createCell(m)>
                    <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SERVIS_GIRIS_MALIYET))>
                    <cfset m = m + 1 > 
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SERVIS_GIRIS_MALIYET_2") >
                    <cfset aa= a.createCell(m)>
                    <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SERVIS_GIRIS_MALIYET_2))>
                    <cfset m = m + 1 > 
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- Teknik Servis Çıkış --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
            <cfif isdefined("GET_ALL_STOCK.SERVIS_CIKIS_MIKTAR")>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SERVIS_CIKIS_MIKTAR,4))>
                <cfset m = m + 1 > 
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SERVIS_CIKIS_MALIYET") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SERVIS_CIKIS_MALIYET))>
                <cfset m = m + 1 >
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SERVIS_CIKIS_MALIYET_2") >
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SERVIS_CIKIS_MALIYET_2))>
                    <cfset m = m + 1 > 
                </cfif>
            </cfif>
        </cfif>
    </cfif>  
    <!--- RMA Giriş --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
            <cfif isdefined("GET_ALL_STOCK.RMA_GIRIS_MIKTAR")>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.RMA_GIRIS_MIKTAR,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.RMA_GIRIS_MALIYET")>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.RMA_GIRIS_MALIYET))>
                <cfset m = m + 1 > 
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                    <cfif isdefined("GET_ALL_STOCK.RMA_GIRIS_MALIYET_2")>
                        <cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.RMA_GIRIS_MALIYET_2))>
                        <cfset m = m+1 > 
                    </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- RMA Çıkış --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
            <cfif isdefined("GET_ALL_STOCK.RMA_CIKIS_MIKTAR")>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.RMA_CIKIS_MIKTAR,4))>
                <cfset m = m + 1 > 
            </cfif>
        <cfif isdefined('attributes.display_cost')>
                <cfif isdefined("GET_ALL_STOCK.RMA_CIKIS_MALIYET")>
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.RMA_CIKIS_MALIYET))>
                    <cfset m = m + 1 > 
                </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                    <cfif isdefined("GET_ALL_STOCK.RMA_CIKIS_MALIYET_2") >
                        <cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.RMA_CIKIS_MALIYET_2))>
                        <cfset m = m + 1 > 
                    </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- uretim fisleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_URETIM") >
            	<cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_URETIM,4))>
                <cfset m = m + 1 > 
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.URETIM_MALIYET")>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.URETIM_MALIYET))>
                <cfset m = m + 1 > 
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.URETIM_MALIYET_2")>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.URETIM_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- sarf ve fire fisleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_SARF") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_SARF,4))>
                <cfset m = m + 1 > 
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_URETIM_SARF") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_URETIM_SARF,4))>
                <cfset m = m + 1 >
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_FIRE") >
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_FIRE,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SARF_MALIYET") >								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SARF_MALIYET))>
                <cfset m = m + 1 > 	
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.URETIM_SARF_MALIYET") >								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.URETIM_SARF_MALIYET))>
                <cfset m = m + 1 > 	
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.FIRE_MALIYET") >								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FIRE_MALIYET))>
                    <cfset m = m + 1 >  	
                </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SARF_MALIYET_2") >								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SARF_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.URETIM_SARF_MALIYET_2") >								
                   	<cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.URETIM_SARF_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.FIRE_MALIYET_2") >								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.FIRE_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- sayim fisleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
		<cfif isdefined("GET_ALL_STOCK.TOPLAM_SAYIM")>
			<cfset aa= a.createCell(m)>
            <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_SAYIM,4))>
            <cfset m = m + 1 >
        </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SAYIM_MALIYET") >								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SAYIM_MALIYET))>
                <cfset m = m + 1 > 	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SAYIM_MALIYET_2") >								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SAYIM_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- demontajdan giris --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
            <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIRIS")>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DEMONTAJ_GIRIS,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET")>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET))>
                <cfset m = m + 1 > 
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET_2")>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- demontaja giden --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
            <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIDEN")>
				<cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DEMONTAJ_GIDEN,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET")>								
                <cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET))>
                <cfset m = m + 1 >
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET_2") >								
                    <cfset aa= a.createCell(m)>
                	<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET_2))>
                	<cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- masraf fişleri--->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_MASRAF_MIKTAR")>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOPLAM_MASRAF_MIKTAR,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.MASRAF_MALIYET")>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.MASRAF_MALIYET))>
                <cfset m = m + 1 >	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.MASRAF_MALIYET_2") >								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.MASRAF_MALIYET_2))>
                	<cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!---depo sevk : giris-cıkıs stok bilgileri ayrı kolonlarda--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
            <cfif isdefined("GET_ALL_STOCK.SEVK_GIRIS_MIKTARI") and len(GET_ALL_STOCK.SEVK_GIRIS_MIKTARI)>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SEVK_GIRIS_MIKTARI,4))>
                <cfset m = m + 1 > 
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.SEVK_CIKIS_MIKTARI") and len(GET_ALL_STOCK.SEVK_CIKIS_MIKTARI)>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SEVK_CIKIS_MIKTARI,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SEVK_GIRIS_MALIYETI") and len(GET_ALL_STOCK.SEVK_GIRIS_MALIYETI)>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SEVK_GIRIS_MALIYETI))>
                <cfset m = m + 1 >
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.SEVK_CIKIS_MALIYETI") and len(GET_ALL_STOCK.SEVK_CIKIS_MALIYETI)>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SEVK_CIKIS_MALIYETI))>
                <cfset m = m + 1 >	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SEVK_GIRIS_MALIYETI_2") and len(GET_ALL_STOCK.SEVK_GIRIS_MALIYETI_2)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SEVK_GIRIS_MALIYETI_2))>
                	<cfset m = m + 1 >	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.SEVK_CIKIS_MALIYETI_2") and len(GET_ALL_STOCK.SEVK_CIKIS_MALIYETI_2)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.SEVK_CIKIS_MALIYETI_2))>
                	<cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!---ithal mal girişi: giris-cıkıs stok bilgileri ayrı kolonlarda--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
            <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_GIRIS_MIKTARI") and len(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MIKTARI)>
				<cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MIKTARI,4))>
                <cfset m = m + 1 >
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_CIKIS_MIKTARI") and len(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MIKTARI)>
                <cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MIKTARI,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI") and len(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI)>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI))>
                <cfset m = m + 1 >	
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI") and len(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI)>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI))>
                <cfset m = m + 1 >	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI_2") and len(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI_2)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI_2))>
                	<cfset m = m + 1 > 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI_2") and len(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI_2)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI_2))>
                	<cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!---ambar fişi--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
            <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_GIRIS_MIKTARI") and len(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MIKTARI)>
					<cfset aa= a.createCell(m)>
                    <cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MIKTARI,4))>
                    <cfset m = m + 1 >
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_CIKIS_MIKTARI") and len(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MIKTARI)>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MIKTARI,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
                <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI") and len(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI))>
                	<cfset m = m + 1 >	
                </cfif>
            <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET") and len(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET)>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET))>
                <cfset m = m + 1 >	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI_2") and len(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI_2)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI_2))>
                    <cfset m = m + 1 > 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET_2)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!---stok virman--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
            <cfif isdefined("GET_ALL_STOCK.stok_virman_GIRIS_MIKTARI") and len(GET_ALL_STOCK.stok_virman_GIRIS_MIKTARI)>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.stok_virman_GIRIS_MIKTARI,4))>
                <cfset m = m + 1 >
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.stok_virman_CIKIS_MIKTARI") and len(GET_ALL_STOCK.stok_virman_CIKIS_MIKTARI)>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.stok_virman_CIKIS_MIKTARI,4))>
                <cfset m = m + 1 >
            </cfif>
        <cfif isdefined('attributes.display_cost')>
                <cfif isdefined("GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI") and len(GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI))>
                    <cfset m = m + 1 >	
                </cfif>
            <cfif isdefined("GET_ALL_STOCK.stok_virman_CIKIS_MALIYET") and len(GET_ALL_STOCK.stok_virman_CIKIS_MALIYET)>								
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.stok_virman_CIKIS_MALIYET))>
                <cfset m = m + 1 >	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI_2") and len(GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI_2)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI_2))>
                    <cfset m = m + 1 > 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.stok_virman_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.stok_virman_CIKIS_MALIYET_2)>								
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.stok_virman_CIKIS_MALIYET_2))>
                    <cfset m = m + 1 > 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
	<cfif isdefined("GET_ALL_STOCK.TOTAL_STOCK")>
            <cfset donem_sonu_stok=GET_ALL_STOCK.TOTAL_STOCK>
            <cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOTAL_STOCK,4))>
            <cfset m = m + 1 >
        <cfelse>
            <cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(TLFormat(0,4))>
            <cfset m = m + 1 >
        </cfif>
    <cfif isdefined('attributes.display_cost')>
        <cfif wrk_round(GET_ALL_STOCK.TOTAL_STOCK) neq 0>
            <cfif (GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST) neq 0>
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif (GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST_2) neq 0>
                </cfif>
            </cfif>
        </cfif>
            <cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST))>
            <cfset m = m + 1 >
        <cfif isdefined('attributes.is_system_money_2')>
                <cfset aa= a.createCell(m)>
				<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST_2))>
            	<cfset m = m + 1 >
        </cfif>
        <cfif isdefined('attributes.display_ds_prod_cost')><!--- birim maliyet --->
                <cfif wrk_round(GET_ALL_STOCK.TOTAL_STOCK) neq 0>
                    <cfset aa= a.createCell(m)>
					<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST/GET_ALL_STOCK.TOTAL_STOCK))>
            		<cfset m = m + 1 >
              	</cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                    <cfif wrk_round(donem_sonu_stok) neq 0>
                    	<cfset aa= a.createCell(m)>
						<cfset aa.setCellValue(TLFormat(GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST_2/GET_ALL_STOCK.TOTAL_STOCK))>
                        <cfset m = m + 1 >
                    </cfif>
            </cfif>
        </cfif>
    </cfif>
    <cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)>
        <cfif len(GET_ALL_STOCK.DIMENTION)>
            <cfif attributes.volume_unit eq 1>
                <cfset prod_volume = evaluate(GET_ALL_STOCK.DIMENTION)>
            <cfelseif attributes.volume_unit eq 2>
                <cfset prod_volume = evaluate(GET_ALL_STOCK.DIMENTION)/ 1000>
            <cfelseif attributes.volume_unit eq 3>
                <cfset prod_volume = evaluate(GET_ALL_STOCK.DIMENTION) / 1000000>
            </cfif>
        </cfif>
            <cfif len(GET_ALL_STOCK.DIMENTION)>
		<cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(prod_volume)>
                <cfset m = m + 1 >
            </cfif>
            <cfif wrk_round(donem_sonu_stok) neq 0 and len(GET_ALL_STOCK.DIMENTION)>
                <cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(prod_volume*wrk_round(GET_ALL_STOCK.TOTAL_STOCK))>
                <cfset m = m + 1 > 
             </cfif>
    </cfif>
    <cfif isdefined('attributes.stock_age')>
        <cfquery name="GET_STOCK_AGE" datasource="#DSN_REPORT#">
        	SELECT * FROM GET_STOCK_AGE
        </cfquery>
		
	<cfset agirlikli_toplam=0>
        <cfif donem_sonu_stok gt 0>
            <cfset kalan=donem_sonu_stok>
            <cfquery name="get_product_detail" dbtype="query">
                SELECT 
                    AMOUNT AS PURCHASE_AMOUNT,
                    GUN_FARKI 
                FROM 
                    GET_STOCK_AGE 
                WHERE 
                    #ALAN_ADI# =<cfif attributes.report_type eq 8>'#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'<cfelse>#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#</cfif>
                ORDER BY ISLEM_TARIHI DESC
            </cfquery>
            <cfloop query="get_product_detail">
                <cfif kalan gt 0 and PURCHASE_AMOUNT lte kalan>
                    <cfset kalan = kalan - PURCHASE_AMOUNT>
                    <cfset agırlıklı_toplam=  agırlıklı_toplam + (PURCHASE_AMOUNT*GUN_FARKI)>
                <cfelseif kalan gt 0 and PURCHASE_AMOUNT gt kalan>
                    <cfset agırlıklı_toplam=  agırlıklı_toplam + (kalan*GUN_FARKI)>
                    <cfbreak>
                </cfif>
            </cfloop>
            <cfset agırlıklı_toplam=agırlıklı_toplam/donem_sonu_stok>
        </cfif>
	     <cfif agırlıklı_toplam gt 0>
                <cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(TLFormat(agırlıklı_toplam))>
                <cfset m = m + 1 > 
            </cfif>
    </cfif>
	</cfoutput>
   
   
<cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_##dir_seperator##file_name_#.xls")/>
<cfset workBook.write(fileOutStream)/>
<cfset fileOutStream.flush()/>
<cfset fileOutStream.close()/>
    
