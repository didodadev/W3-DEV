<cf_box title="#getLang('','Benzer Kriterlerde Kayıtlar Bulundu',30241)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
    <cfscript>
        attributes.employee_name = trim(attributes.employee_name);
        attributes.employee_surname = trim(attributes.employee_surname);
        if(isdefined("attributes.socialsecurity_no")){attributes.socialsecurity_no = trim(attributes.socialsecurity_no);}
        attributes.identycard_no = trim(attributes.identycard_no);	
        attributes.tax_number = trim(attributes.tax_number);	
    </cfscript>
    <cfquery name="GET_EMPLOYEES_APP" datasource="#dsn#">
        SELECT 
            EMPAPP_ID,
            NAME,
            SURNAME,
            TAX_NUMBER,
            WORKTELCODE,
            WORKTEL,
            MOBILCODE,
            MOBIL,
            SOCIALSECURITY_NO,
            IDENTYCARD_NO,
            EMAIL
        FROM
            EMPLOYEES_APP
        WHERE
            NAME = '#attributes.employee_name#' OR
            SURNAME = '#attributes.employee_surname#'
            <cfif isdefined("attributes.socialsecurity_no") and len(attributes.socialsecurity_no)>OR SOCIALSECURITY_NO = '#attributes.socialsecurity_no#'</cfif>
            <cfif len(attributes.identycard_no)>OR IDENTYCARD_NO = '#attributes.identycard_no#'</cfif>
            <cfif len(attributes.tax_number)>OR TAX_NUMBER = '#attributes.tax_number#'</cfif>
    </cfquery>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<form name="search_" method="post" action="">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="25"><cf_get_lang dictionary_id="57487.No"></th>
						<th nowrap><cf_get_lang dictionary_id="57570.Ad soyad"></th>
						<th nowrap><cf_get_lang dictionary_id="57499.Telefon"></th>
						<th nowrap width="120"><cf_get_lang dictionary_id="55477.GSM"></th>
						<th width="120"><cf_get_lang dictionary_id="55484.E-Mail"></th>
						<th width="120"><cf_get_lang dictionary_id="55903.Kimlik Kartı No"></th>
						<th width="120"><cf_get_lang dictionary_id="57752.Vergi no"></th>
						<th width="120"><cf_get_lang dictionary_id="55663.SGK No"></th>
					</tr>
				</thead>		
				<cfif GET_EMPLOYEES_APP.recordcount>
					<tbody>
						<cfoutput query="GET_EMPLOYEES_APP">
							<tr>
								<td>#currentrow#</td>
								<td nowrap><a href="://javascript" onClick="control(1,#empapp_id#);" class="tableyazi">#name# #surname#</a></td>
								<td>#WORKTELCODE# #WORKTEL#</td>
								<td>#MOBILCODE# #MOBIL#</td>
								<td>#EMAIL#</td>
								<td>#IDENTYCARD_NO#</td>
								<td>#TAX_NUMBER#</td>
								<td>#SOCIALSECURITY_NO#</td>
							</tr>
						</cfoutput>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadi'>!</td>
						</tr>
					</tbody>
				</cfif>
			</cf_grid_list>
			<cfif GET_EMPLOYEES_APP.recordcount>
				<div class="ui-info-bottom flex-end">
					<div><input type="submit" name="Devam" id="Devam" value="<cf_get_lang dictionary_id='64586.Var olan Kayıtları Göz ardı Et'>" onClick="control(2,0);" class="ui-wrk-btn ui-wrk-btn-extra"></div>
				</div>
			</cfif>
		</form>
    </div>
    <script type="text/javascript">
    <cfif not GET_EMPLOYEES_APP.recordcount>
        <cfif isDefined("attributes.draggable")>
            window.employe_detail.submit();
            closeBoxDraggable('prerecord_box');
        <cfelse>
            opener.employe_detail.submit();
            window.close();
        </cfif>
    </cfif>
    function control(id,value)
    {
        if( document.getElementById('name_').value == '' || document.getElementById('surname').value == '' ){
            alert( "<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad '> | <cf_get_lang dictionary_id='58726.Soyad'>" );
            event.preventDefault();
            closeBoxDraggable('prerecord_box');
            document.getElementById('name_').focus();
            return false;
        }
        if(id==1)
        {
            <cfif isDefined("attributes.draggable")>
                window.location.href='<cfoutput>#request.self#?fuseaction=hr.form_upd_cv&empapp_id=</cfoutput>' + value;
                closeBoxDraggable('prerecord_box');
            <cfelse>
                opener.location.href='<cfoutput>#request.self#?fuseaction=hr.form_upd_cv&empapp_id=</cfoutput>' + value;
                window.close();
            </cfif>
        }
        if(id==2)
        {
            <cfif isDefined("attributes.draggable")>
                window.employe_detail.submit();
                closeBoxDraggable('prerecord_box');
            <cfelse>
                opener.employe_detail.submit();
                window.close();
            </cfif>
        }
    }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
</cf_box>