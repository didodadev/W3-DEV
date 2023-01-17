<cfif isDefined('session.pp.userid')>
    <cfquery name="GET_COMPANY_PARTNERS" datasource="#DSN#">
        SELECT PARTNER_ID,COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
    </cfquery>
</cfif>
<cfquery name="GET_PROJECTS" datasource="#DSN#">
	SELECT 
		DISTINCT(PRO_PROJECTS.PROJECT_ID),
		PRO_PROJECTS.PROJECT_HEAD
	FROM 
		WORK_GROUP WG,
		WORKGROUP_EMP_PAR WEP,
		PRO_PROJECTS
	WHERE
		WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND 
		(	
			PRO_PROJECTS.PROJECT_ID = WG.PROJECT_ID OR 
			WG.PROJECT_ID IS NULL 
		)
        <cfif isDefined('session.pp.userid')>
            AND
            (	
                PRO_PROJECTS.OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
                PRO_PROJECTS.OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                PRO_PROJECTS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                PRO_PROJECTS.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
                PRO_PROJECTS.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
                WEP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
                WEP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
            )
        </cfif>
		AND PRO_PROJECTS.PROJECT_STATUS=1
</cfquery>
<cfinclude template="../query/get_company_size_cats.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
	SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE IS_INTERNET = 1
</cfquery>
<cfquery name="GET_COMMETHOD_CATS" datasource="#dsn#">
	SELECT COMMETHOD_ID, COMMETHOD FROM SETUP_COMMETHOD ORDER BY COMMETHOD
</cfquery>
<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
	SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE WHERE IS_INTERNET = 1 ORDER BY OPPORTUNITY_TYPE
</cfquery>
<cf_papers paper_type="OPPORTUNITY">
<cfform name="add_opp" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_opportunity" onsubmit="return (unformat_fields());">
<input type="hidden" name="is_popup" id="is_popup" value="<cfif attributes.fuseaction contains 'popup'>1<cfelse>0</cfif>">
	<table>
		<tr>
			<td colspan="4">
		  		<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık Girmelisiniz'> !</cfsavecontent>
		  		&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'>* &nbsp;&nbsp;<cfinput type="text" name="opp_head" id="opp_head" value="" required="yes" message="#message#" style="width:450px;">
			</td>			
			<td><cf_get_lang no='468.Basvuru tarihi'></td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='1357.Başvuru Tarihi Girmelisiniz'></cfsavecontent> 
				<cfinput type="text" name="opp_date" id="opp_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" message="#message#" maxlength="10" style="width:70px;">
				<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_calender&alan=add_opp.opp_date','date');"><img src="/images/calendar.gif" align="absmiddle" border="0"></a>
			</td>
	  	</tr>	
	  	<tr>
			<td rowspan="7" colspan="4" style="vertical-align:top">
				<cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarset="Basic"
					basepath="/fckeditor/"
					instancename="opp_detail"
					valign="top"
					value=""
					width="500"
					height="200">
			</td>
	  	</tr>
	  	<tr>
			<td style="width:80px;"><cf_get_lang_main no='74.Kategori'>*</td>
			<td>
				<select name="opportunity_type_id" id="opportunity_type_id" style="width:170px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_opportunity_type">
						<option value="#opportunity_type_id#">#opportunity_type#</option>
					</cfoutput>
			  	</select>
			</td>
	  	</tr>
        <cfif isDefined('session.pp.userid')>
            <tr>
                <td><cf_get_lang no='429.Satış Ortağı'></td>
                <td>
                    <select name="sales_partner_id" id="sales_partner_id" style="width:170px;">
                        <cfif get_company_partners.recordcount>
                            <cfoutput query="get_company_partners">
                                <option value="#partner_id#" <cfif isdefined('session.pp') and partner_id eq session.pp.userid>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
                            </cfoutput>
                        <cfelse>
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        </cfif>
                    </select>
                </td>
            </tr>
        </cfif>
	  	<tr>
			<td><cf_get_lang no='430.Hareket'></td>
			<td>
				<select name="activity_time" id="activity_time" style="width:170px;" size="1">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<option value="1"><cf_get_lang no ='436.Hemen'></option>
					<option value="7">1 <cf_get_lang_main no ='1322.Hafta'></option>
					<option value="30">1<cf_get_lang_main no ='1312.Ay'> </option>
					<option value="90">3 <cf_get_lang_main no ='1312.Ay'></option>
					<option value="180">6 <cf_get_lang_main no ='1312.Ay'></option>
					<option value="180">6 <cf_get_lang no ='1452.Aydan Fazla'></option>
			  	</select>
			</td>
	  	</tr>
	  	<tr>
			<td><cf_get_lang_main no='731.İletişim'></td>
			<td>
				<select name="commethod_id" id="commethod_id" style="width:170px;" size="1">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_commethod_cats">
						<option value="#get_commethod_cats.commethod_id#">#get_commethod_cats.commethod#</option>
					</cfoutput>
			  	</select>
			</td>
	  	</tr>
	  	<tr>
			<td><cf_get_lang_main no='1240.Olasılık'></td>
			<td>
		  		<select name="probability" id="probability" style="width:170px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<option value="10">%10</option>
					<option value="20">%20</option>
					<option value="30">%30</option>
					<option value="40">%40</option>
					<option value="50">%50</option>
					<option value="60">%60</option>
					<option value="70">%70</option>
					<option value="80">%80</option>
					<option value="90">%90</option>
					<option value="100">%100</option>
		  		</select>
			</td>
	  	</tr>
	  	<tr>
			<td colspan="2">
                <cf_workcube_to_cc 
                    is_update="0" 
                    to_dsp_name="Müşteriler" 
                    form_name="add_opp" 
                    str_list_param="10,11" 
                    data_type="1"> 	
				<!--- <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
					<input type="hidden" name="consumer_id" id="consumer_id" value="" />
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>" />
					<input type="hidden" name="partner_id" id="partner_id" value="" />
					<input type="text" name="member_name" id="member_name" style="width:170px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\',\'0\',\'\',\'\',\'2\',\'1\'','PARTNER_ID,COMPANY_ID,CONSUMER_ID','partner_id,company_id,consumer_id','add_opp','3','250');" value="<cfoutput>#get_par_info(attributes.company_id,1,0,0)#</cfoutput>" autocomplete="off">
				<cfelse>
					<input type="hidden" name="consumer_id" id="consumer_id" value="" />
					<input type="hidden" name="company_id" id="company_id" value="" />
					<input type="hidden" name="partner_id" id="partner_id" value="" />
					<input type="text" name="member_name" id="member_name" style="width:170px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\'','PARTNER_ID,COMPANY_ID,CONSUMER_ID','partner_id,company_id,consumer_id','add_opp','3','250');" value="" autocomplete="off">
				</cfif>--->
			</td>
	  	</tr>
	  	<tr>
			<td><cf_get_lang no='433.Tahmini Gelir'></td>
			<td>
		  		<cfsavecontent variable="message"><cf_get_lang no='189.Gelir Girmelisiniz'></cfsavecontent>
		  		<cfinput type="text" name="income" id="income" value="" message="#message#" class="moneybox" passthrough="onkeyup=""return(formatcurrency(this,event));""" style="width:86px;">
		  		<select name="money" id="money" style="width:50px;">
					<cfoutput query="get_moneys">
						<option value="#money#"<cfif isDefined('session.pp.userid') and money eq session.pp.money>selected</cfif>>#money#</option>
					</cfoutput>
			    </select>
			</td>
			<td><cf_get_lang_main no= '4.Proje'></td>
			<td><select name="project_id" id="project_id" style="width:140px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_projects">
						<option value="#project_id#">#project_head#</option>
					</cfoutput>
				</select>
			</td>
	  	</tr>
	  	<tr>
			<td><cf_get_lang no='431.Tahmini Maliyet'></td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang no ='1451.Maliyet Girmelisiniz'></cfsavecontent>
			  	<cfinput type="text" name="cost" id="cost" value="" message="#message#" class="moneybox" passthrough="onkeyup=""return(formatcurrency(this,event));""" style="width:86px;">
			  	<select name="money2" id="money2" style="width:50px;">
					<cfoutput query="get_moneys">
						<option value="#money#"<cfif isDefined('session.pp.userid') and money eq session.pp.money>selected</cfif>>#money#</option>
					</cfoutput>
			  	</select>
			</td>
			<td><cf_get_lang no='432.Özel Tanım'></td>
			<td>
			  	<select name="sales_add_option" id="sales_add_option" style="width:140px;" size="1">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_sale_add_option">
						<option value="#get_sale_add_option.sales_add_option_id#">#get_sale_add_option.sales_add_option_name#</option>
					</cfoutput>
				</select>
			</td>
	  	</tr>
	  	<tr style="height:35px;">
			<td colspan="5"></td>
			<td colspan="2"><cf_workcube_buttons is_upd='0' add_function='kontrol() && OnFormSubmit()'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  	</tr>
	</table>
</cfform>
<br/>
<script type="text/javascript">
	function kontrol()
	{
		if (document.add_opp.opportunity_type_id[add_opp.opportunity_type_id.selectedIndex].value == '')
		{
			alert ("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'>!");
			return false;
		}
		if ((document.getElementById('member_name').value == '' || document.getElementById('partner_id').value == '') && (document.getElementById('member_name').value == '' || document.getElementById('consumer_id').value == '') && (document.getElementById('member_name').value == '' || document.getElementById('company_id').value == ''))
		{
			alert ("<cf_get_lang no='467.Müşteri Seçmelisiniz'>!");
			return false;
		}
	}
	
	function unformat_fields()
	{
		document.getElementById('income').value = filterNum(document.getElementById('income').value);
		document.getElementById('cost').value = filterNum(document.getElementById('cost').value);
		return OnFormSubmit();
	}
</script>
