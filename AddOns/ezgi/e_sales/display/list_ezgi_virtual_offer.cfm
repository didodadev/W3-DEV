<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.offer_stage" default="">
<cfparam name="attributes.sort_type" default="3">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.durum_siparis" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.sales_type" default="">
<CFSET t_net_total1 = 0>
<CFSET t_net_total2 = 0>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_virtual_offers" datasource="#dsn3#">
    	SELECT        
        	O.VIRTUAL_OFFER_ID, 
            O.VIRTUAL_OFFER_NUMBER, 
	    	O.VIRTUAL_OFFER_HEAD, 
            O.VIRTUAL_OFFER_DATE, 
            O.VIRTUAL_OFFER_DETAIL, 
            O.VIRTUAL_OFFER_STATUS, 
            O.VIRTUAL_OFFER_STAGE,
            O.CONSUMER_ID, 
            O.COMPANY_ID, 
            O.PARTNER_ID, 
            O.REF_NO,
            O.RECORD_EMP,
            O.RECORD_PAR,
            O.MEMBER_TYPE,
            O.PARTNER_COMPANY_ID,
            O.SALES_COMPANY_ID,
            O.BRANCH_ID,
            O.REVISION_NO,
            ISNULL(O.NETTOTAL,0) NETTOTAL,
            ISNULL(O.TAXTOTAL,0) TAXTOTAL,
            ISNULL((
            		SELECT  TOP (1)     
                    	OFR.OFFER_ID
					FROM            
                    	EZGI_VIRTUAL_OFFER_ROW AS OFFR INNER JOIN
                    	#dsn3_alias#.OFFER_ROW AS OFR ON OFFR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID
					WHERE        
                    	OFFR.VIRTUAL_OFFER_ID = O.VIRTUAL_OFFER_ID
            
         	),0) AS OFFER_ID
            <cfif attributes.list_type eq 2>
            	, 
                ORR.VIRTUAL_OFFER_ROW_ID, 
                ORR.PRODUCT_TYPE, 
                ORR.PRODUCT_ID, 
                ORR.PRODUCT_NAME, 
                ORR.PRODUCT_NAME2,
                ORR.QUANTITY, 
                ORR.UNIT, 
                ORR.VIRTUAL_OFFER_ROW_CURRENCY, 
                ORR.IS_STANDART,
                ORR.DELIVER_AMOUNT
            </cfif>
		FROM            
        	EZGI_VIRTUAL_OFFER AS O
            <cfif attributes.list_type eq 2>
                ,
                EZGI_VIRTUAL_OFFER_ROW AS ORR 
            </cfif>
      	WHERE
        	VIRTUAL_OFFER_STATUS = 1
            <cfif attributes.list_type eq 2>
            	AND O.VIRTUAL_OFFER_ID = ORR.VIRTUAL_OFFER_ID
                <cfif len(attributes.currency_id)>
                	<cfif isdefined('currency_type')>
                    	AND ORR.VIRTUAL_OFFER_ROW_CURRENCY <> #attributes.currency_id#
                    <cfelse>
                		AND ORR.VIRTUAL_OFFER_ROW_CURRENCY = #attributes.currency_id#
                    </cfif>
                </cfif>
            <cfelse>
            	<cfif len(attributes.currency_id)>
                	<cfif isdefined('currency_type')>
                    	AND O.VIRTUAL_OFFER_ID IN
                        						(
                                					SELECT DISTINCT 
                                                    	VIRTUAL_OFFER_ID
													FROM         
                                                    	EZGI_VIRTUAL_OFFER_ROW
													WHERE        
                                                    	VIRTUAL_OFFER_ROW_CURRENCY <> #attributes.currency_id#
                                				)
                    <cfelse>
                		AND O.VIRTUAL_OFFER_ID IN
                        						(
                                					SELECT DISTINCT 
                                                    	VIRTUAL_OFFER_ID
													FROM         
                                                    	EZGI_VIRTUAL_OFFER_ROW
													WHERE        
                                                    	VIRTUAL_OFFER_ROW_CURRENCY = #attributes.currency_id#
                                				)
                    </cfif>
                </cfif>
            </cfif>
            <cfif len(attributes.member_name)>
            	<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                    AND O.COMPANY_ID =#attributes.company_id#
                </cfif>
                <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                    AND O.CONSUMER_ID =#attributes.consumer_id# 
                </cfif>
           	</cfif>
            <cfif len(attributes.keyword)>
            	AND 
                (
                	O.VIRTUAL_OFFER_NUMBER LIKE '%#attributes.keyword#%' OR
                    O.VIRTUAL_OFFER_DETAIL LIKE '%#attributes.keyword#%' OR
                    O.VIRTUAL_OFFER_HEAD LIKE '%#attributes.keyword#%' 
              	)
            </cfif>
            <cfif len(attributes.record_emp_name) and len(attributes.record_emp_id)>
            	AND O.RECORD_EMP = #attributes.record_emp_id#
            </cfif>
            <cfif attributes.durum_siparis eq 1>
            	AND ISNULL((
            		SELECT TOP (1)        
                    	OFR.OFFER_ID 
					FROM            
                    	EZGI_VIRTUAL_OFFER_ROW AS OFFR INNER JOIN
                    	#dsn3_alias#.OFFER_ROW AS OFR ON OFFR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID
					WHERE        
                    	OFFR.VIRTUAL_OFFER_ID = O.VIRTUAL_OFFER_ID
         			),0) > 0
             <cfelseif attributes.durum_siparis eq 2>   
                AND ISNULL((
            		SELECT  TOP (1)      
                    	OFR.OFFER_ID  
					FROM            
                    	EZGI_VIRTUAL_OFFER_ROW AS OFFR INNER JOIN
                    	#dsn3_alias#.OFFER_ROW AS OFR ON OFFR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID
					WHERE        
                    	OFFR.VIRTUAL_OFFER_ID = O.VIRTUAL_OFFER_ID
         			),0) <= 0
            </cfif>
            <cfif session.ep.ISBRANCHAUTHORIZATION eq 1>
            	AND O.BRANCH_ID IN 
                				(
                                SELECT        
                                	BRANCH_ID
								FROM   
                                	#dsn_alias#.EMPLOYEE_POSITION_BRANCHES
								WHERE        
                                	POSITION_CODE = #session.ep.POSITION_CODE# AND 
                                    DEPARTMENT_ID IS NULL
                                
                                )
            </cfif>
            <cfif len(attributes.branch_id)>
            	AND O.BRANCH_ID = #attributes.branch_id#
            </cfif>
            <cfif len(attributes.offer_stage)>
            	AND VIRTUAL_OFFER_STAGE IN (#attributes.offer_stage#)
            </cfif>
            <cfif attributes.sales_type eq 1>
            	AND SALES_COMPANY_ID IS NOT NULL
           	<cfelseif attributes.sales_type eq 2>
            	AND BRANCH_ID IS NOT NULL
            </cfif>
     	ORDER BY
        	<cfif attributes.sort_type eq 2>
            	O.VIRTUAL_OFFER_NUMBER
            <cfelseif attributes.sort_type eq 3>
            	O.RECORD_DATE DESC
            <cfelseif attributes.sort_type eq 4>
            	O.VIRTUAL_OFFER_DATE
            <cfelseif attributes.sort_type eq 5>
            	O.VIRTUAL_OFFER_DATE desc
            </cfif>
    </cfquery>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_virtual_offers.recordcount = 0>
    <cfset arama_yapilmali = 1>
</cfif>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT        
    	BRANCH_ID, BRANCH_NAME
	FROM            
    	BRANCH
	WHERE        
    	BRANCH_ID IN
                  	(
                    	SELECT        
                        	BRANCH_ID
                    	FROM            
                        	EMPLOYEE_POSITION_BRANCHES
                    	WHERE        
                        	POSITION_CODE = #session.ep.POSITION_CODE# AND 
                            DEPARTMENT_ID IS NULL
                   	)
      	AND COMPANY_ID = #session.ep.company_id# 
        AND BRANCH_STATUS = 1
</cfquery>
<cfoutput query="get_branch">
	<cfset 'BRANCH_NAME_#BRANCH_ID#' = BRANCH_NAME>
</cfoutput>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%virtual_offer%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfoutput query="GET_PROCESS_TYPE">
	<cfset 'STAGE_#PROCESS_ROW_ID#' = STAGE>
</cfoutput>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_virtual_offers.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" method="post" action="#request.self#?fuseaction=prod.list_ezgi_virtual_offer">
<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
   <cf_big_list_search title="Sanal Teklifler" collapsed="1">
		<cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:175px; height:20px" value="#attributes.keyword#" maxlength="500"></td>
                    
                    
                    <td rowspan="2">
                    	<select name="offer_stage" id="offer_stage" style="height:60px" multiple="multiple">
							<option value=""><cf_get_lang_main no='1447.Süreç'></option>
							<cfoutput query="get_process_type">
								<option value="#process_row_id#"<cfif Listfind(attributes.offer_stage, process_row_id)>selected</cfif>>#stage#</option>
							</cfoutput>
						</select>
                    </td>
                    <td><cf_get_lang_main no='487.Kaydeden'></td>
					<td nowrap="nowrap">
						<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
						<input name="record_emp_name" type="text" id="record_emp_name" style="width:175px;" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off">
						<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search.record_emp_id&field_name=search.record_emp_name<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search.record_emp_name.value),'list','popup_list_positions');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
					</td>
                    
                    
                    <td>
                    	<select name="branch_id" id="branch_id" style="width:120px; height:20px">
                        	<option value=""><cf_get_lang_main no='296.Tümü'></option>
                        	<cfoutput query="get_branch">
                        		<option value="#get_branch.branch_id#" <cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#get_branch.branch_name#</option>
                            </cfoutput>
                       	</select>
                    </td>
                    <td id="currency_id_" style="display:<cfif attributes.list_type eq 1>none</cfif>">
                    	<select name="currency_id" id="currency_id" style="width:100px; height:20px">
                        	<option value="" <cfif attributes.currency_id eq ''>selected</cfif>>Tümü</option>
                         	<option value="1" <cfif attributes.currency_id eq 1>selected</cfif>>Açık</option>
                       		<option value="2" <cfif attributes.currency_id eq 2>selected</cfif>>Onaylandı</option>
                        	<option value="3" <cfif attributes.currency_id eq 3>selected</cfif>>İşlendi</option>
                            <option value="4" <cfif attributes.currency_id eq 4>selected</cfif>>Arge Onayı</option>
                      	</select>
                    </td>
                    <td id="currency_type_" style="display:<cfif attributes.list_type eq 1>none</cfif>">
                    	Olmayanlar
                    	<input type="checkbox" name="currency_type" id="currency_type" <cfif isdefined('attributes.currency_type')>checked</cfif>>
                    </td>
                    
					<td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>
				</tr>

				<tr valign="middle">
                	<td>Sıralama</td>
                    <td><select name="sort_type" id="sort_type" style="width:175px; height:20px">
                        <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>>Teklif Nosuna Göre Artan</option>
                        <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>>Teklif Nosuna Göre Azalan</option>
                        <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>>Teklif Tarihine Göre Artan</option>
                        <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>>Teklif Tarihine Göre Azalan</option>
                        </select>
                    </td>
                	<td><cf_get_lang_main no='107.Cari Hesap'></td>
                	<td>
                    	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                   		<input type="hidden" name="company_id"  id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                       	<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                      	<input type="text"   name="member_name" id="member_name" style="width:175px;"  value="<cfoutput>#attributes.member_name#</cfoutput>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','company_id,consumer_id,member_type','','3','250');" autocomplete="off">
                      	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search.consumer_id&field_comp_id=search.company_id&field_member_name=search.member_name&field_type=search.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search.member_name.value),'list');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
                    </td>
                	<td>
                    	<select name="durum_siparis" id="durum_siparis" style="width:120px; height:20px">
                         	<option value="" <cfif attributes.durum_siparis eq "">selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                           	<option value="1" <cfif attributes.durum_siparis eq 1>selected</cfif>>Teklife Dönüşenler</option>
                         	<option value="2" <cfif attributes.durum_siparis eq 2>selected</cfif>>İşlem Görmeyenler</option>
                     	</select>
                    </td>
                    <td>
                    	<select name="list_type" id="list_type" style="width:100px; height:20px">
                        	<option value="1" <cfif attributes.list_type eq 1>selected</cfif>>Belge Bazında</option>
                            <option value="2" <cfif attributes.list_type eq 2>selected</cfif>>Satır Bazında</option>
                       	</select>
                    </td>
                    <td>
                     	<select name="sales_type" id="sales_type" style="width:100px; height:20px">
                        	<option value="" <cfif attributes.sales_type eq "">selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                        	<option value="1" <cfif attributes.sales_type eq 1>selected</cfif>>Bayi Teklif</option>
                            <option value="2" <cfif attributes.sales_type eq 2>selected</cfif>>Şube Teklif</option>
                       	</select> 
                  	</td>
                </tr>
			</table>
		</cf_big_list_search_area>
	</cf_big_list_search>
	
	<cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th style="width:25px"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="width:70px">Teklif No</th>
                <th style="width:70px">Teklif Tarihi</th>
                <th style="width:200px">Müşteri</th>
                <th style="width:100px">Kaydeden</th>
                <th style="width:150px">Bayi / Şube</th>
                <cfif attributes.list_type eq 2>
                    <th style="width:60px">Durum</th>
                    <th style="width:250px">Ürün Kodu</th>
                    <th style="width:50px">Miktar</th>
                    <th style="width:35px">Birim</th>
                </cfif>
                <th nowrap="nowrap">Teklif Başlığı</th>
                <th style="width:100px"><cf_get_lang_main no='1447.Surec'></th>
                <cfif attributes.list_type eq 1>
                	<th style="width:65px; text-align:left">Tutar<br />(KDV Hariç)</th>
                    <th style="width:65px; text-align:left">Tutar<br />(KDV Dahil)</th>
                </cfif>    
                <!-- sil -->
                <th class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=prod.add_ezgi_virtual_offer</cfoutput>"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
                <!-- sil -->
            </tr>
        </thead>
        <tbody>
            <cfif get_virtual_offers.recordcount>
                <cfoutput query="get_virtual_offers" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(RECORD_PAR)>
                    	<cfquery name="get_par_name" datasource="#dsn#">
                        	SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #RECORD_PAR#
                        </cfquery>
                    </cfif>
                    <tr> 
                        <td style="text-align:right;">#CURRENTROW#</td>
                   		<td style="text-align:left;"><a href="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#get_virtual_offers.virtual_offer_id#" class="tableyazi">#VIRTUAL_OFFER_NUMBER#<cfif len(REVISION_NO)> <span style="font-weight:bold; color:red">Rev:#REVISION_NO#</span></cfif></a></td>
                        <td style="text-align:center;">#DateFormat(VIRTUAL_OFFER_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:LEFT;">
                        	<cfif  get_virtual_offers.MEMBER_TYPE eq 'partner'>
                        		#get_par_info(get_virtual_offers.COMPANY_ID,1,1,0)#
                          	<cfelseif get_virtual_offers.MEMBER_TYPE eq 'consumer'>
                            	#get_cons_info(get_virtual_offers.CONSUMER_ID,0,0)#
                            </cfif>
                      	</td>
                        <td nowrap="nowrap"><cfif len(RECORD_EMP)>#get_emp_info(RECORD_EMP,0,0)#<cfelseif len(RECORD_PAR)>#get_par_name.COMPANY_PARTNER_NAME# #get_par_name.COMPANY_PARTNER_SURNAME#</cfif></td>
                        <td nowrap="nowrap">
                        	<cfif len(get_virtual_offers.SALES_COMPANY_ID)>
                            	#get_par_info(get_virtual_offers.SALES_COMPANY_ID,1,1,0)#
                            <cfelse>
                            	<cfif isdefined('BRANCH_NAME_#BRANCH_ID#')>
                                	#Evaluate('BRANCH_NAME_#BRANCH_ID#')#
                                </cfif>
                            </cfif>
                        </td>
                        <cfif attributes.list_type eq 2>
                            <td>
                               	<cfif VIRTUAL_OFFER_ROW_CURRENCY eq 1>Açık</cfif>
                           		<cfif VIRTUAL_OFFER_ROW_CURRENCY eq 2>Onaylandı</cfif>	
                             	<cfif VIRTUAL_OFFER_ROW_CURRENCY eq 3>İşlendi</cfif>	
                              	<cfif VIRTUAL_OFFER_ROW_CURRENCY eq 4>Arge Onayı</cfif>	
                            </td>
                            <td nowrap="nowrap">#Left(PRODUCT_NAME,80)#<cfif len(PRODUCT_NAME) gt 80>...</cfif></td>
                            <td style="text-align:right;">#AmountFormat(QUANTITY)#</td>
                            <td>#UNIT#</td>
                        </cfif>
                        <td title="<cfif attributes.list_type eq 2>#product_name2#<cfelse>#VIRTUAL_OFFER_HEAD#</cfif>">
                        	<cfif attributes.list_type eq 2>
                            	#Left(product_name2,40)#<cfif len(PRODUCT_NAME2) gt 40>...</cfif>
                            <cfelse>
                            	#Left(VIRTUAL_OFFER_HEAD,40)#<cfif len(VIRTUAL_OFFER_HEAD) gt 40>...</cfif>
                            </cfif>
                        </td>
                        <td><cfif isdefined('STAGE_#VIRTUAL_OFFER_STAGE#')>#Evaluate('STAGE_#VIRTUAL_OFFER_STAGE#')#</cfif></td>
                        <cfif attributes.list_type eq 1>
                        	<td style="text-align:right;">#AmountFormat(NETTOTAL-TAXTOTAL)#</td>
                            <td style="text-align:right;">#AmountFormat(NETTOTAL,2)#</td>
                            <CFSET t_net_total1 = t_net_total1 + NETTOTAL-TAXTOTAL>
							<CFSET t_net_total2 = t_net_total2 + NETTOTAL>
                       	</cfif>
                        <!-- sil -->
                        <td style="text-align:center;"><a href="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#get_virtual_offers.virtual_offer_id#"><img src="/images/transfer.gif" title="Detay"></a></td>
                        <!-- sil -->
                    </tr>
                </cfoutput>
                <cfif attributes.list_type eq 1>
                    <tr>
                        <td colspan="8"><strong>Sayfa Toplam</strong></td>
                        <td style="text-align:right;"><strong><cfoutput>#AmountFormat(t_net_total1,2)#</cfoutput></strong></td>
                        <td style="text-align:right;"><strong><cfoutput>#AmountFormat(t_net_total2,2)#</cfoutput></strong></td>
                        <TD ></TD>
                    </tr>
                </cfif>
            <cfelse>
                <tr> 
                    <td colspan="15" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
	</cf_big_list>
</cfform>
<cfset adres = url.fuseaction>
<cfif isdefined("attributes.is_form_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfif len(attributes.member_name)>
      <cfset adres = '#adres#&company_id=#attributes.company_id#'>
      <cfset adres = '#adres#&member_name=#attributes.member_name#'>
    </cfif>		
    <cfif len(attributes.keyword)>
      <cfset adres = '#adres#&keyword=#URLEncodedFormat(attributes.keyword)#'>
    </cfif>
    <cfif len(attributes.sales_type)>
        <cfset adres = '#adres#&sales_type=#attributes.sales_type#'>
    </cfif>
    <cfif len(attributes.sort_type)>
        <cfset adres = '#adres#&sort_type=#attributes.sort_type#'>
    </cfif>
    <cfif len(attributes.list_type)>
        <cfset adres = '#adres#&list_type=#attributes.list_type#'>
    </cfif>
    <cfif len(attributes.durum_siparis)>
        <cfset adres = '#adres#&durum_siparis=#attributes.durum_siparis#'>
    </cfif>
    <cfif len(attributes.offer_stage)>
        <cfset adres = '#adres#&offer_stage=#attributes.offer_stage#'>
    </cfif>
    <cfif len(attributes.record_emp_name)>
        <cfset adres = '#adres#&record_emp_name=#attributes.record_emp_name#'>
        <cfset adres = '#adres#&record_emp_id=#attributes.record_emp_id#'>
    </cfif>
    <cfif len(attributes.currency_id)>
        <cfset adres = '#adres#&currency_id=#attributes.currency_id#'>
    </cfif>
    <cfif isdefined('attributes.currency_type')>
        <cfset adres = '#adres#&currency_type=#attributes.currency_type#'>
    </cfif>
    <cf_paging 
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#&is_form_submitted=1">
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
