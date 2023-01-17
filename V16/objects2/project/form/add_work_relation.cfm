<cfquery name="GET_PRO_WORKS" datasource="#DSN#">
    SELECT
        WORK_HEAD,
        WORK_ID,
        TARGET_START
    FROM 
        PRO_WORKS
    WHERE
        <cfif isdefined("attributes.pro_id") and len(attributes.pro_id)>
            PRO_WORKS.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_id#"> AND
        </cfif>
        (
            PRO_WORKS.COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
            PRO_WORKS.OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
            PRO_WORKS.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
            PRO_WORKS.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
        )
        <cfif isDefined("attributes.work_id")>
            AND WORK_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
        </cfif>
</cfquery>
<cfif isdefined("attributes.com_id") and len(attributes.com_id)>
  	<cfquery name="GET_COM_WORKS" datasource="#DSN#">
		SELECT
			WORK_HEAD,
			WORK_ID,
			TARGET_START
		FROM
			PRO_WORKS
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.com_id#">
  	</cfquery>
</cfif>

<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
	<tr class="color-list" style="height:35px;">
	  	<td class="headbold">&nbsp;<cf_get_lang no='727.İş İlişkisi Belirle'></td>
	</tr>
</table>

<form name="relation">
<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:100%">	
  	<tr>
		<td>
			<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:100%">
	  			<cfif isdefined("attributes.pro_id") and len(attributes.pro_id)>
					<tr class="color-row" style="height:20px;">
						<td class="txtbold"><cf_get_lang_main no='608.İşler'></td>
                        <td class="txtbold" style="width:150px;">İlişki Tipi</td>
						<td class="txtbold" style="width:100px;"><cf_get_lang_main no='243.Başlama Tarihi'></td>
					</tr>
					<cfoutput query="get_pro_works">
					  	<tr class="color-row">
							<td>&nbsp;<a href="javascript://" class="tableyazi" onclick="sendit();">#work_head#</a>
							  <input type="hidden" name="id#currentrow#" id="id#currentrow#" value="#work_id#">
							  <input type="hidden" name="head#currentrow#" id="head#currentrow#" value="#work_head#">
							</td>
							<td>
								<select name="work_relation_type#currentrow#" id="work_relation_type#currentrow#" style="width:120px;">
									<option value="FS">Finish to Start</option>
									<option value="SF">Start to Finish</option>
									<option value="SS">Start to Start</option>
									<option value="FF">Finish to Finish</option>
								</select>
							</td>
							<td>#dateformat(date_add('h',session.pp.time_zone,target_start),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,target_start),'HH:MM')#</td>
					  	</tr>
					</cfoutput>
				<cfelseif isdefined("attributes.com_id") and len(attributes.com_id)>
					<cfoutput query="get_com_works">
					  	<tr class="color-row">
							<td>&nbsp;<a href="javascript://" onclick="sendit();" class="tableyazi">#work_head#</a>
							  <input type="hidden" name="id#currentrow#" id="id#currentrow#" value="#work_id#">
							  <input type="hidden" name="head#currentrow#" id="head#currentrow#" value="#work_head#">
							</td>
							<td>#dateformat(date_add('h',session.pp.time_zone,target_start),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,target_start),'HH:MM')#</td>
					  	</tr>
					</cfoutput>
	  			</cfif>
			</table>
		</td>
  	</tr>
  	<tr style="height:30px;">
		<td align="right" style="text-align:right;">
		  	<input type="button" name="vazgec" value="<cf_get_lang_main no='50.Vazgeç'>" onClick="window.close();" style="width:65px;">
		</td>
  	</tr>
</table>
</form>
<script type="text/javascript">
	function sendit()
	{
		related_work_head =";";
		for(yy=1;yy<=<cfoutput>#get_pro_works.recordcount#</cfoutput>;yy++)
		{	
			if(document.getElementById('head'+yy).value != "")
			{
				related_work_head = related_work_head + document.getElementById('id'+yy).value+document.getElementById('work_relation_type'+yy).value;
				related_work_head = related_work_head + ";";
			}
		}
		window.opener.document.getElementById('rel_work').value = related_work_head;
		window.close();
		return false;
	}
</script>

