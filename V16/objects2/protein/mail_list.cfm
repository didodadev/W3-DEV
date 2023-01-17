<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='25'>
<cfparam name="attributes.emp_list" default="">
<cfparam name="attributes.partner_id_list" default="">
<cfparam name="attributes.consumer_list" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.names" default="">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.mail_id" default="">
<cfparam name="attributes.title" default="">
<cfset url_string = 'widgetloader?widget_load=mailList&isbox=1&draggable=1'>
<cfif isdefined("attributes.style") and len(attributes.style)>
	<cfset url_string = '#url_string#&style=#attributes.style#'>
</cfif>
<cfif isdefined("attributes.title") and len(attributes.title)>
	<cfset url_string = '#url_string#&title=#attributes.title#'>
</cfif>

<script type="text/javascript">
	var n  = '';
	var c  = '';
	var e  = '';
	var p  = '';
	var no = '';
	var old_names = document.<cfoutput>#attributes.names#</cfoutput>.value;
	<cfif isDefined("attributes.employee_ids")>
		var old_emps = $('#<cfoutput>#ListFirst(attributes.employee_ids,'.')# ###ListLast(attributes.employee_ids,'.')#</cfoutput>').val();
		e = old_emps;
	</cfif>
	<cfif isDefined("attributes.consumer_ids")>
		var old_cons = $('#<cfoutput>#ListFirst(attributes.consumer_ids,'.')# ###ListLast(attributes.consumer_ids,'.')#</cfoutput>').val();
		c = old_cons;
	</cfif>
	<cfif isDefined("attributes.partner_ids")>
		var old_pars = $('#<cfoutput>#ListFirst(attributes.partner_ids,'.')# ###ListLast(attributes.partner_ids,'.')#</cfoutput>').val();
		p = old_pars;
	</cfif>
	var old_ids = document.<cfoutput>#attributes.mail_id#</cfoutput>.value;		
	if(old_names != '')
		n = old_names;
	if(old_ids != '')
		no = old_ids;	
	function don(names,nos,pid,cid,empid)
	{
		if (extra_values.receivers.value != '')
			n = extra_values.receivers.value;

		if (extra_values.receivers_no.value != '')
			no = extra_values.receivers_no.value;						 
							
		if (nos == ''){
			alert(n + " <cf_get_lang dictionary_id='32780.Kullanıcının Mail Adresi Olmadığından Listeye Eklenmedi !'>");
			document.<cfoutput>#attributes.names#</cfoutput>.value  = '';
			document.<cfoutput>#attributes.mail_id#</cfoutput>.value = '';
			return false;			 
		}
		if ((nos.indexOf("@") == -1) || (nos.indexOf(".") == -1) || (nos.length < 6)){
			alert("<cf_get_lang dictionary_id='32757.Girdiğiniz Mail Geçerli Değil !'>");
			return false;			
		}
							
		if (n == '') 
			n = nos;
		else	 
			n  = n + ',' + nos;
		if (no == '')	 
			no = nos;
		else	 
			no = no + ',' + nos;	
		<cfif isDefined("attributes.employee_ids")>
			if (e == '') 
				e = empid;
			else	 
				e  = e + ',' + empid;
				$('#<cfoutput>#ListFirst(attributes.employee_ids,'.')# ###ListLast(attributes.employee_ids,'.')#</cfoutput>').val(e);	
		</cfif>
		<cfif isDefined("attributes.partner_ids")>
			if (p == '') 
				p = pid;
			else	 
				p  = p + ',' + pid;
			$('#<cfoutput>#ListFirst(attributes.partner_ids,'.')# ###ListLast(attributes.partner_ids,'.')#</cfoutput>').val(p);
		</cfif>
		<cfif isDefined("attributes.consumer_ids")>
			if (c == '') 
				c = cid;
			else	 
				c  = c + ',' + cid;
			$('#<cfoutput>#ListFirst(attributes.consumer_ids,'.')# ###ListLast(attributes.consumer_ids,'.')#</cfoutput>').val(c);
		</cfif>
		document.<cfoutput>#attributes.names#</cfoutput>.value  = n;
		document.<cfoutput>#attributes.mail_id#</cfoutput>.value = no;
		extra_values.receivers.value = n;
		extra_values.receivers_no.value = no;
	}
</script>
<cfset QE1.recordcount = 0>
	<cfquery name="QE1" datasource="#dsn#">
		SELECT 
			AB_NAME,
			AB_SURNAME,
			AB_EMAIL,
			PARTNER_ID,
			EMPLOYEE_ID,
			CONSUMER_ID,
			AB_COMPANY 
		FROM 
			ADDRESSBOOK 
		WHERE 
			AB_EMAIL <> ''
			AND IS_ACTIVE=1
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND 
				(
					AB_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%"> OR
					AB_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%"> OR
					AB_EMAIL LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
				)
			</cfif>
			<cfif len(attributes.emp_list) or len(attributes.partner_id_list) or len(attributes.consumer_list)>
				AND
				(
					<cfif isdefined("attributes.emp_list") and len(attributes.emp_list)>
						EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_list#" list="yes">) <cfif (isdefined("attributes.partner_id_list") and len(attributes.partner_id_list)) or (isdefined("attributes.consumer_list") and len(attributes.consumer_list))>OR </cfif>
					</cfif>
					<cfif isdefined("attributes.partner_id_list") and len(attributes.partner_id_list)>
						PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id_list#" list="yes">) <cfif (isdefined("attributes.consumer_list") and len(attributes.consumer_list))>OR </cfif>
					</cfif>
					<cfif isdefined("attributes.consumer_list") and len(attributes.consumer_list)>
						CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_list#" list="yes">)
					</cfif>
				)
			</cfif>			
		ORDER BY AB_NAME
	</cfquery>
<cfset rc = ''>
		<cfset rcno = ''>
		<cfif isDefined("attributes.receivers")>
			<cfset rc = attributes.receivers>
		</cfif>
		<cfif isDefined("attributes.receivers2")>   
			<cfif rc EQ ''>
				<cfset rc = attributes.receivers2>
			</cfif>
		</cfif>
		<cfif isDefined("attributes.receivers_no")>
			<cfset rcno = attributes.receivers_no>
		</cfif>
		<cfif isDefined("attributes.receivers2_no")>   
			<cfif rcno EQ ''>
				<cfset rcno = attributes.receivers2_no>
			</cfif>
		</cfif>
<cfform name="extra_values" id="extra_values" method="post" action="#url_string#" >			
    <input type="hidden" name="receivers" id="receivers" value="<cfoutput>#rc#</cfoutput>">
    <input type="hidden" name="receivers_no" id="receivers_no" value="<cfoutput>#rcno#</cfoutput>">
    <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1" />

    <div class="form-row">
        <div class="form-group col-lg-5">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57631.Ad'>, <cf_get_lang dictionary_id='58726.Soyad'>, <cf_get_lang dictionary_id='39210.Email'></cfsavecontent>
            <cfinput type="text" class="form-control" tabindex="1" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"  placeholder="#message#">
        </div>
    
        <div class="form-group col-lg-3">    
			<button type="button" id="search_btn" class="btn font-weight-bold text-uppercase btn-color-7" onclick="loadPopupBox('extra_values','<cfoutput>#attributes.modal_id#</cfoutput>')"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
		</div>
    </div>
 
</cfform>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default=#qe1.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="table-responsive ui-scroll">
    <table class="table">
        <thead class="main-bg-color">
            <tr>
                <th class="text-uppercase"><cf_get_lang dictionary_id='57487.No'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='57574.Şirket'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='57428.E-Mail'></th>
            </tr>
        </thead>
        <tbody>
			<cfif qe1.RecordCount eq 0>
				<tr>
                    <td colspan="4" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
			<cfelse>
                <cfoutput query="qe1" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                    <tr>
                        <td width="35">#qe1.CurrentRow#</td>
                        <td><a href="javascript://" onclick="don('#ab_name# #ab_surname#','#Trim(ab_email)#','#partner_id#','#consumer_id#','#employee_id#');">#ab_name# #ab_surname#&nbsp;</a></td>
                        <td>#ab_company#</td>
                        <td>#ab_email#&nbsp;</td>
                    </tr> 
                </cfoutput>
			</cfif>
        </tbody>
    </table>
	<cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>
		<cfset url_string = '#url_string#&mail_id=#attributes.mail_id#'>
	</cfif>
	<cfif isdefined("attributes.names") and len(attributes.names)>
		<cfset url_string = '#url_string#&names=#attributes.names#'>
	</cfif>
	<cfif isdefined("attributes.emp_list") and len(attributes.emp_list)>
		<cfset url_string = '#url_string#&emp_list=#attributes.emp_list#'>
	</cfif>
	<cfif isdefined("attributes.partner_id_list") and len(attributes.partner_id_list)>
		<cfset url_string = '#url_string#&partner_id_list=#attributes.partner_id_list#'>
	</cfif>
	<cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)>
		<cfset url_string = '#url_string#&consumer_ids=#attributes.consumer_ids#'>
	</cfif>
	<cfif isdefined("attributes.partner_ids") and len(attributes.partner_ids)>
		<cfset url_string = '#url_string#&partner_ids=#attributes.partner_ids#'>
	</cfif>
	<cfif isdefined("attributes.employee_ids") and len(attributes.employee_ids)>
		<cfset url_string = '#url_string#&employee_ids=#attributes.employee_ids#'>
	</cfif>
	<cfif isdefined("attributes.consumer_list") and len(attributes.consumer_list)>
		<cfset url_string = '#url_string#&consumer_list=#attributes.consumer_list#'>
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
	</cfif>
	<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
		<table width="99%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
			<tr>
				<td>
					<cf_pages 
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="#url_string#" 
						isAjax="1">
				</td>
				<td style="text-align:right"><cfoutput><cf_get_lang dictionary_id='57540.Total Record'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Page'>:#attributes.page#/#lastpage#</cfoutput> </td>
			</tr>
		</table>
	</cfif>
</div>
