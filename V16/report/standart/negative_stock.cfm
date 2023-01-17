<cfparam name="attributes.date" default="#dateformat(createodbcdatetime('#session.ep.period_year#-#month(now())#-1'),dateformat_style)#">
<cfif isdefined("attributes.form_varmi")>
	<cfif isdefined("attributes.report_type") and attributes.report_type  eq 1>
        <cfset alan = 'PRODUCT_ID'>
    <cfelseif isdefined("attributes.report_type") and attributes.report_type  eq 2 >
        <cfset alan = 'STOCK_ID'> 
    <cfelseif isdefined("attributes.report_type") and attributes.report_type  eq 3 >
        <cfset alan = 'ISNULL(SPECT_VAR_ID,STOCK_ID)'>  
    </cfif>
    <cf_date tarih="attributes.date">
    <cfquery name="check_table" datasource="#dsn#">
    	IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME='####TMP_NEGATIVE_STOCK1' )
        DROP TABLE ####TMP_NEGATIVE_STOCK1
        IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME='####TMP_NEGATIVE_STOCK2' )
        DROP TABLE ####TMP_NEGATIVE_STOCK2
    </cfquery>
    <cfquery name="get_negative_stock" datasource="#dsn2#" result="xxx">
              SELECT 
                    SUM(STOCK_IN - STOCK_OUT) AS AMOUNT ,
                    PRODUCT_ID,
                    PROCESS_DATE,
                    STOCK_ID
                    <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>
                        ,SPECT_VAR_ID	
                    </cfif>   
                    <cfif isdefined("attributes.is_location")>
                        ,DEPARTMENT_HEAD
                        ,COMMENT
						,STORE
						,STORE_LOCATION
                    </cfif>
              INTO ####TMP_NEGATIVE_STOCK1
              FROM 
                STOCKS_ROW 
                <cfif isdefined("attributes.is_location")>
                    LEFT JOIN #dsn#.DEPARTMENT ON STOCKS_ROW.STORE = DEPARTMENT.DEPARTMENT_ID LEFT JOIN #dsn#.STOCKS_LOCATION ON  STOCKS_LOCATION.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND STOCKS_LOCATION.LOCATION_ID = STOCKS_ROW.STORE_LOCATION
                </cfif>
              GROUP BY 
                    PRODUCT_ID,
                    PROCESS_DATE,
                    STOCK_ID
                    <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>
                        ,SPECT_VAR_ID	
                    </cfif>  
                    <cfif isdefined("attributes.is_location")>
                        ,DEPARTMENT_HEAD,COMMENT,STORE,STORE_LOCATION
                    </cfif>
              HAVING 
                    PROCESS_DATE IS NOT NULL

                     SELECT *
                     INTO ####TMP_NEGATIVE_STOCK2
                     FROM ####TMP_NEGATIVE_STOCK1 c1
                            CROSS APPLY (SELECT SUM(AMOUNT) AS TOPLAM
                                          FROM ####TMP_NEGATIVE_STOCK1 CTE
                                          WHERE 
                                          	<cfif isdefined("attributes.report_type") and attributes.report_type eq 1>
                                            	PRODUCT_ID = c1.PRODUCT_ID	
                                            <cfelseif isdefined("attributes.report_type") and attributes.report_type eq 2>
                                            	STOCK_ID = c1.STOCK_ID
                                            <cfelseif isdefined("attributes.report_type") and attributes.report_type eq 3>
                                            	ISNULL(SPECT_VAR_ID,STOCK_ID) = ISNULL(c1.SPECT_VAR_ID,c1.STOCK_ID)
											</cfif>
											<cfif isdefined("attributes.is_location")>
												AND STORE = c1.STORE
												AND STORE_LOCATION = c1.STORE_LOCATION
											</cfif>
                                          	AND 
                                            	PROCESS_DATE < = c1.PROCESS_DATE
			                 )c2


        SELECT 
        	CTE2.*,
            PRODUCT.PRODUCT_NAME,
            S.STOCK_CODE
        FROM  
        	  ####TMP_NEGATIVE_STOCK2 AS CTE2 INNER JOIN #DSN1#.PRODUCT on PRODUCT.PRODUCT_ID = CTE2.PRODUCT_ID
	 			   inner join #DSN1#.STOCKS S on S.STOCK_ID = CTE2.STOCK_ID 
        WHERE 
        	CTE2.TOPLAM < 0 
            <cfif isdefined("attributes.keyword") and len("attributes.keyword")>
				AND PRODUCT.PRODUCT_NAME LIKE '%#attributes.keyword#%'
			</cfif>
            <cfif isdefined("attributes.date") and len(attributes.date) >
            	AND PROCESS_DATE <= #attributes.date#
            </cfif>
		ORDER BY
			<cfif isdefined("attributes.report_type") and attributes.report_type eq 3>
            	CTE2.SPECT_VAR_ID desc,
			</cfif>
            CTE2.PRODUCT_ID,
            CTE2.PROCESS_DATE,
            CTE2.STOCK_ID,
            S.STOCK_CODE
    </cfquery>
<cfelse>
	<cfset get_negative_stock.recordcount = 0>
</cfif>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_negative_stock.recordcount#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39768.Negatif Stok'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
        <cfform name="list_negatives">
            <div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'> </label>
									<div class="col col-12 col-xs-12">										
                                        <cfinput type="text" name="keyword" value="#attributes.keyword#">  <cfinput type="hidden" name="form_varmi" value="1">
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'> </label>
									<div class="col col-12 col-xs-12">                                        
                                        <select name="report_type" id="report_type">
                                            <option value="1" <cfif isdefined("attributes.report_type") and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39053.Ürün Bazında'></option>
                                            <option value="2" <cfif isdefined("attributes.report_type") and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='39054.Stok Bazında'></option>
                                            <option value="3" <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39765.Spec Bazında'></option>
                                         </select>
                                    </div>
                                </div>                   
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
									<div class="col col-12 col-xs-12">                                        
                                        <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                        <cfinput value="#dateformat(attributes.date,dateformat_style)#" type="text" name="date" id="date" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"></label>
									<div class="col col-12 col-xs-12">                                        
                                        <label><cf_get_lang dictionary_id='39497.Lokasyon Bazında'> <input type="checkbox" name="is_location" value="1" <cfif isdefined("attributes.is_location")>checked</cfif> /> </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label> 
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                            <cf_wrk_report_search_button button_type="1" is_excel='1' search_function='kontrol()'>
                        </div>
                    </div>
                </div>
            </div>    
        </cfform> 
    </cf_report_list_search_area>
</cf_report_list_search>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</cfif>
<cfif isdefined("attributes.form_varmi")>
<cf_report_list>    
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='57518.STOK KODU'></th>
                <th><cf_get_lang dictionary_id='57657.Ürün Adı'></th> 
                <cfif isdefined("attributes.is_location")>
                    <th><cf_get_lang dictionary_id='58524.Lokasyon'></th> 
                </cfif>
                <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>
                    <th><cf_get_lang dictionary_id='57647.Spec'></th>
                </cfif>
                <th><cf_get_lang dictionary_id='57635.Miktar'></th> 
                <th><cf_get_lang dictionary_id='57742.Tarih'></th> 
            </tr>
        </thead>
        
            	<tbody>
					<cfif isdefined("attributes.form_varmi") and get_negative_stock.recordcount>
                        <cfoutput query="get_negative_stock" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                            
                                    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                           <td> #STOCK_CODE#</td>
                                    <cfelse>
                                    <td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#PRODUCT_ID#" target="_blank">#STOCK_CODE#</a></td>
                                    </cfif>
                            
                                <td>#PRODUCT_NAME#</td>
                                <cfif isdefined("attributes.is_location")>
                                    <td>#DEPARTMENT_HEAD#--#COMMENT#</td>
                                </cfif>
                                <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>
                                    <td>#SPECT_VAR_ID#</td>
                                </cfif>
                                <td style = "text-align:right">#TLFORMAT(TOPLAM,4)#</td>
                                <td>#dateFormat(PROCESS_DATE,dateformat_style)#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tbody>
                            <tr>
                                <td colspan="35" height="20"><cfif isdefined('form_varmi')><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                            </tr>
                        </tbody>
                    </cfif>
                </tbody>  
</cf_report_list>
</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cfset url_str = "report.list_negative_stock">
    <cfif attributes.totalrecords gt attributes.maxrows>
     <table width="99%" align="center" cellpadding="0" cellspacing="0">
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.report_type) and len(attributes.report_type)>
            <cfset url_str = "#url_str#&report_type=#attributes.report_type#">
        </cfif>
        <cfif len(attributes.date)>
            <cfset url_str = "#url_str#&date=#dateformat(attributes.date,dateformat_style)#">
        </cfif>
        <cfif isdefined ("attributes.is_location") and len(attributes.is_location)>
            <cfset url_str = "#url_str#&is_location=#attributes.is_location#">
        </cfif>
		
            <cf_paging 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#&form_varmi=1">
     </cfif>
</cfif>
<script>
    
    
    function kontrol()
    {
        
        if(document.list_negatives.is_excel.checked==false)
			{
				document.list_negatives.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.list_negative_stock"
				return true;
			}
			else
				document.list_negatives.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_list_negative_stock</cfoutput>"
    }
    
    
    
</script>
