<cfset today = dateformat(now(),"yyyy-mm-dd")>
<cfif get_class_attender_emps.recordcount and isdefined('session.ep')>
	<cfquery dbtype="query" name="Kontrol">
		SELECT COUNT(*) AS SAYIM FROM GET_CLASS_ATTENDER_EMPS WHERE EMP_ID = #session.ep.userid#
	</cfquery>
<cfelseif isdefined('session.pp') and get_class_attender_pars.recordcount>
	<cfquery dbtype="query" name="Kontrol">
		SELECT COUNT(*) AS SAYIM FROM GET_CLASS_ATTENDER_PARS WHERE PAR_ID = #session.pp.userid#
	</cfquery>
<cfelseif isdefined('session.ww.userid') and get_class_attender_cons.recordcount>
	<cfquery dbtype="query" name="Kontrol">
		SELECT COUNT(*) AS SAYIM FROM GET_CLASS_ATTENDER_CONS WHERE CONS_ID = #session.ww.userid#
	</cfquery>
<cfelse>
	<cfset Kontrol.Sayim = 0>
</cfif>
<cfif Kontrol.Sayim GT 0> 
	<table>
    	<cfif isdefined("get_class_attender_status.status") and get_class_attender_status.status eq 0>
        	<cfquery name="get_attender_detail" datasource="#DSN#">
            	SELECT DETAIL FROM TRAINING_CLASS_ATTENDER 
                WHERE 
                 	CLASS_ID = #URL.CLASS_ID# AND
                   	<cfif isdefined('session.ep')>
                      	EMP_ID = #SESSION.EP.USERID#
                   	<cfelseif isdefined('session.pp')>
                       	PAR_ID = #SESSION.PP.USERID#
                  	<cfelseif isdefined('session.ww.userid')>
                       	CONS_ID = #SESSION.WW.USERID#
                  	</cfif>
          	</cfquery>
      	</cfif>
    	<cfif len(get_class.finish_date) and today gt dateformat(get_class.finish_date,"yyyy-mm-dd")>
        	<tr>
            	<td class="txtboldblue"><cf_get_lang no='19.Bu eğitime katılmak istiyorum'></td>
                <td>
                    <cfif isdefined("get_class_attender_status.status") and get_class_attender_status.status eq 0>Katılmıyorum - <cfoutput>#get_attender_detail.detail#</cfoutput>
                    <cfelseif isdefined("get_class_attender_status.status") and get_class_attender_status.status eq 1>Katılıyorum</cfif>
                </td>
            </tr>
        <cfelse>
		<cfform name="inspection_class" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_inspection_class&class_id=#url.class_id#" method="post">
			<tr>
				<td class="txtboldblue"><cf_get_lang no='19.Bu eğitime katılmak istiyorum'></td>
				<td><input type="radio" name="status" id="status" value="1" <cfif isdefined("get_class_attender_status.status") and get_class_attender_status.status eq 1>checked</cfif> onchange="closeExp();"><cf_get_lang no='24.Katılıyorum'></input></td>
                <td><input type="radio" name="status" id="status" value="0" <cfif isdefined("get_class_attender_status.status") and get_class_attender_status.status eq 0>checked</cfif> onchange="addExp();">Katılmıyorum</input></td>
                <td valign="bottom"><input type="submit" value="<cf_get_lang_main no='49.Kaydet'>"/></td>
			</tr>
   			<tr id="detail_" name="detail_" <cfif isdefined("get_class_attender_status.status") and get_class_attender_status.status neq 0>style="display:none;"</cfif>>
				<td>Açıklama</td>
				<td colspan="3">
                	<textarea name="detail" id="detail" style="width:250px; height:80px;"><cfif isdefined("get_class_attender_status.status") and get_class_attender_status.status eq 0><cfoutput>#get_attender_detail.detail#</cfoutput></cfif></textarea>
              	</td>
			</tr>
       	</cfform>
        </cfif>
	</table>
</cfif>

<script type="text/javascript">
	function addExp(){
		detail_.style.display = "";
	}
	function closeExp(){
		detail_.style.display = "none";
	}
</script>
