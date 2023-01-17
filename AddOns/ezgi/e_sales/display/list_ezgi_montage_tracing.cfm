<script src="JS/Chart.min.js"></script>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.service_stage" default="">
<cfparam name="attributes.montage_stock_ids" default="">
<cfparam name="attributes.sort_type" default="3">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.durum_sevice" default="">
<cfparam name="attributes.durum_montaj" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.task_emp_id" default="">
<cfparam name="attributes.task_partner_id" default="">
<cfparam name="attributes.task_company_id" default="">
<cfparam name="attributes.task_person_name" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.sales_type" default="">
<cfparam name="attributes.status" default="1">
<CFSET t_amount = 0>

<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_period_id" datasource="#dsn#">
    	SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR <> #session.ep.period_year#
    </cfquery>
	<cfquery name="get_montage_tracing_detail" datasource="#dsn3#">
        SELECT DISTINCT  
        	CASE
         		WHEN SV.SERVICE_COMPANY_ID IS NOT NULL THEN
                   (
                    SELECT     
                      	NICKNAME
					FROM         
                    	#dsn_alias#.COMPANY
					WHERE     
                   		COMPANY_ID = SV.SERVICE_COMPANY_ID
                  	)
          		WHEN SERVICE_CONSUMER_ID IS NOT NULL THEN      
                   	(	
                  	SELECT     
                     	CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
					FROM         
                      	#dsn_alias#.CONSUMER
					WHERE     
                		CONSUMER_ID = SERVICE_CONSUMER_ID
               		)
                   	
          	END AS UNVAN ,
        	EMT.MONTAGE_TRACING_NUMBER, 
            EMT.MONTAGE_TRACING_DETAIL, 
            EMT.MONTAGE_TRACING_ID, 
            EMT.MONTAGE_TRACING_STATUS,
            EMTR.EZGI_ID,
            SV.SERVICE_EMPLOYEE_ID, 
            SV.APPLY_DATE, 
            SV.OTHER_COMPANY_ID, 
            SV.SERVICE_PRODUCT_ID, 
            SV.SERVICE_BRANCH_ID, 
            SV.START_DATE, 
        	SV.FINISH_DATE, 
            SV.SERVICE_COMPANY_ID, 
            SV.SERVICE_CONSUMER_ID, 
            SV.SERVICE_PARTNER_ID, 
            SV.RELATED_COMPANY_ID, 
            SV.PROJECT_ID, 
            SVO.STOCK_ID,
            SVO.PRODUCT_NAME, 
            SVO.PRODUCT_ID, 
            SVO.AMOUNT, 
            SVO.UNIT, 
            SVO.PRICE, 
            SVO.TOTAL_PRICE, 
        	SVO.SPARE_PART_ID, 
            SVO.PREDICTED_AMOUNT,
            EOR.VIRTUAL_OFFER_NUMBER, 
            EOR.QUANTITY,
            EOR.IS_STAGE,
            EOR.LOT_NO,
            EOR.REVISION_NO,
            EOR.VIRTUAL_OFFER_NUMBER,
            EOR.VIRTUAL_OFFER_ID,
            EOR.NAME_PRODUCT,
            EOR.PRODUCT_NAME2,
            SV.SERVICE_SUBSTATUS_ID, 
            SV.SERVICE_STATUS_ID,
            SV.SERVICE_ID,
            SV.SERVICE_NO,
            ISNULL((
            		SELECT
                    	SUM(AMOUNT) AMOUNT
                  	FROM
                    	(
                        SELECT 
                            AMOUNT 
                        FROM 
                            #dsn2#.SHIP_ROW
                        WHERE     
                            WRK_ROW_RELATION_ID = EMTR.WRK_ROW_RELATION_ID
                        <cfif get_period_id.recordcount>
                            <cfloop query="get_period_id">
                                UNION ALL
                                SELECT        
                                    AMOUNT
                                FROM            
                                    #dsn#_#get_period_id.PERIOD_YEAR#_#get_period_id.OUR_COMPANY_ID#.SHIP_ROW
                                WHERE     
                                    WRK_ROW_RELATION_ID = EMTR.WRK_ROW_RELATION_ID
                            </cfloop>
                        </cfif>
                  		) AS TBL      
       		),0) AS SHIP_AMOUNT,
            YEAR(SV.START_DATE) YIL,
            MONTH(SV.START_DATE) AY
		FROM   
     		EZGI_MONTAGE_TRACING_ROW AS EMTR INNER JOIN
          	EZGI_MONTAGE_TRACING AS EMT ON EMTR.MONTAGE_TRACING_ID = EMT.MONTAGE_TRACING_ID INNER JOIN
         	SERVICE AS SV ON EMTR.SERVICE_ID = SV.SERVICE_ID INNER JOIN
          	EZGI_ORGE_RELATIONS AS EOR ON EMTR.EZGI_ID = EOR.EZGI_ID LEFT OUTER JOIN
      		SERVICE_OPERATION AS SVO ON SV.SERVICE_ID = SVO.SERVICE_ID     
		WHERE     
        	1=1
            <cfif len(attributes.keyword)>
            	AND 
                (
                	SV.SERVICE_NO LIKE '%#attributes.keyword#%' OR
                    EOR.VIRTUAL_OFFER_NUMBER LIKE '%#attributes.keyword#%' OR
                    EMT.MONTAGE_TRACING_NUMBER LIKE '%#attributes.keyword#%' 
              	)
            </cfif>
            <cfif len(attributes.task_person_name) and len(attributes.task_company_id)>
            	AND SV.RELATED_COMPANY_ID = #attributes.task_company_id#
           	<cfelseif len(attributes.task_person_name) and len(attributes.task_emp_id)>
            	AND SV.SERVICE_EMPLOYEE_ID = #attributes.task_emp_id#
            </cfif>
            <cfif session.ep.ISBRANCHAUTHORIZATION eq 1>
            	AND SV.SERVICE_BRANCH_ID IN 
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
      	ORDER BY
        	SV.APPLY_DATE DESC
    </cfquery>
    <cfquery name="get_montage_tracing" dbtype="query">
    	SELECT
        	*
       	FROM
        	get_montage_tracing_detail
        WHERE
        	1=1
            <cfif len(attributes.member_name)>
            	<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                    AND SERVICE_COMPANY_ID =#attributes.company_id#
                </cfif>
                <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                    AND SERVICE_CONSUMER_ID =#attributes.consumer_id# 
                </cfif>
           	</cfif>
            <cfif attributes.durum_sevice eq 1>
				AND AMOUNT-SHIP_AMOUNT <= 0
           	<cfelseif attributes.durum_sevice eq 0>
            	AND AMOUNT-SHIP_AMOUNT > 0
            </cfif>
             <cfif len(attributes.status)>
            	AND MONTAGE_TRACING_STATUS =  #attributes.status#
            </cfif>
            <cfif len(attributes.service_stage)>
            	AND SERVICE_STATUS_ID IN (#attributes.service_stage#)
            </cfif>
            <cfif len(attributes.branch_id)>
            	AND SERVICE_BRANCH_ID = #attributes.branch_id#
            </cfif>
            <cfif len(attributes.montage_stock_ids)>
            	AND STOCK_ID IN (#attributes.montage_stock_ids#)
            </cfif>
       	ORDER BY
        	<cfif attributes.sort_type eq 2>
            	MONTAGE_TRACING_NUMBER
            <cfelseif attributes.sort_type eq 3>
            	MONTAGE_TRACING_NUMBER DESC
            <cfelseif attributes.sort_type eq 4>
            	APPLY_DATE
            <cfelseif attributes.sort_type eq 5>
            	APPLY_DATE desc
            </cfif>
    </cfquery>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_montage_tracing.recordcount = 0>
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
    	BRANCH_ID, 
        BRANCH_NAME
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

<cfquery name="MONTAGE_DEFAULTS" datasource="#DSN3#">
	SELECT     
    	E.STOCK_ID MONTAGE_STOCK_ID, 
        E.SORT_NO, 
        S.PRODUCT_NAME MONTAGE_PRODUCT_NAME,
        E.IS_ACTIVE
	FROM        
    	EZGI_VIRTUAL_OFFER_COST_DEFAULT AS E INNER JOIN
      	STOCKS AS S ON E.STOCK_ID = S.STOCK_ID
	ORDER BY 
    	E.SORT_NO
</cfquery>
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%add_ezgi_montage_service%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfoutput query="GET_PROCESS_TYPE">
	<cfset 'STAGE_#PROCESS_ROW_ID#' = STAGE>
</cfoutput>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_montage_tracing.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=prod.list_ezgi_montage_tracing">
<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
   <cf_big_list_search title="Montaj Listesi" collapsed="1">
		<cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:175px; height:20px" value="#attributes.keyword#" maxlength="500"></td>
                    <td nowrap>Montaj Görevlisi</td>
					<td nowrap="nowrap">
                    	<input type="hidden" name="task_emp_id" id="task_emp_id" value="<cfoutput>#attributes.task_emp_id#</cfoutput>">
                     	<input type="hidden" name="task_company_id" id="task_company_id" value="<cfoutput>#attributes.task_company_id#</cfoutput>">
                    	<input type="hidden" name="task_partner_id" id="task_partner_id" value="<cfoutput>#attributes.task_partner_id#</cfoutput>">
                    	<cfinput type="text" name="task_person_name" id="task_person_name" value="#attributes.task_person_name#" style="width:200px;  vertical-align:top" onFocus="AutoComplete_Create('task_person_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,COMPANY_ID,PARTNER_ID','task_emp_id,task_company_id,task_partner_id','','3','250','return_company()');" >
                      	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_comp_id=search_form.task_company_id&field_partner=search_form.task_partner_id&field_name=search_form.task_person_name&field_emp_id=search_form.task_emp_id&select_list=1,2</cfoutput>&keyword='+encodeURIComponent(document.search_form.task_person_name.value),'list');">
                        	<img src="/images/plus_thin.gif" border="0">
                      	</a>
					</td>
                    <td rowspan="2">
                    	<select name="service_stage" id="service_stage" style="height:60px" multiple="multiple">
							<option value=""><cf_get_lang_main no='1447.Süreç'></option>
							<cfoutput query="get_process_type">
								<option value="#process_row_id#"<cfif Listfind(attributes.service_stage, process_row_id)>selected</cfif>>#stage#</option>
							</cfoutput>
						</select>
                    </td>
                    <td rowspan="2">
                    	<select name="montage_stock_ids" id="montage_stock_ids" style="height:60px;width:200px" multiple="multiple">
							<cfoutput query="MONTAGE_DEFAULTS">
								<option value="#montage_stock_id#"<cfif Listfind(attributes.montage_stock_ids, montage_stock_id)>selected</cfif>>#MONTAGE_PRODUCT_NAME#</option>
							</cfoutput>
						</select>
                    </td>
                    <td>
                    	<select name="branch_id" id="branch_id" style="width:180px; height:20px">
                        	<option value=""><cf_get_lang_main no='41.Şube'></option>
                        	<cfoutput query="get_branch">
                        		<option value="#get_branch.branch_id#" <cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#get_branch.branch_name#</option>
                            </cfoutput>
                       	</select>
                    </td>
                    <td>
                    	<select name="durum_sevice" id="durum_sevice" style="width:180px; height:20px">
                         	<option value="" <cfif attributes.durum_sevice eq "">selected</cfif>>İrsaliye Durumu</option>
                           	<option value="0" <cfif attributes.durum_sevice eq 0>selected</cfif>>Kesilecekler</option>
                         	<option value="1" <cfif attributes.durum_sevice eq 1>selected</cfif>>Kesilenler</option>
                     	</select>
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
                        <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>>Takip Nosuna Göre Artan</option>
                        <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>>Takip Nosuna Göre Azalan</option>
                        <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>>Takip Tarihine Göre Artan</option>
                        <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>>Takip Tarihine Göre Azalan</option>
                        </select>
                    </td>
                	<td>Müşteri</td>
                	<td>
                    	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                   		<input type="hidden" name="company_id"  id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                       	<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                      	<input type="text"   name="member_name" id="member_name" style="width:200px;"  value="<cfoutput>#attributes.member_name#</cfoutput>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','company_id,consumer_id,member_type','','3','250');" autocomplete="off">
                      	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search_form.consumer_id&field_comp_id=search_form.company_id&field_member_name=search_form.member_name&field_type=search_form.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search_form.member_name.value),'list');"><img src="/images/plus_thin.gif" align="top" border="0"></a>
                    </td>
                	<td>
                    	<select name="durum_montaj" id="durum_montaj" style="width:180px; height:20px">
                         	<option value="" <cfif attributes.durum_montaj eq "">selected</cfif>>Hizmet Alımı</option>
                           	<option value="1" <cfif attributes.durum_montaj eq 1>selected</cfif>>Çalışanlar</option>
                         	<option value="2" <cfif attributes.durum_montaj eq 2>selected</cfif>>Kurumsal Üyeler</option>
                     	</select>
                    </td>
                    <td>
                    	<select name="status" id="status" style="width:180px; height:20px">
                         	<option value="" <cfif attributes.STATUS eq "">selected</cfif>>Durum</option>
                           	<option value="1" <cfif attributes.STATUS eq 1>selected</cfif>>Aktif</option>
                         	<option value="0" <cfif attributes.STATUS eq 0>selected</cfif>>Pasif</option>
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
                <th style="width:50px">Servis No</th>
                <th style="width:50px">Tarih</th>
                <th style="width:100px">Süreç</th>
                <th style="width:150px">Müşteri</th>
                <th style="width:90px">Görevli</th>
              	<th style="width:200px">Ürün Cinsi</th>
              	<th style="width:60px">Miktar</th>
                <th >Açıklama</th>
                <th style="width:60px">Lot No</th>
  				<th style="width:120px">Hizmet Cinsi</th>
                <th style="width:40px">Montaj<br>Miktarı</th>
                <th style="width:30px">Birim</th>
                <th style="width:40px">Kesilen<br>Miktar</th>
                <th style="width:40px">Kalan<br>Miktar</th>
                <cfif len(attributes.task_person_name) and len(attributes.task_company_id)>
                <!-- sil -->
                <th class="header_icn_none" style="text-align:center">
                	<input type="checkbox" name="all_conv_product" id="all_conv_product" onClick="javascript: wrk_select_all2('all_conv_product','_select_product_',<cfoutput>#get_montage_tracing.recordcount#</cfoutput>);">
                </th>
                <!-- sil -->
                </cfif>
            </tr>
        </thead>
        <tbody>
        	
            <cfif get_montage_tracing.recordcount>
                <cfoutput query="get_montage_tracing" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr> 
                        <td style="text-align:right;">#CURRENTROW#</td>
                   		<td style="text-align:left;"><a href="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#get_montage_tracing.virtual_offer_id#" class="tableyazi">#VIRTUAL_OFFER_NUMBER#<cfif len(REVISION_NO)> <span style="font-weight:bold; color:red">Rev:#REVISION_NO#</span></cfif></a></td>
                        <td style="text-align:left;"><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#SERVICE_ID#&service_no=#SERVICE_NO#" class="tableyazi">#SERVICE_NO#</a></td>
                        <td style="text-align:center;">#DateFormat(APPLY_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:center;">
                        	<cfif isdefined('STAGE_#SERVICE_STATUS_ID#')>
                            	#Evaluate('STAGE_#SERVICE_STATUS_ID#')#
                            </cfif>
                        </td>
                        <td style="text-align:LEFT;">#UNVAN#</td>
                        <td nowrap="nowrap">
                        	<cfif len(get_montage_tracing.RELATED_COMPANY_ID)>
                            	#get_par_info(get_montage_tracing.RELATED_COMPANY_ID,1,1,0)#
                           	<cfelseif len(get_montage_tracing.SERVICE_EMPLOYEE_ID)>
                            	#get_emp_info(get_montage_tracing.SERVICE_EMPLOYEE_ID,0,0)#
                            </cfif>
                        </td>
                     	<td nowrap="nowrap">#Left(NAME_PRODUCT,80)#<cfif len(NAME_PRODUCT) gt 80>...</cfif></td>
                       	<td style="text-align:right;">#AmountFormat(PREDICTED_AMOUNT)# / #AmountFormat(QUANTITY)#</td>
                        <td title="#PRODUCT_NAME2#">
                         	#Left(product_name2,40)#<cfif len(PRODUCT_NAME2) gt 40>...</cfif>
                        </td>
                        
                        <td style="text-align:center; font-weight:bold; color:<cfif IS_STAGE eq 2>red<cfelseif IS_STAGE eq 1>green<cfelse>orange</cfif>">
                        	#LOT_NO#
                        </td>
                        <td nowrap="nowrap">#Left(PRODUCT_NAME,50)#<cfif len(PRODUCT_NAME) gt 50>...</cfif></td>
						<td style="text-align:right;">#AmountFormat(AMOUNT,2)#</td>
                        <td>#UNIT#</td>
                        <cfset kalan = AMOUNT-SHIP_AMOUNT>
                        <cfif kalan lt 0>
                        	<cfset kalan = 0>
                        </cfif>
                        <td style="text-align:right;">#AmountFormat(SHIP_AMOUNT,2)#</td>
                        <td style="text-align:right;">
                        	<input name="montage_amount_#EZGI_ID#_#STOCK_ID#" id="montage_amount_#EZGI_ID#_#STOCK_ID#" value="#AmountFormat(kalan,2)#" class="box" style="width:50px">
                        </td>

                       	<CFSET t_amount = t_amount + (AMOUNT)>
                        <cfif len(attributes.task_person_name) and len(attributes.task_company_id)>
                        <!-- sil -->
                        <td style="text-align:center;">
                        	<input type="checkbox" name="select_product_#EZGI_ID#_#STOCK_ID#" value="#stock_id#" id="_select_product_#currentrow#">
                        </td>
                        <!-- sil -->
                        </cfif>
                    </tr>
                </cfoutput>
            	<tr>
                	<td></td>
                	<td colspan="9" style="vertical-align:top"></td>
                	<td colspan="2"><strong>Toplam</strong></td>
                 	<td style="text-align:right;"><strong><cfoutput>#AmountFormat(t_amount,2)#</cfoutput></strong></td>
                    <cfif len(attributes.task_person_name) and len(attributes.task_company_id)>
                        <td></td>
                        <TD colspan="3" style="text-align:right; padding-right:2px">
                            <input type="button" value="<cfoutput>#getLang('stock',145)#</cfoutput>" name="irsaliye" id="irsaliye" onClick="irsaliye_kontrol(1);" style="width:100%;">
                        </TD>
                    <cfelse>
                    	<td colspan="3"></td>
                    </cfif>
           		</tr>
                <cfif not len(attributes.keyword) and session.ep.ISBRANCHAUTHORIZATION neq 1 and len(attributes.task_person_name) and (len(attributes.task_company_id) or len(attributes.task_emp_id))>
                	<cfquery name="get_montage_tracing_graph" dbtype="query">
                        SELECT
                            SUM(AMOUNT) AS AMOUNT,
                            SUM(SHIP_AMOUNT) AS SHIP_AMOUNT,
                            YIL,
                            AY
                        FROM
                            get_montage_tracing_detail
                        WHERE
                        	YIL = #session.ep.period_year#
                       	GROUP BY
                        	YIL,
                            AY
                       	ORDER BY
                            YIL,
                            AY
                  	</cfquery>
                    <cfquery name="get_montage_tracing_pie" dbtype="query">
                        SELECT
                            SUM(AMOUNT-SHIP_AMOUNT) AS AMOUNT,
                            'Kalan' AS WORKS
                        FROM
                            get_montage_tracing_detail
                        WHERE
                        	YIL = #session.ep.period_year#
                     	UNION ALL
                        SELECT
                            SUM(SHIP_AMOUNT) AS AMOUNT,
                            'Tamamlanan' AS WORKS
                        FROM
                            get_montage_tracing_detail
                        WHERE
                        	YIL = #session.ep.period_year#
                  	</cfquery>
                    <cfif get_montage_tracing_graph.recordcount>
                    	<cfoutput query="get_montage_tracing_graph">
                        	<cfif AY eq 1>
                            	<cfset renk = 'lavender'>
                                <cfset ayisim= 'Ocak'>
                            <cfelseif AY eq 2>
                            	<cfset renk = 'thistle'>
                                <cfset ayisim = 'Şubat'>
                            <cfelseif AY eq 3>
                            	<cfset renk = 'plum'>
                                <cfset ayisim = 'Mart'>
                            <cfelseif AY eq 4>
                            	<cfset renk = 'violet'>
                                <cfset ayisim = 'Nisan'>
                            <cfelseif AY eq 5>
                            	<cfset renk = 'orchid'>
                                <cfset ayisim = 'Mayıs'>
                            <cfelseif AY eq 6>
                            	<cfset renk = 'fuchsia'>
                                <cfset ayisim = 'Haziran'>
                            <cfelseif AY eq 7>
                            	<cfset renk = 'magenta'>
                                <cfset ayisim = 'Temmuz'>
                            <cfelseif AY eq 8>
                            	<cfset renk = 'mediumorchid'>
                                <cfset ayisim = 'Ağustos'>
                            <cfelseif AY eq 9>
                            	<cfset renk = 'mediumpurple'>
                                <cfset ayisim = 'Eylül'>
                            <cfelseif AY eq 10>
                            	<cfset renk = 'blueviolet'>
                                <cfset ayisim = 'Ekim'>
                            <cfelseif AY eq 11>
                            	<cfset renk = 'darkviolet'>
                                <cfset ayisim = 'Kasım'>
                            <cfelseif AY eq 12>
                            	<cfset renk = 'darkorchid'>
                                <cfset ayisim = 'Aralık'>
                            </cfif>
                            <cfset 'item_#currentrow#' = "#ayisim#">
                        	<cfset 'value_#currentrow#' = "#Round(AMOUNT)#">
                    	</cfoutput>
                        <tr> 
                            <td style="text-align:center; height:120px" colspan="17">
                                <table style="width:100%; height:100%" cellpadding="0" cellspacing="1" border="1">
                                    <tr>
                                        <td style="width:50%; height:100%" >
                                            <div id="virt_offr_branch_summary" style="border:solid 1px #c3c3c3;padding:0.5%;margin-bottom:0.5%;">
                                                <canvas id="myChart1" style="height:100%;"></canvas>
												<script>
                                                    var ctx = document.getElementById('myChart1');
                                                    var myChart1 = new Chart(ctx, {
                                                        type: 'line',
                                                        data: {
                                                                labels: [<cfloop from="1" to="#get_montage_tracing_graph.recordcount#" index="jj">
                                                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                                datasets: [{
                                                                label: "<cfoutput>Ay Bazında</cfoutput>",
                                                                backgroundColor: [<cfloop from="1" to="#get_montage_tracing_graph.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                                data: [<cfloop from="1" to="#get_montage_tracing_graph.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                                    }]
                                                                },
                                                        options: {}
                                                    });
                                                </script>
                                            </div>
                                        </td>
                                        <td style="width:50%" >
                                            <div id="virt_offr_process_summary" style="border:solid 1px #c3c3c3;padding:0.5%;margin-bottom:0.5%;">
												<cfoutput query="get_montage_tracing_pie">
                                                    <cfset 'item_#currentrow#' = get_montage_tracing_pie.WORKS>
                                                    <cfset 'value_#currentrow#' = Round(get_montage_tracing_pie.AMOUNT)>
                                                </cfoutput>
                                                <canvas id="myChart2" style="height:100%;"></canvas>
                                                <script>
                                                    var ctx = document.getElementById('myChart2');
                                                    var myChart2 = new Chart(ctx, {
                                                        type: 'doughnut',
                                                        data: {
                                                                labels: [<cfloop from="1" to="#get_montage_tracing_pie.recordcount#" index="jj">
                                                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                                datasets: [{
                                                                label: "<cfoutput></cfoutput>",
                                                                backgroundColor: [<cfloop from="1" to="#get_montage_tracing_pie.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                                data: [<cfloop from="1" to="#get_montage_tracing_pie.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                                    }]
                                                                },
                                                        options: {}
                                                    });
                                                </script>
                                            </div>
                                        </td>
                                        <!---<td style="width:25%" >
                                            
                                        </td>--->
                                    </tr>
                                </table>	
                            </td>
                        </tr>
                   	</cfif>
                </cfif>
            <cfelse>
                <tr> 
                    <td colspan="16" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
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
        <cfif len(attributes.durum_montaj)>
        <cfset adres = '#adres#&durum_montaj=#attributes.durum_montaj#'>
    </cfif>
    <cfif len(attributes.durum_sevice)>
        <cfset adres = '#adres#&durum_sevice=#attributes.durum_sevice#'>
    </cfif>
    <cfif len(attributes.montage_stock_ids)>
        <cfset adres = '#adres#&montage_stock_ids=#attributes.montage_stock_ids#'>
    </cfif>
    <cfif len(attributes.task_person_name)>
        <cfset adres = '#adres#&task_person_name=#attributes.task_person_name#'>
        <cfset adres = '#adres#&task_company_id=#attributes.task_company_id#'>
        <cfset adres = '#adres#&task_partner_id=#attributes.task_partner_id#'>
        <cfset adres = '#adres#&task_emp_id=#attributes.task_emp_id#'>
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
<form name="aktar_form" method="post">
    <input type="hidden" name="convert_ezgi_stocks_id" id="convert_ezgi_stocks_id" value="">
	<input type="hidden" name="convert_amount_ezgi_stocks_id" id="convert_amount_ezgi_stocks_id" value="">
</form>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function irsaliye_kontrol(type)
	{
		var convert_list ="";
		var convert_list_amount ="";

		<cfif isdefined("attributes.is_form_submitted")>
			 <cfoutput query="get_montage_tracing" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			 	 if(document.all.select_product_#EZGI_ID#_#STOCK_ID#.checked && filterNum(document.getElementById('montage_amount_#EZGI_ID#_#STOCK_ID#').value) > 0)
				 {
					 convert_list += "#EZGI_ID#_#STOCK_ID#,";
					 convert_list_amount += filterNum(document.getElementById('montage_amount_#EZGI_ID#_#STOCK_ID#').value,2)+',';
				 }
			 </cfoutput>
		</cfif>
		document.getElementById('convert_ezgi_stocks_id').value=convert_list;
		document.getElementById('convert_amount_ezgi_stocks_id').value=convert_list_amount;
		if(convert_list)//Ürün Seçili ise
		{
			sor = confirm('İsraliye Kaydı Yapılacaktır.')
			if(sor==true)
			{
				if(type==1)
				{
					windowopen('','longpage','cc_paym');
					aktar_form.action="<cfoutput>#request.self#?fuseaction=service.emptypopup_trf_ezgi_service_to_ship</cfoutput>";
					document.getElementById('irsaliye').disabled=true;
					aktar_form.target='cc_paym';
					aktar_form.submit();
				}
			}
			else
				return false;
			 
		}
		else
		 	alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
	}
	function wrk_select_all2(all_conv_product,_select_product_,number)
	{
		for(var cl_ind=1; cl_ind <= number; cl_ind++)
		{
			if(document.getElementById(all_conv_product).checked == true)
			{
				if(document.getElementById('_select_product_'+cl_ind).checked == false)
					document.getElementById('_select_product_'+cl_ind).checked = true;
			}
			else
			{
				if(document.getElementById('_select_product_'+cl_ind).checked == true)
					document.getElementById('_select_product_'+cl_ind).checked = false;
			}
		}
	}
</script>
