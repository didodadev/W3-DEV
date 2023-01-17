<!--- Muhasebe Rasyo Raporu: Seçilen hesap ve karşı hesabın bakiyesi ve bu bakiyelerin oranını gösterir. OZDEN20070329 --->
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.acc_code" default="">
<cfparam name="attributes.other_acc_code" default="">
<cfparam name="attributes.row_count" default="2">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfif isdefined('attributes.is_submitted')>
	<cf_date tarih='attributes.date1'>
	<cf_date tarih='attributes.date2'>
	<cfset all_acc_list =''>
	<cfif len(attributes.acc_code) and len(attributes.other_acc_code)>
		<cfset all_acc_list = listappend(all_acc_list,attributes.acc_code)>
		<cfset all_acc_list = listappend(all_acc_list,attributes.other_acc_code)>
		<cfquery name="GET_ACC_DETAIL" datasource="#dsn2#">
			SELECT ACCOUNT_CODE,ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE IN (#listqualify(all_acc_list,"'")#) ORDER BY ACCOUNT_CODE
		</cfquery>
		<cfset account_code_list=valuelist(GET_ACC_DETAIL.ACCOUNT_CODE)>
		<cfquery name="GET_ACC_TOTAL" datasource="#dsn2#">
			SELECT
				SUM(AMOUNT_TOTAL) AS AMOUNT_TOTAL,
				SUM(AMOUNT_TOTAL_2) AS AMOUNT_TOTAL_2,
				ACCOUNT_CODE,
				BA
			FROM
				GET_ALL_ACC_CODE_DAILY_TOTAL
			WHERE
				ACCOUNT_CODE IN (#listqualify(all_acc_list,"'")#)
			<cfif isdate(attributes.date1)>
				AND ACTION_DATE >= #attributes.date1#
			</cfif>
			<cfif isdate(attributes.date2)>
				AND ACTION_DATE <= #attributes.date2#
			</cfif>
			GROUP BY
				ACCOUNT_CODE,
				BA
		</cfquery>
		<cfoutput>
			<cfscript>
				for(index_i=1; index_i lte attributes.row_count; index_i=index_i+1)
				{   /*sadece rasyo hesaplamalarında kullanılacak degiskenler set ediliyor*/
					'acc_code_borc_amount_#index_i#' = 0;
					'acc_code_alacak_amount_#index_i#'= 0;
					'other_acc_code_borc_amount_#index_i#' = 0;
					'other_acc_code_alacak_amount_#index_i#' = 0;
					for(ddd=1; ddd lte GET_ACC_TOTAL.recordcount; ddd=ddd+1)
					{
						if(listgetat(attributes.acc_code,index_i) eq GET_ACC_TOTAL.ACCOUNT_CODE[ddd] )
						{
							if(GET_ACC_TOTAL.BA[ddd] eq 0)
							{
							'acc_code_borc_amount_#index_i#' = GET_ACC_TOTAL.AMOUNT_TOTAL[ddd];
							'acc_code_borc_amount2_#index_i#'= GET_ACC_TOTAL.AMOUNT_TOTAL_2[ddd];
							}
							else
							{
							'acc_code_alacak_amount_#index_i#' = GET_ACC_TOTAL.AMOUNT_TOTAL[ddd];
							'acc_code_alacak_amount2_#index_i#'= GET_ACC_TOTAL.AMOUNT_TOTAL_2[ddd];
							}
						}
						if(listgetat(attributes.other_acc_code,index_i) eq GET_ACC_TOTAL.ACCOUNT_CODE[ddd] )
						{
							if(GET_ACC_TOTAL.BA[ddd] eq 0)
							{
							'other_acc_code_borc_amount_#index_i#' =GET_ACC_TOTAL.AMOUNT_TOTAL[ddd];
							'other_acc_code_borc_amount2_#index_i#'=GET_ACC_TOTAL.AMOUNT_TOTAL_2[ddd];
							}
							else
							{
							'other_acc_code_alacak_amount_#index_i#' =GET_ACC_TOTAL.AMOUNT_TOTAL[ddd];
							'other_acc_code_alacak_amount2_#index_i#'=GET_ACC_TOTAL.AMOUNT_TOTAL_2[ddd];
							}
						}
					}
				}
			</cfscript>
		</cfoutput>
	</cfif>
</cfif>
<table class="dph">
	<tr>
		<td class="dpht"><a href="javascript:gizle_goster_ikili('gizli','ratio_basket');">&raquo;</a><cf_get_lang dictionary_id ='39585.Rasyo'></td>
		<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
	</tr>
</table> 
<cfform name="ratio_report" action="index.cfm?fuseaction=report.ratio_report" method="post">
<cf_basket_form id="gizli">
<table>
    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <input type="hidden" name="row_count" id="row_count" value="<cfoutput>#attributes.row_count#</cfoutput>">
    <tr>
        <td><cf_get_lang dictionary_id ='57742.Tarih'>&nbsp;
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz !'></cfsavecontent>
            <cfif isdate(attributes.date1)>
                <cfset attributes.date1 = dateformat(attributes.date1, dateformat_style)>
            </cfif>
            <cfinput value="#attributes.date1#" required="Yes" message="#message#" type="text" name="date1" style="width:65px;" validate="#validate_style#" maxlength="10">
            <cf_wrk_date_image date_field="date1">
            <cfif isdate(attributes.date2)>
                <cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
            </cfif>
            <cfinput value="#attributes.date2#" required="Yes" message="#message#" type="text" name="date2" style="width:65px;" validate="#validate_style#" maxlength="10">
            <cf_wrk_date_image date_field="date2">
        </td>
    </tr>					
    <tr>
        <td>
			<cf_form_list margin="0">
				<thead>
					<tr>
						<th><input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row(document.ratio_report.row_count.value);">&nbsp;<cf_get_lang dictionary_id ='57652.Hesap'></th>
						<th><cf_get_lang dictionary_id ='40365.Karşı Hesap'></th>
					</tr>
				</thead>
				<tbody id="acc_code_rows">
					<cfloop from="1" to="#attributes.row_count#" index="row_no">
					<tr>
						<td nowrap style="text-align:right;">
							<a href="javascript://" onClick="del_row(this.parentNode.parentNode.rowIndex);"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id='57463.Sil'>" border="0"></a>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='39340.Hesap Kodu Seçmediniz'></cfsavecontent>
							<input message="#message#" type="text" value="<cfif listlen(attributes.acc_code) gte row_no><cfoutput>#listgetat(attributes.acc_code,row_no)#</cfoutput></cfif>" name="acc_code" id="acc_code" style="width:110px;">
							<a href="javascript://" onClick="pencere_ac('ratio_report.acc_code',this.parentNode.parentNode.rowIndex+1);"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</td>				
						<td nowrap style="text-align:right;">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='39340.Hesap Kodu Seçmediniz'></cfsavecontent>
							<input message="#message#" type="Text"  value="<cfif listlen(attributes.other_acc_code) gte row_no><cfoutput>#listgetat(attributes.other_acc_code,row_no)#</cfoutput></cfif>" name="other_acc_code" id="other_acc_code" style="width:110px;">
							<a href="javascript://" onClick="pencere_ac('ratio_report.other_acc_code',this.parentNode.parentNode.rowIndex+1);"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</td>		
					</tr>	
					</cfloop>
				</tbody>
			</cf_form_list>
        </td>
    </tr>
</table>
<cf_basket_form_button>
    <cf_wrk_search_button button_type='1' is_excel='0' search_function='acc_control()'>
</cf_basket_form_button>
</cf_basket_form>
</cfform>  
<cf_basket id="ratio_basket">
<cfif isdefined('attributes.is_submitted')>
    <table class="basket_list">
    	<thead>
            <tr>
                <th><cf_get_lang dictionary_id ='38889.Hesap Kodu'></th>
                <th><cf_get_lang dictionary_id ='38890.Hesap Adı'></th>
                <th><cfoutput>#session.ep.money#</cfoutput><cf_get_lang dictionary_id ='57587.Borç'> </th>
                <th><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id ='57588.Alacak'></th>
                <th><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang dictionary_id ='57587.Borç'></th>
                <th><cfoutput>#session.ep.money2#</cfoutput>  <cf_get_lang dictionary_id ='57588.Alacak'></th>
                <th width="2px;">&nbsp;</th>
                <th><cf_get_lang dictionary_id ='38889.Hesap Kodu'></th>
                <th><cf_get_lang dictionary_id ='38890.Hesap Adı'></th>
                <th><cfoutput>#session.ep.money#</cfoutput><cf_get_lang dictionary_id ='57587.Borç'></th>
                <th><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id ='57588.Alacak'></th>
                <th><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang dictionary_id ='57587.Borç'></th>
                <th><cfoutput>#session.ep.money2#</cfoutput>  <cf_get_lang dictionary_id ='57588.Alacak'></th>
                <th nowrap><cf_get_lang dictionary_id ='39585.Rasyo'> (B)</th>
                <th nowrap><cf_get_lang dictionary_id ='39585.Rasyo'> (A)</th>
            </tr>
        </thead>
        <tbody>
        <cfoutput>
        <cfloop from="1" to="#attributes.row_count#" index="row_i">
            <tr class="color-list" height="20"> 
                <td>#listgetat(attributes.acc_code,row_i)#</td>
                <td>#GET_ACC_DETAIL.ACCOUNT_NAME[listfind(account_code_list,listgetat(attributes.acc_code,row_i))]#</td>
                <td align="right" style="text-align:right;">
                    <cfif isdefined('acc_code_borc_amount_#row_i#') and len(evaluate('acc_code_borc_amount_#row_i#'))>
                        #TLFormat(abs(evaluate('acc_code_borc_amount_#row_i#')))# 
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif isdefined('acc_code_alacak_amount_#row_i#') and len(evaluate('acc_code_alacak_amount_#row_i#'))>
                        #TLFormat(abs(evaluate('acc_code_alacak_amount_#row_i#')))#
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif isdefined('acc_code_borc_amount2_#row_i#') and len(evaluate('acc_code_borc_amount2_#row_i#'))>
                        #TLFormat(abs(evaluate('acc_code_borc_amount2_#row_i#')))#
                    <cfelse>
                        #TLFormat(0)#
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif isdefined('acc_code_alacak_amount2_#row_i#') and len(evaluate('acc_code_alacak_amount2_#row_i#'))>
                        #TLFormat(abs(evaluate('acc_code_alacak_amount2_#row_i#')))#
                    <cfelse>
                        #TLFormat(0)#
                    </cfif>
                </td>
                <td width="2px;">&nbsp;</td>
                <td>#listgetat(attributes.other_acc_code,row_i)#</td>
                <td>#GET_ACC_DETAIL.ACCOUNT_NAME[listfind(account_code_list,listgetat(attributes.other_acc_code,row_i))]#</td>
                <td align="right" style="text-align:right;">
                    <cfif isdefined('other_acc_code_borc_amount_#row_i#') and len(evaluate('other_acc_code_borc_amount_#row_i#'))>
                        #TLFormat(abs(evaluate('other_acc_code_borc_amount_#row_i#')))#
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif isdefined('other_acc_code_alacak_amount_#row_i#') and len(evaluate('other_acc_code_alacak_amount_#row_i#'))>
                        #TLFormat(abs(evaluate('other_acc_code_alacak_amount_#row_i#')))#
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif isdefined('other_acc_code_borc_amount2_#row_i#') and len(evaluate('other_acc_code_borc_amount2_#row_i#'))>
                        #TLFormat(abs(evaluate('other_acc_code_borc_amount2_#row_i#')))#
                    <cfelse>
                        #TLFormat(0)#
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif isdefined('other_acc_code_alacak_amount2_#row_i#') and len(evaluate('other_acc_code_alacak_amount2_#row_i#'))>
                        #TLFormat(abs(evaluate('other_acc_code_alacak_amount2_#row_i#')))#
                    <cfelse>
                        #TLFormat(0)#
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif (evaluate('acc_code_borc_amount_#row_i#')+evaluate('other_acc_code_borc_amount_#row_i#')) neq 0>
                        %#wrk_round(abs((evaluate('acc_code_borc_amount_#row_i#')*100)/(evaluate('acc_code_borc_amount_#row_i#')+evaluate('other_acc_code_borc_amount_#row_i#'))))#
                    <cfelse>%0</cfif>
                </td>
                <td align="right" style="text-align:right;">
                    <cfif (evaluate('acc_code_alacak_amount_#row_i#')+evaluate('other_acc_code_alacak_amount_#row_i#')) neq 0>
                        %#wrk_round((evaluate('acc_code_alacak_amount_#row_i#')*100)/(evaluate('acc_code_alacak_amount_#row_i#')+evaluate('other_acc_code_alacak_amount_#row_i#')))#
                    <cfelse>%0</cfif>
                </td>
            </tr>	
        </cfloop>
        </cfoutput>
        </tbody>
    </table>
</cfif>
</cf_basket>
<script type="text/javascript">
function del_row(del_row_no)
{
	acc_code_rows.deleteRow(del_row_no);
	var all_row_count = document.ratio_report.row_count.value;
	document.ratio_report.row_count.value = all_row_count-1;
}
function add_row(row_count)
{
	row_count++;
	ratio_report.row_count.value = row_count;
	var newRow;
	var newCell;
	newRow = document.getElementById("acc_code_rows").insertRow(document.getElementById("acc_code_rows").rows.length);
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = row_count;
	newCell.innerHTML = '<a href="javascript://" onClick="del_row(this.parentNode.parentNode.rowIndex);"><img src="/images/delete_list.gif" border="0"></a>&nbsp;';
	newCell.innerHTML += '<input type="text" name="acc_code" style="width:110px;"> ';
	newCell.innerHTML += '<a href="javascript://" onClick=pencere_ac("ratio_report.acc_code",this.parentNode.parentNode.rowIndex+1);><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML =  '<input type="text" name="other_acc_code" style="width:110px;">&nbsp;';
	newCell.innerHTML += '<a href="javascript://" onClick=pencere_ac("ratio_report.other_acc_code",this.parentNode.parentNode.rowIndex+1);><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
}
function acc_control()
{ 
	var row_number = document.ratio_report.row_count.value;
	if(row_number == 1)
		{
			if(eval('ratio_report.acc_code.value') == '')
			{
				alert((row_number) +" <cf_get_lang dictionary_id ='40366.Satırda Hesap Kodu Seçilmemiş'>");
				return false;
			}
			if(eval('ratio_report.other_acc_code.value ')== '')
			{
				alert((row_number) +"<cf_get_lang dictionary_id ='40367.Satırda Karşı Hesap Kodu Seçilmemiş'> ");
				return false;
			}
		}
	else
	{
		for(c_index=0; c_index < row_number; c_index++)
		{
			if(eval('ratio_report.acc_code['+c_index+']').value == '')
			{
				alert((c_index+1) +" <cf_get_lang dictionary_id ='40366.Satırda Hesap Kodu Seçilmemiş'>");
				return false;
			}
			if(eval('ratio_report.other_acc_code['+c_index+']').value == '')
			{
				alert((c_index+1) +"<cf_get_lang dictionary_id ='40367.Satırda Karşı Hesap Kodu Seçilmemiş'> ");
				return false;
			}
		}
	}
	return true;
}

function pencere_ac(str_alan_1,row_)
{	
	row_ --;
	if(ratio_report.row_count.value == 1)
		str_field_name = str_alan_1;
	else
		str_field_name = str_alan_1+'[' + row_ + ']';
	if (eval(str_alan_1+'.value') != '')
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_field_name+'&account_code=' + eval(str_field_name + '.value'), 'list');
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_field_name, 'list');
}
</script>
