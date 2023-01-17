<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.start_date" default='#dateformat(date_add("d", -7, now()),dateformat_style)#'>
<cfparam name="attributes.finish_date" default='#dateformat(now(),dateformat_style)#'>
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.start_date)>
  <cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
  <cf_date tarih='attributes.finish_date'>
</cfif>
<cfinclude template="../query/get_notices.cfm">
<cfparam name='attributes.totalrecords' default="#get_notices.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_notices" action="#request.self#?fuseaction=myhome.list_notices" method="post">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='31458.İK İlanları | INTRANET'></cfsavecontent>
	<cf_big_list_search title="#message#">
		<cf_big_list_search_area>
			<div class="row">
            	<div class="col col-12 form-inline">
                  <div class="form-group">
                    	<div class="input-group">
							<cfinput type="hidden" name="is_form_submitted" value="1">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
							<cfinput type="text" name="keyword" id="keyword" style="width:100px;" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
					   </div>
                  </div>
                    <div class="form-group">
                    	<div class="input-group">
							<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					  </div>
                 </div>
					<div class="form-group">
                    	<div class="input-group">
							<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                      </div>
                 </div>
                 <div class="form-group x-3_5">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group">
						<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
						<cf_wrk_search_button search_function="date_check(search_notices.start_date,search_notices.finish_date,'#message_date#')">
					</div>
				</div>
			</div>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_big_list> 
	<thead>
		<tr>
			<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="180"><cf_get_lang dictionary_id='31477.İlan Başlığı'></th>
			<th width="180"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
			<th width="180"><cf_get_lang dictionary_id='57574.Şirket'></th>
			<th width="180"><cf_get_lang dictionary_id='57971.Şehir'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_notices.recordcount and form_varmi eq 1>
		  <cfoutput query="get_notices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
            	<cfif fusebox.circuit eq 'myhome'>
                	<cfset notice_id_ = contentEncryptingandDecodingAES(isEncode:1,content:notice_id,accountKey:session.ep.userid)>
               	<cfelse>
                  	<cfset notice_id_ = notice_id>
               	</cfif>
				<td width="35">#currentrow#</td>
				 <td width="50"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_notice&notice_id=#notice_id_#','page');" class="tableyazi">#NOTICE_NO#</a></td>
				<td width="90"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_notice&notice_id=#notice_id_#','page');" class="tableyazi">#notice_head#</a></td>
				<td>#POSITION_NAME#</td>
				<cfif len(get_notices.department_id) and len(get_notices.branch_id) and len(get_notices.our_company_id)>
					<cfquery name="get_branchs" datasource="#dsn#">
						SELECT 
							BRANCH.BRANCH_NAME,
							DEPARTMENT.DEPARTMENT_HEAD,
							OUR_COMPANY.NICK_NAME,
							OUR_COMPANY.COMPANY_NAME
						FROM 
							DEPARTMENT,
							BRANCH,
							OUR_COMPANY
						WHERE 
							OUR_COMPANY.COMP_ID=#get_notices.our_company_id# AND
							BRANCH.BRANCH_ID= #get_notices.branch_id# AND
							DEPARTMENT_ID = #get_notices.department_id#
					</cfquery>
				</cfif>
				<td><cfif len(get_notices.company_id) and get_notices.is_view_company_name eq 1>#get_par_info(get_notices.company_id,1,0,0)#<cfelseif len(get_notices.department_id) and len(get_notices.branch_id) and len(get_notices.our_company_id) and get_notices.is_view_company_name eq 1>#get_branchs.nick_name#</cfif>&nbsp;</td>
				<td width="90">
					<cfif listlen(get_notices.notice_city) and listfind(get_notices.notice_city,0,',')>
						<cf_get_lang dictionary_id='31704.Tüm Türkiye'>
					<cfelseif listlen(get_notices.notice_city)>
					<cfset row_count = 0>
					<cfloop list="#get_notices.notice_city#" index="i">
						<cfset row_count = row_count + 1>
						<cfquery name="GET_CITY" datasource="#dsn#">
							SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #i# 
						</cfquery>
						  #GET_CITY.city_name#<cfif row_count lt listlen(get_notices.notice_city,',')>, </cfif>
					 </cfloop>
					</cfif>
				</td>
			</tr>
		  </cfoutput>
		  <cfelse>
		  <tr>
			<td colspan="6"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
		  </tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>

<cf_paging 
	page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="myhome.list_notices#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>