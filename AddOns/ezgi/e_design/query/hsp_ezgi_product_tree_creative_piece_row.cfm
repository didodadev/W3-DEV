<cfset stock_id_list = ''>
<cfif get_max_id.max_id gt 0>
    <cfloop from="1" to="4" index="i">
        <cfif isdefined('attributes.PVC_MATERIALS_#i#') and Evaluate('attributes.PVC_MATERIALS_#i#') gt 0>
            <cfset stock_id_list = ListAppend(stock_id_list,Evaluate('attributes.PVC_MATERIALS_#i#'))>
        </cfif>
    </cfloop>
    <cfif Listlen(stock_id_list)>
        <cfset stock_id_list = ListDeleteDuplicates(stock_id_list,',')>
        <cfquery name="get_kalinlik_etkisi" datasource="#dsn3#">
            SELECT        
                STOCK_ID, 
                KALINLIK_ETKISI_NAME AS KALINLIK_ETKISI
            FROM            
                EZGI_DESIGN_PRODUCT_PROPERTIES_UST
            GROUP BY 
                STOCK_ID, 
                KALINLIK_ETKISI_NAME
            HAVING        
                STOCK_ID IN (#stock_id_list#)
        </cfquery>
        <cfoutput query="get_kalinlik_etkisi">
            <cfset 'KALINLIK_ETKISI_#STOCK_ID#' = KALINLIK_ETKISI>
        </cfoutput>
    </cfif>
    <cfif attributes.PIECE_TYPE eq 1 or attributes.PIECE_TYPE eq 3><!---01-Yonga Levha Reçete İşlemi - 03-Montaj İşlemi--->
    	<cfset boy = filternum(attributes.PIECE_BOY)/1000>
 		<cfset en= filternum(attributes.PIECE_EN)/1000>
    	<cfif attributes.trim_type eq 1>
        	<cfset trim_miktar = FilterNum(attributes.trim_rate,1)>
       	<cfelse>
        	<cfset trim_miktar = 0>
        </cfif>
        <cfset total_boy_trim_amount = 0>
        <cfset total_en_trim_amount = 0>
       	<cfif isdefined('attributes.anahtar_1') and attributes.anahtar_1 eq 1>
            <cfif attributes.trim_type eq 0> <!---Traşlama Yok--->
				<cfif isdefined('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_1#')>
                    <cfset total_boy_trim_amount = total_boy_trim_amount - Evaluate('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_1#')>
                </cfif>
          	<cfelse>
            	<cfif isdefined('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_1#')>
                    <cfset total_boy_trim_amount = total_boy_trim_amount - Evaluate('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_1#')>
                </cfif>
            	<cfset total_boy_trim_amount = total_boy_trim_amount + trim_miktar>
           	</cfif>
        	<cfset attributes.stock_id = attributes.PVC_MATERIALS_1>
			<cfset attributes.miktar = (filternum(attributes.PIECE_BOY)+attributes.pvc_fire_amount)/1000>
         	<cfset attributes.sira_no = 1>
            <cfset attributes.row_row_type = 1> <!---PVC--->
         	<cfinclude template="add_ezgi_product_tree_creative_piece_row_row.cfm">
     	</cfif>
        <cfif isdefined('attributes.anahtar_2') and attributes.anahtar_2 eq 1>
            <cfif attributes.trim_type eq 0> <!---Traşlama Yok--->
				<cfif isdefined('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_2#')>
                    <cfset total_boy_trim_amount = total_boy_trim_amount - Evaluate('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_2#')>
                </cfif>
           	<cfelse>
            	<cfif isdefined('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_2#')>
                    <cfset total_boy_trim_amount = total_boy_trim_amount - Evaluate('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_2#')>
                </cfif>
            	<cfset total_boy_trim_amount = total_boy_trim_amount + trim_miktar>
            </cfif>
        	<cfset attributes.stock_id = attributes.PVC_MATERIALS_2>
			<cfset attributes.miktar = (filternum(attributes.PIECE_BOY)+attributes.pvc_fire_amount)/1000>
         	<cfset attributes.sira_no = 2>
            <cfset attributes.row_row_type = 1> <!---PVC--->
         	<cfinclude template="add_ezgi_product_tree_creative_piece_row_row.cfm">
     	</cfif>
        <cfif isdefined('attributes.anahtar_3') and attributes.anahtar_3 eq 1>
             <cfif attributes.trim_type eq 0> <!---Traşlama Yok--->
				<cfif isdefined('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_3#')>
                    <cfset total_en_trim_amount = total_en_trim_amount - Evaluate('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_3#')>
                </cfif>
           	<cfelse>
            	<cfif isdefined('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_3#')>
                    <cfset total_en_trim_amount = total_en_trim_amount - Evaluate('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_3#')>
                </cfif>
            	<cfset total_en_trim_amount = total_en_trim_amount + trim_miktar>
            </cfif>
        	<cfset attributes.stock_id = attributes.PVC_MATERIALS_3>
			<cfset attributes.miktar = (filternum(attributes.PIECE_EN)+attributes.pvc_fire_amount)/1000>
         	<cfset attributes.sira_no = 3>
            <cfset attributes.row_row_type = 1> <!---PVC--->
         	<cfinclude template="add_ezgi_product_tree_creative_piece_row_row.cfm">
     	</cfif>
        <cfif isdefined('attributes.anahtar_4') and attributes.anahtar_4 eq 1>
        	<cfif attributes.trim_type eq 0> <!---Traşlama Yok--->
				<cfif isdefined('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_4#')>
                    <cfset total_en_trim_amount = total_en_trim_amount - Evaluate('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_4#')>
                </cfif>
           	<cfelse>
            	<cfif isdefined('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_4#')>
                    <cfset total_en_trim_amount = total_en_trim_amount - Evaluate('KALINLIK_ETKISI_#attributes.PVC_MATERIALS_4#')>
                </cfif>
            	<cfset total_en_trim_amount = total_en_trim_amount + trim_miktar>
            </cfif>
        	<cfset attributes.stock_id = attributes.PVC_MATERIALS_4>
			<cfset attributes.miktar = (filternum(attributes.PIECE_EN)+attributes.pvc_fire_amount)/1000>
         	<cfset attributes.sira_no = 4>
            <cfset attributes.row_row_type = 1> <!---PVC--->
         	<cfinclude template="add_ezgi_product_tree_creative_piece_row_row.cfm">
     	</cfif>
        <cfif attributes.PIECE_TYPE eq 1> <!---Sadece Yonga Levha İçin--->
			<cfset alan = (boy+(total_en_trim_amount/1000))*(en+(total_boy_trim_amount/1000))>
            <cfset alan = alan+(alan*attributes.yonga_levha_fire_rate/100)>
			<cfset attributes.stock_id = attributes.PIECE_YONGA_LEVHA>
            <cfset attributes.miktar = alan>
            <cfset attributes.sira_no = 0>
            <cfset attributes.row_row_type = 0> <!---Yonga Levha--->
            <cfinclude template="add_ezgi_product_tree_creative_piece_row_row.cfm">
            <cfif attributes.trim_type eq 1 or attributes.trim_type eq 0>
                <cfquery name="upd_kesim" datasource="#dsn3#"><!---Sabit Traşlama--->
                    UPDATE       
                        EZGI_DESIGN_PIECE_ROWS
                    SET                
                        KESIM_ENI = #(en+(total_boy_trim_amount/1000))*1000#, 
                        KESIM_BOYU = #(boy+(total_en_trim_amount/1000))*1000#
                    WHERE        
                        PIECE_ROW_ID = #get_max_id.max_id#
                </cfquery>
            </cfif>
   		</cfif>
  	</cfif>
    <cfif attributes.PIECE_TYPE eq 3> <!---03-Reçetedeki Ürünün Montajı--->
		<cfif record_num_yrm gt 0>
            <cfloop from="1" to="#record_num_yrm#" index="yrm">
            	<cfif Evaluate('attributes.row_kontrol_yrm#yrm#') eq 1>
					<cfset attributes.stock_id = Evaluate('attributes.piece_yari_mamul#yrm#')>
                    <cfset attributes.miktar = FilterNum(Evaluate('attributes.quantity_yrm#yrm#'),4)>
                    <cfset attributes.sira_no = yrm>
                    <cfset attributes.row_row_type = 4> <!---Montaj Edilecek Ürünler--->
                    <cfif isdefined('ortak_update') and ortak_update eq 1><!--- Ortak Parça Güncelleme İşleminden Geldiyse Alt Parçaları Eklemesin--->
                    
                    <cfelse>
                    	<cfinclude template="add_ezgi_product_tree_creative_piece_row_row.cfm">
                    </cfif>
                </cfif>
            </cfloop>
        </cfif>
    </cfif>
    <cfif attributes.PIECE_TYPE eq 1 or attributes.PIECE_TYPE eq 2 or attributes.PIECE_TYPE eq 3> <!---Aksesuar ve Hizmet Kayıtları--->
    	<cfif record_num gt 0>
            <cfloop from="1" to="#record_num#" index="aks">
            	<cfif Evaluate('attributes.row_kontrol#aks#') eq 1>
					<cfset attributes.stock_id = Evaluate('attributes.stock_id#aks#')>
                    <cfset attributes.miktar = FilterNum(Evaluate('attributes.quantity#aks#'),4)>
                    <cfset attributes.sira_no = aks>
                    <cfset attributes.row_row_type = 2> <!---Aksesuarlar--->
                    <cfinclude template="add_ezgi_product_tree_creative_piece_row_row.cfm">
                </cfif>
            </cfloop>
        </cfif>
        <cfif record_num_hzm gt 0>
            <cfloop from="1" to="#record_num_hzm#" index="hzm">
            	<cfif Evaluate('attributes.row_kontrol_hzm#hzm#') eq 1>
					<cfset attributes.stock_id = Evaluate('attributes.stock_id_hzm#hzm#')>
                    <cfset attributes.miktar = FilterNum(Evaluate('attributes.quantity_hzm#hzm#'),4)>
                    <cfset attributes.sira_no = hzm>
                    <cfset attributes.row_row_type = 3> <!---Hizmetler--->
                    <cfinclude template="add_ezgi_product_tree_creative_piece_row_row.cfm">
                </cfif>
            </cfloop>
        </cfif>
    </cfif>
</cfif>