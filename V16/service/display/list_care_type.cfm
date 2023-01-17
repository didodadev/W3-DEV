<cfquery name="GET_CARE_CAT" datasource="#DSN3#">
	SELECT SERVICE_CARECAT_ID, SERVICE_CARE FROM SERVICE_CARE_CAT ORDER BY SERVICE_CARE
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_care_cat.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	url_string = '';
	if (isdefined('attributes.maxrows')) url_string = '#url_string#&maxrows=#attributes.maxrows#';
	if (isdefined('attributes.keyword')) url_string = '#url_string#&keyword=#attributes.keyword#';
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Bakım Tipi Ekle','36751')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=service.emptypopup_add_care_cat" method="post" name="search">
				<input type="hidden" name="id" id="id" value="<cfoutput>#url.id#</cfoutput>">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="15"><input type="checkbox" name="allSelectDemand" id="allSelectDemand"></th>
							<th><cf_get_lang dictionary_id='33671.Bakım Tipleri'></th>
						</tr>
					</thead>
					<tbody>
						<cfif get_care_cat.recordcount>
							<cfoutput query="get_care_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<tr>
								  <td width="15"><input type="checkbox" name="care_id#currentrow#" id="care_id#currentrow#" class="checkSingle" value="#service_carecat_id#"></td>
								  <td>#service_care#</td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
							</tr>
						</cfif>
					</tbody>
				</cf_grid_list>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' insert_alert=''>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<cfif attributes.totalrecords gt attributes.maxrows>
  	<table>
		<tr>
		  	<td><cf_pages page="#attributes.page#"
				  maxrows="#attributes.maxrows#"
				  totalrecords="#attributes.totalrecords#"
				  startrow="#attributes.startrow#"
				  adres="service.popup_list_care_type#url_string#"> </td>
		  	<!-- sil -->
			<td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57492.Toplam'>:#get_care_cat.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
			</td>
			<!-- sil -->
		</tr>
  	</table>
</cfif>

<script>
$(document).ready(function() {
    $("#allSelectDemand").change(function() {
        if (this.checked) {
            $(".checkSingle").each(function() {
                this.checked=true;
            });
        } else {
            $(".checkSingle").each(function() {
                this.checked=false;
            });
        }
    });

    $(".checkSingle").click(function () {
        if ($(this).is(":checked")) {
            var isAllChecked = 0;

            $(".checkSingle").each(function() {
                if (!this.checked)
                    isAllChecked = 1;
            });

            if (isAllChecked == 0) {
                $("#allSelectDemand").prop("checked", true);
            }     
        }
        else {
            $("#allSelectDemand").prop("checked", false);
        }
    });
});
	
</script>

