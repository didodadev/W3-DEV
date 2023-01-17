<cfquery name="get_dept" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #attributes.department_id#
</cfquery>
<cfquery name="get_depts" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_ID <> #attributes.department_id# AND IS_STORE IN (1,3) AND ISNULL(IS_PRODUCTION,0) = 0
</cfquery>


<cfset deptl_ = attributes.s_dept_list>

<cfset myQuery = QueryNew("DEPT_ID,IHTIYAC","double,double")>

<cfset count_ = 0>
<cfloop list="#deptl_#" index="ccc">
	<cfset count_ = count_ + 1>
	<cfset dept_ = listgetat(ccc,2,'-')>
    <cfset ihtiyac_ = listgetat(ccc,1,'-')>
    <cfset newRow = QueryAddRow(myQuery,1)>
    <cfset temp = QuerySetCell(myQuery, "DEPT_ID",dept_,count_)>
	<cfset temp = QuerySetCell(myQuery, "IHTIYAC",ihtiyac_,count_)>
</cfloop>

<cfquery name="get_order_depts" dbtype="query">
	SELECT
    	get_depts.DEPARTMENT_HEAD,
        myQuery.DEPT_ID,
        myQuery.IHTIYAC
    FROM
    	get_depts,
        myQuery
    WHERE
    	myQuery.DEPT_ID = get_depts.DEPARTMENT_ID AND
        get_depts.DEPARTMENT_ID NOT IN (#attributes.department_id#)
    ORDER BY
    	myQuery.IHTIYAC DESC
</cfquery>


<cf_popup_box title="Stok Dağıtıcı">
<cfoutput>
    <cf_medium_list>
        <thead>
        <tr>
            <th>Ürün</th>
            <th>Depo</th>
            <th>Dağıtılacak Stok Miktarı</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>#get_product_name(stock_id:attributes.stock_id,with_property:1)#</td>
            <td>#get_dept.DEPARTMENT_HEAD#</td>
            <td>#attributes.stock_count#</td>
        </tr>
        </tbody>
    </cf_medium_list>
</cfoutput>
    <br />
    <cf_medium_list id="dept_table">
    	<thead>
        	<tr>
            	<th>Depo</th>
                <th>Toplam İhtiyaç</th>
                <th>İşlenmemiş Sevk Talepleri</th>
                <th>Teslim Alınmamış Transfer İrsaliyeleri</th>
                <th>Diğer Şubelerden Gönderilen</th>
                <th>Gönderilecek</th>
            </tr>
        </thead>
        <tbody>
        	<cfoutput query="get_order_depts">
            <cfset ihtiyac_ = IHTIYAC>
        	<tr>
            	<td>#DEPARTMENT_HEAD#</td>
                <td>#IHTIYAC#</td>
                <cfquery name="get_internal" datasource="#dsn2#">
                    SELECT 
                        SUM(SIR.AMOUNT) AMOUNT 
                    FROM
                        SHIP_INTERNAL SI INNER JOIN
                        SHIP_INTERNAL_ROW SIR ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID
                    WHERE
                        SI.DISPATCH_SHIP_ID NOT IN 
                        (SELECT DISPATCH_SHIP_ID FROM SHIP S WHERE S.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID)                
                		AND SIR.STOCK_ID = #attributes.stock_id#
                        AND SI.DEPARTMENT_IN = #DEPT_ID#
                </cfquery>
                <cfif isdefined('get_internal.amount') and get_internal.amount gt 0>
					<cfset ihtiyac_ = ihtiyac_- get_internal.amount>
                </cfif>
                <td>#get_internal.AMOUNT#</td>
                <cfquery name="GET_SHIP_" datasource="#DSN2#">
                	SELECT
                        SUM(SR.AMOUNT) AMOUNT
                    FROM
                        SHIP S INNER JOIN
                        SHIP_ROW SR ON SR.SHIP_ID = S.SHIP_ID
                    WHERE
                        S.SHIP_TYPE = 81 AND 
                        S.SHIP_STATUS = 1 AND
                        ISNULL(S.IS_DELIVERED,0) = 0  AND 
                        S.DEPARTMENT_IN = #DEPT_ID# AND 
                        S.LOCATION_IN = 1 AND
                        SR.STOCK_ID = #attributes.stock_id#
                </cfquery>
				<cfif isdefined('GET_SHIP_.amount') and GET_SHIP_.amount gt 0>
					<cfset ihtiyac_ = ihtiyac_-GET_SHIP_.amount>
                </cfif>
                <td>#GET_SHIP_.AMOUNT#</td>
                <td><input type="text" id="diger_sube_#dept_id#" name="diger_sube_#dept_id#" value="" readonly="yes" style="width:75px;"></td>
                <td><input type="text" id="yazilan_#dept_id#" name="yazilan_#dept_id#" value="0" style="width:75px;"></td>
            </tr>
            <cfset 'ihtiyac_#dept_id#' = ihtiyac_>
            </cfoutput>
        </tbody>
        <tfoot>
        	<tr>
            	<td colspan="6" style="text-align:right;"><input type="button" value="Dağılım Yap" onclick="dagilim_yap();"/></td>
            </tr>
        </tfoot>
    </cf_medium_list>
</cf_popup_box>
<script>
	dept_list = "";
	dept_list_ihtiyac = "";
	
	<cfoutput>
		toplam_adet_kalan = parseInt(#attributes.stock_count#);
		eski_veri = window.opener.document.getElementById('sevk_islemi_#attributes.stock_id#_#attributes.department_id#').value;
	</cfoutput>
	
	<cfoutput query="get_order_depts">
		dept_ihtiyac = parseInt(#evaluate('ihtiyac_#dept_id#')#);
		once_yazilan = window.opener.document.getElementById('sevk_islemi_gelen_#attributes.stock_id#_#get_order_depts.DEPT_ID#').value;
		if(once_yazilan == '')
			once_yazilan = 0;
		if(eski_veri != '')
		{
			eleman_sayisi = list_len(eski_veri);
			
			for (var m=1; m <= eleman_sayisi; m++)
			{
				deger_ = list_getat(eski_veri,m);
				depo_ = list_getat(deger_,1,'-');
				rakam_ = list_getat(deger_,2,'-');

				if(depo_ == '#get_order_depts.DEPT_ID#')
				{
					once_yazilan = once_yazilan - rakam_;	
				}
			}
		}
		
		if(dept_ihtiyac > 0)
		{
			yazilabilecek_ = dept_ihtiyac - once_yazilan;
			if(eski_veri == '')
			{
				if(yazilabilecek_ > 0)
				{
					if(toplam_adet_kalan > 0 && yazilabilecek_ <= toplam_adet_kalan)
					{
						yazilacak_ = yazilabilecek_;
					}
					else if(toplam_adet_kalan > 0 && yazilabilecek_ > toplam_adet_kalan)
					{
						yazilacak_ = toplam_adet_kalan;
					}
					document.getElementById('yazilan_#get_order_depts.DEPT_ID#').value = yazilacak_;
				}
				else
					document.getElementById('yazilan_#get_order_depts.DEPT_ID#').value = 0;
			}
			else
			{
				eleman_sayisi = list_len(eski_veri);
				
				for (var m=1; m <= eleman_sayisi; m++)
				{
					deger_ = list_getat(eski_veri,m);
					depo_ = list_getat(deger_,1,'-');
					rakam_ = list_getat(deger_,2,'-');
	
					if(depo_ == '#get_order_depts.DEPT_ID#')
					{
						document.getElementById('yazilan_#get_order_depts.DEPT_ID#').value = rakam_;
					}
				}	
			}
		}
		document.getElementById('diger_sube_#get_order_depts.DEPT_ID#').value = once_yazilan;		
	</cfoutput>
function dagilim_yap()
{
	deger_list_ = '';
	<cfoutput query="get_order_depts">
		deger_ = parseInt(document.getElementById('diger_sube_#dept_id#').value) + parseInt(document.getElementById('yazilan_#dept_id#').value);
		window.opener.document.getElementById('sevk_islemi_gelen_#attributes.stock_id#_#get_order_depts.DEPT_ID#').value = deger_;
		
		<cfif currentrow eq 1>
			deger_list_ = '#dept_id#-' + parseInt(document.getElementById('yazilan_#dept_id#').value);
		<cfelse>
			deger_list_ += ',' + '#dept_id#-' + parseInt(document.getElementById('yazilan_#dept_id#').value);
		</cfif>
	</cfoutput>	
	
	<cfoutput>
		window.opener.document.getElementById('sevk_islemi_#attributes.stock_id#_#attributes.department_id#').value = deger_list_;
	</cfoutput>
	
	window.close();
}
</script>