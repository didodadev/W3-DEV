<cfform name="list_demand" id="list_demand" action="#request.self#?fuseaction=report.list_click_report" method="post">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='57434.Rapor'></cfsavecontent>
	<cf_form_box title="#title#">
        <table border="0" align="left">
            <tr>
                <td><cf_get_lang dictionary_id='58960.Rapor Tipi'></td>
                <td>
                	<select id="report_type" name="report_type">
                		<option value="1" <cfif isdefined("report_type") and report_type eq 1 > selected</cfif>><cf_get_lang dictionary_id='57657.Ürün'></option>
                        <option value="2" <cfif isdefined("report_type") and report_type eq 2 >selected </cfif>><cf_get_lang dictionary_id='30828.Talep'></option>
                        <option value="3" <cfif isdefined("report_type") and report_type eq 3 >selected </cfif>><cf_get_lang dictionary_id='57658.Üye'></option>
                	</select>
                </td>
                <td style="width:100px;"><cf_get_lang dictionary_id='57657.Ürün'></td>
                <td style="width:150px;">
                	<input type="hidden" name="form_submit" id="form_submit" value="1" />
                    <input type="text" name="product" id="product" />
                    <input type="hidden" name="product_id" id="product_id" />
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.popup_worknet_product_list&field_id=list_demand.product_id&field_name=list_demand.product','list');"><img src="/images/plus_thin.gif"></a></td>
                <td style="width:100px;"><cf_get_lang dictionary_id='57658.Üye'></td>
                <td style="width:150px;">
                	<input type="hidden" onfocus="satir_getir();" id="company_id" name="company_id" />
                	<input type="text" onfocus="satir_getir();"  name="company_name" id="company_name" />
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=list_demand.company_id&field_comp_name=list_demand.company_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(list_demand.company_name.value),'list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
                </td>
            </tr>   
             <tr>    
               <td>
                    <cf_get_lang dictionary_id='30828.Talep'>
                </td>
                 <td>
                 	<input type="hidden" name="demand_id" id="demand_id" value="" />
                 	<input type="text" id="demand_name"    name="demand_name"  value="" />
                 	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.popup_list_demand&field_id=list_demand.demand_id&field_name=list_demand.demand_name','list')"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
                 </td>
                <td><span id="search_type" style="display:none"><cf_get_lang dictionary_id='57734.seçiniz'>Arama Tipi</span></td>
                <td>
                    <select id="arama_tipi" name="arama_tipi" style="width:80px;display:none">
                        <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                        <option value="1"><cf_get_lang dictionary_id='57657.Ürün'></option>
                        <option value="2"><cf_get_lang dictionary_id='30828.Talep'></option>
                    </select>
                </td>
            </tr>
            <tr>
                 <td></td>
                 <td></td>
            </tr>   
        </table>
    <cf_form_box_footer>
    	<cf_workcube_buttons add_function="control()" insert_info="Çalıştır">
    </cf_form_box_footer>
    </cf_form_box>
</cfform>
<br />


<cfif isdefined ("attributes.form_submit") and form_submit eq  1>
        <cfif not len (attributes.demand_name) and  len (attributes.product)>
            <cfquery name="get_visit_click_product" datasource="#DSN#">
                SELECT 
                    P.PRODUCT_ID,
                    P.PRODUCT_NAME,
                    CLICK.TOTAL
                FROM 
                    (SELECT 
                        PROCESS_TYPE, 
                        PROCESS_ID,  
                        SUM(TOTAL_COUNT) AS TOTAL
                    FROM 
                        WRK_VISIT_CLICK WVC inner join #dsn1_alias#.WORKNET_PRODUCT  P ON P.PRODUCT_ID = WVC.PROCESS_ID
                    WHERE
                         PROCESS_TYPE = 'PRODUCT'
                         <cfif isdefined ("attributes.product") and len(attributes.product)>	
                            AND P.PRODUCT_NAME = '#attributes.product#'  
                         </cfif>	                
                   GROUP BY 
                         PROCESS_TYPE, 
                         PROCESS_ID
                      ) AS CLICK INNER JOIN #dsn1_alias#.WORKNET_PRODUCT P  ON CLICK.PROCESS_ID = P.PRODUCT_ID  
               ORDER BY
                    TOTAL DESC       
            </cfquery>
        <cfelseif len (attributes.demand_name) and  not len (attributes.product)>
             <cfquery name="get_visit_click_demand" datasource="#DSN#">
                     SELECT 
                        WD.DEMAND_ID,
                        WD.DEMAND_HEAD,
                        CLICK.TOTAL
                    FROM 
                        (SELECT 
                            PROCESS_TYPE, 
                            PROCESS_ID,  
                            SUM(TOTAL_COUNT) AS TOTAL
                        FROM 
                            WRK_VISIT_CLICK  wvc inner join #dsn_alias#.WORKNET_DEMAND WD ON wvc.PROCESS_ID = WD.DEMAND_ID  
                        WHERE
                             PROCESS_TYPE = 'DEMAND'
                             <cfif isdefined ("attributes.demand_name") and len(attributes.demand_name)>	
                               AND WD.DEMAND_HEAD = '#attributes.demand_name#'   
                             </cfif>	                
                       GROUP BY 
                             PROCESS_TYPE, 
                             PROCESS_ID
                          ) AS CLICK INNER JOIN #dsn_alias#.WORKNET_DEMAND WD ON CLICK.PROCESS_ID = WD.DEMAND_ID  
                   ORDER BY
                    TOTAL DESC 
             </cfquery>
       <cfelseif not len (attributes.demand_name) and  not len (attributes.product) and not len (attributes.company_name)>
                 <cfquery name="get_visit_click_product" datasource="#DSN#">
                    SELECT 
                      	P.PRODUCT_ID,
                        P.PRODUCT_NAME,
                        CLICK.TOTAL
                    FROM 
                        (SELECT 
                            PROCESS_TYPE, 
                            PROCESS_ID,  
                            SUM(TOTAL_COUNT) AS TOTAL
                        FROM 
                            WRK_VISIT_CLICK WVC inner join #dsn1_alias#.WORKNET_PRODUCT P ON P.PRODUCT_ID = WVC.PROCESS_ID
                        WHERE
                             PROCESS_TYPE = 'PRODUCT'
                             <cfif isdefined ("attributes.product") and len(attributes.product)>	
                                AND P.PRODUCT_NAME = '#attributes.product#'  
                             </cfif>	                
                       GROUP BY 
                             PROCESS_TYPE, 
                             PROCESS_ID
                          ) AS CLICK INNER JOIN #dsn1_alias#.WORKNET_PRODUCT P  ON CLICK.PROCESS_ID = P.PRODUCT_ID  
                   ORDER BY
                        TOTAL DESC       
                </cfquery>
                <cfquery name="get_visit_click_demand" datasource="#DSN#">
                    SELECT 
                        WD.DEMAND_ID,
                        WD.DEMAND_HEAD,
                        CLICK.TOTAL
                    FROM 
                        (SELECT 
                            PROCESS_TYPE, 
                            PROCESS_ID,  
                            SUM(TOTAL_COUNT) AS TOTAL
                        FROM 
                            WRK_VISIT_CLICK  wvc inner join #dsn_alias#.WORKNET_DEMAND WD ON wvc.PROCESS_ID = WD.DEMAND_ID  
                        WHERE
                             PROCESS_TYPE = 'DEMAND'
                             <cfif isdefined ("attributes.demand_name") and len(attributes.demand_name)>	
                                AND WD.DEMAND_HEAD = '#attributes.demand_name#'    
                             </cfif>	                
                       GROUP BY 
                             PROCESS_TYPE, 
                             PROCESS_ID
                          ) AS CLICK INNER JOIN #dsn_alias#.WORKNET_DEMAND WD ON CLICK.PROCESS_ID = WD.DEMAND_ID  
                   ORDER BY
                    TOTAL DESC 
                 </cfquery>

                 <cfquery name="get_company_click" datasource="#dsn#">
                SELECT 
                    C.FULLNAME, 
                    WVC.PROCESS_ID,
                    SUM(wvc.TOTAL_COUNT) AS TOTAL_COUNT 
                    FROM 
                            WRK_VISIT_CLICK wvc 
                        INNER JOIN 
                            COMPANY c 
                        ON 
                            wvc.PROCESS_ID = C.COMPANY_ID 
                   WHERE     wvc.PROCESS_type = 'member'          
                GROUP BY 
                        C.FULLNAME,
                        WVC.PROCESS_ID
             </cfquery>
       </cfif>
       <cfif isdefined("attributes.company_name") and len(attributes.company_name) and isdefined("attributes.arama_tipi") and attributes.arama_tipi eq 1 >
       		<cfquery name="get_company_product" datasource="#dsn#">
            	SELECT 
                    CLICK.TOTAL_COUNT,
                    P.PRODUCT_NAME,
                    p.PRODUCT_ID 
                  FROM 
                 ( 
                    SELECT 
                        wvc.PROCESS_ID,
                        SUM(TOTAL_COUNT) AS TOTAL_COUNT
                    FROM 
                        workcube_cf_product.WORKNET_PRODUCT p 
                        INNER JOIN WRK_VISIT_CLICK wvc ON 
                        wvc.PROCESS_ID = P.PRODUCT_ID
                    WHERE 
                        P.COMPANY_ID in
                                (SELECT C.COMPANY_ID FROM COMPANY C  WHERE C.FULLNAME='#attributes.company_name#')
                            AND
                        wvc.PROCESS_TYPE = 'PRODUCT'			
                 GROUP BY 
                    wvc.PROCESS_ID
                 ) AS CLICK INNER JOIN workcube_cf_product.WORKNET_PRODUCT p ON p.PRODUCT_ID = CLICK.PROCESS_ID
            </cfquery>
      <cfelseif isdefined("attributes.company_name") and len(attributes.company_name) and isdefined("attributes.arama_tipi") and attributes.arama_tipi eq 2>
            <cfquery name="get_company_demand" datasource="#dsn#">
                    SELECT 
                        CLICK.TOTAL_COUNT,
                        WD.DEMAND_HEAD,
                        WD.DEMAND_ID 
                      FROM 
                     ( 
                        SELECT 
                            wvc.PROCESS_ID,
                            SUM(TOTAL_COUNT) AS TOTAL_COUNT
                        FROM  
                            WORKNET_DEMAND WD
                            INNER JOIN WRK_VISIT_CLICK wvc ON 
                            wvc.PROCESS_ID = WD.DEMAND_ID
                        WHERE 
                            WD.COMPANY_ID in
                                    (SELECT C.COMPANY_ID FROM COMPANY C  WHERE C.FULLNAME='#attributes.company_name#')
                                AND
                            wvc.PROCESS_TYPE = 'DEMAND'			
                     GROUP BY 
                        wvc.PROCESS_ID
                     ) AS CLICK INNER JOIN WORKNET_DEMAND WD ON WD.DEMAND_ID = CLICK.PROCESS_ID
                </cfquery>
	  	  <cfelseif isdefined("attributes.company_name") and len(attributes.company_name)>
            <cfquery name="get_company_member_click" datasource="#dsn#">
                SELECT 
                    C.FULLNAME, 
                    WVC.PROCESS_ID,
                    SUM(wvc.TOTAL_COUNT) AS TOTAL_COUNT 
                    FROM 
                            WRK_VISIT_CLICK wvc 
                        INNER JOIN 
                            COMPANY c 
                        ON 
                            wvc.PROCESS_ID = C.COMPANY_ID 
                        AND 
                            WVC.PROCESS_TYPE = 'MEMBER'
                WHERE 
                    C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY  WHERE COMPANY.FULLNAME = '#attributes.company_name#')		
                GROUP BY 
                        C.FULLNAME,
                        WVC.PROCESS_ID
             </cfquery>           		
       </cfif>       
   <table align="left">
        <tr>
        	 <cfif  isdefined ("get_visit_click_product") and get_visit_click_product.recordcount >
                <td valign="top">
                    <cf_medium_list style="width:300px; float:left; margin-left:8px;">
                        <thead>
                            <tr>
                                <th style="width:100px;"><cf_get_lang dictionary_id='57657.Ürün'></th>
                                <th style="width:100px;"><cf_get_lang dictionary_id='59164.Tıklanma Sayısı'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_visit_click_product">
                                <tr>
                                    <td>#PRODUCT_NAME#</td>
                                    <td><a href="#request.self#?fuseaction=report.list_product_click&pid=#PRODUCT_ID#" target="_blank">#TOTAL#</a></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_medium_list>
                </td>
            </cfif>
			 <cfif isdefined ("get_visit_click_demand") and get_visit_click_demand.recordcount >
                <tr  ><td valign="top">
                     <cf_medium_list style="width:300px;float:left; margin-left:8px;">
                        <thead>
                            <tr>
                                <th style="width:100px;"><cf_get_lang dictionary_id='30828.Talep'></th>
                                <th style="width:100px;"><cf_get_lang dictionary_id='59164.Tıklanma Sayısı'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_visit_click_demand">
                                <tr>
                                    <td>#DEMAND_HEAD#</td>
                                    <td><a href="#request.self#?fuseaction=report.list_demand_click&demand_id=#DEMAND_ID#" target="_blank">#TOTAL#</a></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_medium_list>
                </td>
        	</cfif>
             <cfif isdefined("get_company_click") and get_company_click.recordcount >
            	<tr  ><td valign="top">
                     <cf_medium_list style="width:300px; float:left; margin-left:8px;">
                        <thead>
                            <tr>
                                <th style="width:100px;"><cf_get_lang dictionary_id='57574.Şirket'></th>
                                <th style="width:100px;"><cf_get_lang dictionary_id='59164.Tıklanma Sayısı'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_company_click">
                                <tr>
                                    <td>#FULLNAME#</td>
                                    <td><a href="#request.self#?fuseaction=report.list_member_click&member_id=#PROCESS_ID#" target="_blank">#TOTAL_COUNT#</a></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_medium_list>
                </td>
            </cfif>
             <cfif isdefined("get_company_product") and get_company_product.recordcount >
            	<tr  ><td valign="top">
                     <cf_medium_list style="width:300px; float:left; margin-left:8px;">
                        <thead>
                            <tr>
                                <th style="width:100px;"><cf_get_lang dictionary_id='57657.Ürün'></th>
                                <th style="width:100px;"><cf_get_lang dictionary_id='59164.Tıklanma Sayısı'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_company_product">
                                <tr>
                                    <td>#PRODUCT_NAME#</td>
                                    <td><a href="#request.self#?fuseaction=report.list_product_click&pid=#PRODUCT_ID#" target="_blank">#TOTAL_COUNT#</a></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_medium_list>
                </td> 
            </cfif>
             <cfif isdefined("get_company_demand") and get_company_demand.recordcount >
            	<tr  ><td valign="top">
                     <cf_medium_list style="width:300px; float:left; margin-left:8px;">
                        <thead>
                            <tr>
                                <th style="width:100px;"><cf_get_lang dictionary_id='57527.Talepler'></th>
                                <th style="width:100px;"><cf_get_lang dictionary_id='59164.Tıklanma Sayısı'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_company_demand">
                                <tr>
                                    <td>#DEMAND_HEAD#</td>
                                    <td><a href="#request.self#?fuseaction=report.list_demand_click&demand_id=#DEMAND_ID#" target="_blank">#TOTAL_COUNT#</a></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_medium_list>
                </td> 
            </cfif>
             <cfif isdefined("get_company_member_click") and get_company_member_click.recordcount >
            	<tr  ><td valign="top">
                     <cf_medium_list style="width:300px; float:left; margin-left:8px;">
                        <thead>
                            <tr>
                                <th style="width:100px;"><cf_get_lang dictionary_id='57658.Üye'></th>
                                <th style="width:100px;"><cf_get_lang dictionary_id='59164.Tıklanma Sayısı'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_company_member_click">
                                <tr>
                                    <td>#FULLNAME#</td>
                                    <td><a href="#request.self#?fuseaction=report.list_member_click&member_id=#PROCESS_ID#" target="_blank">#TOTAL_COUNT#</a></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </cf_medium_list>
                </td> 
            </cfif>
        </tr>
    </table>
</cfif>

<script type="text/javascript">
function satir_getir()
{
	document.getElementById('search_type').style.display = '';
	document.getElementById('arama_tipi').style.display = '';
}

function control()
{
	var product = document.getElementById('product').value;
	var demand_name = document.getElementById('demand_name').value;
	var company_name = document.getElementById('company_name').value;
	var plen = product.length;
	var dlen = demand_name.length;
	var clen = company_name.length;
	if(plen != 0 && clen != 0)
	{
		alert("<cf_get_lang dictionary_id='60774.Ürün ve Üye Alanları birlikte sorgulanamaz'>");
		return false;
	}
	else if (dlen != 0 && clen != 0)
	{
		alert("<cf_get_lang dictionary_id='60775.Talep ve Üye Alanları birlikte sorgulanamaz'>");;
		return false;
	}
}

</script>
