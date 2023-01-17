<cfset new_basket = DeserializeJSON(attributes.print_note)>

<cfquery name="get_department" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.DEPARTMENT_ID = #attributes.department_id#
</cfquery>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID IN (#attributes.department_id_list#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfparam name="attributes.mode" default="45">
<cfif attributes.type eq 1>
    <cfdocument format="pdf" marginleft="0" marginbottom="0" margintop="0" marginright="0" pagetype="a4" orientation="landscape" scale="85">
        <style> 
        table{font-size:10px;};
        table tr{font-size:10px;};
        table tr td{font-size:10px;};
    </style>
    	<cfset sira_ = 0>
       <cfloop from="1" to="#arraylen(new_basket)#" index="ccc">
            <cfset yazilacak_satir = 0>
            <cfoutput query="get_departments_search">
                    <cfset in_depo_id = department_id>
                    <cfset miktar = trim(evaluate("new_basket[ccc].reel_dagilim_#in_depo_id#"))>
                    <cfset onay = evaluate("new_basket[ccc].onay_#in_depo_id#")>
                    <cfif (onay is 'YES' or onay is 'yes') and len(miktar) and miktar is not 'null' and isnumeric(miktar) and miktar gt 0>
                        <cfset yazilacak_satir = 1>
                    </cfif>
            </cfoutput>
            <cfif yazilacak_satir eq 1>
				<cfset sira_ = sira_ + 1>
                <cfif sira_ eq 1 or (sira_ gt attributes.mode and sira_ mod attributes.mode eq 1)>
                <table cellpadding="2" cellspacing="0" border="1" width="99%">
                    <tr>
                        <td>Sıra No</td>
                        <td>Barkod</td>
                        <td>Stok Adı</td>
                        <td>Koli</td>
                        <td><cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Stok</td>
                        <td><cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Ort.</td>
                        <td><cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Yet.</td>
                        <cfoutput query="get_departments_search">
                        <td>#department_head#</td>
                        </cfoutput>
                    </tr>
                </cfif>
                <tr>
                    <cfoutput>
                    <td>#sira_#</td>
                    <td>#new_basket[ccc].barcode#</td>
                    <td nowrap>#new_basket[ccc].stock_name#</td>
                    <td>#new_basket[ccc].koli_carpan#</td>
                    <td>#new_basket[ccc].sube_stock#</td>
                    <td>#new_basket[ccc].sube_ortalama_satis#</td>
                    <td>#new_basket[ccc].sube_yeter#</td>
                    </cfoutput>
                    <cfoutput query="get_departments_search">
                        <td style="text-align:right;">
                            <cfset in_depo_id = department_id>
                            <cfset miktar = trim(evaluate("new_basket[ccc].reel_dagilim_#in_depo_id#"))>
                            <cfset onay = evaluate("new_basket[ccc].onay_#in_depo_id#")>
                            <cfif (onay is 'YES' or onay is 'yes') and len(miktar) and miktar is not 'null' and isnumeric(miktar)>
                                #tlformat(miktar,0)#
                            <cfelse>
                                0
                            </cfif>
                        </td>
                    </cfoutput>
                </tr>
                <cfif ccc eq arraylen(new_basket) or (sira_ gte attributes.mode and sira_ mod attributes.mode eq 0)>
                    </table>
                    <cfdocumentitem type="pagebreak"/>
                </cfif>
           </cfif>     
       </cfloop>
    </cfdocument>
<cfelse>
	<cfsavecontent variable="print_icerik">
        <table cellpadding="2" cellspacing="0" border="1" width="99%">
            <tr>
                <td>Sıra No</td>
                <td>Barkod</td>
                <td>Stok Adı</td>
                <td>Koli</td>
                <td><cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Stok</td>
                <td><cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Ort.</td>
                <td><cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Yet.</td>
                <cfoutput query="get_departments_search">
                <td>#department_head#</td>
                </cfoutput>
            </tr>
            <cfloop from="1" to="#arraylen(new_basket)#" index="ccc">
            <tr>
                <cfoutput>
                <td>#ccc#</td>
                <td>#new_basket[ccc].barcode#</td>
                <td nowrap>#new_basket[ccc].stock_name#</td>
                <td>#new_basket[ccc].koli_carpan#</td>
                <td>#tlformat(new_basket[ccc].sube_stock)#</td>
                <td>#tlformat(new_basket[ccc].sube_ortalama_satis)#</td>
                <td>#tlformat(new_basket[ccc].sube_yeter)#</td>
                </cfoutput>
                <cfoutput query="get_departments_search">
                    <td style="text-align:right;">
                        <cfset in_depo_id = department_id>
                        <cfset miktar = trim(evaluate("new_basket[ccc].reel_dagilim_#in_depo_id#"))>
                        <cfset onay = evaluate("new_basket[ccc].onay_#in_depo_id#")>
                        <cfif (onay is 'YES' or onay is 'yes') and len(miktar) and miktar is not 'null' and isnumeric(miktar)>
                            #tlformat(miktar,0)#
                        <cfelse>
                            0
                        </cfif>
                    </td>
                </cfoutput>
            </tr>
         </cfloop>
        </table>
    </cfsavecontent>
	
	<!--- kirli dosya oluşmasın diye --->
	<cfif isdefined("session.ep.userid")>
        <cfset filename = "#fusebox.fuseaction#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')##session.ep.userid#">
    <cfelse>
        <cfset filename = "#fusebox.fuseaction#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')#">
    </cfif>	
    <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
    <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
        <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
    </cfif>
    <cfdirectory action="list" name="get_ds" directory="#upload_folder#reserve_files">
    <cfif get_ds.recordcount>
        <cfoutput query="get_ds">
            <cfif type is 'dir' and name is not drc_name_>
                <cftry>
                    <cfset d_name_ = name>
                    <cfdirectory action="list" name="get_ds_ic" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
                        <cfif get_ds_ic.recordcount>
                            <cfloop query="get_ds_ic">
                                <cffile action="delete" file="#upload_folder#reserve_files#dir_seperator##d_name_##dir_seperator##get_ds_ic.name#">
                            </cfloop>
                        </cfif>
                    <cfdirectory action="delete" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
                <cfcatch></cfcatch>
                </cftry>
            </cfif>
        </cfoutput>
    </cfif>
    <!--- kirli dosya oluşmasın diye --->
    <cffile action="write" file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.xls" output="#print_icerik#" charset="utf-16"/>
    
    <script type="text/javascript">
        get_wrk_message_div("<cf_get_lang_main no='1931.Dosya İndir'>","<cf_get_lang_main no='1934.Excel'>","<cfoutput>/documents/reserve_files/#drc_name_#/#filename#.xls</cfoutput>");
    </script>
</cfif>