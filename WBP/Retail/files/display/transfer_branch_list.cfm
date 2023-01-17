<cfset cfc=createObject("component","WBP.Retail.files.params")>
<cfset bugun_ = cfc.systemParam().bugun_>
<cfset dsn_dev_alias= cfc.systemParam().dsn_dev_alias>
<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("d",-90,bugun_)>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = dateadd("d",-1,bugun_)>
</cfif>

<cfquery name="get_tranfers" datasource="#dsn_dev#">
    SELECT
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EKLEYEN,
        D.DEPARTMENT_HEAD,
        D.DEPARTMENT_ID,
        D2.DEPARTMENT_HEAD AS D_DEPT,
        D2.DEPARTMENT_ID AS D_DEPT_ID,
        S.STOCK_ID,
        S.PROPERTY,
        ISNULL(#dsn_dev_alias#.fnc_get_ortalama_satis_stok(S.STOCK_ID,D.DEPARTMENT_ID,#attributes.search_startdate#,#attributes.search_finishdate#),0) AS ROW_ORT_STOK_SATIS_MIKTARI,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = D.DEPARTMENT_ID),0) AS ROW_STOCK_MAGAZA,
        SIT.RECORD_DATE,
        SIT.ROW_ID,
        SIT.AMOUNT
    FROM
        STOCK_TRANSFER_LIST SIT,
        #dsn_alias#.EMPLOYEES E,
        #dsn_alias#.DEPARTMENT D,
        #dsn_alias#.DEPARTMENT D2,
        #dsn3_alias#.STOCKS S
    WHERE
    	SIT.RECORD_EMP = E.EMPLOYEE_ID AND
        SIT.DEPARTMENT_ID = D.DEPARTMENT_ID AND
        SIT.TO_DEPARTMENT_ID = D2.DEPARTMENT_ID AND
        SIT.STOCK_ID = S.STOCK_ID
    ORDER BY
    	D.DEPARTMENT_HEAD,
        D.DEPARTMENT_ID,
        S.PROPERTY
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='61500.Şube Stok Transfer Listeleri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th></th>
                    <th><cf_get_lang dictionary_id='61498.Dağılım Mağaza'></th>
                    <th><cf_get_lang dictionary_id='61499.Ekleyen'></th>
                    <th><cf_get_lang dictionary_id='41212.Eklenme Tarihi'></th>
                    <th><cf_get_lang dictionary_id='45693.Stok Adı'></th>
                    <th><cf_get_lang dictionary_id='51100.Talep'></th>
                    <th><cf_get_lang dictionary_id='40640.Ortalama'></th>
                    <th><cf_get_lang dictionary_id='57452.Stok'></th>
                    <th><cf_get_lang dictionary_id='57452.Stok'>. Y.</th>
                </tr>
            </thead>
            <tbody>
            <cfoutput query="get_tranfers" group="DEPARTMENT_HEAD">
                <tr>
                    <td width="15" style="background-color:##9CC;"><a href="javascript://" onclick="del_department('#department_id#');"><img src="/images/delete_list.gif"/></a></td>
                    <td colspan="8" class="formbold" style="background-color:##9CC;"><a href="#request.self#?fuseaction=retail.transfer_branch&department_id=#department_id#&transfer_type=1&is_from_list=1">#DEPARTMENT_HEAD#</a></td>
                </tr>
                <cfoutput>
                <tr>
                    <td width="15"><a href="javascript://" onclick="del_row('#row_id#');"><img src="/images/delete_list.gif"/></a></td>
                    <td width="75">#D_DEPT#</td>
                    <td width="150">#EKLEYEN#</td>
                    <td width="65">#dateformat(RECORD_DATE,'dd/mm/yyyy')#</td>
                    <td>#PROPERTY#</td>
                    <td width="35" style="text-align:right;">#tlformat(amount)#</td>
                    <td width="35" style="text-align:right;">#tlformat(ROW_ORT_STOK_SATIS_MIKTARI)#</td>
                    <td width="35" style="text-align:right;">#tlformat(ROW_STOCK_MAGAZA)#</td>
                    <td width="35" style="text-align:right;"><cfif ROW_ORT_STOK_SATIS_MIKTARI gt 0>#tlformat(ROW_STOCK_MAGAZA / ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>-</cfif></td>
                </tr>
                </cfoutput>
            </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

<script>
function del_row(rid)
{
	if(confirm('Satırı Silmek İstediğinize Emin misiniz?'))
		windowopen('index.cfm?fuseaction=retail.transfer_branch_list&row_id=' + rid,'small');
	else
		return false;	
}

function del_department(did)
{
	if(confirm('Mağazaya Ait Tüm Satırları Silmek İstediğinize Emin misiniz?'))
		windowopen('index.cfm?fuseaction=retail.transfer_branch_list&department_id=' + did,'small');
	else
		return false;	
}
</script>