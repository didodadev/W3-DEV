<cfset last_puantaj_cmp = createObject("component","V16.myhome.cfc.get_puantaj")>
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.sal_year_end" default="#year(now())#">
<cfparam name="attributes.sal_mon_end" default="#month(now())#">
<cfset GET_PUANTAJ_PERSONAL = last_puantaj_cmp.GET_PUANTAJ_PERSONAL(
	employee_id = session.ep.userid,
	position_code = session.ep.position_code,
	sal_year = attributes.sal_year,
	sal_mon = attributes.sal_mon,
	sal_year_end = attributes.sal_year_end,
	sal_mon_end = attributes.sal_mon_end,
	is_bireysel_bordro : 1
)>
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id="31444.Bordro"></cfsavecontent>
<cfset emp_id=contentEncryptingandDecodingAES(isEncode:1,content:session.ep.userid,accountKey:'wrk')>

<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfscript>
	url_str = "";
	if (len(attributes.sal_year))
		url_str = "#url_str#&sal_year=#attributes.sal_year#";
	if (len(attributes.sal_mon))
		url_str = "#url_str#&sal_mon=#attributes.sal_mon#";
	if (len(attributes.sal_year_end))
		url_str = "#url_str#&sal_year_end=#attributes.sal_year_end#";
	if (len(attributes.sal_mon_end))
		url_str = "#url_str#&sal_mon_end=#attributes.sal_mon_end#";	
</cfscript>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default='#GET_PUANTAJ_PERSONAL.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#head#" closable="0" collapsed="0">
	<!--- BORDRO FİLTRE --->
	<cfform name="bordro_filtre" method="post" action="#request.self#?fuseaction=myhome.my_extre">
		<input type="hidden" name="employee_id" id="employee_id" value="">
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-sal_mon">
					<label class="col col-4 col-xs-12">
						<cf_get_lang dictionary_id="58053.Başlangıç Tarihi">
					</label>
					<div class="col col-4 col-xs-12">
						<div class="form-group">
							<select name="sal_mon" id="sal_mon">
								<cfloop from="1" to="12" index="i">
									<cfoutput>
										<option value="#i#" <cfif i eq attributes.sal_mon>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="col col-4 col-xs-12">
						<div class="form-group">
							<select name="sal_year" id="sal_year">
								<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
									<cfoutput>
										<option value="#i#" <cfif attributes.sal_year eq i>selected</cfif>>#i#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-sal_mon">
					<label class="col col-4 col-xs-12">
						<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>
					</label>
					<div class="col col-4 col-xs-12">
						<select name="sal_mon_end" id="sal_mon_end">
							<cfloop from="1" to="12" index="i">
								<cfoutput>
									<option value="#i#" <cfif attributes.sal_mon_end eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
								</cfoutput>
							</cfloop>
						</select>
					</div>
					<div class="col col-4 col-xs-12">
						<select name="sal_year_end" id="sal_year_end">
							<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
								<cfoutput>
									<option value="#i#" <cfif attributes.sal_year_end eq i>selected</cfif>>#i#</option>
								</cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_wrk_search_button search_function="control_date()">
		</cf_box_footer>
	</cfform>
	<!--- // BORDRO FİLTRE --->

	<cf_flat_list>
		<thead>
			<tr>
				<th><cfoutput>#head#</cfoutput></th>
				<th width="20"><a href="javascript://"><i class="fa fa-table"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="GET_PUANTAJ_PERSONAL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>
						#listgetat(ay_list(),sal_mon,',')# - #sal_year#
					</td>
					<td><a href="#request.self#?fuseaction=myhome.list_my_bordro_ajax&sal_year=#sal_year#&employee_id=#emp_id#&sal_mon=#sal_mon#" title="<cf_get_lang dictionary_id='46905.Görüntüle'>"><i class="fa fa-table"></i></a></td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_flat_list>	 
	<cf_paging
		name="bordro_filtre"
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="myhome.my_extre#url_str#"
		>
</cf_box>
<script type="text/javascript">
	function control_date()
	{
		if (parseInt(document.getElementById('sal_year').value) == parseInt(document.getElementById('sal_year_end').value))
		{
			if (parseInt(document.getElementById('sal_mon').value) > parseInt(document.getElementById('sal_mon_end').value))
			{
				
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>.");
				return false;
			}
		}
		else if (parseInt(document.getElementById('sal_year').value) > parseInt(document.getElementById('sal_year_end').value))
		{
			
			{
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.'>.");
				return false;
			}
		}
		return true;
	}
</script>