<cfparam name="attributes.norm_year" default="#year("#now()#")#">
<cfparam name="attributes.branch_status" default="1">
<cfquery name="get_branches" datasource="#DSN#">
	SELECT
		RELATED_COMPANY,
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE 
		<cfif len(attributes.branch_status)>BRANCH_STATUS = #attributes.branch_status# AND</cfif>
		BRANCH_ID IS NOT NULL
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #SESSION.EP.POSITION_CODE#
					)
	</cfif>
	ORDER BY
		RELATED_COMPANY,
		BRANCH_NAME
</cfquery>
		<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="100%">
        	<tr>
          		<td class="headbold" height="35"><cf_get_lang dictionary_id='55211.Norm Kadrolar'> <cf_get_lang dictionary_id="38458.Departman Oranları Girişi"> <div style="position:absolute" id="MESSAGE_PLACE"></td>
			</tr>
			<tr>
				<td height="5">
					<table cellspacing="1" cellpadding="2" border="0" class="color-border" width="98%">
					<tr class="color-row">
					<td>
					<table>
					<cfform name="search_" action="" method="post">
						<tr>
							<td>
								<select name="branch_status" id="branch_status" onChange="showBranches();">
									<option value=""><cf_get_lang dictionary_id="57708.Tümü"></option>
									<option value="1" <cfif attributes.branch_status eq 1>selected</cfif>><cf_get_lang dictionary_id="57493.Aktif"></option>
									<option value="0" <cfif attributes.branch_status eq 0>selected</cfif>><cf_get_lang dictionary_id="57494.Pasif"></option>
								</select>
							</td>
							<td><div id="BRANCH_PLACE">
								<select name="branch_id" id="branch_id">
									<option value=""><cf_get_lang dictionary_id="30126.Şube Seçiniz"></option>
									<cfoutput query="get_branches" group="RELATED_COMPANY">
											<optgroup label="#RELATED_COMPANY#"></optgroup>
										<cfoutput>
											<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
										</cfoutput>
									</cfoutput>
								</select>
								</div>
							</td>
							<td>
								<cfset bu_yil = "#year("#now()#")#">
                                <select name="norm_year" id="norm_year">
                                    <cfoutput>
                                        <cfloop from="-2" to="3" index="i">
                                        <cfset deger=bu_yil+i>
                                            <option value="#deger#" <cfif attributes.norm_year eq deger>selected</cfif>>#deger#</option>
                                        </cfloop>
                                    </cfoutput>
                                </select>
							</td>
							<td><a href="javascript://" onClick="gonder();"><img src="/images/ara_blue.gif" border="0"></a></td>
						</tr>
					</cfform>
					</table>
				</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<div id="ADD_PLACE" style="width:100%;height:100%;"></div>
				</td>			
			</tr>
     	</table>
<script type="text/javascript">
function showBranches()
{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_get_branches&b_status=";
		var tmp = document.norm_position.branch_status.value;
        send_address +=tmp;
		AjaxPageLoad(send_address,'BRANCH_PLACE');
}

function gonder()
{	
	if (document.search_.branch_id.value == '')
	{
		alert("Şube Seçiniz!");
		return false;
	}
	var b_id = document.search_.branch_id.value;
	var n_year = document.search_.norm_year.value;
	var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_add_norm_position_department_rate&branch_id=";
	send_address +=b_id;
	send_address +='&norm_year=';
	send_address +=n_year;
	AjaxPageLoad(send_address,'ADD_PLACE');
}
<cfif isdefined("attributes.branch_id") and isdefined("attributes.norm_year")>
	gonder();
</cfif>
</script>
