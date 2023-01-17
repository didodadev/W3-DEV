<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
</cfquery>
<cfquery name="get_departments" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id#
</cfquery>
<table>
	<tr>
		<td class="formbold" height="25"><cfoutput>#get_branch.branch_name# - #attributes.norm_year#</cfoutput></td>
	</tr>
</table>
<table cellspacing="1" cellpadding="2" border="0" class="color-border">
<cfform name="search_2" action="#request.self#?fuseaction=hr.emptypopup_add_norm_position_department_rate_action" method="post">
<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
<input type="hidden" name="norm_year" id="norm_year" value="<cfoutput>#attributes.norm_year#</cfoutput>">
	<tr class="color-header" height="22">
		<td class="form-title" width="150"><cf_get_lang dictionary_id="35449.Departman"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57592.Ocak"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57593.Şubat"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57594.Mart"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57595.Nisan"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57596.Mayıs"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57597.Haziran"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57598.Temmuz"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57599.Ağustos"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57600.Eylül"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57601.Ekim"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57602.Kasım"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57603.Aralık"></td>
	</tr>
	<cfoutput query="get_departments">
	<cfquery name="get_" datasource="#dsn#">
		SELECT 
            DEPARTMENT_ID, 
            AVERAGE_RATE_YEAR,
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_DATE, 
            UPDATE_IP 
        FROM 
    	    EMPLOYEE_NORM_POSITIONS_DEPT_RATE 
        WHERE 
	        DEPARTMENT_ID = #department_id# 
        AND 
        	AVERAGE_RATE_YEAR = #attributes.norm_year#
	</cfquery>
	<tr class="color-row" height="22">
		<td>#department_head#</td>
		<cfloop from="1" to="12" index="i">
			<td><input type="text" name="ongorulen_#i#_#department_id#" id="ongorulen_#i#_#department_id#" value="<cfif get_.recordcount and len(evaluate("get_.AVERAGE_RATE_#i#"))>#tlformat(evaluate('get_.AVERAGE_RATE_#i#'),6)#</cfif> " style="width:75px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,6));" onBlur="uygula('#i#','#department_id#')"></td>
		</cfloop>
	</tr>
	</cfoutput>
	<tr class="color-list">
		<td colspan="12">
			<strong><cf_get_lang dictionary_id="57483.Kayıt"> :</strong> <cfoutput>#get_emp_info(get_.record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_.record_date),timeformat_style)#)</cfoutput>
			<cfif len(get_.update_emp)>
				&nbsp;&nbsp;&nbsp;<strong><cf_get_lang dictionary_id="57703.Güncelleme"> :</strong> <cfoutput>#get_emp_info(get_.update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_.update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_.update_date),timeformat_style)#)</cfoutput>
			</cfif>
		</td>
		<td  style="text-align:right;"><input type="button" value="Güncelle" onClick="add_gonder();"></td>
	</tr>
</cfform>
</table>

<script type="text/javascript">
function uygula(ilgili_ay,departman_no)
{
	deger_ = eval("document.search_2.ongorulen_"+ilgili_ay+"_"+departman_no).value;
		for(var i=1; i<13; i++)
		{
			if(ilgili_ay < i)
				eval("document.search_2.ongorulen_"+i+"_"+departman_no).value = deger_;
		}
}
function add_gonder()
{
	<cfoutput query="get_departments">
		<cfloop from="1" to="12" index="i">
			document.search_2.ongorulen_#i#_#department_id#.value = filterNum(document.search_2.ongorulen_#i#_#department_id#.value,6);
		</cfloop>
	</cfoutput>
	AjaxFormSubmit(search_2,'MESSAGE_PLACE',1,'Kaydediliyor','Kaydedildi','<cfoutput>#request.self#?fuseaction=hr.emptypopup_add_norm_position_department_rate&branch_id=#attributes.branch_id#&norm_year=#attributes.norm_year#</cfoutput>','ADD_PLACE');
}
</script>
