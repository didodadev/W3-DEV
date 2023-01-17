<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cfprocessingdirective pageencoding="utf-8"> 
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.comp_cat" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.has_account_code" default="">
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>       
<cfif isdefined("attributes.form_submitted")>	
    <cfset get_comp_period.recordcount = 0> 
    <cfset get_comp_period.query_count = 0> 
    <cfquery name="get_comp_period" datasource="#DSN#">
        WITH CTE1 AS (
            SELECT   
                C.COMPANY_ID,
                (SELECT COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID = C.COMPANYCAT_ID) COMPANY_CAT,
                C.NICKNAME,
                CP.ACCOUNT_CODE,
                CP.KONSINYE_CODE,
                CP.ADVANCE_PAYMENT_CODE,
                CP.SALES_ACCOUNT,
                CP.PURCHASE_ACCOUNT,
                CP.RECEIVED_GUARANTEE_ACCOUNT,
                CP.GIVEN_GUARANTEE_ACCOUNT,
                CP.RECEIVED_ADVANCE_ACCOUNT,
                CP.EXPORT_REGISTERED_SALES_ACCOUNT,
                CP.EXPORT_REGISTERED_BUY_ACCOUNT
            FROM 
                COMPANY C
                LEFT JOIN COMPANY_PERIOD CP ON CP.COMPANY_ID = C.COMPANY_ID AND CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            WHERE
               	(IS_SELLER = 1 OR IS_BUYER = 1)
                <cfif len(attributes.company) and len(attributes.company_id)>
                    AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfif>
                <cfif len(attributes.comp_cat)>
                    AND C.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_cat#">
                </cfif>
                <cfif len(attributes.is_active) and (attributes.is_active eq 2)>
                    AND C.COMPANY_STATUS = 1
                <cfelseif len(attributes.is_active) and (attributes.is_active eq 3)>
                    AND C.COMPANY_STATUS = 0
                </cfif>
                <cfif len(attributes.has_account_code)>
                    <cfif attributes.has_account_code eq 1>
                        AND C.COMPANY_ID IN 
                            (SELECT 
                                COMPANY_ID 
                            FROM 
                                COMPANY_PERIOD 
                            WHERE 
                                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                    <cfelseif attributes.has_account_code eq 0>
                        AND C.COMPANY_ID NOT IN
                            (SELECT COMPANY_ID FROM COMPANY_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                    </cfif>
                </cfif>
          ),
    	CTE2 AS (
        	SELECT
            	CTE1.*,
                	ROW_NUMBER() OVER (	ORDER BY
                    	NICKNAME
               		) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
       		FROM
            	CTE1
           	)
       		SELECT
            	CTE2.*
        	FROM
            	CTE2
            <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_comp_period.recordcount = 0>    
     <cfset get_comp_period.query_count = 0> 
</cfif>
<cfparam name="attributes.totalrecords" default="#get_comp_period.query_count#">   
<cfform name="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='61002.Üye Muhasebe Kodları'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
        <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
					<div class="row" type="row">
                        <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                            <div class="col col-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                    <div class="col col-12 col-xs-12 ">
                                        <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                                        <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                        <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                        <input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'2\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','search','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=search.company&field_comp_id=search.company_id&field_consumer=search.consumer_id&field_member_name=search.company&field_name=search.company&field_type=search.member_type<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=2</cfoutput>&keyword='+encodeURIComponent(document.search.company.value),'list')"></span>
                                    </div>
                                    </div>
                                </div>
                            </div> 
                        </div>
                        <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                            <div class="col col-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58137.Kategori'></label>
                                    <div class="col col-12 col-xs-12">
                                            <cfsavecontent variable="text2"><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></cfsavecontent>
                                           <cf_wrk_membercat
                                            name="comp_cat"
                                            option_text="#text2#"
                                            value="#attributes.comp_cat#"
                                            comp_cons=1>  
                                    </div> 
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                           <div class="col col-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'></label>
                                    <div class="col col-12 col-xs-12">
                                            <select name="is_active" id="is_active">
                                                <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                <option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                                <option value="3" <cfif attributes.is_active eq 3>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                            </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                            <div class="col col-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label> 
                                        <div class="col col-12 col-xs-12">
                                            <select name="has_account_code" id="has_account_code">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="1" <cfif attributes.has_account_code is "1">selected</cfif>><cf_get_lang dictionary_id='39317.Tanimli'></option>
                                                <option value="0" <cfif attributes.has_account_code is "0">selected</cfif>><cf_get_lang dictionary_id='58845.Tanimsiz'></option>
                                            </select>
                                        </div>
                                </div>
                                <!---
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"></label>		
                                    <div class="col col-12 col-xs-12" id="tdlist_account" <cfif attributes.has_account_code eq '' or  attributes.has_account_code eq 0> style="display:none" </cfif>>
                                                <select name="list_account" id="list_account">
                                                    <option value=""><cf_get_lang dictionary_id="39664.Muhasebe Kodu Hesabı Seçiniz"></option>
                                                    <option value="account_code"<cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_code'>selected</cfif></cfif>><cf_get_lang dictionary_id='57448.Satis'></option>
                                                    <option value="account_code_pur" <cfif isdefined('attributes.list_account')><cfif attributes.list_account eq 'account_code_pur'>selected</cfif></cfif>><cf_get_lang dictionary_id='58176.Alis'></option>
                                                </select>
                                    </div>
                                </div>---->
                            </div>                          
                        </div> 
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><input type="checkbox" value="1" name="is_excel" id="is_excel"<cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id ='57858.Excel Getir'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this)" required="yes" message="#message#">
                        <cfelse>    
                            <cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,999" onKeyUp="isNumber(this)" required="yes" message="#message#">
                        </cfif>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                        <input type="hidden" name="form_submitted" id="form_submitted" value="1">                     
                        <cf_wrk_report_search_button is_excel="1" button_type="1" search_function='control()' insert_info='#message#'>
                    </div>
                </div>
            </div>
        </div>
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
    <cfset type_ = 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=get_comp_period.recordcount>
<cfelse>
    <cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cf_report_list>
			<thead>
				<tr> 
					<th ><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57486.Kategorisi'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='29436.Standart Hesap'></th>
                    <th><cf_get_lang dictionary_id='57448.Satis'></th>
					<th><cf_get_lang dictionary_id='58176.Alis'></th>
                    <th><cf_get_lang dictionary_id='45518.Konsinye'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='48668.Hesabı'></th>
					<th><cf_get_lang dictionary_id='58490.Verilen'> <cf_get_lang dictionary_id='58204.Avans'> <cf_get_lang dictionary_id='48668.Hesabı'></th>
                    <th><cf_get_lang dictionary_id='40316.Alınan Teminat'> <cf_get_lang dictionary_id='48668.Hesabı'></th>
                    <th><cf_get_lang dictionary_id='58490.Verilen'><cf_get_lang dictionary_id='58689.Teminat'><cf_get_lang dictionary_id='48668.Hesabı'></th>
                    <th><cf_get_lang dictionary_id='58488.Alınan'><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'></th>
                    <th><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38373.Satış Hesabı'></th>
                    <th><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38375.Alış Hesabı'></th>
			 </tr>
		 </thead>        
		<cfif get_comp_period.recordcount>
			<cfset row_count_ = 0>
			<cfoutput query="get_comp_period">
				<cfset row_count_ = row_count_+1>
				<tbody>
					<tr>
						<td align="center">#currentrow#</td><!---No--->
						<td align="center">#COMPANY_CAT#</td><!--- Kategorisi--->
						<td align="center">
                            <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#NICKNAME#</a>
                            <cfelse>
                                #NICKNAME#
                            </cfif>
                            </td>
						<td align="center">#account_code#</td><!---STANDART--->
						<td align="center">#SALES_ACCOUNT#</td><!---SATIŞ--->
                        <td align="center">#PURCHASE_ACCOUNT#</td><!---ALIŞ--->
						<td align="center">#KONSINYE_CODE#</td>
                        <td align="center">#ADVANCE_PAYMENT_CODE#</td>
                        <td align="center">#RECEIVED_GUARANTEE_ACCOUNT#</td>
                        <td align="center">#GIVEN_GUARANTEE_ACCOUNT#</td>
                        <td align="center">#RECEIVED_ADVANCE_ACCOUNT#</td>
                        <td align="center">#EXPORT_REGISTERED_SALES_ACCOUNT#</td>
                        <td align="center">#EXPORT_REGISTERED_BUY_ACCOUNT#</td>
					</tr> 
				</tbody>
			</cfoutput>
			<input type="hidden" name="row_count_" id="row_count_" value="<cfoutput>#row_count_#</cfoutput>">
		<cfelse>
			<tbody>
				<tr>
                	<cfset colspan_ = 13>
					<td colspan="13"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
				</tr>
			</tbody>
		</cfif>        
</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset adres = "#attributes.fuseaction#&form_submitted=#attributes.form_submitted#">
    <cfif len(attributes.company_id) and len(attributes.company)>
        <cfset adres = '#adres#&company_id=#attributes.company_id#'>
    </cfif>  
    <cfif len(attributes.has_account_code)>
        <cfset adres = '#adres#&has_account_code=#attributes.has_account_code#'>
    </cfif>
    <cfif isdefined('attributes.comp_cat') and len(attributes.comp_cat)>
        <cfset adres='#adres#&comp_cat=#attributes.comp_cat#'>
    </cfif>
    <cfset adres = '#adres#&is_active=#attributes.is_active#'>
    <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#"> 
</cfif>
<script type="text/javascript">
    function show_select()
	{
		if(document.getElementById('has_account_code').value==1)
			document.getElementById('tdlist_account',).style.display='';
		else if(document.getElementById('has_account_code').value==0)
			document.getElementById('tdlist_account').style.display='none';
	}
    function control()
    {
		if(document.search.is_excel.checked==false)
			{
				document.search.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.member_account_code"
				return true;
			}
			else
				document.search.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_member_account_code</cfoutput>"
	}
</script>
